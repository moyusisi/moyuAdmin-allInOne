import service from '@/utils/request'

/**
 * 系统配置相关接口
 */
export default {
  // 查询系统配置列表
  configList(data) {
    return service.postJson('/api/sys/config/list', data)
  },
  // 分页查询系统配置列表
  configPage(data) {
    return service.postJson('/api/sys/config/page', data)
  },
  // 获取系统配置详情
  configDetail(data) {
    return service.postJson('/api/sys/config/detail', data)
  },
  // 新增系统配置
  addConfig(data) {
    return service.postJson('/api/sys/config/add', data)
  },
  // 编辑系统配置
  editConfig(data) {
    return service.postJson('/api/sys/config/edit', data)
  },
  // 删除系统配置，通过ids删除
  deleteConfig(data) {
    return service.postJson('/api/sys/config/delete', data)
  },
  // 刷新配置缓存
  refreshConfig(data) {
    return service.postJson('/api/sys/config/refresh', data)
  }

}
