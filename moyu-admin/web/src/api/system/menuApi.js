import service from '@/utils/request'

/**
 * 菜单相关接口(菜单树中的id均使用的code)
 */
export default {
	// 查询菜单列表,暂未使用
	menuList(data) {
		return service.postJson('/api/sys/menu/list', data)
	},
	// 查询模块列表(menuType=1)
	moduleList(data) {
		return service.postJson('/api/sys/menu/list', { "menuType": 1 })
	},
	// 分页查询资源列表(模块、按钮列表)
	menuPage(data) {
		return service.postJson('/api/sys/menu/page', data)
	},
	// 获取菜单树(包括按钮)
	menuTree(data) {
		return service.postJson('/api/sys/menu/tree', data)
	},
	// 获取菜单详情
	menuDetail(data) {
		return service.postJson('/api/sys/menu/detail', data)
	},
	// 新增菜单
	addMenu(data) {
		return service.postJson('/api/sys/menu/add', data)
	},
	// 删除菜单，通过ids删除，不会集联删除
	deleteMenu(data) {
		return service.postJson('/api/sys/menu/delete', data)
	},
	// 删除菜单，通过codes删除，会集联删除整个树
	deleteMenuTree(data) {
		return service.postJson('/api/sys/menu/deleteTree', data)
	},
	// 编辑菜单
	editMenu(data) {
		return service.postJson('/api/sys/menu/edit', data)
	},
	// 获取菜单树选择器(不包括按钮)
	menuTreeSelector(data) {
		return service.postJson('/api/sys/menu/menuTreeSelector', data)
	},
}
