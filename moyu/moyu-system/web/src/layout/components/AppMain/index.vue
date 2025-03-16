<template>
  <div id="admin-ui-main" class="admin-ui-main">
    <router-view v-slot="{ Component }">
      <keep-alive :include="cachedViews">
        <component :is="Component" :key="route.path"/>
      </keep-alive>
    </router-view>
    <iframe-view/>
  </div>
</template>

<script setup>
import IframeView from "./iframeView.vue"
import { useTagsViewStore } from "@/store"

const route = useRoute()
const cachedViews = computed(() => useTagsViewStore().cachedViews); // 缓存页面集合

</script>

<style scoped>

</style>
