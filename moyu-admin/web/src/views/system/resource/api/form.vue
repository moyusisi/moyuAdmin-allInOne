<template>
  <a-drawer
      :open="visible"
      :title="title"
      :width="drawerWidth"
      :closable="false"
      :maskClosable="false"
      :destroy-on-close="true"
      :get-container="getDrawerContainer"
      @close="onClose"
  >
    <!--  上方操作区  -->
    <template #extra>
      <a-button type="primary" size="small" @click="onClose"><CloseOutlined /></a-button>
    </template>
    <!--  数据区  -->
    <a-spin :spinning="dataLoading">
      <a-form ref="formRef" :model="formData" :label-col="{span: 6}">
        <a-card>
          <template #title>
            <span><RightSquareFilled style="color: dodgerblue;"/> 基本信息</span>
          </template>
          <a-row :gutter="24">
            <a-col :span="12">
              <a-form-item name="name" label="接口名称" tooltip="" required>
                <a-input v-model:value="formData.name" placeholder="接口名称" allowClear />
              </a-form-item>
            </a-col>
            <a-col :span="12">
              <a-form-item name="code" label="权限标识" tooltip="权限标识/唯一标识" required>
                <a-input v-model:value="formData.code" placeholder="权限标识/唯一标识" allowClear />
              </a-form-item>
            </a-col>
            <a-col :span="12">
              <a-form-item name="path" label="接口地址" tooltip="" required>
                <a-input v-model:value="formData.path" placeholder="接口地址" allowClear />
              </a-form-item>
            </a-col>
            <a-col :span="12">
              <a-form-item name="apiType" label="接口类型" tooltip="" >
                <a-radio-group v-model:value="formData.apiType" option-type="button" button-style="solid">
                  <a-radio :value="1">后端接口</a-radio>
                  <a-radio :value="2">三方接口</a-radio>
                </a-radio-group>
              </a-form-item>
            </a-col>
            <a-col :span="12" v-if="formData.apiType === 1">
              <a-form-item name="hasScope" label="数据范围" tooltip="是否控制数据范围" >
                <a-radio-group v-model:value="formData.hasScope" option-type="button" button-style="solid">
                  <a-radio :value="0">无</a-radio>
                  <a-radio :value="1">有</a-radio>
                </a-radio-group>
              </a-form-item>
            </a-col>
            <a-col :span="12">
              <a-form-item name="extJson" label="扩展信息" tooltip="" >
                <a-textarea v-model:value="formData.extJson" placeholder="扩展信息" allowClear />
              </a-form-item>
            </a-col>
            <a-col :span="12">
              <a-form-item name="remark" label="备注" tooltip="" >
                <a-textarea v-model:value="formData.remark" placeholder="备注" allowClear />
              </a-form-item>
            </a-col>
          </a-row>
        </a-card>
      </a-form>
    </a-spin>
    <!--  底部操作区  -->
    <template #footer>
      <a-flex gap="small" justify="flex-end">
        <a-button type="primary" danger @click="onClose"> 关闭</a-button>
        <a-button type="primary" :loading="submitLoading" @click="onSubmit">保存</a-button>
      </a-flex>
    </template>
  </a-drawer>
</template>
<script setup>
import sysApi from '@/api/system/api.js'

import { message } from "ant-design-vue"
import { useSettingsStore } from "@/store"

// store
const settingsStore = useSettingsStore()

const emit = defineEmits({ successful: null })
// 默认是关闭状态
const visible = ref(false)
const title = ref()
// 计算属性 抽屉宽度
const drawerWidth = computed(() => {
  return settingsStore.menuCollapsed ? `calc(100% - 80px)` : `calc(100% - 210px)`
})

// 是否为编辑
const edit = ref(false)
// 表单数据
const formRef = ref()
const formData = ref({
  apiType: 1,
  hasScope: 0,
})
const dataLoading = ref(false)
const submitLoading = ref(false)

// 打开抽屉
const onOpen = (row) => {
  if (row) {
    edit.value = true
    title.value = "编辑接口信息"
    // 表单数据赋值
    loadData(row)
  } else {
    edit.value = false
    title.value = "新增接口信息"
    // 数据就绪之后显示
    visible.value = true
  }
}
// 关闭抽屉
const onClose = () => {
  formRef.value.resetFields()
  visible.value = false
}
// 加载数据
const loadData = (row) => {
  dataLoading.value = true
  // 组装请求参数
  let param = { id: row.id }
  sysApi.apiDetail(param).then((res) => {
    formData.value = res.data
  }).finally(() => {
    dataLoading.value = false
    // 数据就绪之后显示
    visible.value = true
  })
}

// 验证并提交数据
const onSubmit = () => {
  formRef.value.validate().then(() => {
    submitLoading.value = true
    // formData.value 加工处理 add/edit
    let fun = sysApi.addApi
    if (edit.value) {
      fun = sysApi.editApi
    }
    // add/edit 发送不同请求
    fun(formData.value).then((res) => {
      message.success(res.message)
      emit('successful')
      onClose()
    }).finally(() => {
      submitLoading.value = false
    })
  }).catch(() => {
  })
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
.ant-form-item {
}
</style>
