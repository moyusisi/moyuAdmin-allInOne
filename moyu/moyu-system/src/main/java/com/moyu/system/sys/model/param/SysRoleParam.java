package com.moyu.system.sys.model.param;

import com.moyu.common.model.BasePageParam;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.util.Set;

/**
 * 角色信息参数
 */
@Getter
@Setter
@ToString
@Builder
public class SysRoleParam extends BasePageParam {
    //********** 额外字段 **********//
    /**
     * 待删除的id列表
     */
    private Set<Long> ids;
    /**
     * 指定要查询的code集合
     */
    private Set<String> codeSet;
    /**
     * 指定要查询的orgCode
     */
    private String orgCode;
    /**
     * 角色授权时的菜单code列表
     */
    private Set<String> grantMenuList;

    /**
     * 名称关键词
     */
    private String searchKey;

    //********** db中存在的字段 **********//
    /**
     * 主键ID
     */
    private Long id;

    /**
     * 名称
     */
    @NotBlank(message = "角色名称name不能为空")
    private String name;

    /**
     * 编码
     */
    private String code;

    /**
     * 归属模块
     */
    private String module;

    /**
     * 排序顺序
     */
    private Integer sortNum;

    /**
     * 使用状态（0正常 1停用）
     */
    @NotNull(message = "角色状态status不能为空")
    @Min(value = 0, message = "角色状态status有效取值范围为[0,1]")
    @Max(value = 1, message = "角色状态status有效取值范围为[0,1]")
    private Integer status;

    /**
     * 扩展信息
     */
    private String extJson;

    /**
     * 备注
     */
    private String remark;

}