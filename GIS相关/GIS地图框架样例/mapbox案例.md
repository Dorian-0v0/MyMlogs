# Mapbox地图框架介绍
Mapbox提供多种功能和特性，包括
 **1. 自定义地图设计
 2. 支持矢量和栅格图层以高分辨率渲染地图
 3. 实时数据更新
 4. 丰富的API与SDK以支持各种应用的开发
 5. 位置服务与导航功能
 6. 地理空间分析和多种专业图层样式**
此外，Mapbox 还支持离线地图，提高了用户在无网络条件下的体验，并且能够创建生动的动画效果来展示变化数据。

> 下载依赖：` npm i mapbox-gl`

# 初始化一个地图
```html
<template>
  <!-- 创建一个div元素作为地图容器 -->
  <div ref="mapContainer" class="map-container"></div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'; // 引入Vue的组合式API函数
import 'mapbox-gl/dist/mapbox-gl.css'; // 引入Mapbox GL的样式文件
import mapboxgl from 'mapbox-gl'; // 引入Mapbox GL JS库

// 设置Mapbox访问令牌，用于验证和加载地图资源，没有问马云要
mapboxgl.accessToken = 'pk.eyJ1IjoiaGdjb2RlNTk2OSIsImEiOiJjbTE3ejh6Zm0weGprMmpxeDhha3dxMzYyIn0.73jueC5DbqxUWlI9XbOiGQ';

// 创建一个引用，用于指向地图容器DOM元素
const mapContainer = ref(null);
// 创建一个变量，用于存储地图实例
let map = null;

onMounted(() => {
  // 当组件挂载后初始化地图
  map = new mapboxgl.Map({
    container: mapContainer.value, // 使用通过ref创建的地图容器
    center: [117.868642, 24.667836], // 设置地图中心点坐标
    style: 'mapbox://styles/mapbox/standard', // 设置地图样式为Mapbox Standard
    zoom: 10, // 设置初始缩放级别
    projection: 'globe', // 设置地图投影类型为"globe"
  });

  // 添加导航控件（包括缩放和旋转功能）到地图上，并将其放置在左上角
  map.addControl(new mapboxgl.NavigationControl(), 'top-left');
});

onUnmounted(() => {
  // 当组件卸载时销毁地图实例，清理资源
  if (map) {
    map.remove();
  }
});
</script>

<style scoped>
/* 设置地图容器的宽度和高度 */
.map-container {
  width: 100%;
  height: 500px;
}
</style>
```
见官方文档：[Map类包含的属性](https://docs.mapbox.com/mapbox-gl-js/api/map/#docs-content)
## 常用地图控件

```javascript
// 添加比例尺控件到地图上，设置最大宽度为80px，并使用公制单位（米）
map.addControl(new mapboxgl.ScaleControl({
    maxWidth: 80, // 设置比例尺的最大宽度
    unit: 'metric' // 使用公制单位显示比例尺
  }), 'bottom-left'); // 将比例尺控件放置在地图的左下角

// 添加导航控件（包括缩放和旋转功能）到地图上
map.addControl(new mapboxgl.NavigationControl(), 'top-left'); // 将导航控件放置在地图的左上角

// 添加全屏控件到地图上，允许用户将地图切换至全屏模式
map.addControl(new mapboxgl.FullscreenControl(), 'top-left'); // 将全屏控件放置在地图的左上角

// 添加定位控件到地图上，该控件可以帮助用户将其地图视图移动到当前位置
map.addControl(new mapboxgl.GeolocateControl({
    positionOptions: {
      enableHighAccuracy: true // 启用高精度定位
    },
    trackUserLocation: true, // 持续跟踪用户的地理位置并更新地图中心点
    showUserLocation: true // 在地图上显示用户的当前位置
  }), 'top-left'); // 将定位控件放置在地图的左上角
```
## 地图Mapbox自带的地图样式
| 样式名称          | 样式 URL                                       |
| ----------------- | ---------------------------------------------- |
| Mapbox 标准       | `mapbox://styles/mapbox/standard`              |
| Mapbox 卫星加路网 | `mapbox://styles/mapbox/standard-satellite`    |
| Mapbox 街道       | `mapbox://styles/mapbox/streets-v12`           |
| Mapbox 户外       | `mapbox://styles/mapbox/outdoors-v12`          |
| Mapbox 高亮       | `mapbox://styles/mapbox/light-v11`             |
| 深色底图          | `mapbox://styles/mapbox/dark-v10`              |
| Mapbox 卫星       | `mapbox://styles/mapbox/satellite-v9`          |
| Mapbox 卫星街道   | `mapbox://styles/mapbox/satellite-streets-v12` |
| Mapbox 日间导航   | `mapbox://styles/mapbox/navigation-day-v1`     |
| Mapbox 夜间导航   | `mapbox://styles/mapbox/navigation-night-v1`   |
### 使用方法
要使用这些样式，只需将对应的样式 URL 添加到你的 Mapbox 配置中。例如，在使用 Mapbox GL JS 时，可以通过以下代码设置地图样式：

```javascript
map.setStyle('mapbox://styles/mapbox/streets-v12');
// 或者
style: 'mapbox://styles/mapbox/basic-print-v2', // Use the Mapbox Standard style
```
## 球体背景Fog、Snow、Rain设置
```javascript
// 监听地图样式加载完成的事件
  map.on('style.load', function () {
    // 设置地图的雾效
    map.setFog({
      // 定义雾的可见范围，即雾的开始和结束距离
      // 第一个值（0.8）表示雾开始出现的距离，第二个值（8）表示雾结束的距离
      "range": [0.8, 8],

      // 设置雾的颜色
      "color": "#e5e510",

      // 设置地平线与雾之间的混合程度，取值范围为 0 到 1
      // 值越小，混合越少，雾效越明显；值越大，混合越多，雾效越不明显
      "horizon-blend": 0.5,

      // 设置高空颜色，用于模拟高空的雾效颜色
      "high-color": "#ffffff",

      // 设置太空颜色，用于模拟太空中的雾效颜色
      "space-color": "#124888",

      // 设置星空强度，取值范围为 0 到 1
      // 值越大，星空效果越明显
      "star-intensity": 0.6
    }).setSnow({
      density: 0.3,
      intensity: 0.4
    }).setRain({
      // density: 定义雨滴的密度，取值范围通常是从 0 到 1
      // 值越大，雨滴越密集，模拟的降雨效果越强烈
      density: 1,

      // intensity: 定义降雨的强度，取值范围通常是从 0 到 1
      // 值越大，降雨效果越明显，模拟的雨滴下落速度越快
      intensity: 0.8,

      // distortion-strength: 定义雨滴对视线的扭曲强度，取值范围通常是从 0 到 1
      // 值越大，雨滴对视线的扭曲效果越明显，模拟的降雨视觉效果越逼真
      "distortion-strength": 0.3
    });
  });
```
效果如下
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/a8343d17413a4e34b060b252b0ce05e5.png)
具体看：[https://docs.mapbox.com/mapbox-gl-js/api/map/#map#getsnow](https://docs.mapbox.com/mapbox-gl-js/api/map/#map#getsnow)
# 加载高德地图等图层
## 加载高德地图
```javascript
<template>
  <!-- 创建一个div元素作为地图容器 -->
  <div ref="mapContainer" class="map-container"></div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'; // 引入Vue的组合式API函数
import 'mapbox-gl/dist/mapbox-gl.css'; // 引入Mapbox GL的样式文件
import mapboxgl from 'mapbox-gl'; // 引入Mapbox GL JS库

// 设置Mapbox访问令牌，以便可以访问Mapbox的地图服务
mapboxgl.accessToken = 'pk.eyJ1IjoiaGdjb2RlNTk2OSIsImEiOiJjbTE3ejh6Zm0weGprMmpxeDhha3dxMzYyIn0.73jueC5DbqxUWlI9XbOiGQ';

// 创建一个引用，用于指向地图容器DOM元素
const mapContainer = ref(null);
// 创建一个变量，用于存储地图实例
let map = null;

onMounted(() => {
  // 当组件挂载后初始化地图
  map = new mapboxgl.Map({
    container: mapContainer.value, // 使用通过ref创建的地图容器
    center: [115.86862, 28.6636], // 设置地图中心点坐标
    style: 'mapbox://styles/mapbox/satellite-v9', // 设置地图样式为卫星视图
    zoom: 10, // 设置初始缩放级别
    projection: 'globe', // 设置地图投影类型为球体（3D投影）
  });

  // 添加导航控件（包括缩放和旋转功能）到地图上，并将其放置在左上角
  map.addControl(new mapboxgl.NavigationControl(), 'top-left');

  // 等待地图加载完成
  map.on('load', () => {
    // 添加Mapbox官方的地形数据源
    map.addSource('mapbox-dem', {
      type: 'raster-dem', // 数据源类型为点阵地形数据
      url: 'mapbox://mapbox.terrain-rgb', // 使用Mapbox官方的地形数据源URL
      tileSize: 256, // 设置瓦片大小
      maxzoom: 14 // 设置最大缩放级别
    });

    // 设置地形并指定夸张倍数（1.5倍的高度变化）
    map.setTerrain({ source: 'mapbox-dem', exaggeration: 1.5 });

    // 设置雾效（可选），以增加视觉效果
    map.setFog({
      range: [0.8, 8], // 定义雾效的范围
      color: '#def', // 设置雾的基本颜色
      'high-color': '#def', // 设置高处的雾颜色
      'space-color': '#def' // 设置太空背景颜色
    });
  });
});

// 组件卸载时清理资源，销毁地图实例
onUnmounted(() => {
  if (map) {
    map.remove(); // 清除地图实例
  }
});
</script>

<style scoped>
/* 设置地图容器的宽度和高度 */
.map-container {
  width: 100%;
  height: 500px; 
}
</style>
```
## 加载dem地形

```html
<template>  
  <!-- 创建一个div元素作为地图容器 -->  
  <div ref="mapContainer" class="map-container"></div>  
</template>  

<script setup>  
import { ref, onMounted, onUnmounted } from 'vue'; // 引入Vue的组合式API函数  
import 'mapbox-gl/dist/mapbox-gl.css'; // 引入Mapbox GL的样式文件  
import mapboxgl from 'mapbox-gl'; // 引入Mapbox GL JS库  

// 设置Mapbox访问令牌，以便可以访问Mapbox的地图服务  
mapboxgl.accessToken = 'pk.eyJ1IjoiaGdjb2RlNTk2OSIsImEiOiJjbTE3ejh6Zm0weGprMmpxeDhha3dxMzYyIn0.73jueC5DbqxUWlI9XbOiGQ';  

// 创建一个引用，用于指向地图容器DOM元素  
const mapContainer = ref(null);  
// 创建一个变量，用于存储地图实例  
let map = null;  

onMounted(() => {  
  // 当组件挂载后初始化地图  
  map = new mapboxgl.Map({  
    container: mapContainer.value, // 使用通过ref创建的地图容器  
    center: [115.86862, 28.6636], // 设置地图中心点坐标  
    style: 'mapbox://styles/mapbox/satellite-v9', // 设置地图样式为卫星视图  
    zoom: 10, // 设置初始缩放级别  
    projection: 'globe', // 设置地图投影类型为球体（3D投影）  
  });  

  // 添加导航控件（包括缩放和旋转功能）到地图上，并将其放置在左上角  
  map.addControl(new mapboxgl.NavigationControl(), 'top-left');  

  // 等待地图加载完成  
  map.on('load', () => {  
    // 添加Mapbox官方的地形数据源  
    map.addSource('mapbox-dem', {  
      type: 'raster-dem', // 数据源类型为点阵地形数据  
      url: 'mapbox://mapbox.terrain-rgb', // 使用Mapbox官方的地形数据源URL  
      tileSize: 256, // 设置瓦片大小  
      maxzoom: 14 // 设置最大缩放级别  
    });  

    // 设置地形并指定夸张倍数（1.5倍的高度变化）  
    map.setTerrain({ source: 'mapbox-dem', exaggeration: 1.5 });  

    // 设置雾效（可选），以增加视觉效果  
    map.setFog({  
      range: [0.8, 8], // 定义雾效的范围  
      color: '#def', // 设置雾的基本颜色  
      'high-color': '#def', // 设置高处的雾颜色  
      'space-color': '#def' // 设置太空背景颜色  
    });  
  });  
});  

// 组件卸载时清理资源，销毁地图实例  
onUnmounted(() => {  
  if (map) {  
    map.remove(); // 清除地图实例  
  }  
});  
</script>  

<style scoped>  
/* 设置地图容器的宽度和高度 */  
.map-container {  
  width: 100%; // 地图宽度为100%  
  height: 500px; // 地图高度为500像素  
}  
</style>
```

## 实现图层切换

```html
<template>
  <!-- 创建一个div元素作为地图容器 -->
  <div ref="mapContainer" class="map-container">
    <!-- 添加切换地图影像的按钮 -->
    <button class="map-button" @click="switchMapStyle">切换地图样式</button>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'; // 引入Vue的组合式API函数
import 'mapbox-gl/dist/mapbox-gl.css'; // 引入Mapbox GL的样式文件
import mapboxgl from 'mapbox-gl'; // 引入Mapbox GL JS库

// 设置Mapbox访问令牌
mapboxgl.accessToken = 'pk.eyJ1IjoiaGdjb2RlNTk2OSIsImEiOiJjbTE3ejh6Zm0weGprMmpxeDhha3dxMzYyIn0.73jueC5DbqxUWlI9XbOiGQ';

// 创建一个引用，用于指向地图容器DOM元素
const mapContainer = ref(null);
// 创建一个变量，用于存储地图实例
let map = null;
// 定义当前地图样式
let currentStyle = 'mapbox://styles/mapbox/standard';

// 定义切换地图样式的函数
function switchMapStyle() {
  if (map) {
    // 切换地图样式
    if (currentStyle === 'mapbox://styles/mapbox/standard') {
      currentStyle = 'mapbox://styles/mapbox/satellite-v9';
      map.setStyle(currentStyle);
    } else {
      currentStyle = 'mapbox://styles/mapbox/standard';
      map.setStyle(currentStyle);
    }
  }
}

onMounted(() => {
  // 当组件挂载后初始化地图
  map = new mapboxgl.Map({
    container: mapContainer.value, // 使用通过ref创建的地图容器
    center: [115.86862, 28.6636], // 设置地图中心点坐标
    style: currentStyle, // 设置初始地图样式
    zoom: 10, // 设置初始缩放级别
    projection: 'globe', // 设置地图投影类型为"globe"
  });

  // 添加导航控件（包括缩放和旋转功能）到地图上，并将其放置在左上角
  map.addControl(new mapboxgl.NavigationControl(), 'top-left');
});

onUnmounted(() => {
  // 当组件卸载时销毁地图实例，清理资源
  if (map) {
    map.remove();
  }
});
</script>

<style scoped>
/* 设置地图容器的宽度和高度 */
.map-container {
  width: 100%;
  height: 500px;
  position: relative; /* 设置为相对定位，以便按钮可以绝对定位 */
}

/* 设置按钮的样式 */
.map-button {
  position: absolute;
  top: 10px;
  right: 10px;
  z-index: 1000; /* 确保按钮在地图之上 */
  padding: 10px;
  background-color: #fff;
  border: 1px solid #ccc;
  border-radius: 5px;
  cursor: pointer;
}
</style>
```
## 加载OSMBuilding

```javascript
// 监听地图样式加载完成事件
map.on('style.load', () => {
    // 获取当前地图样式的所有图层
    const layers = map.getStyle().layers;

    // 查找第一个符合条件的符号图层（symbol layer），该图层的布局属性中包含文本字段（text-field）
    // 这里假设我们需要在该符号图层之前插入新的3D建筑图层
    const labelLayerId = layers.find(layer => layer.type === 'symbol' && layer.layout['text-field']).id;

    // 添加3D建筑图层
    map.addLayer({
      id: 'add-3d-buildings', // 新图层的唯一标识符
      source: 'composite', // 指定数据源，这里使用的是默认的Mapbox提供的合成数据源
      'source-layer': 'building', // 指定数据源中的具体图层，这里是建筑图层
      filter: ['all', // 设置过滤条件，仅对符合条件的建筑进行3D渲染
        ['==', 'extrude', 'true'], // 只选择具有“extrude”属性且值为“true”的建筑
        ['has', 'height'] // 仅选择具有“height”属性的建筑
      ],
      type: 'fill-extrusion', // 指定图层类型为填充拉伸（用于3D效果）
      minzoom: 15, // 设置该图层的最小缩放级别，只有在缩放级别大于或等于15时才会显示
      paint: {
        'fill-extrusion-color': '#aaa', // 设置3D建筑的填充颜色
        'fill-extrusion-height': [ // 设置3D建筑的高度
          'interpolate', // 使用插值函数
          ['linear'], // 插值方式为线性
          ['zoom'], // 根据缩放级别进行插值
          1, // 当缩放级别为1时
          ['+', ['get', 'height'], 10], // 建筑高度为其自身的“height”属性值加上10
          8, // 当缩放级别为8时
          ['+', ['get', 'height'], 10] // 建筑高度仍为其自身的“height”属性值加上10
        ],
        'fill-extrusion-base': 0, // 设置3D建筑的底部高度始终为0
        'fill-extrusion-opacity': 0.9 // 设置3D建筑的透明度为0.9
      }
    }, labelLayerId); // 将新图层插入到之前找到的符号图层之前
});
```
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/045b60b68ce646068ee2acffee0691dc.png)


