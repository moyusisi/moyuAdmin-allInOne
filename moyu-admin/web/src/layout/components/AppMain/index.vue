<template>
  <div class="admin-ui-main">
    <router-view v-slot="{ Component, route }">
      <!--  TODO keep-alive还有点问题，被缓存的页面，激活时onMounted和onActivated都会触发，导致多次请求    -->
      <keep-alive :include="cachedViews">
        <component :is="currentComponent(Component, route)" :key="route.fullPath"/>
      </keep-alive>
    </router-view>
    <iframe-view/>
  </div>
</template>

<script setup>
import IframeView from "./iframeView.vue"
import { useTagsViewStore } from "@/store"
const Error404  = () => import('@/views/other/404.vue')

// 缓存页面集合, 直接解构store中的同名字段
const { cachedViews } = toRefs(useTagsViewStore());

// 当前组件 keep-alive通过组件的name匹配,而不是route的name
const wrapperMap = new Map();
const currentComponent = (component, route) => {
  if (!component) return;
  // 使用路由的fullPath作为组件名称
  const { fullPath: componentName } = route;
  let wrapper = wrapperMap.get(componentName);
  // 对组件进行包装
  if (!wrapper) {
    wrapper = {
      name: componentName,
      render: () => {
        try {
          return h(component);
        } catch (error) {
          console.error(`Error rendering component for route: ${componentName}`, error);
          return h(Error404);
        }
      },
    };
    wrapperMap.set(componentName, wrapper);
  }

  // 添加组件数量限制
  if (wrapperMap.size > 10) {
    const firstKey = wrapperMap.keys().next().value;
    if (firstKey) {
      wrapperMap.delete(firstKey);
    }
  }
  return h(wrapper);
}

</script>

<style scoped>

</style>
