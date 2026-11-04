<template>
  <div class="admin-tabs-container">
    <vxe-tabs v-model="selectTab" padding :options="tabList" :close-config="closeConfig"
              @tab-click="onTabClick" @tab-close="onTabClose" :show-body="false">
    </vxe-tabs>
  </div>
</template>

<script setup lang="ts">
import { useTabsViewStore } from '@/store'

const route = useRoute()
const router = useRouter()
const tabsStore = useTabsViewStore()

// 解构 store中的属性
const { visitedViews } = toRefs(tabsStore)

const tabList = computed(() => {
  return visitedViews.value
})

// 选中的tab
const selectTab = ref()

const closeConfig = ref({
  enabled: true,
  visibleMethod({ name }) {
    const item = tabList.value.find(item => item.name === name)
    // affix不可关闭
    return !(item?.affix === true);
  }
})

// 首次加载会调用onMounted但route不会改变
onMounted(() => {
  // console.log('onMounted')
  tabsStore.initTabs()
  addTabView(route)
})

// 非首次加载则不再调用onMounted，但route会改变
watch(route, (to) => {
  // console.log('watch')
  addTabView(to)
})

// 把路由增加到tabsView
const addTabView = (to) => {
  selectTab.value = to.name
  if (to.meta.title) {
    const tabView = {
      path: to.path,
      fullPath: to.fullPath || to.path,
      name: to.name as string,
      routeName: to.name as string,
      query: to.query,
      params: to.params,
      title: to.meta?.title || "no-name",
      affix: to.meta?.affix,
      keepAlive: to.meta?.keepAlive,
    }
    tabsStore.addView(tabView);
  }
}

// 是否激活
const isActive = (tab) => {
  return tab.path === route.path
}

const onTabClick = ({ name }) => {
  const item = tabList.value.find(item => item.name === name)
  if (item) {
    if (item.fullPath !== route.fullPath) {
      router.push(item.fullPath)
    }
  }
}

const onTabClose = ({ name }) => {
  const item = tabList.value.find(item => item.name === name)
  closeSelectedTab(item)
}

// 关闭tab
const closeSelectedTab = (tab, autoPushLatestView = true) => {
  // 移除时会同步改变 tabList.value
  tabsStore.removeView(tab)
  if (autoPushLatestView && isActive(tab)) {
    const latestView = tabList.value.slice(-1)[0]
    // console.log('isActive', latestView)
    if (latestView) {
      // 注意这里要用fullPath
      router.push(latestView.fullPath)
    } else {
      router.push('/')
    }
  }
}
</script>

<style>

.admin-tabs-container {
  height: 40px;
  background: #FFFFFF;
}

/** 覆盖vxe的默认样式 */
.vxe-tabs-header--wrapper {
  height: 40px !important;
  .vxe-tabs-header--item {
    height: 40px !important;
  }
}

</style>