import service from '@/utils/request'

/**
 * 用户中心API，当前登陆用户相关的API
 */
export default {
	// 获取登陆用户的信息
	loginUserInfo(data) {
		return service.postJson('/api/sys/userCenter/userInfo', data)
	},
	// 获取登陆用户的菜单树
	loginUserMenu(data) {
		return service.postJson('/api/sys/userCenter/userMenu', data)
	},

}
