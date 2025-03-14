import { defineStore } from "pinia"

export const useTagsViewStore = defineStore('tagsView', () => {
  // 定义state
  const visitedViews = ref([]);
  const cachedViews = ref([]);

  // 定义action
  function addView(route) {
  }

  function removeView(route) {
  }

  function clearViews() {
    cachedViews.value = [];
  }


  return {
    visitedViews,
    cachedViews,
    addView,
    removeView,
    clearViews,
  }
})