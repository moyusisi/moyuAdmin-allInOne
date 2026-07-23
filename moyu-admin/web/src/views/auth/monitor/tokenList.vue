<template>
  <a-drawer
    :open="visible"
    title="令牌列表"
    :width="drawerWidth"
    :closable="false"
    :footerStyle="{display: 'flex', justifyContent: 'flex-end'}"
    :destroy-on-close="true"
    :get-container="getDrawerContainer"
    @close="onClose"
  >
    <template #extra>
      <a-button type="primary" size="small" @click="onClose"><CloseOutlined /></a-button>
    </template>
    <!-- 页面内容 -->
    <a-card size="small">
      <!--  表格数据区  -->
      <vxe-grid ref="gridRef" v-bind="gridOptions">
        <!-- 左侧操作栏 -->
        <template #toolbarButtons>
          <a-space wrap style="margin-bottom: 6px">
            <a-button danger :icon="h(DeleteOutlined)" @click="gridRef?.commitProxy('delete')">批量删除</a-button>
          </a-space>
        </template>
        <template #configKey="{row, rowIndex, column, columnIndex}">
          <a @click="openDetail(row)">{{ row.configKey }}</a>
        </template>
        <template #tokenDevice="{row, rowIndex, column, columnIndex}">
          <a-tag v-if="row.tokenDevice === 'PC'" color="blue">{{ row.tokenDevice }}</a-tag>
          <a-tag v-if="row.tokenDevice === 'DEF'" color="green">{{ row.tokenDevice }}</a-tag>
          <a-tag v-if="row.tokenDevice === 'APP'" color="purple">{{ row.tokenDevice }}</a-tag>
          <a-tag v-if="row.tokenDevice === 'MINI'" color="orange">{{ row.tokenDevice }}</a-tag>
        </template>
        <template #tokenTimeout="{row, rowIndex, column, columnIndex}">
          <a-tooltip>
            <template #title>
              <span v-if="row.tokenTimeout <= 0">永久有效</span>
              <a-statistic-countdown v-else :value="row.deadline" format="D 天 H 时 m 分 s 秒" :valueStyle="{fontSize:'14px', color:'#fff'}" />
            </template>
            <a-progress v-if="row.tokenTimeoutPercent * 100 > 80" status="success" :percent="row.tokenTimeoutPercent * 100" :show-info="false"/>
            <a-progress v-if="row.tokenTimeoutPercent * 100 > 20 && row.tokenTimeoutPercent * 100 < 80" status="active" :percent="row.tokenTimeoutPercent * 100" :show-info="false"/>
            <a-progress v-if="row.tokenTimeoutPercent * 100 < 20" status="exception" :percent="row.tokenTimeoutPercent * 100" :show-info="false"/>
          </a-tooltip>
        </template>
        <template #activeTimeout="{row, rowIndex, column, columnIndex}">
          <a-tooltip>
            <template #title>
              <span v-if="row.activeTimeout === -2">已失效</span>
              <a-statistic-countdown v-else :value="row.activeTimeoutDeadline" format="D 天 H 时 m 分 s 秒" :valueStyle="{fontSize:'14px', color:'#fff'}" />
            </template>
            <a-progress v-if="row.activeTimeoutPercent * 100 > 80" status="success" :percent="row.activeTimeoutPercent * 100" :show-info="false"/>
            <a-progress v-if="row.activeTimeoutPercent * 100 > 20 && row.activeTimeoutPercent * 100 < 80" status="active" :percent="row.activeTimeoutPercent * 100" :show-info="false"/>
            <a-progress v-if="row.activeTimeoutPercent * 100 < 20" status="exception" :percent="row.activeTimeoutPercent * 100" :show-info="false"/>
          </a-tooltip>
        </template>
        <template #status="{row, rowIndex, column, columnIndex}">
          <a-tag v-if="row.status === 0" color="green">正常</a-tag>
          <a-tag v-else>已停用</a-tag>
        </template>
        <template #action="{row:record, rowIndex, column, columnIndex}">
          <a-space>
            <template #split>
              <a-divider type="vertical" />
            </template>
            <a-tooltip title="更新令牌有效期">
              <a style="color:#1980FF;" @click="renewActiveToken(record)">续签</a>
            </a-tooltip>
          </a-space>
        </template>
      </vxe-grid>
    </a-card>
  </a-drawer>
</template>

<script setup>
  import monitorApi from "@/api/auth/monitorApi.js";
  import { h, ref } from "vue";
  import { DeleteOutlined } from "@ant-design/icons-vue";
  import { useSettingsStore } from "@/store";
  import { message } from "ant-design-vue";

  const settingsStore = useSettingsStore()

  // 计算属性
  const drawerWidth = computed(() => {
    return settingsStore.menuCollapsed ? `calc(100% - 80px)` : `calc(100% - 210px)`
  })

  // 默认是关闭状态
  const visible = ref(false)
  const record = ref()
  // 表格中的数据
  const tableData = ref([])

  /***** 表格相关对象 start *****/
  const gridRef = ref()
  const gridOptions = ref({
    // 分页配置项
    pagerConfig: {
      enabled: false,
    },
    // 排序配置项
    sortConfig: {
      // 服务端排序
      remote: false,
    },
    // 数据代理配置
    proxyConfig: {
      // 启用排序请求代理
      sort: true,
      // 代理配置
      ajax: {
        query: ({ page, sort, sorts, filters, form }) => {
          const sortItem = sorts[0] || {}
          // console.log(sortItem)
          // 默认接收 Promise<{ result: [], page: { total: 100 } }>
          return loadData({ sortField: sortItem.field, sortOrder: sortItem.order })
        },
        delete: ({ body, form }) => {
          // 删除已选
          const codes = body.removeRecords.map(item => item.tokenValue);
          return monitorApi.deleteToken({ codes })
        }
      }
    },
    // 列字段
    columns: [
      { type: 'checkbox', width: 50 },
      { type: 'seq', title: '序号', width: 50 },
      { field: 'tokenDevice', title: '登录设备', width: 80, slots: { default: 'tokenDevice' } },
      { field: 'tokenValue', title: '令牌' },
      { field: 'activeTimeout', title: '有效期', width: 150, slots: { default: 'activeTimeout' } },
      { field: 'lastActiveTime', title: '最后活跃时间', width: 170, sortable: true },
      { field: 'createTime', title: '令牌签发时间', width: 170, sortable: true },
      { field: 'tokenTimeout', title: '清理期限', width: 150, slots: { default: 'tokenTimeout' } },
      { field: 'action', title: '操作', width: 80, slots: { default: 'action' } },
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

  // 打开抽屉
  const onOpen = (row) => {
    record.value = row;
    tableData.value = record.value.tokenList
    // 数据就绪之后显示
    visible.value = true
  }
  // 关闭抽屉
  const onClose = () => {
    // table数据清空
    tableData.value = []
    // 关闭
    visible.value = false
  }

  // 加载数据
  const loadData = (parameter) => {
    let param = Object.assign(parameter, { loginId: record.value.loginId })
    return monitorApi.tokenList(param).then((res) => {
      return res.data
    })
  }

  // 刷新
  const refresh = () => {
    // 返回第一页触发ajax.query
    gridRef.value?.commitProxy("reload")
  }

  // 续签token[更新最后操作时间]
  const renewActiveToken = (record) => {
    let data = { tokenValue: record.tokenValue }
    monitorApi.renewActive(data).then((res) => {
      message.success(res.message)
      refresh()
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
    margin-bottom: 10px !important;
  }
  .selectorTree {
    max-height: 600px;
    overflow: auto;
  }
</style>
