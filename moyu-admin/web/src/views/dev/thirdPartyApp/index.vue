<template>
  <!-- 上方查询区 -->
  <a-card size="small">
    <a-form ref="queryFormRef" :model="queryFormData">
      <a-row :gutter="24">
        <a-col :span="6">
          <a-form-item name="appCode" label="应用标识">
            <a-input v-model:value="queryFormData.appCode" placeholder="搜索应用标识" allowClear />
          </a-form-item>
        </a-col>
        <a-col :span="6">
          <a-form-item name="appName" label="应用名称">
            <a-input v-model:value="queryFormData.appName" placeholder="搜索应用名称" allowClear />
          </a-form-item>
        </a-col>
        <a-col :span="6">
          <a-form-item name="digestAlgo" label="签名算法">
            <a-select v-model:value="queryFormData.digestAlgo" placeholder="签名算法" :options="digestOptions" allowClear />
          </a-form-item>
        </a-col>
        <a-col :span="6">
          <a-form-item>
            <a-flex gap="small">
              <a-button type="primary" :icon="h(SearchOutlined)" @click="querySubmit">查询</a-button>
              <a-button :icon="h(RedoOutlined)" @click="reset">重置</a-button>
            </a-flex>
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
          <a-button type="primary" :icon="h(PlusOutlined)" @click="formRef.onOpen()">新增</a-button>
          <a-button danger :icon="h(DeleteOutlined)" @click="gridRef?.commitProxy('delete')">批量删除</a-button>
        </a-space>
      </template>
      <!-- 字段插槽 -->
      <template #appCode="{row, rowIndex, column, columnIndex}">
        <a @click="openDetail(row)">{{ row.appCode }}</a>
      </template>
      <template #digestAlgo="{row, rowIndex, column, columnIndex}">
        <a-tag color="blue">{{ row.digestAlgo }}</a-tag>
      </template>
      <template #action="{row, rowIndex, column, columnIndex}">
        <a-space>
          <template #split>
            <a-divider type="vertical" />
          </template>
          <a-tooltip title="编辑">
            <a @click="formRef.onOpen(row)"><FormOutlined /></a>
          </a-tooltip>
          <a-tooltip title="删除">
            <a-popconfirm title="确定要删除吗？" @confirm="deleteThirdPartyApp(row)">
              <a style="color:#FF4D4F;"><DeleteOutlined/></a>
            </a-popconfirm>
          </a-tooltip>
        </a-space>
      </template>
    </vxe-grid>
  </a-card>
  <Form ref="formRef" @successful="refresh()"/>
  <Detail ref="detailRef"/>
</template>

<script setup>
  import thirdPartyAppApi from '@/api/dev/thirdPartyAppApi.js'

  import { h, ref } from "vue"
  import { useRoute, useRouter } from "vue-router"
  import { PlusOutlined, DeleteOutlined, RedoOutlined, SearchOutlined, DownOutlined, UpOutlined } from "@ant-design/icons-vue"
  import { message } from "ant-design-vue"
  import Form from "./form.vue"
  import Detail from "./detail.vue"

  // store
  const route = useRoute();
  const router = useRouter();

  // 查询表单相关对象
  const queryFormRef = ref()
  const queryFormData = ref({})
  // 签名算法下拉框选项
  const digestOptions = [
    { label: "md5", value: "md5" },
    { label: "sha1", value: "sha1" },
    { label: "sha256", value: "sha256" },
    { label: "sha384", value: "sha384" },
    { label: "sha512", value: "sha512" },
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
          return thirdPartyAppApi.deleteThirdPartyApp({ ids })
        }
      }
    },
    // 列字段
    columns: [
      { type: 'checkbox', width: 50 },
      { type: 'seq', width: 50 },
      { field: 'appCode', title: '应用标识', width: 150, slots: { default: 'appCode' } },
      { field: 'appName', title: '应用名称', width: 150 },
      { field: 'digestAlgo', title: '签名算法', width: 150, slots: { default: 'digestAlgo' } },
      { field: 'remark', title: '备注' },
      { field: 'updateTime', title: '修改时间', width: 170 },
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
    return thirdPartyAppApi.thirdPartyAppPage(param).then((res) => {
      // res.data 为 {total, records}
      return res.data
    }).catch((err) => {
      console.error(err)
    })
  }

  // 删除
  const deleteThirdPartyApp = (record) => {
    let data = { ids: [record.id] }
    thirdPartyAppApi.deleteThirdPartyApp(data).then((res) => {
      message.success(res.message)
      refresh()
    })
  }

  // 打开详情页
  const openDetail = (row) => {
    detailRef.value.onOpen(row)
    // 独立页面打开(与抽屉打开二选一)
    // router.push({ path: "/dev/thirdPartyApp/detail", query: { id: row.id } })
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
