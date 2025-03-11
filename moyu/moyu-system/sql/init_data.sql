-- 组织机构
insert into moyu.sys_org (id, parent_code, name, code, org_type, org_level, org_path, sort_num, status, ext_json, remark, delete_flag, create_time, create_by, update_time, update_by)
values  (2001, '0', 'MY集团', '10000000', 1, 1, '0', 1, 0, null, null, 0, '2025-03-03 23:37:20', null, '2025-02-26 14:24:47', null),
        (2002, '10000000', '集团总部', '11000000', 1, 2, '10000000,0', 2, 0, null, null, 0, '2025-02-18 18:52:51', null, '2025-03-05 10:40:40', 'superAdmin'),
        (2003, '10000000', '北京公司', '12000000', 1, 2, '10000000,0', 4, 0, null, null, 0, '2025-03-04 22:30:14', 'superAdmin', '2025-03-05 10:41:11', 'superAdmin'),
        (2004, '10000000', '华东公司', '14000000', 1, 2, '10000000,0', 6, 0, null, null, 0, '2025-03-04 22:31:30', 'superAdmin', '2025-03-04 22:31:30', 'superAdmin'),
        (2005, '10000000', '华南公司', '16000000', 1, 2, '10000000,0', 8, 0, null, null, 0, '2025-03-04 22:31:42', 'superAdmin', '2025-03-04 22:31:42', 'superAdmin'),
        (2006, '11000000', '总部财务部', '11001000', 2, 2, '11000000,10000000,0', 22, 0, null, null, 0, '2025-03-05 10:38:43', 'superAdmin', '2025-03-05 10:40:54', 'superAdmin'),
        (2007, '11000000', '总部科技部', '11002000', 2, 2, '11000000,10000000,0', 24, 0, null, null, 0, '2025-03-05 10:38:56', 'superAdmin', '2025-03-05 10:40:58', 'superAdmin'),
        (2008, '12000000', '北京运营部', '12001000', 2, 2, '12000000,10000000,0', 42, 0, null, null, 0, '2025-03-05 10:39:09', 'superAdmin', '2025-03-05 10:41:19', 'superAdmin'),
        (2009, '12000000', '北京技术部', '12002000', 2, 2, '12000000,10000000,0', 44, 0, null, null, 0, '2025-03-05 10:39:20', 'superAdmin', '2025-03-05 10:41:26', 'superAdmin'),
        (2010, '14000000', '华东技术部', '14001000', 2, 2, '14000000,10000000,0', 62, 0, null, null, 0, '2025-03-05 10:39:48', 'superAdmin', '2025-03-05 10:41:44', 'superAdmin'),
        (2011, '16000000', '华南行政部', '16001000', 2, 2, '16000000,10000000,0', 84, 0, null, null, 0, '2025-03-05 10:40:01', 'superAdmin', '2025-03-05 10:41:51', 'superAdmin');

-- 用户
insert into moyu.sys_user (id, account, password, nick_name, avatar, name, gender, birthday, email, phone, id_no, address, staff_code, entry_date, org_code, org_name, org_path, login_ip, login_time, last_login_ip, last_login_time, pwd_update_time, status, remark, delete_flag, create_time, create_by, update_time, update_by)
values  (101, 'superAdmin', '$2a$10$ZxsW23u3p2wdnEpPTkT5zuOU.rs.TqyWAAa5eFTgxbQfbQggZ2Y3C', null, null, 'superAdmin', 1, null, null, null, null, null, null, null, '11000000', '集团总部', '11000000,10000000,0', null, null, null, null, null, 0, null, 0, null, null, null, null),
        (102, 'bjAdmin', '$2a$10$ZxsW23u3p2wdnEpPTkT5zuOU.rs.TqyWAAa5eFTgxbQfbQggZ2Y3C', null, null, 'bjAdmin', 1, null, null, null, null, null, null, null, '12000000', '北京公司', '12000000,10000000,0', null, null, null, null, null, 0, null, 0, null, null, null, null);

-- 角色
insert into moyu.sys_role (id, name, code, sort_num, status, ext_json, remark, delete_flag, create_time, create_by, update_time, update_by)
values  (100, '超级管理员', 'superAdmin', 2, 0, null, null, 0, '2025-02-26 17:00:16', null, '2025-02-26 17:00:38', ''),
        (110, 'ROOT管理员', 'ROOT', 1, 0, null, '', 0, '2025-02-26 17:00:16', null, '2025-02-26 17:00:16', '');

