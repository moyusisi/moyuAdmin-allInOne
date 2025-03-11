package com.moyu.system.sys.controller;


import cn.hutool.core.lang.Assert;
import cn.hutool.core.lang.tree.Tree;
import cn.hutool.core.util.ObjectUtil;
import com.moyu.common.annotation.Log;
import com.moyu.common.model.BaseResponse;
import com.moyu.common.model.PageResult;
import com.moyu.system.sys.model.entity.SysResource;
import com.moyu.system.sys.model.param.SysResourceParam;
import com.moyu.system.sys.service.SysResourceService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;

/**
 * 资源菜单权限控制器
 *
 * @author shisong
 * @since 2024-12-11
 */
@Log(jsonLog = true)
@RestController
@RequestMapping("/api/sys/resource")
public class SysResourceController {


    @Resource
    private SysResourceService sysResourceService;

    /**
     * 资源列表
     */
    @PostMapping("/list")
    public BaseResponse<List<SysResource>> list(@RequestBody SysResourceParam resourceParam) {
        List<SysResource> list = sysResourceService.list(resourceParam);
        return BaseResponse.getSuccessResponse(list);
    }

    /**
     * 资源分页列表
     */
//    @PreAuthorize("hasRole('ROOT') || hasAuthority('sys:resource:page')")
    @PostMapping("/page")
    public BaseResponse<PageResult<SysResource>> pageList(@RequestBody SysResourceParam resourceParam) {
        Assert.isTrue(ObjectUtil.isAllNotEmpty(resourceParam.getPageNum(), resourceParam.getPageSize()), "分页参数pageNum,pageSize都不能为空");
        PageResult<SysResource> list = sysResourceService.pageList(resourceParam);
        return BaseResponse.getSuccessResponse(list);
    }

    /**
     * 获取资源树(可指定module、status)
     */
//    @PreAuthorize("hasRole('ROOT') || hasAuthority('sys:resource:tree')")
    @Log(jsonLog = true, response = false)
    @PostMapping("/tree")
    public BaseResponse<List<Tree<String>>> tree(@RequestBody SysResourceParam resourceParam) {
        List<Tree<String>> treeList = sysResourceService.tree(resourceParam);
        return BaseResponse.getSuccessResponse(treeList);
    }

    /**
     * 获取资源详情
     */
//    @PreAuthorize("hasRole('ROOT') || hasAuthority('sys:resource:detail')")
    @PostMapping("/detail")
    public BaseResponse<SysResource> detail(@RequestBody SysResourceParam resourceParam) {
        Assert.isTrue(!ObjectUtil.isAllEmpty(resourceParam.getId(), resourceParam.getCode()), "id和code不能同时为空");
        return BaseResponse.getSuccessResponse(sysResourceService.detail(resourceParam));
    }

    /**
     * 添加资源
     */
    @PreAuthorize("hasRole('ROOT') || hasAuthority('sys:resource:add')")
    @PostMapping("/add")
    public BaseResponse<String> add(@RequestBody SysResourceParam resourceParam) {
        sysResourceService.add(resourceParam);
        return BaseResponse.getSuccessResponse();
    }

    /**
     * 删除资源
     */
    @PreAuthorize("hasRole('ROOT') || hasAuthority('sys:resource:delete')")
    @PostMapping("/delete")
    public BaseResponse<String> delete(@RequestBody SysResourceParam resourceParam) {
        Assert.notEmpty(resourceParam.getIds(), "删除列表ids不能为空");
        sysResourceService.deleteByIds(resourceParam);
        return BaseResponse.getSuccessResponse();
    }

    /**
     * 删除资源树,会集联删除
     */
    @PreAuthorize("hasRole('ROOT') || hasAuthority('sys:resource:deleteTree')")
    @PostMapping("/deleteTree")
    public BaseResponse<String> deleteTree(@RequestBody SysResourceParam resourceParam) {
        Assert.notEmpty(resourceParam.getCodes(), "删除列表codes不能为空");
        sysResourceService.deleteTree(resourceParam);
        return BaseResponse.getSuccessResponse();
    }

    /**
     * 编辑资源
     */
    @PreAuthorize("hasRole('ROOT') || hasAuthority('sys:resource:edit')")
    @PostMapping("/edit")
    public BaseResponse<String> edit(@RequestBody SysResourceParam resourceParam) {
        Assert.isTrue(!ObjectUtil.isAllEmpty(resourceParam.getId(), resourceParam.getCode()), "id和code不能同时为空");
        sysResourceService.edit(resourceParam);
        return BaseResponse.getSuccessResponse();
    }

    /**
     * 获取菜单树选择器
     */
    @PostMapping("/menuTreeSelector")
    public BaseResponse<List<Tree<String>>> menuTreeSelector(@RequestBody SysResourceParam resourceParam) {
        return BaseResponse.getSuccessResponse(sysResourceService.menuTreeSelector(resourceParam));
    }

}
