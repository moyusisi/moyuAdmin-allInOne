<template>
  <div class="admin-ui-main">
    <a-row :gutter="4">
      <a-col :xs="24" :sm="24" :md="24" :lg="18" :xl="18">
        <a-card title="我的任务" :bordered="false">
          <a-row :gutter="24">
            <a-col :xs="12" :sm="6" :md="6" :lg="6" :xl="6">
              <div class="item">
                <span class="item-tag" style="background-color: #2db7f5">
                  <span class="item-tag-icon">
                      <youtube-outlined/>
                  </span>
                </span>
                <span>
                  <span class="item-title">6</span><br>
                  <span>已发申请</span>
                </span>
              </div>
            </a-col>
            <a-col :xs="12" :sm="6" :md="6" :lg="6" :xl="6">
              <div class="item">
                <span class="item-tag" style="background-color: #f50">
                  <span class="item-tag-icon">
                      <youtube-outlined/>
                  </span>
                </span>
                <span>
                  <span class="item-title">1</span><br>
                  <span>待办任务</span>
                </span>
              </div>
            </a-col>
            <a-col :xs="12" :sm="6" :md="6" :lg="6" :xl="6">
              <div class="item">
                <span class="item-tag" style="background-color: #87d068">
                  <span class="item-tag-icon">
                      <youtube-outlined/>
                  </span>
                </span>
                <span>
                  <span class="item-title">99+</span><br>
                  <span>已办任务</span>
                </span>
              </div>
            </a-col>
            <a-col :xs="12" :sm="6" :md="6" :lg="6" :xl="6">
              <div class="item">
                <span class="item-tag" style="background-color: #108ee9">
                  <span class="item-tag-icon">
                      <youtube-outlined/>
                  </span>
                </span>
                <span>
                  <span class="item-title">0</span><br>
                  <span>已办任务</span>
                </span>
              </div>
            </a-col>
          </a-row>
        </a-card>
        <a-card title="" :bordered="false" style="margin-top: 2px;">
          <vxe-grid ref="gridRef" v-bind="gridOptions">
            <template #toolbarButtons>
              <span class="table-title">待办事项</span>
            </template>
            <template #toolbarTools>
              <a class="title-more">查看更多<RightOutlined /></a>
            </template>
            <!-- 字段插槽 -->
            <template #name="{row, rowIndex, column, columnIndex}">
              <a @click="">{{ row.name }}</a>
            </template>
            <template #path="{row, rowIndex, column, columnIndex}">
              <a-tag v-if="row.path" :bordered="false">{{ row.path }}</a-tag>
            </template>
          </vxe-grid>
        </a-card>
      </a-col>
      <a-col :xs="24" :sm="24" :md="24" :lg="6" :xl="6">
        <a-card title="快捷入口" :bodyStyle="{ marginBottom: '20px' }">
          <a-card-grid style="width: 33%; text-align: center">
            <div class="item-icon">
              <SolutionOutlined/>
            </div>
            <div class="item-text">
              <span>已发申请</span>
            </div>
          </a-card-grid>
          <a-card-grid style="width: 33%; text-align: center">
            <div class="item-icon">
              <SendOutlined/>
            </div>
            <div class="item-text">
              <span>已发申请</span>
            </div>
          </a-card-grid>
          <a-card-grid style="width: 33%; text-align: center">
            <div class="item-icon">
              <WalletOutlined/>
            </div>
            <div class="item-text">
              <span>已发申请</span>
            </div>
          </a-card-grid>
          <a-card-grid style="width: 33%; text-align: center">
            <div class="item-icon">
              <WalletOutlined/>
            </div>
            <div class="item-text">
              <span>已发申请</span>
            </div>
          </a-card-grid>
        </a-card>
        <a-card title="">
          <vxe-grid ref="noticeGridRef" v-bind="noticeGridOptions">
            <template #toolbarButtons>
              <span class="table-title">消息提醒</span>
            </template>
            <template #toolbarTools>
              <a class="title-more">查看更多<RightOutlined /></a>
            </template>
            <!-- 字段插槽 -->
            <template #title="{row, rowIndex, column, columnIndex}">
              <vxe-link @click="">{{ row.title }}</vxe-link>
              <div style="color: darkgray;">{{ row.createTime }}</div>
            </template>
          </vxe-grid>
        </a-card>
      </a-col>
    </a-row>
  </div>
</template>

<script setup>
import logApi from '@/api/system/logApi.js'
import messageApi from '@/api/dev/messageApi.js'

