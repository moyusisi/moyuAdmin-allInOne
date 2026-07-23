import type { App } from "vue";

import Antd from 'ant-design-vue';
import * as antdvIcons from '@ant-design/icons-vue';

// 引入antdv的全量样式
import 'ant-design-vue/dist/reset.css';


// 全局注册 Antd-vue
export function setupAntdVue(app: App<Element>) {

  // 已自动按需引入,减少打包体积 https://antdv.com/docs/vue/introduce-cn
  // app.use(Antd)

  // 全局注册所有 Ant Design 图标 (自动引入无法使用动态图标,如h(icon-name))
  for (const iconName in antdvIcons) {
    app.component(iconName, (antdvIcons as any)[iconName])
  }
}