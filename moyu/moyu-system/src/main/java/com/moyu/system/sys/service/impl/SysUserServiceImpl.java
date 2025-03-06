package com.moyu.system.sys.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.lang.tree.Tree;
import cn.hutool.core.lang.tree.TreeUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.google.common.base.Strings;
import com.moyu.common.enums.ExceptionEnum;
import com.moyu.common.exception.BaseException;
import com.moyu.common.model.PageResult;
import com.moyu.common.mybatis.enums.DataScopeEnum;
import com.moyu.common.security.util.SecurityUtils;
import com.moyu.system.sys.constant.SysConstants;
import com.moyu.system.sys.mapper.SysUserMapper;
import com.moyu.system.sys.model.entity.SysUser;
import com.moyu.system.sys.model.param.SysUserParam;
import com.moyu.system.sys.service.SysOrgService;
import com.moyu.system.sys.service.SysUserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * @author shisong
 * @description 针对表【sys_user(用户信息表)】的数据库操作Service实现
 * @createDate 2024-12-25 20:35:45
 */
@Slf4j
@Service
public class SysUserServiceImpl extends ServiceImpl<SysUserMapper, SysUser> implements SysUserService {

    @Resource
    private SysOrgService sysOrgService;

    @Resource
    private PasswordEncoder passwordEncoder;

    @Override
    public List<SysUser> list(SysUserParam userParam) {
        // 查询指定的组织所有的children
        List<String> childrenCode = new ArrayList<>();
        if (StrUtil.isNotBlank(userParam.getOrgCode())) {
            childrenCode = sysOrgService.childrenCodeList(userParam.getOrgCode());
        }
        QueryWrapper<SysUser> queryWrapper = new QueryWrapper<SysUser>().checkSqlInjection();
        // 查询条件
        queryWrapper.lambda()
                // 关键词搜索
                .like(StrUtil.isNotBlank(userParam.getSearchKey()), SysUser::getName, userParam.getSearchKey())
                // 指定orgCode
                .in(ObjectUtil.isNotEmpty(childrenCode), SysUser::getOrgCode, childrenCode)
                // 指定account集合
                .in(ObjectUtil.isNotEmpty(userParam.getCodeSet()), SysUser::getAccount, userParam.getCodeSet())
                // 指定状态
                .eq(ObjectUtil.isNotEmpty(userParam.getStatus()), SysUser::getStatus, userParam.getStatus())
                .eq(SysUser::getDeleteFlag, 0);
        // 查询
        List<SysUser> groupList = this.list(queryWrapper);
        return groupList;
    }

    @Override
    public PageResult<SysUser> pageList(SysUserParam userParam) {
        String deptCode = userParam.getOrgCode();
        // 查询指定的组织所有的children
        List<String> childrenCode = new ArrayList<>();
        if (StrUtil.isNotBlank(deptCode)) {
            childrenCode = sysOrgService.childrenCodeList(deptCode);
        }

        // 查询条件
        LambdaQueryWrapper<SysUser> queryWrapper = Wrappers.lambdaQuery(SysUser.class)
                // 关键词搜索(name nickname staff_code)
                .like(StrUtil.isNotBlank(userParam.getSearchKey()), SysUser::getName, userParam.getSearchKey())
                // 指定orgCode
                .in(ObjectUtil.isNotEmpty(childrenCode), SysUser::getOrgCode, childrenCode)
                .apply(ObjectUtil.isNotEmpty(deptCode), "find_in_set('" + deptCode + "', org_path)")
                // 指定状态
                .eq(ObjectUtil.isNotEmpty(userParam.getStatus()), SysUser::getStatus, userParam.getStatus())
                .eq(SysUser::getDeleteFlag, 0);
        // 非ROOT则限制数据权限
        if (!SecurityUtils.isRoot()) {
            // 指定的列名
            Integer dataScope = SecurityUtils.getLoginUser().getDataScope();
            if (DataScopeEnum.SELF.getCode().equals(dataScope)) {
                String username = SecurityUtils.getLoginUser().getUsername();
                queryWrapper.and(e -> e.eq(SysUser::getCreateBy, username));
            } else if (DataScopeEnum.ORG.getCode().equals(dataScope)) {
                String orgCode = SecurityUtils.getLoginUser().getOrgCode();
                queryWrapper.and(e -> e.eq(SysUser::getOrgCode, orgCode));
            } else if (DataScopeEnum.ORG_CHILD.getCode().equals(dataScope)) {
                String orgCode = SecurityUtils.getLoginUser().getOrgCode();
                // find_in_set函数比like高效
//                queryWrapper.and(e -> e.eq(SysUser::getOrgCode, orgCode).or().like(SysUser::getOrgPath, orgCode));
                queryWrapper.and(e -> e.eq(SysUser::getOrgCode, orgCode).or().apply("find_in_set('" + orgCode + "', org_path)"));
            } else if (DataScopeEnum.ORG_DEFINE.getCode().equals(dataScope)) {
                Set<String> scopes = SecurityUtils.getLoginUser().getScopes();
                queryWrapper.and(e -> e.in(SysUser::getOrgCode, scopes));
            }
            log.debug("数据权限为:{}, 已追加过滤条件", DataScopeEnum.getByCode(dataScope));
        }
        // 分页查询
        Page<SysUser> page = new Page<>(userParam.getPageNum(), userParam.getPageSize());
        Page<SysUser> groupPage = this.page(page, queryWrapper);
        return new PageResult<>(groupPage.getTotal(), groupPage.getRecords());
    }