import { h, ref } from "vue"
import { useRoute, useRouter } from "vue-router"

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
const gridOptions = reactive({
  // 分页配置项
  pager: false,
  // 数据代理配置
  proxyConfig: {
    // 获取响应的值配置
    response: {
      // 响应结果中获取数据列表的属性（不分页场景）
      list: "records",
    },
    ajax: {
      query: ({ page, sort, sorts, filters, form }) => {
        // 默认接收 Promise<{ result: [], page: { total: 100 } }>
        return loadData({ pageNum: 1, pageSize: 8 })
      }
    }
  },
  // 列字段
  columns: [
    { field: 'id', title: '任务编号', width: 100 },
    { field: 'name', title: '标题', minWidth: 200, slots: { default: 'name' } },
    { field: 'sourceClient', title: '业务来源', width: 150 },
    { field: 'business', title: '所属流程', width: 150 },
    { field: 'createTime', title: '接收时间', width: 170 },
  ],
  // 工具栏配置
  toolbarConfig: {
    // 是否显示个性化列配置
    custom: false,
    // 是否允许最大化显示
    zoom: false,
    // 刷新按钮配置
    refresh: false,
    slots: {
      buttons: 'toolbarButtons',
      tools: 'toolbarTools'
    }
  },
})
const noticeGridRef = ref()
const noticeGridOptions = reactive({
  border: 'inner',
  showHeader: false,
  cellConfig: {
    height: 60
  },
  // 所有的列对齐方式
  align: "left",
  // 分页配置项
  pager: false,
  // 数据代理配置
  proxyConfig: {
    // 获取响应的值配置
    response: {
      // 响应结果中获取数据列表的属性（不分页场景）
      list: "records",
    },
    ajax: {
      query: ({ page, sort, sorts, filters, form }) => {
        // hasRead:0未读，1已读
        let param = { pageNum: 1, pageSize: 5 }
        return messageApi.readPage(param).then((res) => {
          // res.data 为 {total, records}
          return res.data
        }).catch((err) => {
          console.error(err)
        })
      }
    }
  },
  // 列字段
  columns: [
    { field: 'title', title: '标题', slots: { default: 'title' } },
  ],
  // 工具栏配置
  toolbarConfig: {
    // 是否显示个性化列配置
    custom: false,
    // 是否允许最大化显示
    zoom: false,
    // 刷新按钮配置
    refresh: false,
    slots: {
      buttons: 'toolbarButtons',
      tools: 'toolbarTools',
    }
  },
})
/***** 表格相关对象 end *****/

// 挂载前初始化参数
onBeforeMount(() => {
  if (route.query.id) {
    queryFormData.value.id = route.query.id
  } else if (route.query.id || history.state.id) {
    queryFormData.value.id = history.state.id
  }
})

// 挂载后处理
onMounted(() => {
  if (route.query.id || history.state.id) {
    const row = { id: route.query.id || history.state.id }
    openDetail(row)
  }
})

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
  return logApi.logPage(param).then((res) => {
    // res.data 为 {total, records}
    return res.data
  }).catch((err) => {
    console.error(err)
  })
}

// 打开详情页
const openDetail = (row) => {
  detailRef.value.onOpen(row)
  // 独立页面打开(与抽屉打开二选一)
  // router.push({ path: "/ops/sys/logDetail", query: { id: row.id } })
}
</script>

<style scoped>
:deep(.ant-card-head) {
  border-bottom: 0 !important;
}

:deep(.ant-card-body) {
  padding-top: 0 !important;
}

.item {
  height: 60px;
  min-width: 100px;
  display: flex;
  align-items: center;
  cursor: pointer;
  transition: all .5s;
}

.item:hover {
  background-color: #F0F0F0;
}

.item-tag {
  width: 45px;
  height: 45px;
  border-radius: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-left: 10px;
  margin-right: 20px;
}

.item-tag-icon {
  color: #ffffff;
  font-size: 20px;
}

.item-title {
  font-weight: 700;
  font-size: 18px;
}

/** 快捷入口样式 **/
.item-icon {
  font-size: 28px;
}
.ant-card-grid:nth-child(odd) .item-icon {
  color: #2db7f5;
}
.ant-card-grid:nth-child(even) .item-icon {
  color: #108ee9;
}

.ant-card-grid {
  box-shadow: none !important;
  padding: 8px !important;
}
.ant-card-grid:hover {
  cursor: pointer;
  background-color: #F0F0F0;
}
.table-title {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 8px;
  margin-top: 8px;
}
.title-more {
  color: darkgray;
  margin-bottom: 8px;
  margin-top: 8px;
}
</style>
