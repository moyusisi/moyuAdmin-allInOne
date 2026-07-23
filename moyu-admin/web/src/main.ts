import { createApp } from 'vue';
import router from './router';
import App from './App.vue';

import { setupStore } from "@/store";
import { setupI18n } from "@/locale";
import { setupAntdVue } from "@/plugin/antdv.ts";
import { setupVxeTable } from "@/plugin/vxeTable.ts";
import { setupHighlight } from "@/plugin/highlight.ts";

// 引入样式文件
import '@/style/index.css';

// 创建 Vue 应用实例
const app = createApp(App);

// 核心配置
setupStore(app)
app.use(router)
setupI18n(app)
setupAntdVue(app)

// 第三方插件
setupVxeTable(app)
setupHighlight(app)

// 挂载app
app.mount('#app')
