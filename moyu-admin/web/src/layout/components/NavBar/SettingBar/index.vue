<template>
	<!-- 系统设置Bar -->
  <div class="bar-item" @click="openSetting">
    <SettingOutlined />
  </div>
  <!-- 系统设置抽屉 -->
  <a-drawer v-model:open="settingDialog" :closable="false" width="300">
    <setting />
  </a-drawer>
</template>
<script setup>
	import { SettingOutlined } from "@ant-design/icons-vue"
  import Setting from "@/layout/components/NavBar/SettingBar/setting.vue"

  const settingDialog = ref(false)

  // 设置抽屉
  const openSetting = () => {
    settingDialog.value = true
  }
</script>

<style scoped>
</style>
