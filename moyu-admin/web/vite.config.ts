import { defineConfig, loadEnv, UserConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import VueJSX from '@vitejs/plugin-vue-jsx'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { AntDesignVueResolver } from 'unplugin-vue-components/resolvers'
import { viteMockServe } from "vite-plugin-mock"
import { resolve } from 'path'

export default defineConfig(({ mode }): UserConfig => {
  // const env = loadEnv(mode, './')
  const env = loadEnv(mode, process.cwd());
  const alias = {
    '~': `${resolve(__dirname, './')}`,
    '@': `${resolve(__dirname, 'src')}`
  }
  return {
    resolve: {
      alias
    },
    // 开发环境服务器选项
    server: {
      // 允许IP访问
      host: "0.0.0.0",
      // 应用端口 (默认:3000)
      port: Number(env.VITE_PORT),
      // 运行是否自动打开浏览器
      open: true,
      proxy: {
        // 配置代理规则：所有 /api/ 开头的请求(未被 Mock 拦截的)转发到真实后端
        '/api': {
          // 请求转发到的后端地址(未被mock拦截的请求),
          target: 'http://127.0.0.1:8080',
          ws: false,
          // 跨域时修改 Origin 头
          changeOrigin: true,
          // 可选：重写路径（如后端接口无 /api 前缀时）
          // rewrite: (path) => path.replace(/^\/api/, '')
          // 可选：忽略证书错误（本地开发用）
          // secure: false
        }
      }
    },
    // 构建配置选项
    build: {
      // 指定输出路径（相对于根目录),默认:dist。
      outDir: 'dist',
      // 指定生成静态资源的存放路径,默认:assets。库模式下不能使用
      assetsDir: 'assets',
      // 规定触发警告的 chunk 大小，单位KB。默认:500
      chunkSizeWarningLimit: 1500,
      // 启用/禁用 gzip 压缩大小报告。默认:true
      reportCompressedSize: true,
      // 压缩器,控制生产构建是否压缩JS、CSS代码，类型: boolean | 'oxc' | 'terser' | 'esbuild'.默认'oxc',比 terser 快 30~90 倍
      minify: 'oxc',
      // 单独配置CSS的压缩方式，取值:boolean | 'lightningcss' | 'esbuild'。默认:'lightningcss'
      cssMinify: 'lightningcss',
      rolldownOptions: {
        output: {
          // 入口文件，默认 [name].js
          entryFileNames: '[name].[hash].js',
          // 静态资源名，默认 assets/[name]-[hash][extname]
          assetFileNames: 'assets/static/[name].[hash].[ext]',
          // 代码分割chunk包，默认 [name]-[hash].js
          chunkFileNames: 'assets/chunks/[name].[hash].js',
          // 按模块拆分 chunk，减小单个文件体积
          codeSplitting: {
            // 模块至少被几处引用才抽离公共chunk，避免只在一个页面使用也强行分包
            // minShareCount: 2,
            // 控制【单个模块】达到阈值才允许进入分组。可过滤零散微型库
            // minModuleSize: 2 * 1024, // 10KB
            // 控制【分组产出 chunk文件】的最小体积。分组原体积超过此值就打包
            minSize: 10 * 1024, // 10KB
            // 分包规则
            groups: [
              {
                name: 'vendor-vue',
                test: /node_modules[\\/](vue|vue-router|pinia|vue-i18n|@vueuse|axios|fuse)/,
                priority: 20,
              },
              {
                name: 'vendor-vxe',
                test: /node_modules[\\/](vxe|xe-utils|@vxe-ui)/,
                priority: 15,
              },
              {
                name: 'antd-vue',
                test: /node_modules[\\/]ant-design-vue/,
                priority: 10,
              },
              {
                name: 'antd-icons',
                test: /node_modules[\\/]@ant-design/,
                priority: 10,
              },
              {
                name: 'vendor-exceljs',
                test: /node_modules[\\/](exceljs)/,
                priority: 5,
              },
              {
                name: 'vendor-other',
                test: /node_modules[\\/](highlight|@highlightjs|js-pinyin)/,
                priority: 5,
              },
            ],
          },
        },
        // Rolldown output 钩子(便于查看代码拆分，可以删掉)
        plugins: [
          {
            // 便于查看代码拆分，可以删掉
            name: 'debug-module-size',
            generateBundle(_outputOptions, bundle) {
              for (const [fileName, chunk] of Object.entries(bundle)) {
                // 只看 index 主包(index、assets/chunks/xxx)
                if (!fileName.startsWith('index.')) continue

                console.log(`\n==================== ${fileName} ====================`)
                // @ts-ignore
                if (!chunk.modules) continue

                // @ts-ignore 遍历每一个独立模块，拿到单个模块大小
                const entries = Object.entries(chunk.modules)
                  .map(([moduleId, moduleInfo]) => ({
                    moduleId,
                    // @ts-ignore
                    singleKb: (moduleInfo.renderedLength / 1024).toFixed(2),
                    // @ts-ignore
                    bytes: moduleInfo.renderedLength
                  }))
                  // 模块尺寸从大到小排序
                  .sort((a, b) => b.bytes - a.bytes)

                entries.forEach(item => {
                  // 简化路径，剔除本地项目目录
                  const shortPath = item.moduleId.replace(resolve(__dirname), '')
                  console.log(`[${item.singleKb} KB] ${shortPath}`)
                })
              }
            }
          }
        ]
      },
    },
    plugins: [
      vue(),
      VueJSX(),
      viteMockServe({
        // mock文件存放路径（默认是 src/mock）
        mockPath: 'mock',
        // 是否启用mock
        enable: mode === 'dev',
        // 是否在控制台打印 mock 接口请求日志
        logger: true,
      }),
      // 使用unplugin-auto-import插件自动导入API（如 ref、reactive 等），参考：https://cloud.tencent.com/developer/article/2236166
      AutoImport({
        // 自动导入 Vue 相关函数，如：ref, reactive, toRef 等
        imports: ["vue", "vue-router", "pinia"],
        // 自动导入模板，可在template中使用(否则只能在setup中使用)
        vueTemplate: true,
        // 配置文件生成位置(false:关闭自动生成)
        dts: "src/types/auto-imports.d.ts",
      }),
      // 自动注册 antdv 组件 + 图标
      Components({
        resolvers: [
          // antdv自动导入
          AntDesignVueResolver({
            // 不自动引入样式（css in js）
            importStyle: false,
            // 自动导入 antdv 图标
            resolveIcons: true,
          }),
        ],
        dts: 'src/types/auto-components.d.ts', // 类型声明
      }),
    ],
  }
})
