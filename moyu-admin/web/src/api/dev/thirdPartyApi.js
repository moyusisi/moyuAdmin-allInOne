import service from '@/utils/request'

/**
 * 三方集成接口相关接口
 */
export default {
  // 分页查询三方集成接口列表
  thirdPartyApiPage(data) {
    return service.postJson('/api/dev/thirdApi/page', data)
  },
  // 获取三方集成接口详情
  thirdPartyApiDetail(data) {
    return service.postJson('/api/dev/thirdApi/detail', data)
  },
  // 新增三方集成接口
  addThirdPartyApi(data) {
    return service.postJson('/api/dev/thirdApi/add', data)
  },
  // 编辑三方集成接口
  editThirdPartyApi(data) {
    return service.postJson('/api/dev/thirdApi/edit', data)
  },
  // 删除三方集成接口，通过ids删除
  deleteThirdPartyApi(data) {
    return service.postJson('/api/dev/thirdApi/delete', data)
  },

  // 调试接口
  debugApi(data) {
    return service.postJson('/api/dev/thirdApi/debugApi', data)
  }

}
