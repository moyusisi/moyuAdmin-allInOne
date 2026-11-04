<template>
  <!-- 经典布局 -->
  <a-layout>
    <!-- 左侧侧边栏 a-layout-sider -->
    <SideBar />
    <!-- 右侧布局 -->
    <a-layout>
      <!-- 最上方导航 -->
      <NavBar />
      <!-- 多标签 -->
      <TabsView v-if="tabsView" />
      <!-- 主要内容区域 -->
      <a-layout-content class="main-content-wrapper">
        <AppMain/>
      </a-layout-content>
    </a-layout>
  </a-layout>

</template>

<script setup>
import { notification, Button } from 'ant-design-vue'
import { getLocalVersion, getOnlineVersion } from '@/utils/version'
import SideBar from "@/layout/components/SideBar/index.vue"
import NavBar from "@/layout/components/NavBar/index.vue"
import TabsView from "@/layout/components/TabsView/index.vue"
import AppMain from "@/layout/components/AppMain/index.vue"
import { useSettingsStore } from "@/store"

const settingsStore = useSettingsStore()
const tabsView = computed(() => {
  return settingsStore.tabsView
})

onMounted(() => {
  updateVersion()
})
// 新版检测
const updateVersion = () => {
  const updateVersionOpen = import.meta.env.VITE_VERSION_UPDATE
  if (updateVersionOpen) {
    setTimeout(async () => {
      // 本地
      let localVersion = getLocalVersion()
      // 线上
      let onlineVersion = await getOnlineVersion()
      // 如果有新版本且不一样，提示更新
      if (onlineVersion && localVersion !== onlineVersion) {
        // 防止重复弹出更新提示
        if (document.querySelector('.notification-update-version')) {
          return
        }
        const key = `open${Date.now()}`
        notification.open({
          type: 'info',
          message: '发现新版本',
          description: '检测到新版本，请更新后使用',
          duration: 0,
          btn: () =>
              h(
                  Button,
                  {
                    type: 'primary',
                    onClick: () => {
                      notification.close(key)
                      window.location.reload(true)
                    }
                  },
                  { default: () => '立即更新' }
              ),
          key
        })
      }
    }, 3000)
  }
}
</script>

<style scoped>

</style>
