import { defineStore } from "pinia"
import { TagView } from "@/types/global";

export const useTagsViewStore = defineStore('tagsView', () => {
  // 定义state
  // 访问列表，用于tabs页签
  const visitedViews = ref<TagView[]>([]);
  // 缓存列表，用于keep-alive
  const cachedViews = ref<string[]>([]);

  // 定义action
  function addView(view: TagView) {
    // 添加到已访问列表
    addVisitedView(view)
    // 添加到缓存列表
    addCachedView(view)
  }

  // 移除视图
  function removeView(view: TagView) {
    // visitedViews中移除
    removeVisitedView(view)
    // cacheView中移除
    removeCachedView(view)
  }

  // 添加视图到已访问视图列表中
  function addVisitedView(view: TagView) {
    // 重定向不添加
    if (view.path.startsWith("/redirect")) {
      return;
    }
    // 已存在于已访问的视图列表中，则不再添加
    if (visitedViews.value.some((v) => v.path === view.path)) {
      return;
    }
    // 如果视图是固定的（affix），则在已访问的视图列表的开头添加
    if (view.affix) {
      visitedViews.value.unshift(view);
    } else {
      // 如果视图不是固定的，则在已访问的视图列表的末尾添加
      visitedViews.value.push(view);
    }
  }

  // 添加视图到已缓存列表中
  function addCachedView(view: TagView) {
    // 如果缓存视图名称已经存在于缓存视图列表中，则不再添加
    if (cachedViews.value.includes(view.fullPath)) {
      return;
    }
    // 如果视图需要缓存（keepAlive），则将其路由名称添加到缓存视图列表中
    if (view.keepAlive) {
      cachedViews.value.push(view.fullPath);
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

  // 从已访问视图列表中删除指定的视图
  function removeCachedView(view: TagView) {
    // cacheView中移除
    const index = cachedViews.value.indexOf(view.fullPath);
    if (index > -1) {
      cachedViews.value.splice(index, 1);
    }
  }

  return {
    visitedViews,
    cachedViews,
    addView,
    removeView,
  }
})