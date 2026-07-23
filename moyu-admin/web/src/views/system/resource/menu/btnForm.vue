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
    <template #extra>
      <a-button type="primary" size="small" @click="onClose"><CloseOutlined /></a-button>
    </template>
    <a-form ref="formRef" :model="formData" :label-col="{span: 6}">
      <a-card>
        <template #title>
          <span><RightSquareFilled style="color: dodgerblue;"/>基本信息</span>
        </template>
        <a-row :gutter="24">
          <a-col :span="12">
            <a-form-item name="name" label="名称" tooltip="" required>
              <a-input v-model:value="formData.name" placeholder="请输入名称" allow-clear />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item name="code" label="唯一编码" tooltip="不填将自动生成，创建后不可更改">
              <a-input v-model:value="formData.code" placeholder="如:btn_sys_user_edit" :disabled="edit" allowClear/>
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item name="parentCode" label="上级菜单" tooltip="" required>
              <MenuTreeSelect :moduleCode="formData.module" :defaultValue="formData.parentCode" @onChange="parentChange"/>
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item name="sortNum" label="排序顺序" tooltip="排序顺序" required>
              <a-input-number v-model:value="formData.sortNum" style="width: 100%"/>
            </a-form-item>
          </a-col>
        </a-row>
      </a-card>
      <a-card>
        <template #title>
          <span><RightSquareFilled style="color: dodgerblue;"/>按钮信息</span>
        </template>
        <a-row :gutter="24">
          <!-- 按钮:权限标识 -->
          <a-col :span="12" v-if="formData.resourceType === 6">
            <a-form-item name="permission" label="权限标识" tooltip="权限标识，如'sys:user:add'" required>
              <a-input v-model:value="formData.permission" placeholder="请输入权限标识" allow-clear/>
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item name="remark" label="备注" tooltip="" >
              <a-textarea v-model:value="formData.remark" placeholder="备注" allowClear showCount :maxlength="100" />
            </a-form-item>
          </a-col>
        </a-row>
      </a-card>
    </a-form>
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
  import resourceApi from '@/api/system/resourceApi.js'
  import { message } from "ant-design-vue"
  import { useSettingsStore } from "@/store"
  import { RightSquareFilled } from "@ant-design/icons-vue"
  import MenuTreeSelect from "@/views/system/components/menuTreeSelect.vue"

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
    resourceType: 6,
    visible: 0,
    sortNum: 99
  })
  const dataLoading = ref(false)
  const submitLoading = ref(false)
  const treeData = ref([])

  // 打开抽屉
  const onOpen = (row, module, parentCode) => {
    if (row) {
      edit.value = true
      title.value = "编辑按钮"
      // 表单数据赋值
      loadData(row)
    } else {
      edit.value = false
      title.value = "新增按钮"
      // 菜单树默认值,无法异步赋值
      formData.value.module = module.code
      formData.value.parentCode = parentCode ? parentCode : module.code
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
    // 获取模块信息
    resourceApi.resourceDetail(param).then((res) => {
      formData.value = res.data
    }).finally(() => {
      dataLoading.value = false
      // 数据就绪之后显示
      visible.value = true
    })
  }
  // 选择上级加载模块的选择框
  const parentChange = (value, label) => {
    formData.value.parentCode = value
  }

  // 验证并提交数据
  const onSubmit = () => {
    formRef.value.validate().then(() => {
      submitLoading.value = true
      // formData.value 加工处理 add/edit
      let fun = resourceApi.addResource
      if (edit.value) {
        fun = resourceApi.editResource
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
