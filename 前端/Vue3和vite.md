## 使用vite创建vue3项目

### Vue CLI 和 Vite 对比

| 特性         | Vite               | Vue CLI            |
| ------------ | ------------------ | ------------------ |
| 启动速度     | 快速               | 较慢               |
| 热更新       | 高效               | 较高效             |
| 配置复杂度   | 轻量化，简单       | 详细，灵活         |
| 插件生态     | 正在发展           | 完善               |
| 适用项目类型 | 中小型项目，新项目 | 大型项目，复杂项目 |
| 社区支持     | 新兴，快速增长     | 强大，官方支持     |

Vite 的名字来源于法语“快”，它确实是一个以快速开发体验为目标的工具。

Vite 提供了简洁的默认配置，对于大多数项目来说，开发者可以无需进行复杂的配置就能快速开始开发。它支持常见的前端框架，如 Vue、React 等。

创建指令

```
npm create vite@latest my-vue-app -- --template vue
```

vite新项目配置文件路径跳转：[vue3 ts vite 配置@ 代码可以跑但是爆红_前端-CSDN问答](https://ask.csdn.net/questions/8159916)

## 路由安装

#### 安装配置路由

```
npm install vue-router@4
```

#### 说明@路径

**检查 `vite.config.js`（Vite 项目）**

```js
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'), // 确保 @ 正确指向 src
    },
  },
})
```

#### 配置路由表

```javascript
import { createRouter, createWebHistory } from 'vue-router';
// 定义路由配置
const routes = [
    {
        path: "/",  // 根路径
        redirect: { name: 'map' }  // 重定向到map
    },
    {
        path: "/map",  // map页面
        name: 'map',
        component: () => import('@/views/GeosceneMap.vue')
    },
    {
        path: '/404',  // 404 错误页面路径
        name: '404',
        component: () => import('@/views/404Page.vue')
    },
    {
        path: '/:pathMatch(.*)*', // 捕获所有未匹配的路径（应该放在最后）
        redirect: '/404'  // 重定向到 404 页面
    }
];
// 创建路由实例
const router = createRouter({
    history: createWebHistory(),  // 使用 HTML5 的历史记录模式
    routes,  // 注册路由配置
});

// 导出路由实例
export default router;
```

#### 挂载

```js
import { createApp } from 'vue'
import App from './App.vue'
import router from './router' // 导入路由配置
const app = createApp(App)
app.use(router) // 注册路由
app.mount('#app')
```

#### 暴露出口

通常是app.vue文件

```vue
<template>
 <router-view></router-view>
</template>
```

#### 配置端口和路径

```js
export default defineConfig({
  plugins: [react()],
  server: {
    port: 2020, // 改为你想要的端口号
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'), // 将 @ 映射为 src 目录
    },
  },
})

```

## ant-design使用

#### 安装

```
npm install ant-design-vue
# 或
yarn add ant-design-vue
```

index.js里配置

```js
import { createApp } from 'vue'
import App from './App.vue'
import Antd from 'ant-design-vue';
import 'ant-design-vue/dist/reset.css';
import router from './router'; 

const app = createApp(App);
app.use(Antd);

createApp(App).use(router).use(Antd).mount('#app');  
```

## 点击组件跳转到VsCode(vite-plugin-react-click-to-component插件)

[hellof2e/vite-plugin-dev-inspector: 【基于webcomponents实现，以此适配任何前端框架】点击页面元素，编辑器直接打开本地代码文件。A vite plugin which provides the ability that to jump to the local IDE when you click the element of browser automatically. It supports Vue2, Vue3, React, Svelte,Angular, SSR(All frameworks).](https://github.com/hellof2e/vite-plugin-dev-inspector)

```
pnpm install vite-plugin-dev-inspector -D  #加-D是为安装开发依赖，项目打包上线之后不需要该依赖 
```

```js
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc"; // or @vitejs/plugin-react
import { reactClickToComponent } from "vite-plugin-react-click-to-component";

export default defineConfig({
  plugins: [react(), reactClickToComponent()],
});
```
