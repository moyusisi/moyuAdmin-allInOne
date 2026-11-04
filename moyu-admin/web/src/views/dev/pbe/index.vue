<template>
  <!-- 上方查询区 -->
  <a-card title="PBE配置文件加密工具">
    <a-form ref="formRef" :model="formData" layout="vertical">
      <a-row :gutter="24">
        <a-col :span="12">
          <a-form-item name="algorithm" label="加密算法" required>
            <a-select v-model:value="formData.algorithm" placeholder="请选择加密算法" show-search>
              <a-select-option value="PBEWithMD5AndDES">PBEWithMD5AndDES</a-select-option>
              <a-select-option value="PBEWithSHA1AndRC2_40">PBEWithSHA1AndRC2_40</a-select-option>
              <a-select-option value="PBEWithSHA1AndRC2_128">PBEWithSHA1AndRC2_128</a-select-option>
              <a-select-option value="PBEWithSHA1AndRC4_40">PBEWithSHA1AndRC4_40</a-select-option>
              <a-select-option value="PBEWithSHA1AndRC4_128">PBEWithSHA1AndRC4_128</a-select-option>
              <a-select-option value="PBEWithMD5AndTripleDES">PBEWithMD5AndTripleDES</a-select-option>
              <a-select-option value="PBEWithHmacSHA1AndAES_128">PBEWithHmacSHA1AndAES_128</a-select-option>
              <a-select-option value="PBEWithHmacSHA224AndAES_128">PBEWithHmacSHA224AndAES_128</a-select-option>
              <a-select-option value="PBEWithHmacSHA256AndAES_128">PBEWithHmacSHA256AndAES_128</a-select-option>
              <a-select-option value="PBEWithHmacSHA384AndAES_128">PBEWithHmacSHA384AndAES_128</a-select-option>
              <a-select-option value="PBEWithHmacSHA512AndAES_128">PBEWithHmacSHA512AndAES_128</a-select-option>
              <a-select-option value="PBEWithHmacSHA1AndAES_256">PBEWithHmacSHA1AndAES_256</a-select-option>
              <a-select-option value="PBEWithHmacSHA224AndAES_256">PBEWithHmacSHA224AndAES_256</a-select-option>
              <a-select-option value="PBEWithHmacSHA256AndAES_256">PBEWithHmacSHA256AndAES_256</a-select-option>
              <a-select-option value="PBEWithHmacSHA384AndAES_256">PBEWithHmacSHA384AndAES_256</a-select-option>
              <a-select-option value="PBEWithHmacSHA512AndAES_256">PBEWithHmacSHA512AndAES_256</a-select-option>
            </a-select>
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item name="secretKey" label="密钥" required>
            <a-input v-model:value="formData.secretKey" placeholder="请输入密钥" allowClear />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item>
            <a-button type="primary" :icon="h(LockOutlined)" :loading="submitLoading" @click="encrypt">加密</a-button>
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item>
            <a-button type="primary" :icon="h(KeyOutlined)" :loading="submitLoading" @click="decrypt">解密</a-button>
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item name="plainText" label="" tooltip="" >
            <a-textarea v-model:value="formData.plainText" placeholder="明文/要加密的内容" allowClear :rows="18" />
          </a-form-item>
        </a-col>
        <a-col :span="12">
          <a-form-item name="encryptedText" label="" tooltip="" >
            <a-textarea v-model:value="formData.encryptedText" placeholder="密文/要解密的内容" allowClear :rows="18" />
          </a-form-item>
        </a-col>
      </a-row>
    </a-form>
  </a-card>
</template>

<script setup>
  import pbeApi from "@/api/dev/pbeApi.js";

  import { h, ref } from "vue"
  import { LockOutlined, KeyOutlined } from "@ant-design/icons-vue"
  import { message } from "ant-design-vue";

  // 查询表单相关对象
  const formRef = ref()
  const formData = ref({
    algorithm: 'PBEWithHmacSHA512AndAES_256',
    plainText: '',
    encryptedText: ''
  })
  const submitLoading = ref(false)

  // 加载完毕调用
  onMounted(() => {
  })

  // 加密
  const encrypt = () => {
    if(!formData.value.plainText) {
      message.error("要加密的内容不能为空！")
      return
    }
    formRef.value.validate().then(() => {
      let param = Object.assign({}, formData.value)
      pbeApi.encrypt(param).then((res) => {
        if (res.data) {
          formData.value.encryptedText = res.data
        }
      }).catch((err) => {
        console.error(err)
      })
    }).catch(() => {
    })
  }
  // 解密
  const decrypt = () => {
    if(!formData.value.encryptedText) {
      message.error("要解密的内容不能为空！")
      return
    }
    formRef.value.validate().then(() => {
      submitLoading.value = true
      let param = Object.assign({}, formData.value)
      pbeApi.decrypt(param).then((res) => {
        if (res.data) {
          formData.value.plainText = res.data
        }
      }).catch((err) => {
        console.error(err)
      }).finally(() => {
        submitLoading.value = false
      })
    }).catch(() => {
    })
  }

</script>

<style scoped>
</style>
