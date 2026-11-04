import { defineStore } from "pinia"
import { TagView } from "@/types/global";
import { useMenuStore } from "@/store/menu.ts";

export const useTabsViewStore = defineStore('tabsView', () => {
  // 定义state
  // 访问列表，用于tabs页签
  const visitedViews = ref<TagView[]>([]);
  // 缓存列表，用于keep-alive
  const cacheList = ref<string[]>([]);

  // 定义action
  function addView(view: TagView) {
    // 重定向不添加
    if (view.path.startsWith("/redirect")) {
      return;
    }
    // 添加到已访问列表
    addVisitedView(view)
    // 添加到缓存列表
    addCachedView(view)
  }

  // 移除视图
  function removeView(view: TagView) {
    // visitedViews中移除
    removeVisitedView(view)
    // cacheList中移除
    removeCacheList(view)
  }

  // 添加视图到已访问视图列表中
  function addVisitedView(view: TagView) {
    // 查找已存在的tab
    const tab = visitedViews.value.find(v => v.path === view.path)
    // 存在同path的tab时，不新增标签页，复用此tab；不存在tab时，新增标签页
    if (tab) {
      tab.fullPath = view.fullPath
      return;
    }
    // 如果视图是固定的（affix），则在已访问的视图列表的开头添加
    if (view.affix) {
      // filter返回所有affix元素组成的数组，length即为个数
      let count = visitedViews.value.filter(item => view.affix).length;
      // 新view插入到前面所有affix后面
      visitedViews.value.splice(count, 0, view);
    } else {
      // 如果视图不是固定的，则在已访问的视图列表的末尾添加
      visitedViews.value.push(view);
    }
  }

  // 添加视图到已缓存列表中
  function addCachedView(view: TagView) {
    // 如果缓存视图名称已经存在于缓存视图列表中，则不再添加
    if (cacheList.value.includes(view.fullPath)) {
      return;
    }
    // 如果视图需要缓存（keepAlive），则将其路由名称添加到缓存视图列表中
    if (view.keepAlive) {
      cacheList.value.push(view.fullPath);
    }
  }

  // 从已访问视图列表中删除指定的视图
  function removeVisitedView(view: TagView) {
    // visitedViews中移除
    for (const [i, v] of visitedViews.value.entries()) {
      // 找到与指定视图路径匹配的视图，在已访问视图列表中删除该视图
      if (v.path === view.path) {
        visitedViews.value.splice(i, 1);
        break;
      }
    }
  }

  // 从缓存列表中删除指定的视图
  function removeCacheList(view: TagView) {
    // cacheList中移除
    const index = cacheList.value.indexOf(view.path);
    if (index > -1) {
      cacheList.value.splice(index, 1);
    }
  }

  // 根据菜单路由初始化标签,添加affix的页面
  function initTabs() {
    visitedViews.value = []
    cacheList.value = []
    const menuStore = useMenuStore()
    const tabs = filterAffixTabs(menuStore.routes);
    for (const tab of tabs) {
      if (tab.name) {
        addView(tab)
      }
    }
  }

  /**
   * 过滤出需要固定的标签
   */
  function filterAffixTabs(routes) {
    let tags: TagView[] = [];
    routes.forEach((route) => {
      if (route.meta?.affix) {
        tags.push({
          path: route.path,
          fullPath: route.fullPath || route.path,
          name: String(route.name),
          routeName: String(route.name),
          query: route.query,
          params: route.params,
          title: route.meta?.title || "no-name",
          affix: route.meta?.affix,
          keepAlive: route.meta?.keepAlive,
        });
      }
      if (route.children) {
        const tempTags = filterAffixTabs(route.children)
        if (tempTags.length >= 1) {
          tags = [...tags, ...tempTags]
        }
      }
    });
    return tags;
  }

  return {
    visitedViews,
    cacheList,
    initTabs,
    addView,
    removeView,
    removeCacheList,
  }
})