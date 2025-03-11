<template>
	<div class="user-bar">
		<!-- 搜索面板 -->
		<div v-if="!isMobile" class="screen panel-item hidden-sm-and-down" @click="fullscreen">
			<fullscreen-outlined />
		</div>
		<a-dropdown class="user panel-item">
			<div class="user-avatar">
<!--        <a-avatar :src="userInfo ? userInfo.avatar : undefined" />-->
        <a-avatar>
          <template #icon><UserOutlined /></template>
        </a-avatar>
				<label>{{ userInfo.name }}</label>
			</div>
			<template #overlay>
				<a-menu>
          <a-sub-menu v-if="userInfo.groupInfoList && userInfo.groupInfoList.length > 1" key="groupSubMenu" :icon="h(UserSwitchOutlined)" title="岗位切换">
            <template v-for="group in userInfo.groupInfoList" :key="group.code" :item="group">
              <a-menu-item :class="{'item-selected':userInfo.groupCode === group.code}" @click="switchUserGroup(group.code)">
                <user-outlined class="mr8" />
                <span>{{ group.name }}</span>
                <div class="item-sub-title">{{ group.orgFullName }}</div>
              </a-menu-item>
            </template>
          </a-sub-menu>
          <a-menu-divider />
          <a-menu-item key="logOut" @click="userLogout()">
            <export-outlined class="mr8" />
            <span>退出登录</span>
          </a-menu-item>
				</a-menu>
			</template>
		</a-dropdown>
		<div class="setting panel-item" @click="openSetting">
			<layout-outlined />
		</div>
	</div>

	<!-- 整体风格设置抽屉 -->
	<a-drawer v-model:open="settingDialog" :closable="false" width="300">
		<setting />
	</a-drawer>
</template>

<script setup>
	import { h, createVNode } from 'vue'
  import { ExclamationCircleOutlined, UserSwitchOutlined } from '@ant-design/icons-vue'
	import { Modal } from 'ant-design-vue'
	import screenFull from 'screenfull'
	import { message } from 'ant-design-vue'
	import Setting from '../setting.vue'
	import router from '@/router'
	import loginApi from '@/api/auth/loginApi'
  import { useMenuStore, useUserStore } from '@/store'

	const settingDialog = ref(false)
  const userStore = useUserStore()
  const menuStore = useMenuStore()
	const isMobile = ref(false)
	const userInfo = computed(() => {
		return userStore.userInfo
	})

  // 切换用户岗位
  const switchUserGroup = async (groupCode) => {
    try {
      await userStore.switchUserGroup(groupCode)
      // await router.reloadRoutes()
      message.loading('切换中...', 0.5)
      window.location.href = '/index'
      message.success('切换成功')
    } catch (err) {
      message.error('切换失败')
      console.log(err)
    }
  }
	// 退出登陆
	const userLogout = () => {
    Modal.confirm({
				title: '提示',
				content: '确认退出当前用户？',
				icon: createVNode(ExclamationCircleOutlined),
				maskClosable: false,
				onOk() {
					message.loading('退出中...', 0.5)
					loginApi.logout().then(() => {
						// 清理掉个人的一些信息
            localStorage.clear()
						router.replace({ path: '/login' })
            userStore.$reset()
            menuStore.$reset()
					}).catch(() => {
            localStorage.clear()
						router.replace({ path: '/login' })
						location.reload()
					})
				},
				onCancel() {}
			})
	}
	// 设置抽屉
	const openSetting = () => {
		settingDialog.value = true
	}
	// 全屏
	const fullscreen = () => {
		const element = document.documentElement
		if (screenFull.isEnabled) {
			screenFull.toggle(element)
		}
	}
</script>

<style lang="less">
	:deep(.ant-modal) {
		top: 20px;
	}
	:deep(.ant-modal-content) {
		border-radius: 10px;
	}
	.user-bar {
		display: flex;
		align-items: center;
		height: 100%;
	}
	.user-bar .user-avatar {
		height: 49px;
		display: flex;
		align-items: center;
	}
	.user-bar .user-avatar label {
		display: inline-block;
		margin-left: 5px;
		cursor: pointer;
	}
	.setting {
		margin-right: 10px;
	}
  .mr8 {
    margin-right: 8px;
  }
  .item-sub-title {
    font-size: 12px;
    color: var(--text-color-secondary);
  }
  .item-selected {
    background-color: var(--primary-1);
  }
</style>
