<template>
  <!-- 上方查询区 -->
  <a-card size="small">
    <a-form ref="queryFormRef" :model="queryFormData">
      <a-row :gutter="24">
        <a-col :span="6">
          <a-form-item name="keyword" label="序列器">
            <a-input v-model:value="queryFormData.keyword" placeholder="搜索序列器" allowClear />
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
    </vxe-grid>
  </a-card>
</template>

<script setup>
  import seqApi from '@/api/dev/seqApi.js'

  import { h, ref } from "vue"
  import { PlusOutlined, DeleteOutlined, RedoOutlined, SearchOutlined, CloudOutlined } from "@ant-design/icons-vue"
  import configApi from "@/api/system/configApi.js";
  import { message } from "ant-design-vue";

  // 查询表单相关对象
  const queryFormRef = ref()
  const queryFormData = ref({})


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
      { type: 'seq', title: '序号', width: 50 },
      { field: 'idKey', title: '序列器', width: 300 },
      { field: 'idValue', title: '序列值', width: 300 },
      { field: 'seq', title: '序列号' },
    ],
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
    return seqApi.seqList(param).then((res) => {
      // res.data 为 list数组
      return res.data
    }).catch((err) => {
      console.error(err)
    })
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
