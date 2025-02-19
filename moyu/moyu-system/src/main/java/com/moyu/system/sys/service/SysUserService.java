package com.moyu.system.sys.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.moyu.common.model.PageResult;
import com.moyu.system.sys.model.entity.SysUser;
import com.moyu.system.sys.model.param.SysUserParam;

import java.util.List;

/**
 * @author shisong
 * @description 针对表【sys_user(用户信息表)】的数据库操作Service
 * @createDate 2024-12-25 20:35:45
 */
public interface SysUserService extends IService<SysUser> {

    /**
     * 获取记录列表
     */
    List<SysUser> list(SysUserParam userParam);

    /**
     * 分页获取记录列表
     */
    PageResult<SysUser> pageList(SysUserParam userParam);

    /**
     * 获取记录详情
     */
    SysUser detail(SysUserParam userParam);

    /**
     * 添加记录
     */
    void add(SysUserParam userParam);

    /**
     * 通过ids删除记录
     */
    void deleteByIds(SysUserParam userParam);

    /**
     * 修改记录
     */
    void edit(SysUserParam userParam);

    /**
     * 重置用户密码
     **/
    void updatePassword(SysUserParam userParam);

    /**
     * 重置用户密码
     **/
    void resetPassword(SysUserParam userParam);

}