    @Override
    public SysUser detail(SysUserParam userParam) {
        LambdaQueryWrapper<SysUser> queryWrapper = new QueryWrapper<SysUser>().checkSqlInjection().lambda()
                .eq(ObjectUtil.isNotEmpty(userParam.getId()), SysUser::getId, userParam.getId())
                .eq(ObjectUtil.isNotEmpty(userParam.getAccount()), SysUser::getAccount, userParam.getAccount());
        // id、code均为唯一标识
        SysUser SysUser = this.getOne(queryWrapper);
        if (SysUser == null) {
            throw new BaseException(ExceptionEnum.INVALID_PARAMETER, "未查到指定数据");
        }
        return SysUser;
    }

    @Override
    public void add(SysUserParam userParam) {
        // 若指定了唯一编码code，则必须全局唯一
        if (!Strings.isNullOrEmpty(userParam.getAccount())) {
            // 查询指定code
            SysUser user = this.getOne(new LambdaQueryWrapper<SysUser>()
                    .eq(SysUser::getAccount, userParam.getAccount()));
            if (user != null) {
                throw new BaseException(ExceptionEnum.INVALID_PARAMETER, "此账号已存在，请更换账号");
            }
        }
        // 属性复制
        SysUser user = BeanUtil.copyProperties(userParam, SysUser.class);
        user.setId(null);
        // 若指定了直属组织，则设置所属组织
        if (ObjectUtil.isNotEmpty(user.getOrgCode())) {
            // 获取组织结构树
            Tree<String> rootTree = sysOrgService.singleTree();
            Tree<String> orgNode = rootTree.getNode(user.getOrgCode());
            // 设置直属机构名称
            user.setOrgName(orgNode.getName().toString());
            // 组织机构层级路径,逗号分隔,父节点在后
            List<String> list = TreeUtil.getParentsId(orgNode, true);
            user.setOrgPath(SysConstants.COMMA_JOINER.join(list));
        }
        // 初始密码为系统默认
        if (ObjectUtil.isEmpty(user.getPassword())) {
            user.setPassword(passwordEncoder.encode(SysConstants.DEFAULT_PASSWORD));
        }
        this.save(user);
    }

    @Override
    public void deleteByIds(SysUserParam userParam) {
        // 待删除的id集合
        Set<Long> idSet = userParam.getIds();
        // 逻辑删除
        UpdateWrapper<SysUser> updateWrapper = new UpdateWrapper<>();
        updateWrapper.in("id", idSet).set("delete_flag", 1);
        this.update(updateWrapper);
    }

    @Override
    public void edit(SysUserParam userParam) {
        SysUser oldUser = this.detail(userParam);
        // 属性复制
        SysUser updateUser = BeanUtil.copyProperties(userParam, SysUser.class);
        updateUser.setId(oldUser.getId());
        // 若新指定了直属组织，则设置所属组织
        if (ObjectUtil.notEqual(oldUser.getOrgCode(), updateUser.getOrgCode()) && ObjectUtil.isNotEmpty(updateUser.getOrgCode())) {
            // 获取组织结构树
            Tree<String> rootTree = sysOrgService.singleTree();
            Tree<String> orgNode = rootTree.getNode(userParam.getOrgCode());
            // 设置直属机构名称
            updateUser.setOrgName(orgNode.getName().toString());
            // 组织机构层级路径,逗号分隔,父节点在后
            List<String> list = TreeUtil.getParentsId(orgNode, true);
            updateUser.setOrgPath(SysConstants.COMMA_JOINER.join(list));
        }
        this.updateById(updateUser);
    }

    @Override
    public void updatePassword(SysUserParam userParam) {
        // 先查原有数据
        SysUser oldUser = this.detail(userParam);
        this.update(new LambdaUpdateWrapper<SysUser>()
                .eq(SysUser::getId, oldUser.getId())
                .set(SysUser::getPassword, passwordEncoder.encode(userParam.getPassword())));
    }

    @Override
    public void resetPassword(SysUserParam userParam) {
        // 先查原有数据
        SysUser oldUser = this.detail(userParam);
        this.update(new LambdaUpdateWrapper<SysUser>()
                .eq(SysUser::getId, oldUser.getId())
                .set(SysUser::getPassword, passwordEncoder.encode(SysConstants.DEFAULT_PASSWORD)));
    }
}




