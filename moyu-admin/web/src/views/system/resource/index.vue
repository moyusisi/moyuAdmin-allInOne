<template>
  <!-- 上方查询区 -->
  <a-card size="small">
    <a-form ref="queryFormRef" :model="queryFormData">
      <a-row :gutter="24">
        <a-col :span="6">
          <a-form-item name="module" label="所属模块">
            <a-select v-model:value="queryFormData.module" placeholder="请选择模块" allowClear >
              <a-select-option v-for="item in moduleList" :key="item.code" :value="item.code">{{item.name}}</a-select-option>
            </a-select>
          </a-form-item>
        </a-col>
        <a-col :span="6">
          <a-form-item name="resourceType" label="资源类型">
            <a-select v-model:value="queryFormData.resourceType" placeholder="请选择资源类型" :options="resourceTypeOptions" allowClear />
          </a-form-item>
        </a-col>
        <a-col :span="6">
          <a-form-item name="name" label="名称">
            <a-input v-model:value="queryFormData.name" placeholder="搜索名称" allowClear />
          </a-form-item>
        </a-col>
        <a-col :span="6">
          <a-form-item>
            <a-flex gap="small">
              <a-button type="primary" :icon="h(SearchOutlined)" @click="querySubmit">查询</a-button>
              <a-button :icon="h(RedoOutlined)" @click="reset">重置</a-button>
              <a-button v-if="!showMore" type="link" @click="showMore = !showMore">更多条件<DownOutlined /></a-button>
              <a-button v-else type="link"  @click="showMore = !showMore">收起<UpOutlined /></a-button>
            </a-flex>
          </a-form-item>
        </a-col>
        <a-col :span="6" v-if="showMore">
          <a-form-item name="code" label="唯一编码">
            <a-input v-model:value="queryFormData.code" placeholder="请输入编码" allowClear />
          </a-form-item>
        </a-col>
        <a-col :span="6" v-if="showMore">
          <a-form-item name="path" label="路由地址">
            <a-input v-model:value="queryFormData.path" placeholder="搜索路由地址" allowClear />
          </a-form-item>
        </a-col>
        <a-col :span="6" v-if="showMore">
          <a-form-item name="component" label="组件地址">
            <a-input v-model:value="queryFormData.component" placeholder="搜索组件地址" allowClear />
          </a-form-item>
        </a-col>
        <a-col :span="6" v-if="showMore">
          <a-form-item name="permission" label="权限标识">
            <a-input v-model:value="queryFormData.permission" placeholder="搜索权限标识" allowClear />
          </a-form-item>
        </a-col>
      </a-row>
    </a-form>
  </a-card>
  <a-card size="small">
    <!--  表格数据区  -->
    <vxe-grid ref="gridRef" v-bind="gridOptions">
      <!-- 左侧操作栏 -->
      <template #toolbarButtons>
        <a-space wrap style="margin-bottom: 6px">
<!--          <a-button type="primary" :icon="h(PlusOutlined)" @click="formRef.onOpen()">新增</a-button>-->
        </a-space>
      </template>
      <!-- 字段插槽 -->
      <template #icon="{row, rowIndex, column, columnIndex}">
        <span v-if="row.icon && row.icon !== '#'" >
          <component :is="row.icon"/>
        </span>
        <span v-else />
      </template>
      <template #resourceType="{row, rowIndex, column, columnIndex}">
        <a-tag v-if="row.resourceType === 1" color="orange">模块</a-tag>
        <a-tag v-if="row.resourceType === 2" color="cyan">目录</a-tag>
        <a-tag v-if="row.resourceType === 3" color="blue">菜单</a-tag>
        <a-tag v-if="row.resourceType === 4" color="gold">内链</a-tag>
        <a-tag v-if="row.resourceType === 5" color="green">链接</a-tag>
        <a-tag v-if="row.resourceType === 6" color="purple">按钮</a-tag>
      </template>
      <template #code="{row, rowIndex, column, columnIndex}">
        <a @click="openDetail(row)">{{ row.code }}</a>
      </template>
      <template #path="{row, rowIndex, column, columnIndex}">
        <a-tag v-if="row.path" :bordered="false">{{ row.path }}</a-tag>
        <span v-else>-</span>
      </template>
      <template #component="{row, rowIndex, column, columnIndex}">
        <a-tag v-if="row.component" :bordered="false">{{ row.component }}</a-tag>
        <span v-else>-</span>
      </template>
      <template #permission="{row, rowIndex, column, columnIndex}">
        <a-tag v-if="row.permission" :bordered="false">{{ row.permission }}</a-tag>
        <span v-else>-</span>
      </template>
      <template #visible="{row, rowIndex, column, columnIndex}">
        <span v-if="row.resourceType !== 6" >
            <a-tag v-if="row.visible === 1" color="green">显示</a-tag>
            <a-tag v-else>隐藏</a-tag>
          </span>
        <span v-else ></span>
      </template>
      <template #action="{row, rowIndex, column, columnIndex}">
        <a-space>
          <template #split>
            <a-divider type="vertical" />
          </template>
        </a-space>
      </template>
    </vxe-grid>
  </a-card>
  <Form ref="formRef" @successful="refresh()"/>
  <Detail ref="detailRef"/>
</template>

