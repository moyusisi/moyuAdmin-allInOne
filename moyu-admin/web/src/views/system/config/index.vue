<template>
  <!-- 上方查询区 -->
  <a-card size="small">
    <a-form ref="queryFormRef" :model="queryFormData">
      <a-row :gutter="24">
        <a-col :span="6">
          <a-form-item name="configName" label="配置名称">
            <a-input v-model:value="queryFormData.configName" placeholder="搜索配置项" allowClear />
          </a-form-item>
        </a-col>
        <a-col :span="6">
          <a-form-item name="configKey" label="配置Key">
            <a-input v-model:value="queryFormData.configKey" placeholder="搜索配置Key" allowClear />
          </a-form-item>
        </a-col>
        <a-col :span="6">
          <a-form-item name="configValue" label="配置Value">
            <a-input v-model:value="queryFormData.configValue" placeholder="搜索配置Value" allowClear />
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
          <a-button type="primary" :icon="h(CloudOutlined)" @click="refreshCache()">刷新缓存</a-button>
        </a-space>
      </template>
      <!-- 字段插槽 -->
<!--      <template #id="{row, rowIndex, column, columnIndex}">-->
<!--        <a @click="openDetail(row)">{{ row.id }}</a>-->
<!--      </template>-->
      <template #configKey="{row, rowIndex, column, columnIndex}">
        <a @click="openDetail(row)">{{ row.configKey }}</a>
      </template>
      <template #status="{row, rowIndex, column, columnIndex}">
        <a-tag v-if="row.status === 0" color="green">正常</a-tag>
        <a-tag v-else>已停用</a-tag>
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
            <a-popconfirm title="确定要删除吗？" @confirm="deleteConfig(row)">
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
  import configApi from '@/api/system/configApi.js'

  import { h, ref } from "vue"
  import { useRoute, useRouter } from "vue-router"
  import { PlusOutlined, DeleteOutlined, RedoOutlined, SearchOutlined, CloudOutlined, DownOutlined, UpOutlined } from "@ant-design/icons-vue"
  import { message } from "ant-design-vue"
  import Form from "./form.vue"
  import Detail from "./detail.vue"

  // store
  const route = useRoute();
  const router = useRouter();

  // 查询表单相关对象
  const queryFormRef = ref()
  const queryFormData = ref({})
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
          return configApi.deleteConfig({ ids })
        }
      }
    },
    // 列字段
    columns: [
      { type: 'checkbox', width: 50 },
      { type: 'seq', width: 50 },
      { field: 'configName', title: '配置名称', width: 150 },
      { field: 'configKey', title: '配置Key', width: 200, slots: { default: 'configKey' } },
      { field: 'configValue', title: '配置Value', width: 200 },
      { field: 'status', title: '使用状态', width: 100, sortable: true, slots: { default: 'status' } },
      { field: 'remark', title: '备注' },
      { field: 'updateTime', title: '更新时间', width: 170, sortable: true },
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
    return configApi.configPage(param).then((res) => {
      // res.data 为 {total, records}
      return res.data
    }).catch((err) => {
      console.error(err)
    })
  }

  // 删除
  const deleteConfig = (record) => {
    let data = { ids: [record.id] }
    configApi.deleteConfig(data).then((res) => {
      message.success(res.message)
      refresh()
    })
  }

  // 刷新配置缓存
  const refreshCache = () => {
    configApi.refreshConfig().then((res) => {
      message.success(res.message)
    })
  }

  // 打开详情页
  const openDetail = (row) => {
    detailRef.value.onOpen(row)
    // 独立页面打开(与抽屉打开二选一)
    // router.push({ path: "/system/sysConfig/detail", query: { id: row.id } })
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
