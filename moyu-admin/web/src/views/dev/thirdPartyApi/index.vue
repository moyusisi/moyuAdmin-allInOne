<template>
  <!-- 上方查询区 -->
  <a-card size="small">
    <a-form ref="queryFormRef" :model="queryFormData">
      <a-row :gutter="24">
        <a-col :span="6">
          <a-form-item name="code" label="唯一标识">
            <a-input v-model:value="queryFormData.code" placeholder="搜索唯一标识" allowClear />
          </a-form-item>
        </a-col>
        <a-col :span="6">
          <a-form-item name="name" label="接口名称">
            <a-input v-model:value="queryFormData.name" placeholder="搜索三方接口名称" allowClear />
          </a-form-item>
        </a-col>
        <a-col :span="6">
          <a-form-item name="url" label="接口URL">
            <a-input v-model:value="queryFormData.url" placeholder="搜索三方接口URL" allowClear />
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
          <a-form-item name="debugStatus" label="调试状态">
            <a-select v-model:value="queryFormData.debugStatus" placeholder="消息类型" :options="debugStatusOptions" allowClear />
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
      <template #code="{row, rowIndex, column, columnIndex}">
        <a @click="openDetail(row)">{{ row.code }}</a>
      </template>
      <template #url="{row, rowIndex, column, columnIndex}">
        <a-tag :bordered="false">{{ row.url }}</a-tag>
      </template>
      <template #requestMethod="{row, rowIndex, column, columnIndex}">
        <a-tag color="blue">{{ row.requestMethod }}</a-tag>
      </template>
      <template #debugStatus="{row, rowIndex, column, columnIndex}">
        <a-tag :bordered="false" v-if="row.debugStatus === 1" color="green">已调通</a-tag>
        <a-tag :bordered="false" v-else>未调通</a-tag>
      </template>
      <template #statusCode="{row, rowIndex, column, columnIndex}">
        <a-tag :bordered="false" v-if="row.statusCode === '200'" color="green">{{ row.statusCode }}</a-tag>
        <a-tag :bordered="false" v-else-if="row.statusCode">{{ row.statusCode }}</a-tag>
        <span v-else>-</span>
      </template>
      <template #action="{row, rowIndex, column, columnIndex}">
        <a-space>
          <template #split>
            <a-divider type="vertical" />
          </template>
          <a-tooltip title="调试">
            <a style="color:#53C61D;" @click="debugRef.onOpen(row)"><ApiOutlined /></a>
          </a-tooltip>
          <a-tooltip title="调用记录">
            <a style="color:grey" @click="openLog(row)"><HistoryOutlined /></a>
          </a-tooltip>
          <a-tooltip title="编辑">
            <a @click="formRef.onOpen(row)"><FormOutlined /></a>
          </a-tooltip>
          <a-tooltip title="删除">
            <a-popconfirm title="确定要删除吗？" @confirm="deleteThirdPartyApi(row)">
              <a style="color:#FF4D4F;"><DeleteOutlined/></a>
            </a-popconfirm>
          </a-tooltip>
        </a-space>
      </template>
    </vxe-grid>
  </a-card>
  <Form ref="formRef" @successful="refresh()"/>
  <Detail ref="detailRef"/>
  <Debug ref="debugRef" @successful="refresh()"/>
</template>

<script setup>
  import thirdPartyApi from '@/api/dev/thirdPartyApi.js'

  import { h, ref } from "vue"
  import { useRoute, useRouter } from "vue-router"
  import { PlusOutlined, DeleteOutlined, RedoOutlined, SearchOutlined, DownOutlined, UpOutlined } from "@ant-design/icons-vue"
  import { message } from "ant-design-vue"
  import Form from "./form.vue"
  import Detail from "./detail.vue"
  import Debug from "./debug.vue"

  // store
  const route = useRoute();
  const router = useRouter();

  // 查询表单相关对象
  const queryFormRef = ref()
  const queryFormData = ref({})
  // 是否展示更多搜索条件
  const showMore = ref(false)
  // 其他页面操作
  const formRef = ref()
  const detailRef = ref()
  const debugRef = ref()
  // 调试状态选项
  const debugStatusOptions = [
    { label: "未调通", value: 0 },
    { label: "已调通", value: 1 }
  ]

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
          return thirdPartyApi.deleteThirdPartyApi({ ids })
        }
      }
    },
    // 列字段
    columns: [
      { type: 'checkbox', width: 50 },
      { type: 'seq', width: 50 },
      { field: 'code', title: '唯一标识', width: 150, slots: { default: 'code' } },
      { field: 'name', title: '接口名称', width: 150 },
      { field: 'url', title: '接口URL', width: 200, slots: { default: 'url' } },
      { field: 'requestMethod', title: '请求方式', width: 80, slots: { default: 'requestMethod' } },
      { field: 'debugStatus', title: '调试状态', width: 80, slots: { default: 'debugStatus' } },
      { field: 'statusCode', title: 'HTTP状态码', width: 120, sortable: true, slots: { default: 'statusCode' } },
      { field: 'remark', title: '备注' },
      // { field: 'updateTime', title: '修改时间', width: 170 },
      { field: 'action', title: '操作', width: 180, slots: { default: 'action' } },
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
    return thirdPartyApi.thirdPartyApiPage(param).then((res) => {
      // res.data 为 {total, records}
      return res.data
    }).catch((err) => {
      console.error(err)
    })
  }

  // 删除
  const deleteThirdPartyApi = (record) => {
    let data = { ids: [record.id] }
    thirdPartyApi.deleteThirdPartyApi(data).then((res) => {
      message.success(res.message)
      refresh()
    })
  }

  // 打开详情页
  const openDetail = (row) => {
    detailRef.value.onOpen(row)
    // 独立页面打开(与抽屉打开二选一)
    // router.push({ path: "/dev/thirdPartyApi/detail", query: { id: row.id } })
  }

  // 打开调用日志
  const openLog = (row) => {
    // 独立页面打开(query显示传参，state隐式传参)
    router.push({ path: "/ops/log/thirdlog", query: { requestUrl: row.url } })
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