-- 功能权限组
insert into moyu.sys_group (id, name, code, org_code, org_name, data_scope, scope_set, org_path, sort_num, status, ext_json, remark, delete_flag, create_time, create_by, update_time, update_by)
values  (1894925631903645700, '总部兼职岗', 'G1897207291765641216', '11000000', '集团总部', 3, '', '11000000,10000000,0', 2, 0, null, null, 0, '2025-03-05 11:02:14', 'superAdmin', '2025-03-06 13:10:51', 'superAdmin'),
        (1894925631903645701, '北京技术部岗', 'G1897478009027895296', '12002000', '北京技术部', 3, '', '12002000,12000000,10000000,0', 9, 0, null, null, 0, '2025-03-06 10:43:05', 'superAdmin', '2025-03-06 18:43:38', 'superAdmin');

-- 数据权限组
insert into moyu.sys_scope (id, name, code, org_code, org_name, scope_type, scope_set, org_path, sort_num, status, ext_json, remark, delete_flag, create_time, create_by, update_time, update_by)
values  (1, '总部及以下数据', '67c19a5de4b0576ca0dc6dd8', '11000000', '集团总部', 3, null, '11000000,10000000,0', 5, 0, null, null, 0, '2025-02-28 19:13:34', 'superAdmin', '2025-03-05 10:47:40', 'superAdmin');

