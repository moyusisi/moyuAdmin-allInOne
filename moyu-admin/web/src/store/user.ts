import { defineStore } from 'pinia'
import loginApi from '@/api/auth/loginApi'
import userCenterApi from '@/api/system/userCenterApi'
import { UserInfo } from "@/api/system/types.ts";
import { useStorage } from "@vueuse/core";

export const useUserStore = defineStore('userStore', () => {
  // 定义state
  const token = useStorage<string>("TOKEN", null);
  // 用户信息
  const userInfo = useStorage<UserInfo>("USER_INFO", {});

  // 定义action
  // 登录
  const login = async ({ account, password, captchaId, captchaCode }) => {
    // 获取token
    const res = await loginApi.login({ account, password, captchaId, captchaCode })
    if (!res.data) {
      // 这等价于 Promise.reject(new Error("Rejected value"))
      throw new Error("登录失败");
    }
    token.value = res.data;
  }

  const logout = async () => {
    await loginApi.logout()
    clear()
  }

  const clear = () => {
    // 清理掉个人的一些信息
    localStorage.removeItem('TOKEN')
    localStorage.removeItem('USER_INFO')
  }

  // 初始化用户信息
  const initUserInfo = async () => {
    const res = await userCenterApi.loginUserInfo()
    if (!res.data) {
      // 这等价于 Promise.reject(new Error("Rejected value"))
      throw new Error("更新用户信息失败");
    }
    userInfo.value = res.data
  }
  // 刷新登录用户信息
  const refreshUserInfo = () => {
    userCenterApi.loginUserInfo().then((res) => {
      userInfo.value = res.data
    }).catch((err) => {
      console.log('更新用户信息失败', err)
      // 这等价于 Promise.reject(new Error("Rejected value"))
      throw new Error("更新用户信息失败");
    })
  }

  // 切换用户岗位身份
  const switchUserGroup = async (groupCode: string) => {
    const res = await userCenterApi.switchUserGroup({ code: groupCode })
    await refreshUserInfo()
  }

  return {
    login,
    logout,
    userInfo,
    initUserInfo,
    refreshUserInfo,
    switchUserGroup
  }
})