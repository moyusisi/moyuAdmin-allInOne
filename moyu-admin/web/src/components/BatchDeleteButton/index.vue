<template>
  <a-popconfirm title="确定要批量删除吗？" @confirm="batchDelete">
    <a-button danger :icon="h(DeleteOutlined)" :disabled="props.selectedRowKeys.length < 1">
      {{ props.buttonName }}
    </a-button>
  </a-popconfirm>
</template>

<script setup>
  import { h } from "vue";
  import { DeleteOutlined } from "@ant-design/icons-vue";
  import { message } from 'ant-design-vue'

	const emit = defineEmits({ batchDelete: null })
	const props = defineProps({
		buttonName: {
			type: String,
			default: () => '批量删除'
		},
		icon: {
			type: String,
			default: () => undefined
		},
		selectedRowKeys: {
			type: Array,
			default: () => []
		}
	})
	// 批量删除
	const batchDelete = () => {
    if (props.selectedRowKeys.length < 1) {
      message.warning('请至少选择一条数据')
      return
    }
		const params = props.selectedRowKeys.map((m) => {
			return {
				id: m
			}
		})
		// 发起方法调用，谁的谁来实现
		emit('batchDelete', params)
	}
</script>
