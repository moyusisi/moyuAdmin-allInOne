import service from '@/utils/request'

/**
 * 三方应用相关接口
 */
export default {
  // 查询三方应用列表
  thirdPartyAppList(data) {
    return service.postJson('/api/dev/thirdApp/list', data)
  },
  // 分页查询三方应用列表
  thirdPartyAppPage(data) {
    return service.postJson('/api/dev/thirdApp/page', data)
  },
  // 获取三方应用详情
  thirdPartyAppDetail(data) {
    return service.postJson('/api/dev/thirdApp/detail', data)
  },
  // 新增三方应用
  addThirdPartyApp(data) {
    return service.postJson('/api/dev/thirdApp/add', data)
  },
  // 编辑三方应用
  editThirdPartyApp(data) {
    return service.postJson('/api/dev/thirdApp/edit', data)
  },
  // 删除三方应用，通过ids删除
  deleteThirdPartyApp(data) {
    return service.postJson('/api/dev/thirdApp/delete', data)
  }

}
