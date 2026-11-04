import Layout from '@/layout/index.vue'

/**
 * 静态路由
 * * name            路由唯一标识，必填
 * * path            路由地址，必填，以"/"开头的绝对路径,children中的path也要写绝对路径
 * * component       路由的页面组件
 * * redirect        重定向地址，非必填
 * * children        子路由
 *
 * * meta.title      标题名称
 * * meta.icon       图标
 * * meta.type       菜单类型 dir|menu|link 等
 * * meta.hidden     是否隐藏
 * * meta.brief     【目录】是否简洁模式(目录下只有一个菜单时，不显示目录直接显示该菜单)
 * * meta.affix     【菜单】是否固定显示(标签页)
 * * meta.keepAlive 【菜单】是否支持缓存(标签页)
 * * meta.url       【链接】链接地址
 */
const routes = [
	{
		name: 'layout',
		path: '/',
		component: Layout,
		redirect: '/index',
		meta: { title: '系统菜单', hidden: false, brief: true, icon: 'home-outlined' },
		children: [
			{
				path: '/index',
				// 用于 keep-alive 功能，需要与 SFC 中自动推导或显式声明的组件名称一致
				// 参考文档: https://cn.vuejs.org/guide/built-ins/keep-alive.html#include-exclude
				name: 'Index',
				component: () => import('@/views/home/index.vue'),
				meta: { title: '首页', icon: 'home-outlined', affix: true }
			},
			{
				path: '/index2',
				// 用于 keep-alive 功能，需要与 SFC 中自动推导或显式声明的组件名称一致
				// 参考文档: https://cn.vuejs.org/guide/built-ins/keep-alive.html#include-exclude
				name: 'Index2',
				component: () => import('@/views/home/index2.vue'),
				meta: { title: '业务首页', icon: 'home-outlined' }
			},
		]
	},
	{
		name: 'Login',
		path: '/login',
		component: () => import('@/views/auth/login/login.vue'),
		meta: { title: '登录', hidden: true }
	},
	// 兜底路由，最后匹配的路由，将不会存在无匹配的情况
	{
		name: 'NotFound',
		path: '/:pathMatch(.*)*',
		component: () => import('@/layout/other/404.vue'),
		meta: { title: '404', hidden: true }
	}
]

export default routes
