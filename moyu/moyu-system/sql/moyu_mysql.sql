-- 1. 组织机构表
DROP TABLE IF EXISTS `sys_org`;
CREATE TABLE `sys_org`
(
    `id`          BIGINT(20)    NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `parent_code` VARCHAR(64)   NULL DEFAULT '0' COMMENT '父编码',

    `name`        VARCHAR(64)   NULL DEFAULT NULL COMMENT '名称',
    `code`        VARCHAR(64)   NULL DEFAULT NULL COMMENT '编码',
    `org_type`    TINYINT(5)    NULL DEFAULT NULL COMMENT '组织机构类型(字典 1公司组织 2部门机构 3虚拟节点)',
    `org_level`   TINYINT(5)    NULL DEFAULT NULL COMMENT '组织层级(字典 1一级公司 2二级公司 3三级公司)',
    `org_chain`   VARCHAR(1024) NULL DEFAULT NULL COMMENT '所属组织链,逗号分隔,父节点在后',

    `sort_num`    INT(10)       NULL DEFAULT NULL COMMENT '排序顺序',
    `status`      TINYINT(5)    NULL DEFAULT 0 COMMENT '状态（0正常 1停用）',
    `ext_json`    LONGTEXT      NULL COMMENT '扩展信息',
    `remark`      VARCHAR(200)  NULL DEFAULT NULL comment '备注',
    `delete_flag` TINYINT(5)    NULL DEFAULT 0 COMMENT '删除标志（0未删除  1已删除）',
    `create_time` DATETIME      NULL DEFAULT NULL COMMENT '创建时间',
    `create_user` VARCHAR(20)   NULL DEFAULT NULL COMMENT '创建用户',
    `update_time` DATETIME      NULL DEFAULT NULL COMMENT '修改时间',
    `update_user` VARCHAR(20)   NULL DEFAULT NULL COMMENT '修改用户',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci
  AUTO_INCREMENT = 2000 COMMENT = '组织机构表';

-- 2. 用户信息表
drop table if exists sys_user;
create table sys_user
(
    `id`              BIGINT(20)   NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `account`         VARCHAR(64)  NULL DEFAULT NULL COMMENT '账号',
    `password`        VARCHAR(64)  NULL DEFAULT NULL COMMENT '密码',
    `nick_name`       VARCHAR(64)  NULL DEFAULT NULL COMMENT '昵称',
    `avatar`          VARCHAR(255) NULL DEFAULT NULL COMMENT '头像',
    `name`            VARCHAR(64)  NULL DEFAULT NULL COMMENT '姓名',
    `gender`          TINYINT(4)   NULL DEFAULT NULL COMMENT '性别(字典 0未知 1男 2女)',
    `birthday`        DATETIME     NULL DEFAULT NULL COMMENT '生日',
    `email`           VARCHAR(64)  NULL DEFAULT NULL COMMENT '邮箱',
    `phone`           VARCHAR(20)  NULL DEFAULT NULL COMMENT '手机',
    `id_no`           VARCHAR(20)  NULL DEFAULT NULL COMMENT '身份证号',
    `address`         VARCHAR(200) NULL DEFAULT NULL COMMENT '联系地址',

    `staff_code`      VARCHAR(64)  NULL DEFAULT NULL COMMENT '员工编码',
    `entry_date`      DATETIME     NULL DEFAULT NULL COMMENT '员工入职日期',
    `org_code`        VARCHAR(64)  NULL DEFAULT NULL COMMENT '直属组织编码',
    `org_name`        VARCHAR(64)  NULL DEFAULT NULL COMMENT '直属组织名称',

    `login_ip`        VARCHAR(20)  NULL DEFAULT NULL COMMENT '登陆IP',
    `login_time`      DATETIME     NULL DEFAULT NULL COMMENT '登陆时间',
    `last_login_ip`   VARCHAR(20)  NULL DEFAULT NULL COMMENT '上次登陆IP',
    `last_login_time` DATETIME     NULL DEFAULT NULL COMMENT '上次登陆时间',
    `pwd_update_time` DATETIME     NULL DEFAULT NULL COMMENT '上次密码更新时间',

    `status`          TINYINT(5)   NULL DEFAULT 0 COMMENT '状态（0正常 1停用）',
    `remark`          VARCHAR(200) NULL DEFAULT NULL comment '备注',
    `delete_flag`     TINYINT(5)   NULL DEFAULT 0 COMMENT '删除标志（0未删除  1已删除）',
    `create_time`     DATETIME     NULL DEFAULT NULL COMMENT '创建时间',
    `create_user`     VARCHAR(32)  NULL DEFAULT NULL COMMENT '创建用户',
    `update_time`     DATETIME     NULL DEFAULT NULL COMMENT '修改时间',
    `update_user`     VARCHAR(32)  NULL DEFAULT NULL COMMENT '修改用户',
    PRIMARY KEY (`id`),
    UNIQUE INDEX `uniq_account` (`account`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci
  AUTO_INCREMENT = 2000 COMMENT = '用户信息表';

-- 3. 功能权限分组表
drop table if exists sys_group;
create table sys_group
(
    `id`          bigint(20)   NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `name`        VARCHAR(64)  NULL DEFAULT NULL COMMENT '名称',
    `code`        VARCHAR(64)  NULL DEFAULT NULL COMMENT '编码',
    `group_type`  TINYINT(5)   NULL DEFAULT NULL COMMENT '分组类型(字典 1特有 2通用 3自建)',
    `org_code`    VARCHAR(64)  NULL DEFAULT NULL COMMENT '直属组织编码',
    `org_name`    VARCHAR(64)  NULL DEFAULT NULL COMMENT '直属组织名称',

    `sort_num`    INT(10)      NULL DEFAULT NULL COMMENT '排序顺序',
    `status`      TINYINT(5)   NULL DEFAULT 0 COMMENT '状态（0正常 1停用）',
    `ext_json`    LONGTEXT     NULL COMMENT '扩展信息',
    `remark`      VARCHAR(200) NULL DEFAULT NULL comment '备注',
    `delete_flag` TINYINT(5)   NULL DEFAULT 0 COMMENT '删除标志（0未删除  1已删除）',
    `create_time` DATETIME     NULL DEFAULT NULL COMMENT '创建时间',
    `create_user` VARCHAR(32)  NULL DEFAULT NULL COMMENT '创建用户',
    `update_time` DATETIME     NULL DEFAULT NULL COMMENT '修改时间',
    `update_user` VARCHAR(32)  NULL DEFAULT NULL COMMENT '修改用户',
    primary key (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci
  AUTO_INCREMENT = 1000 COMMENT = '分组信息表';

-- 7. 数据权限分组表
drop table if exists sys_scope;
create table sys_scope
(
    `id`          bigint(20)    NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `name`        VARCHAR(64)   NULL DEFAULT NULL COMMENT '名称',
    `code`        VARCHAR(64)   NULL DEFAULT NULL COMMENT '编码',
    `org_code`    VARCHAR(64)   NULL DEFAULT NULL COMMENT '直属组织编码',
    `org_name`    VARCHAR(64)   NULL DEFAULT NULL COMMENT '直属组织名称',
    `scope_type`  TINYINT(5)    NULL DEFAULT NULL COMMENT '数据权限(字典 0无限制 1本人数据 2本机构 3本机构及以下 4自定义)',
    `scope_set`   VARCHAR(1024) NULL DEFAULT NULL COMMENT '自定义scope集合,逗号分隔',

    `sort_num`    INT(10)       NULL DEFAULT NULL COMMENT '排序顺序',
    `status`      TINYINT(5)    NULL DEFAULT 0 COMMENT '状态（0正常 1停用）',
    `ext_json`    LONGTEXT      NULL COMMENT '扩展信息',
    `remark`      VARCHAR(200)  NULL DEFAULT NULL comment '备注',
    `delete_flag` TINYINT(5)    NULL DEFAULT 0 COMMENT '删除标志（0未删除  1已删除）',
    `create_time` DATETIME      NULL DEFAULT NULL COMMENT '创建时间',
    `create_user` VARCHAR(32)   NULL DEFAULT NULL COMMENT '创建用户',
    `update_time` DATETIME      NULL DEFAULT NULL COMMENT '修改时间',
    `update_user` VARCHAR(32)   NULL DEFAULT NULL COMMENT '修改用户',
    primary key (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci
  AUTO_INCREMENT = 1000 COMMENT = '数据权限分组表';

-- 4. 角色信息表
drop table if exists sys_role;
create table sys_role
(
    `id`          BIGINT(20)   NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `name`        VARCHAR(64)  NULL DEFAULT NULL COMMENT '名称',
    `code`        VARCHAR(64)  NULL DEFAULT NULL COMMENT '编码',

    `sort_num`    INT(10)      NULL DEFAULT NULL COMMENT '排序顺序',
    `status`      TINYINT(5)   NULL DEFAULT 0 COMMENT '使用状态（0正常 1停用）',
    `ext_json`    LONGTEXT     NULL COMMENT '扩展信息',
    `remark`      VARCHAR(200) NULL DEFAULT NULL comment '备注',
    `delete_flag` TINYINT(5)   NULL DEFAULT 0 COMMENT '删除标志（0未删除  1已删除）',
    `create_time` DATETIME     NULL DEFAULT NULL COMMENT '创建时间',
    `create_user` VARCHAR(32)  NULL DEFAULT NULL COMMENT '创建用户',
    `update_time` DATETIME     NULL DEFAULT NULL COMMENT '修改时间',
    `update_user` VARCHAR(32)  NULL DEFAULT NULL COMMENT '修改用户',
    primary key (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci
  AUTO_INCREMENT = 100 COMMENT = '角色信息表';

-- 5. 菜单权限表
drop table if exists sys_resource;
create table sys_resource
(
    `id`            BIGINT(20)   NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `parent_code`   VARCHAR(64)  NULL DEFAULT '0' COMMENT '父编码',
    `name`          VARCHAR(64)  NULL DEFAULT NULL COMMENT '名称',
    `code`          VARCHAR(64)  NULL DEFAULT NULL COMMENT '编码',
    `resource_type` TINYINT(5)   NULL DEFAULT NULL COMMENT '资源类型（字典 1模块 2目录 3菜单 4按钮 5外链）',
    `path`          VARCHAR(64)  NULL DEFAULT NULL COMMENT '路由地址',
    `component`     VARCHAR(64)  NULL DEFAULT NULL COMMENT '组件地址',
    `icon`          VARCHAR(64)  NULL DEFAULT NULL COMMENT '图标',
    `permission`    VARCHAR(64)  NULL DEFAULT NULL COMMENT '权限标识',
    `visible`       TINYINT(5)   NULL DEFAULT 1 COMMENT '是否可见（0不可见 1可见）',
    `link`          VARCHAR(255) NULL DEFAULT NULL COMMENT '链接地址',
    `module`        VARCHAR(64)  NULL DEFAULT NULL COMMENT '归属模块',

    `sort_num`      INT(10)      NULL DEFAULT NULL COMMENT '排序顺序',
    `status`        TINYINT(5)   NULL DEFAULT 0 COMMENT '使用状态（0正常 1停用）',
    `ext_json`      LONGTEXT     NULL COMMENT '扩展信息',
    `remark`        VARCHAR(200) NULL DEFAULT NULL comment '备注',
    `delete_flag`   TINYINT(5)   NULL DEFAULT 0 COMMENT '删除标志（0未删除  1已删除）',
    `create_time`   DATETIME     NULL DEFAULT NULL COMMENT '创建时间',
    `create_user`   VARCHAR(32)  NULL DEFAULT NULL COMMENT '创建用户',
    `update_time`   DATETIME     NULL DEFAULT NULL COMMENT '修改时间',
    `update_user`   VARCHAR(32)  NULL DEFAULT NULL COMMENT '修改用户',
    primary key (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci
  AUTO_INCREMENT = 2000 COMMENT = '资源权限表';

-- 6. 用户角色权限关系表
DROP TABLE IF EXISTS `sys_relation`;
CREATE TABLE `sys_relation`
(
    `id`            BIGINT(20)  NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `object_id`     VARCHAR(64) NULL DEFAULT NULL COMMENT '对象ID',
    `target_id`     VARCHAR(64) NULL DEFAULT NULL COMMENT '目标ID',
    `relation_type` TINYINT(5)  NULL DEFAULT NULL COMMENT '关系类型(字典 1:group_has_user,2:group_has_role,3:role_has_resource,4:role_has_user,5:scope_has_user)',
    `create_time`   DATETIME    NULL DEFAULT NULL COMMENT '创建时间',
    `create_user`   VARCHAR(32) NULL DEFAULT NULL COMMENT '创建用户',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci
  AUTO_INCREMENT = 2000 COMMENT = '用户角色权限关系表';