-- 菜单数据
insert into moyu.sys_resource (id, parent_code, name, code, resource_type, path, component, icon, permission, visible, link, module, sort_num, status, ext_json, remark, delete_flag, create_time, create_by, update_time, update_by)
values  (2001, '0', '系统模块', 'sys_module', 1, '/sysModule', '', 'appstore-add-outlined', '', 1, null, 'sys_module', 1, 0, null, '', 0, null, null, '2025-02-19 22:22:35', null),
        (2002, '0', '业务模块', 'biz_module', 1, '/bizModule', '', 'profile-outlined', '', 1, null, null, 2, 0, null, '', 0, null, null, '2025-02-19 22:22:42', null),

        (2003, 'sys_module', '组织架构', 'dir_sys_org', 2, '/org', 'Layout', 'apartment-outlined', '', 1, null, 'sys_module', 4, 0, null, '', 0, null, null, '2025-01-28 01:26:56', null),
        (2004, 'sys_module', '权限控制', 'dir_sys_perm', 2, '/perm', 'Layout', 'user-switch-outlined', '', 1, null, 'sys_module', 8, 0, null, '', 0, null, null, '2025-02-28 19:15:32', 'superAdmin'),
        (2005, 'sys_module', '资源管理', 'dir_sys_resource', 2, '/sys/resource', 'Layout', 'trademark-circle-outlined', '', 1, null, 'sys_module', 12, 0, null, null, 0, '2025-03-03 16:43:15', 'superAdmin', '2025-03-03 16:45:45', 'superAdmin'),
        (2006, 'sys_module', '基础工具', 'dir_sys_tool', 2, '/tool', 'Layout', 'tool-outlined', '', 1, null, 'sys_module', 13, 0, null, '', 0, null, null, '2025-01-28 01:26:33', null),
        (2007, 'sys_module', '系统运维', 'dir_sys_ops', 2, '/ops', 'Layout', 'hdd-outlined', '', 1, null, 'sys_module', 18, 0, null, '', 0, null, null, '2025-01-28 01:26:12', null),
        (2008, 'sys_module', '在线开发', 'dir_sys_dev', 2, '/dev', 'Layout', 'project-outlined', '', 1, null, 'sys_module', 41, 0, null, '', 0, null, null, '2025-01-28 01:25:53', null),
        (2009, 'sys_module', '移动端管理', 'dir_sys_mobile', 2, '/mobile', 'Layout', 'mobile-outlined', '', 1, null, 'sys_module', 50, 0, null, '', 0, null, null, '2025-01-28 01:26:04', null),
        (2010, 'biz_module', '公司架构', 'dir_biz_company', 2, '/1nlpdpnief', 'Layout', 'cluster-outlined', '', 1, null, 'biz_module', 51, 0, null, '', 0, null, null, '2025-02-19 22:48:10', null),
        (2011, 'biz_module', '通知公告', 'menu_biz_notice', 3, '/biz/notice', 'biz/notice/index', 'appstore-outlined', null, 1, null, 'biz_module', 99, 0, null, '', 0, null, null, null, null),

        (2012, 'dir_sys_org', '组织管理', 'menu_sys_org', 3, '/sys/org', 'sys/org/index', 'cluster-outlined', null, 1, null, 'sys_module', 5, 0, null, '', 0, null, null, null, null),
        (2013, 'dir_sys_org', '用户管理', 'menu_sys_user', 3, '/sys/user', 'sys/user/index', 'user-outlined', '', 1, null, 'sys_module', 6, 0, null, '', 0, null, null, '2025-01-17 15:14:44', null),
        (2015, 'dir_sys_perm', '岗位权限', 'menu_sys_group', 3, '/sys/group', 'sys/group/index', 'team-outlined', '', 1, null, 'sys_module', 7, 0, null, '', 0, null, null, '2025-03-03 16:44:30', 'superAdmin'),
        (2017, 'dir_sys_perm', '角色管理', 'menu_sys_role', 3, '/sys/role', 'sys/role/index', 'deployment-unit-outlined', '', 1, null, 'sys_module', 9, 0, null, '', 0, null, null, '2025-02-06 17:38:38', null),
        (2018, 'dir_sys_resource', '模块管理', 'menu_sys_module', 3, '/sys/module', 'sys/resource/module/index', 'appstore-add-outlined', '', 1, null, 'sys_module', 10, 0, null, '', 0, null, null, '2025-03-03 16:43:58', 'superAdmin'),
        (2019, 'dir_sys_resource', '菜单管理', 'menu_sys_menu', 3, '/sys/menu', 'sys/resource/menu/index', 'pic-left-outlined', '', 1, null, 'sys_module', 11, 0, null, '', 0, null, null, '2025-03-03 16:44:07', 'superAdmin'),
        (2020, 'dir_sys_resource', '接口管理', 'menu_sys_button', 3, '/sys/button', 'sys/resource/button/index', 'api-outlined', '', 1, null, 'sys_module', 12, 0, null, null, 0, '2025-03-02 10:46:19', 'superAdmin', '2025-03-05 20:02:09', 'superAdmin'),
        (2021, 'dir_sys_tool', '文件管理', 'menu_sys_file', 3, '/dev/file/index', 'dev/file/index', 'copy-outlined', null, 1, null, 'sys_module', 14, 0, null, '', 0, null, null, null, null),
        (2022, 'dir_sys_tool', '邮件推送', 'menu_sys_email', 3, '/dev/email/index', 'dev/email/index', 'send-outlined', null, 1, null, 'sys_module', 15, 0, null, '', 0, null, null, null, null),
        (2023, 'dir_sys_tool', '短信发送', 'menu_sys_sms', 3, '/dev/sms/index', 'dev/sms/index', 'mail-outlined', null, 1, null, 'sys_module', 16, 0, null, '', 0, null, null, null, null),
        (2024, 'dir_sys_tool', '站内信息', 'menu_sys_message', 3, '/dev/message/index', 'dev/message/index', 'message-outlined', null, 1, null, 'sys_module', 17, 0, null, '', 0, null, null, null, null),
        (2025, 'dir_sys_ops', '三方用户', 'menu_sys_third', 3, '/auth/third', 'auth/third/index', 'team-outlined', null, 1, null, 'sys_module', 19, 0, null, '', 0, null, null, null, null),
        (2026, 'dir_sys_ops', '任务调度', 'menu_sys_job', 3, '/dev/job', 'dev/job/index', 'field-time-outlined', null, 1, null, 'sys_module', 22, 0, null, '', 0, null, null, null, null),
        (2027, 'dir_sys_ops', '系统监控', 'menu_sys_monitor', 3, '/dev/monitor', 'dev/monitor/index', 'database-outlined', null, 1, null, 'sys_module', 24, 0, null, '', 0, null, null, null, null),
        (2028, 'dir_sys_ops', '数据库监控', 'menu_sys_sql', 5, 'http://localhost:82/druid/index.html', '', 'console-sql-outlined', '', 1, null, 'sys_module', 25, 0, null, '', 0, null, null, '2025-01-30 02:12:26', null),
        (2029, 'dir_sys_ops', '接口文档', 'menu_sys_doc', 5, 'http://localhost:82/doc.html', '', 'file-word-outlined', '', 1, null, 'sys_module', 29, 0, null, '', 0, null, null, '2025-01-30 02:12:14', null),
        (2030, 'dir_sys_ops', '日志审计', 'dir_sys_log', 2, '/ops/log', null, 'robot-outlined', null, 1, null, 'sys_module', 27, 0, null, '', 0, null, null, null, null),
        (2031, 'dir_sys_log', '访问日志', 'menu_sys_log_visit', 3, '/dev/vislog', 'dev/log/vislog/index', 'bars-outlined', null, 1, null, 'sys_module', 28, 0, null, '', 0, null, null, null, null),
        (2032, 'dir_sys_log', '操作日志', 'menu_sys_log_op', 3, '/dev/oplog', 'dev/log/oplog/index', 'bars-outlined', null, 1, null, 'sys_module', 29, 0, null, '', 0, null, null, null, null),
        (2033, 'dir_sys_dev', '代码生成', 'menu_sys_gen', 3, '/dev/gen', 'gen/index', 'rocket-outlined', '', 1, null, 'sys_module', 45, 0, null, '', 0, null, null, '2025-02-19 22:51:28', null),
        (2034, 'dir_sys_mobile', '模块管理', 'menu_sys_mobile_module', 3, '/mobile/module/index', 'mobile/resource/module/index', 'build-outlined', null, 1, null, 'sys_module', 51, 0, null, '', 0, null, null, null, null),
        (2035, 'dir_sys_mobile', '菜单管理', 'menu_sys_mobile_menu', 3, '/mobile/menu/index', 'mobile/resource/menu/index', 'appstore-add-outlined', null, 1, null, 'sys_module', 52, 0, null, '', 0, null, null, null, null),
        (2036, 'dir_biz_company', '机构管理', 'menu_biz_org', 3, '/biz/org', 'biz/org/index', 'cluster-outlined', null, 1, null, 'biz_module', 52, 0, null, '', 0, null, null, null, null),
        (2037, 'dir_biz_company', '人员管理', 'menu_biz_user', 3, '/biz/user', 'biz/user/index', 'user-outlined', null, 1, null, 'biz_module', 53, 0, null, '', 0, null, null, null, null),
        (2038, 'dir_biz_company', '岗位管理', 'menu_biz_pos', 3, '/biz/position', 'biz/position/index', 'apartment-outlined', null, 1, null, 'biz_module', 54, 0, null, '', 0, null, null, null, null),

        (2041, 'menu_sys_org', '新增组织', 'btn_sys_org_add', 4, '/api/sys/org/add', '', '', 'sys:org:add', 1, null, 'sys_module', 2, 0, null, '', 0, null, null, '2025-03-11 14:15:20', 'superAdmin'),
        (2042, 'menu_sys_org', '删除组织', 'btn_sys_org_delete', 4, '/api/sys/org/delete', '', '', 'sys:org:delete', 1, null, 'sys_module', 4, 0, null, '', 0, null, null, '2025-03-11 14:15:28', 'superAdmin'),
        (2043, 'menu_sys_org', '修改组织', 'btn_sys_org_edit', 4, '/api/sys/org/edit', '', '', 'sys:org:edit', 1, null, 'sys_module', 6, 0, null, '', 0, null, null, '2025-03-11 14:15:45', 'superAdmin'),
        (2044, 'menu_sys_org', '组织列表', 'btn_sys_org_list', 4, '/api/sys/org/page', '', '', 'sys:org:page', 1, null, 'sys_module', 8, 0, null, '', 0, null, null, '2025-03-11 14:15:55', 'superAdmin'),
        (2045, 'menu_sys_org', '组织详情', 'btn_sys_org_detail', 4, '/api/sys/org/detail', '', null, 'sys:org:detail', 1, null, 'sys_module', 10, 0, null, null, 0, '2025-03-11 11:35:49', 'superAdmin', '2025-03-11 14:16:07', 'superAdmin'),
        (2046, 'menu_sys_org', '删除组织树', 'btn_sys_org_deleteTree', 4, '/api/sys/org/deleteTree', '', null, 'sys:org:deleteTree', 1, null, 'sys_module', 12, 0, null, null, 0, '2025-03-11 11:38:38', 'superAdmin', '2025-03-11 14:16:13', 'superAdmin'),

        (2047, 'menu_sys_user', '新增用户', 'btn_sys_user_add', 4, '/api/sys/user/add', '', null, 'sys:user:add', 1, null, 'sys_module', 2, 0, null, null, 0, '2025-03-11 12:50:12', 'superAdmin', '2025-03-11 12:50:12', 'superAdmin'),
        (2048, 'menu_sys_user', '删除用户', 'btn_sys_user_delete', 4, '/api/sys/user/delete', '', null, 'sys:user:delete', 1, null, 'sys_module', 4, 0, null, null, 0, '2025-03-11 12:51:42', 'superAdmin', '2025-03-11 12:51:42', 'superAdmin'),
        (2049, 'menu_sys_user', '修改用户', 'btn_sys_user_edit', 4, '/api/sys/user/add', '', null, 'sys:user:edit', 1, null, 'sys_module', 6, 0, null, null, 0, '2025-03-11 12:52:47', 'superAdmin', '2025-03-11 12:52:47', 'superAdmin'),
        (2050, 'menu_sys_user', '用户列表', 'btn_sys_user_list', 4, '/api/sys/user/page', '', null, 'sys:user:page', 1, null, 'sys_module', 8, 0, null, null, 0, '2025-03-11 12:47:57', 'superAdmin', '2025-03-11 12:51:54', 'superAdmin'),
        (2051, 'menu_sys_user', '用户详情', 'btn_sys_user_detail', 4, '/api/sys/user/detail', '', null, 'sys:user:detail', 1, null, 'sys_module', 10, 0, null, null, 0, '2025-03-11 12:53:35', 'superAdmin', '2025-03-11 12:53:35', 'superAdmin'),

        (2052, 'menu_sys_group', '新增岗位', 'btn_sys_group_add', 4, '/api/sys/group/add', '', null, 'sys:group:add', 1, null, 'sys_module', 2, 0, null, null, 0, '2025-03-11 12:50:12', 'superAdmin', '2025-03-11 12:50:12', 'superAdmin'),
        (2053, 'menu_sys_group', '删除岗位', 'btn_sys_group_delete', 4, '/api/sys/group/delete', '', null, 'sys:group:delete', 1, null, 'sys_module', 4, 0, null, null, 0, '2025-03-11 12:51:42', 'superAdmin', '2025-03-11 12:51:42', 'superAdmin'),
        (2054, 'menu_sys_group', '修改岗位', 'btn_sys_group_edit', 4, '/api/sys/group/add', '', null, 'sys:group:edit', 1, null, 'sys_module', 6, 0, null, null, 0, '2025-03-11 12:52:47', 'superAdmin', '2025-03-11 12:52:47', 'superAdmin'),
        (2055, 'menu_sys_group', '岗位列表', 'btn_sys_group_list', 4, '/api/sys/group/page', '', null, 'sys:group:page', 1, null, 'sys_module', 8, 0, null, null, 0, '2025-03-11 12:47:57', 'superAdmin', '2025-03-11 12:51:54', 'superAdmin'),
        (2056, 'menu_sys_group', '岗位详情', 'btn_sys_group_detail', 4, '/api/sys/group/detail', '', null, 'sys:group:detail', 1, null, 'sys_module', 10, 0, null, null, 0, '2025-03-11 12:53:35', 'superAdmin', '2025-03-11 12:53:35', 'superAdmin'),
        (2057, 'menu_sys_group', '岗位用户列表', 'btn_sys_group_userList', 4, '/api/sys/group/userList', '', null, 'sys:group:userList', 1, null, 'sys_module', 12, 0, null, null, 0, '2025-03-11 12:57:42', 'superAdmin', '2025-03-11 12:57:42', 'superAdmin'),
        (2058, 'menu_sys_group', '岗位新增用户', 'btn_sys_group_addUser', 4, '/api/sys/group/addUser', null, null, 'sys:group:addUser', 1, null, 'sys_module', 14, 0, null, null, 0, '2025-03-11 12:57:42', 'superAdmin', '2025-03-11 12:57:42', 'superAdmin'),
        (2059, 'menu_sys_group', '岗位移除用户', 'btn_sys_group_deleteUser', 4, '/api/sys/group/deleteUser', null, null, 'sys:group:deleteUser', 1, null, 'sys_module', 16, 0, null, null, 0, '2025-03-11 12:57:42', 'superAdmin', '2025-03-11 12:57:42', 'superAdmin'),
        (2060, 'menu_sys_group', '岗位角色列表', 'btn_sys_group_roleList', 4, '/api/sys/group/roleList', '', null, 'sys:group:roleList', 1, null, 'sys_module', 18, 0, null, null, 0, '2025-03-11 12:57:42', 'superAdmin', '2025-03-11 12:57:42', 'superAdmin'),
        (2061, 'menu_sys_group', '岗位新增角色', 'btn_sys_group_addRole', 4, '/api/sys/group/addRole', null, null, 'sys:group:addRole', 1, null, 'sys_module', 20, 0, null, null, 0, '2025-03-11 12:57:42', 'superAdmin', '2025-03-11 12:57:42', 'superAdmin'),
        (2062, 'menu_sys_group', '岗位移除角色', 'btn_sys_group_deleteRole', 4, '/api/sys/group/deleteRole', null, null, 'sys:group:deleteRole', 1, null, 'sys_module', 22, 0, null, null, 0, '2025-03-11 12:57:42', 'superAdmin', '2025-03-11 12:57:42', 'superAdmin'),

        (2063, 'menu_sys_role', '新增角色', 'btn_sys_role_add', 4, '/api/sys/role/add', '', null, 'sys:role:add', 1, null, 'sys_module', 2, 0, null, null, 0, '2025-03-11 12:50:12', 'superAdmin', '2025-03-11 12:50:12', 'superAdmin'),
        (2064, 'menu_sys_role', '删除角色', 'btn_sys_role_delete', 4, '/api/sys/role/delete', '', null, 'sys:role:delete', 1, null, 'sys_module', 4, 0, null, null, 0, '2025-03-11 12:51:42', 'superAdmin', '2025-03-11 12:51:42', 'superAdmin'),
        (2065, 'menu_sys_role', '修改角色', 'btn_sys_role_edit', 4, '/api/sys/role/add', '', null, 'sys:role:edit', 1, null, 'sys_module', 6, 0, null, null, 0, '2025-03-11 12:52:47', 'superAdmin', '2025-03-11 12:52:47', 'superAdmin'),
        (2066, 'menu_sys_role', '角色列表', 'btn_sys_role_list', 4, '/api/sys/role/page', '', '', 'sys:role:page', 1, null, 'sys_module', 8, 0, null, '', 0, null, null, '2025-03-11 13:05:49', 'superAdmin'),
        (2067, 'menu_sys_role', '角色详情', 'btn_sys_role_detail', 4, '/api/sys/role/detail', '', null, 'sys:role:detail', 1, null, 'sys_module', 10, 0, null, null, 0, '2025-03-11 12:53:35', 'superAdmin', '2025-03-11 12:53:35', 'superAdmin'),
        (2068, 'menu_sys_role', '角色用户列表', 'btn_sys_role_userList', 4, '/api/sys/role/userList', '', null, 'sys:role:userList', 1, null, 'sys_module', 12, 0, null, null, 0, '2025-03-11 12:57:42', 'superAdmin', '2025-03-11 12:57:42', 'superAdmin'),
        (2069, 'menu_sys_role', '角色新增用户', 'btn_sys_role_addUser', 4, '/api/sys/role/addUser', null, null, 'sys:role:addUser', 1, null, 'sys_module', 14, 0, null, null, 0, '2025-03-11 12:57:42', 'superAdmin', '2025-03-11 12:57:42', 'superAdmin'),
        (2070, 'menu_sys_role', '角色移除用户', 'btn_sys_role_deleteUser', 4, '/api/sys/role/deleteUser', null, null, 'sys:role:deleteUser', 1, null, 'sys_module', 16, 0, null, null, 0, '2025-03-11 12:57:42', 'superAdmin', '2025-03-11 12:57:42', 'superAdmin'),
        (2071, 'menu_sys_role', '角色授权', 'btn_sys_role_grantMenu', 4, '/api/sys/role/grantMenu', null, null, 'sys:role:grantMenu', 1, null, 'sys_module', 18, 0, null, null, 0, '2025-03-11 12:57:42', 'superAdmin', '2025-03-11 12:57:42', 'superAdmin'),

        (2072, 'menu_sys_module', '新增模块', 'btn_sys_module_add', 4, '/api/sys/resource/add', '', null, 'sys:resource:add', 1, null, 'sys_module', 2, 0, null, null, 0, '2025-03-11 12:50:12', 'superAdmin', '2025-03-11 12:50:12', 'superAdmin'),
        (2073, 'menu_sys_module', '删除模块', 'btn_sys_module_delete', 4, '/api/sys/resource/delete', '', null, 'sys:resource:delete', 1, null, 'sys_module', 4, 0, null, null, 0, '2025-03-11 12:51:42', 'superAdmin', '2025-03-11 12:51:42', 'superAdmin'),
        (2074, 'menu_sys_module', '修改模块', 'btn_sys_module_edit', 4, '/api/sys/resource/add', '', null, 'sys:resource:edit', 1, null, 'sys_module', 6, 0, null, null, 0, '2025-03-11 12:52:47', 'superAdmin', '2025-03-11 12:52:47', 'superAdmin'),
        (2075, 'menu_sys_module', '模块列表', 'btn_sys_module_list', 4, '/api/sys/resource/page', '', null, 'sys:resource:page', 1, null, 'sys_module', 8, 0, null, null, 0, '2025-03-11 12:47:57', 'superAdmin', '2025-03-11 12:51:54', 'superAdmin'),
        (2076, 'menu_sys_module', '模块详情', 'btn_sys_module_detail', 4, '/api/sys/resource/detail', '', null, 'sys:resource:detail', 1, null, 'sys_module', 10, 0, null, null, 0, '2025-03-11 12:53:35', 'superAdmin', '2025-03-11 12:53:35', 'superAdmin'),

        (2077, 'menu_sys_menu', '新增菜单', 'btn_sys_menu_add', 4, '/api/sys/resource/add', '', '', 'sys:resource:add', 1, null, 'sys_module', 2, 0, null, '', 0, '2025-02-05 18:27:12', null, '2025-02-05 18:27:12', null),
        (2078, 'menu_sys_menu', '删除菜单树', 'btn_sys_menu_deleteTree', 4, '/api/sys/resource/deleteTree', '', null, 'sys:resource:deleteTree', 1, null, 'sys_module', 4, 0, null, null, 0, '2025-03-11 12:51:42', 'superAdmin', '2025-03-11 12:51:42', 'superAdmin'),
        (2079, 'menu_sys_menu', '修改菜单', 'btn_sys_menu_edit', 4, '/api/sys/resource/edit', '', null, 'sys:resource:edit', 1, null, 'sys_module', 6, 0, null, null, 0, '2025-03-11 12:52:47', 'superAdmin', '2025-03-11 12:52:47', 'superAdmin'),
        (2080, 'menu_sys_menu', '菜单树', 'btn_sys_menu_tree', 4, '/api/sys/resource/tree', '', null, 'sys:resource:detail', 1, null, 'sys_module', 8, 0, null, null, 0, '2025-03-11 12:53:35', 'superAdmin', '2025-03-11 12:53:35', 'superAdmin'),
        (2081, 'menu_sys_menu', '菜单详情', 'btn_sys_menu_detail', 4, '/api/sys/resource/detail', '', null, 'sys:resource:detail', 1, null, 'sys_module', 10, 0, null, null, 0, '2025-03-11 12:53:35', 'superAdmin', '2025-03-11 12:53:35', 'superAdmin'),

        (2082, 'menu_sys_button', '新增按钮', 'btn_sys_button_add', 4, '/api/sys/resource/add', '', null, 'sys:resource:add', 1, null, 'sys_module', 2, 0, null, null, 0, '2025-03-11 12:50:12', 'superAdmin', '2025-03-11 12:50:12', 'superAdmin'),
        (2083, 'menu_sys_button', '删除按钮', 'btn_sys_button_delete', 4, '/api/sys/resource/delete', '', null, 'sys:resource:delete', 1, null, 'sys_module', 4, 0, null, null, 0, '2025-03-11 12:51:42', 'superAdmin', '2025-03-11 12:51:42', 'superAdmin'),
        (2084, 'menu_sys_button', '修改按钮', 'btn_sys_button_edit', 4, '/api/sys/resource/add', '', null, 'sys:resource:edit', 1, null, 'sys_module', 6, 0, null, null, 0, '2025-03-11 12:52:47', 'superAdmin', '2025-03-11 12:52:47', 'superAdmin'),
        (2085, 'menu_sys_button', '按钮列表', 'btn_sys_button_list', 4, '/api/sys/resource/page', '', null, 'sys:resource:page', 1, null, 'sys_module', 8, 0, null, null, 0, '2025-03-11 12:47:57', 'superAdmin', '2025-03-11 12:51:54', 'superAdmin'),
        (2086, 'menu_sys_button', '按钮详情', 'btn_sys_button_detail', 4, '/api/sys/resource/detail', '', null, 'sys:resource:detail', 1, null, 'sys_module', 10, 0, null, null, 0, '2025-03-11 12:53:35', 'superAdmin', '2025-03-11 12:53:35', 'superAdmin'),

        (2087, 'menu_biz_org', '新增机构', 'btn_biz_org_add', 4, null, null, null, null, 1, null, 'biz_module', 2, 0, null, '', 0, null, null, null, null),
        (2088, 'menu_biz_org', '删除机构', 'btn_biz_org_del', 4, null, null, null, null, 1, null, 'biz_module', 4, 0, null, '', 0, null, null, null, null),
        (2089, 'menu_biz_org', '编辑机构', 'btn_biz_org_edit', 4, null, null, null, null, 1, null, 'biz_module', 6, 0, null, '', 0, null, null, null, null);