<script setup>
  import resourceApi from '@/api/system/resourceApi.js'

  import { h, ref } from "vue"
  import { useRoute, useRouter } from "vue-router"
  import { PlusOutlined, DeleteOutlined, RedoOutlined, SearchOutlined, FormOutlined } from "@ant-design/icons-vue"
  import { message } from "ant-design-vue"
  import Form from "@/views/system/resource/module/form.vue"
  import Detail from "@/views/system/resource/detail.vue"

  // store
  const route = useRoute();
  const router = useRouter();

  // 查询表单相关对象
  const queryFormRef = ref()
  const queryFormData = ref({})
  const moduleList = ref([])
  // 是否展示更多搜索条件
  const showMore = ref(false)
  // 下拉框选项
  const resourceTypeOptions = [
    { label: "模块", value: 1 },
    { label: "目录", value: 2 },
    { label: "菜单", value: 3 },
    { label: "按钮", value: 6 },
    { label: "内部链接", value: 4 },
    { label: "外部链接", value: 5 },
  ]

  // 其他页面操作
  const formRef = ref()
  const detailRef = ref()

  /***** 表格相关对象 start *****/
  const gridRef = ref()
  const gridOptions = ref({
    // 分页配置项
    pagerConfig: {
      enabled: true,
    },
    // 排序配置项
    sortConfig: {
      // 服务端排序
      remote: true,
    },
    // 数据代理配置
    proxyConfig: {
      // 获取响应的值配置
      response: {
        // 只对 pager-config 配置时有效，响应结果中获取数据列表的属性（分页场景）
        result: "records",
        // 只对 pager-config 配置时有效，响应结果中获取分页的属性（分页场景）
        total: "total",
      },
      // 启用排序请求代理
      sort: true,
      // 代理配置
      ajax: {
        query: ({ page, sort, sorts, filters, form }) => {
          const sortItem = sorts[0] || {}
          // console.log(sortItem)
          // 默认接收 Promise<{ result: [], page: { total: 100 } }>
          return loadData({
            pageNum: page.currentPage,
            pageSize: page.pageSize,
            sortField: sortItem.field,
            sortOrder: sortItem.order
          })
        },
        delete: ({ body, form }) => {
          // 删除已选
          const ids = body.removeRecords.map(item => item.id);
          return resourceApi.deleteResource({ ids })
        }
      }
    },
    // 列字段
    columns: [
      { type: 'seq', width: 50 },
      { field: 'icon', title: '图标', width: 50, slots: { default: 'icon' } },
      { field: 'name', title: '名称', width: 150 },
      { field: 'resourceType', title: '资源类型', width: 80, slots: { default: 'resourceType' } },
      { field: 'code', title: '唯一编码', width: 150, sortable: true, slots: { default: 'code' } },
      { field: 'path', title: '路径地址', width: 150, sortable: true, slots: { default: 'path' } },
      { field: 'component', title: '组件地址', width: 150, sortable: true, slots: { default: 'component' } },
      { field: 'permission', title: '权限标识', width: 150, sortable: true, slots: { default: 'permission' } },
      { field: 'visible', title: '是否可见', width: 100, sortable: true, slots: { default: 'visible' } },
      { field: 'remark', title: '备注', width: 150 },
      { field: 'updateTime', title: '修改时间', width: 170, sortable: true, },
      { field: 'updateBy', title: '修改人', width: 150 },
      { field: 'action', title: '操作', width: 100, slots: { default: 'action' } },
    ],
    // 工具栏配置
    toolbarConfig: {
      // 是否显示个性化列配置
      custom: true,
      // 是否允许最大化显示
      zoom: true,
      // 刷新按钮配置
      refresh: true,
      // 插槽
      slots: {
        // 操作栏按钮
        buttons: "toolbarButtons",
      },
    },
  })
  /***** 表格相关对象 end *****/

  // 加载完毕调用
  onMounted(() => {
    resourceApi.moduleList().then((res) => {
      moduleList.value = res.data
    })
  })

  // 提交查询
  const querySubmit = () => {
    // reload 返回第一页触发ajax.query
    // query 当前页触发ajax.query
    gridRef.value?.commitProxy("reload")
  }
  // 重置
  const reset = () => {
    queryFormRef.value.resetFields()
    refresh()
  }
  // 重置
  const refresh = () => {
    // 返回第一页触发ajax.query
    gridRef.value?.commitProxy("reload")
  }
  // 加载数据
  const loadData = (parameter) => {
    // 分页参数
    let param = Object.assign(parameter, queryFormData.value)
    return resourceApi.resourcePage(param).then((res) => {
      // res.data 为 {total, records}
      return res.data
    }).catch((err) => {
      console.error(err)
    })
  }
  // 删除
  const deleteResource = (record) => {
    let data = { ids: [record.id] }
    resourceApi.deleteResource(data).then((res) => {
      message.success(res.message)
      refresh()
    })
  }

  // 打开详情页
  const openDetail = (row) => {
    detailRef.value.onOpen(row)
    // 独立页面打开(与抽屉打开二选一)
    // router.push({ path: "/system/resource/detail", query: { id: row.id } })
  }
</script>

<style scoped>
/** 后代选择器 **/
.ant-card .ant-form {
  margin-bottom: -12px !important;
}
.ant-card .ant-form-item {
  margin-bottom: 12px !important;
}
</style>
