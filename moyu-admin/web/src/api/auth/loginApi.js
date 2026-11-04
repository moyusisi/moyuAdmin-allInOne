import service from '@/utils/request'

export default {
  // 表单登陆
  login(data) {
    return service.postForm('/api/auth/login', data)
  },
  // 退出登陆
  logout(data) {
    return service.postJson('/api/auth/logout', data)
  },
  // 获取登陆验证码图片
  loginCaptcha(data) {
    return service.get('/api/auth/login/captcha', { })
  },
}