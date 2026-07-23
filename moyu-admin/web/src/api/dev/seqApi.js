import service from '@/utils/request'

/**
 * 序列器相关接口
 */
export default {
  // 序列器列表
  seqList(data) {
    return service.postForm('/api/seq/day/list', data)
  },
}
