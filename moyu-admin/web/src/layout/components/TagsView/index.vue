<template>
  <div class="admin-tags">
    <a-tabs
        v-model:activeKey="activeKey"
        type="editable-card"
        class="admin-tabs"
        hide-add
        @edit="onTabRemove"
        @tabClick="onTabClick"
        @mouseup="onTabUp"
    >
      <template #leftExtra>
        <div class="admin-tabs-arrow" @click="scrollLeft">
          <left-outlined/>
        </div>
      </template>
      <template #rightExtra>
        <div class="admin-tabs-arrow" @click="scrollRight">
          <right-outlined/>
        </div>
      </template>

      <a-tab-pane v-for="tag in tagList" :key="tag.fullPath" :closable="!(tag?.affix===true)">
        <template #tab>
					<span :key="tag.fullPath">
						{{ tag.title }}
					</span>
        </template>
      </a-tab-pane>
    </a-tabs>
  </div>
</template>

<script setup lang="ts">
import { useTagsViewStore, useMenuStore } from '@/store'
import { TagView } from "@/types/global"

const route = useRoute()
const router = useRouter()
const tagsViewStore = useTagsViewStore()
const menuStore = useMenuStore()
// 解构 store中的属性
const { visitedViews } = toRefs(tagsViewStore)

const tagList = computed(() => {
  return visitedViews.value
})

const activeKey = ref()
const affixTags = ref<TagView[]>([]);

// 首次加载会调用onMounted但route不会改变
onMounted(() => {
  // console.log('onMounted')
  initTags()
  addView(route)
  activeKey.value = route.fullPath
})

// 非首次加载则不再调用onMounted，但route会改变
watch(route, (to) => {
  // console.log('watch')
  addView(to)
  activeKey.value = to.fullPath
})


function initTags() {
  const tags = filterAffixTags(menuStore.routes);
  affixTags.value = tags;
  for (const tag of tags) {
    // Must have tag name
    if (tag.name) {
      tagsViewStore.addView(tag)
    }
  }
}

/**
 * 过滤出需要固定的标签
 */
function filterAffixTags(routes) {
  let tags: TagView[] = [];
  routes.forEach((route) => {
    const tagPath = route.path;
    if (route.meta?.affix) {
      tags.push({
        path: tagPath,
        fullPath: tagPath,
        name: String(route.name),
        title: route.meta?.title || "no-name",
        affix: route.meta?.affix,
        keepAlive: route.meta?.keepAlive,
      });
    }
    if (route.children) {
      const tempTags = filterAffixTags(route.children)
      if (tempTags.length >= 1) {
        tags = [...tags, ...tempTags]
      }
    }
  });
  return tags;
}

// 增加tagsView
const addView = (to) => {
  activeKey.value = to.fullPath
  if (to.meta.title) {
    tagsViewStore.addView({
      name: to.name as string,
      title: to.meta.title,
      path: to.path,
      fullPath: to.fullPath,
      affix: to.meta?.affix,
      keepAlive: to.meta?.keepAlive,
    });
  }
}

const onTabRemove = (tabKey, action) => {
  // console.log(action, tabKey)
  if (action === 'remove') {
    const tag = tagList.value.find((tag) => tag.fullPath === tabKey)
    closeSelectedTag(tag)
  }
}
// 关闭tag
const closeSelectedTag = (tag, autoPushLatestView = true) => {
  // 移除时会同步改变 tagList.value
  tagsViewStore.removeView(tag)
  if (autoPushLatestView && isActive(tag)) {
    const latestView = tagList.value.slice(-1)[0]
    // console.log('isActive', latestView)
    if (latestView) {
      router.push(latestView.path)
    } else {
      router.push('/')
    }
  }
}
// 是否激活
const isActive = (to) => {
  return to.path === route.path
}
const onTabClick = (tabKey) => {
  // console.log('onTabClick', tabKey)
  router.push(tabKey)
}
// 处理鼠标放开事件
const onTabUp = (e) => {
  // 鼠标中键
  if (e.which === 2) {
    // handleTabContextMenu(e)
    // closeTabs()
  }
}
const getTabWrapEl = () => {
  return document.querySelector('.ant-tabs-nav-wrap')
}
const scrollLeft = () => {
  const wrapEl = getTabWrapEl()
  if (wrapEl) {
    const event = new WheelEvent('wheel', { deltaX: 0, deltaY: -100 })
    wrapEl.dispatchEvent(event)
  }
}
const scrollRight = () => {
  const wrapEl = getTabWrapEl()
  if (wrapEl) {
    const event = new WheelEvent('wheel', { deltaX: 0, deltaY: 100 })
    wrapEl.dispatchEvent(event)
  }
}
</script>

<style lang="less">

.admin-tags {
  height: 40px;
  background: var(--background-color);
}

.admin-tabs {
  //overflow: hidden; // 新增
  &.ant-tabs {
    z-index: 99;

    .ant-tabs-nav {
      margin-bottom: 0;

      .ant-tabs-extra-content {
        display: flex;
      }

      .ant-tabs-nav-wrap {
        .ant-tabs-ink-bar {
          visibility: visible;
        }

        .ant-tabs-tab-with-remove {
          padding-right: 4px;
        }

        .ant-tabs-tab {
          background: none;
          height: 40px;
          line-height: 40px;
          transition: background-color 0.3s,
          color 0.3s;
          padding: 0 16px;
          border-radius: 0;
          border: none;
          margin: 0;

          .ant-tabs-tab-remove {
            margin: 0;
            padding: 0 5px;
          }
        }

        .ant-tabs-tab-active {
          background: var(--primary-1);
        }
      }
    }

    .admin-tabs-drop,
    .admin-tabs-arrow,
    .ant-tabs-nav-operations .ant-tabs-nav-more {
      padding: 0;
      width: 40px;
      height: 40px;
      line-height: 40px;
      text-align: center;
      cursor: pointer;

      .anticon {
        font-size: 12px;
        vertical-align: -1px;
      }
    }
  }
}

</style>