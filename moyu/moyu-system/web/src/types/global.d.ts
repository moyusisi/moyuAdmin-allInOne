/**
 * 系统设置
 */
export interface AppSettings {
  // 默认站点名称
  title: string,
  // 默认logo
  logo: string,
  // 版本
  version: string,
  // 版权
  copyright: string,
  // 语言
  lang: string,
  // 默认主题: light | dark
  theme: string,
  // 默认主题色
  themeColor: string,
  // 菜单是否折叠
  menuCollapsed: boolean,
  // 侧边菜单是否排他展开
  sideUniqueOpen: boolean,
  // 是否展示面包屑
  breadcrumbView: boolean,
  // 是否展示多标签页
  tagsView: boolean,
  // 是否启用水印
  watermarkEnabled: boolean,

  // 接口地址
  API_URL: string,
  // Token前缀，注意最后有个空格，如不需要需设置空字符串 // Bearer
  TOKEN_PREFIX: string,
}

/**
 * 页签对象
 */
export interface TagView {
  /** 页签名称 */
  name: string;
  /** 页签标题 */
  title: string;
  /** 页签路由路径 */
  path: string;
  /** 页签路由完整路径 */
  fullPath: string;
  /** 页签图标 */
  icon?: string;
  /** 是否固定页签 */
  affix?: boolean;
  /** 是否开启缓存 */
  keepAlive?: boolean;
  /** 是否禁用缓存(与keepAlive保留一个即可) */
  noCache?: boolean;
  /** 路由查询参数 */
  query?: any;
}


