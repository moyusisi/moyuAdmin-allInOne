import service from '@/utils/request'

export default {
  // 分页查询会话列表
  analyse(data) {
    return service.postJson('/api/auth/session/analyse', data)
  },
  // 分页查询会话列表
  sessionPage(data) {
    return service.postJson('/api/auth/session/page', data)
  },
  // 删除所有配置
  deleteSession(data) {
    return service.postJson('/api/auth/session/delete', data)
  },
  // 分页查询会话列表
  tokenList(data) {
    return service.postJson('/api/auth/session/tokenList', data)
  },
  // 删除所有配置
  deleteToken(data) {
    return service.postJson('/api/auth/session/deleteToken', data)
  },
  // 续签token[更新最后操作时间]
  renewActive(data) {
    return service.postJson('/api/auth/session/renewActive', data)
  },
}