-- 关系
insert into moyu.sys_relation (id, object_id, target_id, relation_type, delete_flag, create_time, create_by, update_time, update_by)
values  (1, 'ROOT', 'superAdmin', 1, 0, null, null, null, null),
        (2, 'superAdmin', 'superAdmin', 1, 0, '2025-03-05 20:12:30', 'superAdmin', '2025-03-05 20:12:30', 'superAdmin'),
        (3, 'superAdmin', 'menu_sys_org', 2, 0, '2025-03-05 20:12:30', 'superAdmin', '2025-03-05 20:12:30', 'superAdmin'),
        (4, 'superAdmin', 'menu_sys_user', 2, 0, '2025-03-05 20:12:30', 'superAdmin', '2025-03-05 20:12:30', 'superAdmin'),
        (5, 'superAdmin', 'menu_sys_group', 2, 0, '2025-03-05 20:12:30', 'superAdmin', '2025-03-05 20:12:30', 'superAdmin'),
        (6, 'superAdmin', 'menu_sys_role', 2, 0, '2025-03-05 20:12:30', 'superAdmin', '2025-03-05 20:12:30', 'superAdmin'),
        (7, 'superAdmin', 'menu_sys_module', 2, 0, '2025-03-05 20:12:30', 'superAdmin', '2025-03-05 20:12:30', 'superAdmin'),
        (8, 'superAdmin', 'menu_sys_menu', 2, 0, '2025-03-05 20:12:30', 'superAdmin', '2025-03-05 20:12:30', 'superAdmin'),
        (9, 'superAdmin', 'menu_sys_button', 2, 0, '2025-03-05 20:12:30', 'superAdmin', '2025-03-05 20:12:30', 'superAdmin'),
        (10, 'superAdmin', 'menu_biz_pos', 2, 0, '2025-03-07 09:28:00', 'superAdmin', '2025-03-07 09:28:00', 'superAdmin'),
        (11, 'G1897207291765641216', 'superAdmin', 3, 0, '2025-03-07 09:28:00', 'superAdmin', '2025-03-07 09:28:00', 'superAdmin'),
        (12, 'G1897207291765641216', 'superAdmin', 4, 0, '2025-03-07 09:28:00', 'superAdmin', '2025-03-07 09:28:00', 'superAdmin'),
        (13, 'G1897478009027895296', 'bjAdmin', 3, 0, '2025-03-07 09:28:00', 'superAdmin', '2025-03-07 09:28:00', 'superAdmin'),
        (14, 'G1897478009027895296', 'superAdmin', 4, 0, '2025-03-07 09:28:00', 'superAdmin', '2025-03-07 09:28:00', 'superAdmin'),
        (15, 'G1897207291765641216', 'bjAdmin', 3, 0, '2025-03-07 09:28:00', 'superAdmin', '2025-03-07 09:28:00', 'superAdmin'),
        (16, '67c19a5de4b0576ca0dc6dd8', 'superAdmin', 5,  0, '2025-03-07 09:28:00', 'superAdmin', '2025-03-07 09:28:00', 'superAdmin');