# 地图事件
## 水平旋转展示地图

```javascript
// 旋转展示事件
let timer = null;
let isCircle = false;

const CircleShow = () => {
  isCircle = !isCircle; // 切换旋转状态
  if (!isCircle) {
    clearInterval(timer); // 如果状态为false，清除定时器，停止旋转
  } else {
    timer = setInterval(() => {
      let bearing = map.getBearing() + 1; // 获取当前地图的旋转角度并加1
      map.setBearing(bearing); // 设置新的旋转角度
    }, 20); // 每20毫秒更新一次旋转角度
  }
};

// 添加地图点击事件监听器（在onMounted中）
map.on('click', () => {
  clearInterval(timer); // 点击地图时清除定时器，停止旋转
  isCircle = false; // 重置旋转状态
});
```
## 地球自转加飞行复位
```html
<template>  
  <div ref="mapContainer" class="map-container">  
    <button class="map-button" @click="flyToCity">跳转</button>  
  </div>  
</template>  

<script setup>  
import { ref, onMounted, onUnmounted } from 'vue';  
import 'mapbox-gl/dist/mapbox-gl.css'; // 导入 Mapbox 的 CSS 样式  
import mapboxgl from 'mapbox-gl'; // 导入 Mapbox GL JS 库  

// 设置 Mapbox 访问令牌  
mapboxgl.accessToken = 'pk.eyJ1IjoiaGdjb2RlNTk2OSIsImEiOiJjbTE3ejh6Zm0weGprMmpxeDhha3dxMzYyIn0.73jueC5DbqxUWlI9XbOiGQ'; // 替换为你的 Mapbox 访问令牌  

// 定义响应式引用  
const mapContainer = ref(null); // 地图容器的引用  
let map = null; // 地图实例  
let rotateEnabled = true; // 控制地图自转的开关  

// 停止地图自转的函数  
const OffRotateMap = () => {  
  rotateEnabled = false; // 设置旋转开关为 false，停止自转  
};  

// 地图自转函数  
const rotateMap = () => {  
  // 如果当前缩放级别不为 1，则停止自转  
  if (map.getZoom() !== 1) {  
    OffRotateMap();  
  }  
  
  // 如果自转被启用且地图实例存在  
  if (rotateEnabled && map) {  
    const currentCenter = map.getCenter(); // 获取当前地图的中心点  
    let newLongitude = currentCenter.lng - 1; // 每帧自西向东减少经度  

    // 确保经度在 0 到 360 之间  
    if (newLongitude < 0) {  
      newLongitude += 360; // 如果小于 0，加上 360  
    }  
    
    // 更新地图的中心点  
    map.setCenter([newLongitude, currentCenter.lat]);  
    
    // 请求下一帧动画，继续自转  
    requestAnimationFrame(rotateMap);  
  }  
};  

// 跳转到指定城市的函数  
const flyToCity = () => {  
  OffRotateMap(); // 停止自转  
  if (map) {  
    // 使用 flyTo 方法平滑跳转到指定城市  
    map.flyTo({  
      center: [115.86862, 28.6636], // 目标中心点经纬度  
      pitch: 70, // 俯仰角度  
      bearing: 60, // 方向角度  
      zoom: 10, // 缩放级别  
      speed: 1.2, // 动画速度  
      essential: true // 是否为关键动画  
    });  
  }  
};  

// 组件挂载时初始化地图  
onMounted(() => {  
  // 创建 Mapbox 地图实例  
  map = new mapboxgl.Map({  
    container: mapContainer.value, // 地图容器  
    center: [110, 30], // 初始中心点经纬度  
    style: 'mapbox://styles/mapbox/standard', // 地图样式  
    zoom: 1, // 初始缩放级别  
    projection: 'globe', // 使用 3D 地球投影  
  });  

  // 地图加载完成后开始自转  
  map.on('load', rotateMap);  
  
  // 添加导航控件到地图  
  map.addControl(new mapboxgl.NavigationControl(), 'top-left');  
  
  // 监听地图点击事件来停止自转  
  map.on('click', OffRotateMap); // 传递函数引用而非调用  
});  

// 组件卸载时销毁地图实例  
onUnmounted(() => {  
  if (map) {  
    map.remove(); // 销毁地图实例  
  }  
});  
</script>  

<style scoped>  
.map-container {  
  width: 100%; /* 地图容器宽度 */  
  height: 500px; /* 地图容器高度 */  
  position: relative; /* 设置相对定位 */  
}  

.map-button {  
  position: absolute; /* 设置绝对定位 */  
  top: 10px; /* 按钮距离顶部的距离 */  
  right: 10px; /* 按钮距离右侧的距离 */  
  z-index: 1000; /* 设置较高的层级 */  
  padding: 10px; /* 按钮内边距 */  
  background-color: #fff; /* 按钮背景颜色 */  
  border: 1px solid #ccc; /* 按钮边框 */  
  border-radius: 5px; /* 按钮圆角 */  
  cursor: pointer; /* 鼠标悬停时的光标样式 */  
}  
</style>
```
# AntV L7开源地理空间数据可视化分析开发框架
**介绍**：AntV L7 是一个基于 WebGL 的开源大规模地理空间数据可视化分析开发框架。它专注于数据可视化表达，通过颜色、大小、纹理、方向、体积等视觉变量设置，实现从数据到信息的清晰、有效表达。L7 能够满足常见的地图图表、BI 系统的可视化分析需求，以及 GIS、交通、电力、国土、农业、城市等领域的空间信息管理、分析等应用系统开发需求。它支持 2D 和 3D 一体化的海量数据高性能渲染，简单灵活的数据接入，支持 CSV、JSON、GeoJSON 等数据格式接入，可以根据需求自定义数据格式，无需复杂的空间数据转换。此外，L7 还支持多地图底图，支持离线内网部署。
**[官网文档](https://l7.antv.antgroup.com/tutorial/quickstart)**
**下载依赖**

```dart
// 安装L7 依赖
npm install --save @antv/l7
// 安装第三方底图依赖
npm install --save @antv/l7-maps
```

```dart
npm i  @antv/l7-maps @antv/l7
```

如果你需要卫星地图，可能还需要装个包：

```dart
@antv/l7-draw
```
## AntV L7加载mapbox地图
```html
<template>
  <!-- 创建一个div元素作为地图容器 -->
  <div ref="mapContainer"></div>
</template>

<script setup>
import { onMounted, ref } from 'vue'; // 导入 Vue 的生命周期钩子和响应式引用
import { Scene, PointLayer } from '@antv/l7'; // 导入 L7 的场景和点图层
import { Mapbox } from '@antv/l7-maps'; // 导入 L7 的 Mapbox 适配器
import 'mapbox-gl/dist/mapbox-gl.css'; // 导入 Mapbox GL JS 的样式文件
import mapboxgl from 'mapbox-gl'; // 引入 Mapbox GL JS 库

// 创建一个引用，用于指向地图容器 DOM 元素
const mapContainer = ref(null);

// 设置 Mapbox 访问令牌，这是使用 Mapbox 服务的必要凭证
mapboxgl.accessToken = "pk.eyJ1IjoiaGdjb2RlNTk2OSIsImEiOiJjbTE3ejh6Zm0weGprMmpxeDhha3dxMzYyIn0.73jueC5DbqxUWlI9XbOiGQ";

let map = null; // 定义一个变量来存储 Mapbox 地图实例

onMounted(() => {
  // 初始化 Mapbox 地图实例
  map = new mapboxgl.Map({
    container: mapContainer.value, // 指定地图容器为通过 ref 创建的 DOM 元素
    center: [115.868642, 28.667836], // 设置地图中心点坐标（经度和纬度）
    style: 'mapbox://styles/mapbox/streets-v11', // 使用 Mapbox 提供的街道地图样式
    zoom: 10, // 设置地图的初始缩放级别
    projection: 'globe', // 设置地图投影类型为地球仪模式
  });

  // 添加导航控件（包括缩放和旋转功能）到地图上，并将其放置在左上角
  map.addControl(new mapboxgl.NavigationControl(), 'top-left');

  // 创建 L7 场景实例
  const scene = new Scene({
    id: mapContainer.value, // 使用 ref 对应的 DOM 元素作为场景的 ID
    map: new Mapbox({
      mapInstance: map, // 将 Mapbox 地图实例传递给 L7
    }),
  });
});
</script>

<style scoped>
/* 设置地图容器的宽度和高度 */
div {
  width: 100%; // 地图容器宽度占满父容器
  height: 400px; // 地图容器高度为 400 像素
}
</style>
```
## 在底图上添加点或者特定样式的柱体
文档链接：[点图层](https://l7.antv.antgroup.com/api/point_layer/pointlayer)
```javascript
 scene.on('loaded', () => {
    console.log('地图加载完成');
    const pointLayer = new PointLayer()
      .source([
        {
          lng: 115.899,
          lat: 28.619,
          type: 'road'
        },
      ], {
        parser: {
          type: 'json',
          x: 'lng',
          y: 'lat',
        },
      })
      .shape('type', (value) => {
        switch (value) {
          case 'path':
            return "cylinder";
          case 'road':
            return "triangleColumn";
        }
      })
      .size('type', (value) => {
        switch (value) {
          case 'path':
            return [30, 30];
          case 'road':
            return [10, 50];
        }
      })
      .color('type', (value) => { // 传入
        switch (value) {
          case 'path':
            return '#f00';
          case 'road':
            return '#0f0';
        }
      })
      .animate({
        enable: true, // 启用动画
        speed: 0.005, // 动画速度,默认为 `0.01`。
        repeat: 3,  // 播放次数
      });

    scene.addLayer(pointLayer);
  });
```
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/7243b5ec97494d5db9eb5e3ac4157021.png)
## AntvL7实现城市沙盘炫酷样式
```html
<template>
  <!-- 创建一个div元素作为地图容器 -->
  <div ref="mapContainer"></div>
</template>

<script setup>
import { onMounted, ref } from 'vue'; // 导入 Vue 的生命周期钩子和响应式引用
import { Scene, CityBuildingLayer } from '@antv/l7'; // 导入 L7 的场景和城市建筑图层
import { Mapbox } from '@antv/l7-maps'; // 导入 L7 的 Mapbox 适配器
import 'mapbox-gl/dist/mapbox-gl.css'; // 导入 Mapbox GL JS 的样式文件
import mapboxgl from 'mapbox-gl'; // 引入 Mapbox GL JS 库

// 创建一个引用，用于指向地图容器 DOM 元素
const mapContainer = ref(null);

// 设置 Mapbox 访问令牌，这是使用 Mapbox 服务的必要凭证
mapboxgl.accessToken = "pk.eyJ1IjoiaGdjb2RlNTk2OSIsImEiOiJjbTE3ejh6Zm0weGprMmpxeDhha3dxMzYyIn0.73jueC5DbqxUWlI9XbOiGQ";

let map = null; // 定义一个变量来存储 Mapbox 地图实例

onMounted(() => {
  // 初始化 Mapbox 地图实例
  map = new mapboxgl.Map({
    container: mapContainer.value, // 指定地图容器为通过 ref 创建的 DOM 元素
    center: [115.868642, 28.667836], // 设置地图中心点坐标（经度和纬度）
    style: 'mapbox://styles/mapbox/dark-v10', // 使用 Mapbox 提供的街道地图样式
    zoom: 10, // 设置地图的初始缩放级别
    projection: 'globe', // 设置地图投影类型为地球仪模式
  });
  map.on('style.load', function () {
    // 设置地图的雾效
    map.setFog({
      // 定义雾的可见范围，即雾的开始和结束距离
      // 第一个值（0.8）表示雾开始出现的距离，第二个值（8）表示雾结束的距离
      "range": [0.8, 8],

      // 设置雾的颜色
      "color": "#cad2d9",

      // 设置地平线与雾之间的混合程度，取值范围为 0 到 1
      // 值越小，混合越少，雾效越明显；值越大，混合越多，雾效越不明显
      "horizon-blend": 0.5,

      // 设置高空颜色，用于模拟高空的雾效颜色
      "high-color": "#007acc",

      // 设置太空颜色，用于模拟太空中的雾效颜色
      "space-color": "#1e1e1e",

      // 设置星空强度，取值范围为 0 到 1
      // 值越大，星空效果越明显
      "star-intensity": 0.6
    })
  });
  // 添加导航控件（包括缩放和旋转功能）到地图上，并将其放置在左上角
  map.addControl(new mapboxgl.NavigationControl(), 'top-left');

  // 创建 L7 场景实例
  const scene = new Scene({
    id: mapContainer.value, // 使用 ref 对应的 DOM 元素作为场景的 ID
    map: new Mapbox({
      mapInstance: map, // 将 Mapbox 地图实例传递给 L7
    }),
  });

  // 监听 L7 场景加载完成事件
  scene.on('loaded', () => {
    // 从本地文件加载地理空间数据（GeoJSON 格式）
    fetch('public/data.geojson')
      .then((res) => res.json()) // 将响应转换为 JSON 格式
      .then((data) => {
        // 创建城市建筑图层
        const layer = new CityBuildingLayer({
          zIndex: 0, // 设置图层的层级
        })
          .source(data) // 将加载的 GeoJSON 数据作为图层的数据源
          .size('height') // 字段映射到geojson文件的字段
          .animate(true) // 启用动画效果
          .style({
            // 定义建筑的基础样式
            baseColor: '#333', // 楼房基础颜色
            windowColor: '#666', // 窗户颜色
            brightColor: '#e5e510', // 点亮窗户颜色
            // 扫光动画配置
            sweep: {
              enable: true, // 开启扫光动画
              sweepRadius: 10, // 扩散半径
              sweepCenter: [115.868642, 28.667836], // 扩散中心点坐标
              sweepColor: '#00FFFF', // 扩散颜色
              sweepSpeed: 0.2, // 扩散速度
              baseColor: '#333' // 扫光时的基础颜色
            }
          });

        // 将创建的图层添加到 L7 场景中
        scene.addLayer(layer);
      });
  });
});
</script>

<style scoped>
/* 设置地图容器的宽度和高度 */
div {
  width: 100%;
  height: 500px;
}
</style>
```
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/7831ead57b3b4920898b66757aafbede.png)

**关于城市白膜数据的获取：**

 1. 获取城市白膜的shp格式的数据（**OSM下载**）
 2. 将shp格式转为geojson格式，同时设置坐标系为EPSG:4326坐标系（geojson也可以是一个url）
 3. 在代码中加载（注意高度字段）

# 加载WMTS底图

```javascript
map.on('load', () => {
    map.addSource('wmts-source', {
      type: 'raster',
      tiles: [
        // WMTS服务的URL模板，如果是geoserver，那么使用900913坐标系
        'http://localhost:8080/geoserver/Taxi/gwc/service/wmts?layer=Taxi:NCresult2&style=&tilematrixset=EPSG:900913&Service=WMTS&Request=GetTile&Version=1.0.0&Format=image/jpeg&TileMatrix=EPSG:900913:{z}&TileCol={x}&TileRow={y}'
      ],
      tileSize: 256
    });
    map.addLayer({
      id: 'wmts-layer',
      type: 'raster',
      source: 'wmts-source',
      minzoom: 0,
      maxzoom: 22
    });
})
```

