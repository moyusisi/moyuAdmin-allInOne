package com.moyu.system.sys.controller;


import cn.hutool.core.lang.Assert;
import cn.hutool.core.util.ObjectUtil;
import com.moyu.common.annotation.Log;
import com.moyu.common.model.BaseResponse;
import com.moyu.common.model.PageResult;
import com.moyu.system.sys.model.entity.SysScope;
import com.moyu.system.sys.model.entity.SysUser;
import com.moyu.system.sys.model.param.SysScopeParam;
import com.moyu.system.sys.service.SysScopeService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;

/**
 * 数据权限分组控制器
 *
 * @author shisong
 * @since 2024-12-20
 */
@Log(jsonLog = true)
@RestController
@RequestMapping("/api/sys/scope")
public class SysScopeController {

    @Resource
    private SysScopeService sysScopeService;

    /**
     * 分页获取数据权限分组列表
     */
    @PostMapping("/page")
    public BaseResponse<PageResult<SysScope>> pageList(@RequestBody SysScopeParam scopeParam) {
        Assert.isTrue(ObjectUtil.isAllNotEmpty(scopeParam.getPageNum(), scopeParam.getPageSize()), "分页参数pageNum,pageSize都不能为空");
        PageResult<SysScope> page = sysScopeService.pageList(scopeParam);
        return BaseResponse.getSuccessResponse(page);
    }

    /**
     * 获取详情
     */
    @PostMapping("/detail")
    public BaseResponse<SysScope> detail(@RequestBody SysScopeParam scopeParam) {
        Assert.isTrue(!ObjectUtil.isAllEmpty(scopeParam.getId(), scopeParam.getCode()), "id和code不能同时为空");
        return BaseResponse.getSuccessResponse(sysScopeService.detail(scopeParam));
    }

    /**
     * 添加
     */
    @PostMapping("/add")
    public BaseResponse<String> add(@Validated @RequestBody SysScopeParam scopeParam) {
        sysScopeService.add(scopeParam);
        return BaseResponse.getSuccessResponse();
    }

    /**
     * 删除
     */
    @PostMapping("/delete")
    public BaseResponse<String> delete(@RequestBody SysScopeParam scopeParam) {
        Assert.notEmpty(scopeParam.getIds(), "删除列表ids不能为空");
        sysScopeService.deleteByIds(scopeParam);
        return BaseResponse.getSuccessResponse();
    }

    /**
     * 编辑
     */
    @PostMapping("/edit")
    public BaseResponse<String> edit(@Validated @RequestBody SysScopeParam scopeParam) {
        Assert.isTrue(!ObjectUtil.isAllEmpty(scopeParam.getId(), scopeParam.getCode()), "id和code不能同时为空");
        sysScopeService.edit(scopeParam);
        return BaseResponse.getSuccessResponse();
    }

    /**
     * 查询指定分组的用户列表
     */
    @PostMapping("/userList")
    public BaseResponse<List<SysUser>> userList(@RequestBody SysScopeParam scopeParam) {
        Assert.notEmpty(scopeParam.getCode(), "分组code不能为空");
        List<SysUser> list = sysScopeService.scopeUserList(scopeParam);
        return BaseResponse.getSuccessResponse(list);
    }

    /**
     * 分组内新增用户
     */
    @PostMapping("/addUser")
    public BaseResponse<?> addUser(@RequestBody SysScopeParam scopeParam) {
        Assert.notEmpty(scopeParam.getCode(), "分组code不能为空");
        Assert.notEmpty(scopeParam.getCodeSet(), "指定集合codeSet不能为空");
        sysScopeService.scopeAddUser(scopeParam);
        return BaseResponse.getSuccessResponse();
    }

    /**
     * 分组内移除用户
     */
    @PostMapping("/deleteUser")
    public BaseResponse<?> deleteUser(@RequestBody SysScopeParam groupParam) {
        Assert.notEmpty(groupParam.getCode(), "分组code不能为空");
        Assert.notEmpty(groupParam.getCodeSet(), "指定集合codeSet不能为空");
        sysScopeService.scopeDeleteUser(groupParam);
        return BaseResponse.getSuccessResponse();
    }

}
