import service from '@/utils/request'

/**
 * 接口信息相关接口
 */
export default {
  // 分页查询接口信息列表
  apiPage(data) {
    return service.postJson('/api/sys/api/page', data)
  },
  // 获取接口信息详情
  apiDetail(data) {
    return service.postJson('/api/sys/api/detail', data)
  },
  // 新增接口信息
  addApi(data) {
    return service.postJson('/api/sys/api/add', data)
  },
  // 编辑接口信息
  editApi(data) {
    return service.postJson('/api/sys/api/edit', data)
  },
  // 删除接口信息，通过ids删除
  deleteApi(data) {
    return service.postJson('/api/sys/api/delete', data)
  }

}