<template>
  <a-card size="small">
    <a-form ref="queryFormRef" :model="queryFormData">
      <a-row :gutter="24">
        <a-col :span="8">
          <a-form-item name="searchKey" label="名称关键词">
            <a-input v-model:value="queryFormData.searchKey" placeholder="请输入关键词" allowClear />
          </a-form-item>
        </a-col>
        <a-col :span="6">
          <a-form-item label="使用状态" name="status">
            <a-select v-model:value="queryFormData.status" placeholder="请选择状态" :options="statusOptions" allowClear />
          </a-form-item>
        </a-col>
        <a-col :span="6">
          <a-flex gap="small">
            <a-button type="primary" :icon="h(SearchOutlined)" @click="querySubmit">查询</a-button>
            <a-button :icon="h(RedoOutlined)" @click="reset">重置</a-button>
          </a-flex>
        </a-col>
      </a-row>
    </a-form>
  </a-card>
  <a-card size="small">
    <MTable ref="tableRef"
            :columns="columns"
            :loadData="loadData"
            :row-key="(row) => row.id"
            showRowSelection
            @selectedChange="onSelectedChange"
    >
      <template #operator>
        <a-space wrap style="margin-bottom: 6px">
          <a-button type="primary" :icon="h(PlusOutlined)" @click="addFormRef.onOpen()">新增角色</a-button>
          <a-popconfirm :title=" '确定要删除这 ' + selectedRowKeys.length + ' 条数据吗？' " :disabled ="selectedRowKeys.length < 1" @confirm="deleteBatchRole">
            <a-button danger :icon="h(DeleteOutlined)" :disabled="selectedRowKeys.length < 1">
              批量删除
            </a-button>
          </a-popconfirm>
        </a-space>
      </template>
      <template #bodyCell="{ column, record }">
        <template v-if="column.dataIndex === 'code'">
          <a-tag v-if="record.code" :bordered="false">{{ record.code }}</a-tag>
        </template>
        <template v-if="column.dataIndex === 'status'">
          <a-tag v-if="record.status === 0" color="green">正常</a-tag>
          <a-tag v-else>已停用</a-tag>
        </template>
        <template v-if="column.dataIndex === 'action'">
          <a-space>
            <template #split>
              <a-divider type="vertical" />
            </template>
            <a-tooltip title="分配权限">
              <a style="color:#1980FF;" @click="grantMenuFormRef.onOpen(record)"><DeploymentUnitOutlined /></a>
            </a-tooltip>
            <a-tooltip title="分配用户">
              <a style="color:#53C61D;" @click="roleUserRef.onOpen(record)"><UserAddOutlined /></a>
            </a-tooltip>
            <a-tooltip title="编辑">
              <a @click="editFormRef.onOpen(record)"><FormOutlined /></a>
            </a-tooltip>
            <a-tooltip title="删除">
              <a-popconfirm title="确定要删除吗？" @confirm="deleteRole(record)">
                <a style="color:#FF4D4F;"><DeleteOutlined/></a>
              </a-popconfirm>
            </a-tooltip>
          </a-space>
        </template>
      </template>
    </MTable>
  </a-card>
  <grant-menu-form ref="grantMenuFormRef" @successful="tableRef.refresh()" />
  <AddForm ref="addFormRef" @successful="tableRef.refresh()" />
  <EditForm ref="editFormRef" @successful="tableRef.refresh()" />
  <RoleUser ref="roleUserRef" />
</template>

<script setup>
  import roleApi from '@/api/sys/roleApi'

  import { h } from "vue"
  import { PlusOutlined, DeleteOutlined, SearchOutlined, RedoOutlined } from "@ant-design/icons-vue"
  import AddForm from "./addForm.vue";
  import EditForm from "./editForm.vue";
  import GrantMenuForm from "./grantMenuForm.vue";
  import { message } from "ant-design-vue";
  import MTable from "@/components/MTable/index.vue"
  import RoleUser from "./roleUser.vue";

  const columns = [
    {
      title: '角色名称',
      dataIndex: 'name',
      resizable: true,
      width: 150
    },
    {
      title: '唯一编码',
      dataIndex: 'code',
      resizable: true,
      width: 200
    },
    {
      title: '排序',
      dataIndex: 'sortNum',
      align: 'center',
      width: 100
    },
    {
      title: '状态',
      dataIndex: 'status',
      align: 'center',
      width: 100
    },
    {
      title: '创建时间',
      dataIndex: 'createTime',
      align: 'center',
      width: 160
    },
    {
      title: '更新时间',
      dataIndex: 'updateTime',
      align: 'center',
      width: 160
    },
    {
      title: '操作',
      dataIndex: 'action',
      align: 'center',
      width: 150
    }
  ]
  const selectedRowKeys = ref([])
  // 使用状态options（0正常 1停用）
  const statusOptions = [
    { label: "正常", value: 0 },
    { label: "已停用", value: 1 }
  ]

  // 定义tableDOM
  const tableRef = ref()
  const formRef = ref()
  const addFormRef = ref()
  const editFormRef = ref()
  const module = ref()
  const grantMenuFormRef = ref()
  const roleUserRef = ref()
  const queryFormRef = ref()
  const queryFormData = ref({})

  // 表格查询 返回 Promise 对象
  const loadData = (parameter) => {
    let param = Object.assign(parameter, queryFormData.value)
    return roleApi.rolePage(param).then((res) => {
      return res.data
    })
  }
  // 查询
  const querySubmit = () => {
    tableRef.value.refresh(true)
  }
  // 重置
  const reset = () => {
    queryFormRef.value.resetFields()
    tableRef.value.refresh(true)
  }
  // 选中行发生变化
  const onSelectedChange = (selectedKeys, selectedRows) => {
    selectedRowKeys.value = selectedKeys
    // console.log('onSelectedChange,selectedKeys:', selectedKeys);
  }
  // 删除
  const deleteRole = (record) => {
    let data = { ids: [record.id] }
    roleApi.deleteRole(data).then((res) => {
      message.success(res.message)
      tableRef.value.refresh(true)
    })
  }
  // 批量删除
  const deleteBatchRole = (params) => {
    let data = { ids: selectedRowKeys.value }
    roleApi.deleteRole(data).then((res) => {
      message.success(res.message)
      tableRef.value.refresh(true)
    })
  }
</script>

<style scoped>
  /** 后代选择器 **/
  .ant-card .ant-form {
    margin-bottom: -12px !important;
  }
  .ant-form-item {
    margin-bottom: 12px !important;
  }

</style>
