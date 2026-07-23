<template>
  <a-drawer
    :open="visible"
    title="菜单透视"
    :width="500"
    :closable="false"
    :destroy-on-close="true"
    :get-container="getDrawerContainer"
    @close="onClose"
  >
    <template #extra>
      <a-button type="primary" size="small" @click="onClose"><CloseOutlined /></a-button>
    </template>
    <!-- 页面内容 -->
    <a-card size="small">
      <a-tree
          v-if="treeData.length > 0"
          :tree-data="treeData"
          :field-names="treeFieldNames"
          :showLine="{ showLeafIcon:false }"
          default-expand-all
      >
        <template #title="{ name, code }">
          <span>{{ name }}</span>
        </template>
      </a-tree>
      <a-empty v-else :image="Empty.PRESENTED_IMAGE_SIMPLE" />
    </a-card>
  </a-drawer>
</template>

<script setup>
  import { Empty } from "ant-design-vue";

  // 默认是关闭状态
  const visible = ref(false)

  // 树的节点数据
  const treeData = ref([])
  // 替换treeNode 中 children,title,key
  const treeFieldNames = { children: 'children', title: 'name', key: 'code' }

  // 打开抽屉
  const onOpen = (menuTreeData) => {
    if (menuTreeData) {
      treeData.value = menuTreeData
    }
    // 数据就绪之后显示
    visible.value = true
  }
  // 关闭抽屉
  const onClose = () => {
    treeData.value = []
    visible.value = false
  }

  // 获取Drawer渲染到的dom容器。 默认body,当有vxe-grid时使用表格dom
  const getDrawerContainer = () => {
    // vxe-grid的z-index过大，防止盖住drawer
    return document.querySelector('.vxe-grid') || document.body
  }
  // 调用这个函数将子组件的一些数据和方法暴露出去
  defineExpose({
    onOpen
  })
</script>

<style scoped>
</style>
