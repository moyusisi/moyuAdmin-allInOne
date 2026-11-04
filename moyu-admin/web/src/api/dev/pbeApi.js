import service from '@/utils/request'

/**
 * PBE加密工具相关接口
 */
export default {
  // 加密
  encrypt(data) {
    return service.postJson('/api/dev/pbe/encrypt', data)
  },
  // 解密
  decrypt(data) {
    return service.postJson('/api/dev/pbe/decrypt', data)
  },
}
