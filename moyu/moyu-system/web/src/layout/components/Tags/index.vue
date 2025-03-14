<template>
  <div v-if="tagsView" class="admin-tags">
  </div>
</template>

<script setup>
import { useSettingsStore } from '@/store'

const settingsStore = useSettingsStore()

const tagsView = computed(() => {
  return settingsStore.tagsView
})

</script>

<style scoped>

</style>