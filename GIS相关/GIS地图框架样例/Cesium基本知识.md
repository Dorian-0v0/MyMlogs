# cesium介绍
Cesium.js 是一个开源的 JavaScript 库，专门用于创建高性能的 3D 地理空间可视化应用。它以强大的 3D 地球和地图渲染能力而闻名，广泛应用于地理信息系统（GIS）、航空航天、国防、交通等领域。
 ## 核心功能
### 3D 地球和地图
Cesium.js 能够创建高度逼真的 3D 地球和 2D 地图，支持多种地图模式（如 3D 地球、2D 地图、哥伦布视图等）。
支持高分辨率的地形和卫星影像图层，可以动态加载和切换不同的地图服务（如 ArcGIS、OpenStreetMap 等）。
### 3D 模型和实体
支持加载和显示多种格式的 3D 模型，如 glTF、COLLADA 等。
提供 Entity API 和 Primitive API，用于创建和管理地图上的各种对象（如点、线、面、3D 模型等）。
### 地理空间分析
支持时间动态数据，可以模拟和显示随时间变化的地理信息。
提供地形分析工具，如视域分析、地形剖面等。
### 虚拟现实和增强现实
支持 VR 和 AR 设备，用户可以通过虚拟现实头盔或增强现实设备沉浸式地体验 3D 地理空间应用。
# 第一个cesium案例
## 第一步：配置环境
下载依赖：
```bash
npm install cesium
```
安装插件：

```bash
npm i cesium vite-plugin-cesium vite -D  
# yarn add cesium vite-plugin-cesium vite -D
```
之后在 vite.config.js 中添加以下配置：
```javascript
import { defineConfig } from 'vite';
import cesium from 'vite-plugin-cesium'; // 使用 vite-plugin-cesium 插件

export default defineConfig({
  plugins: [cesium()],
});
```
## 第二步：设置Cesium的密钥token
Cesium在没有设置token的情况下，它会给你使用一个默认的token，在一段时间内你是可以正常使用的，但是不久后它会提示token过期，地图无法加载。
这个问题其实可以通过申请token来解决（问马云）
获取的token在main.js里加载
```javascript
import * as Cesium from 'cesium';
// 设置 Cesium Ion 的 Token
Cesium.Ion.defaultAccessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIyY2RkZTQ4OS0wYzRlLTQyNmMtYmFjNy0zMzI3MWEwZmYwODIiLCJpZCI6MjMxODE5LCJpYXQiOjE3MjI0MTY0Mzh9.rRYOzcdNEqL45HmrFguJzNk2KCBb38afCpPyedi0bZ0'; // 这个没有用😊
```
## 第三步：加载地图

```html
<script setup>
import * as Cesium from 'cesium';
import { onMounted } from 'vue';
onMounted(() => {
  const viewer = new Cesium.Viewer('cesiumContainer');
}) 

</script>
<template>
  <div id="cesiumContainer"></div>
</template>
```
加载的地图如下
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/6f707cc8307c46e99798bb2f4488c4f3.png)
### 地图控件关闭
```javascript
onMounted(() => {
  const viewer = new Cesium.Viewer('cesiumContainer', {
  	// 是否显示信息窗口
  	infoBox: false
    // 搜索按钮
    geocoder: false,
    // 地图风格切换按钮
    baseLayerPicker: false,
    // 恢复默认视角按钮
    homeButton: false,
    // 2D/2.5D/3D切换按钮
    sceneModePicker: false,
    // 操作指引按钮
    navigationHelpButton: false,
    // 动画播放控件
    animation: false,
    // 时间轴控件
    timeline: false,
    // 全屏按钮
    fullscreenButton: false,
  });
  // 隐藏Cesium的logo
  viewer._cesiumWidget._creditContainer.style.display = "none";
})
```
### 天空盒加载
天空盒资源图片放在public的skybox文件夹内
```javascript
onMounted(() => {
  // 创建 Cesium.Viewer 实例，初始化 Cesium 地球视图
  const viewer = new Cesium.Viewer('cesiumContainer', {
    infoBox: false, // 禁用默认的信息框（点击实体时显示的弹出框）
    skyBox: new Cesium.SkyBox({ // 创建一个天空盒对象
      sources: { // 定义天空盒的6个面的图片路径
        positiveX: './skybox/px.jpg', // 正X方向的图片
        negativeX: './skybox/nx.jpg', // 负X方向的图片
        positiveY: './skybox/py.jpg', // 正Y方向的图片
        negativeY: './skybox/ny.jpg', // 负Y方向的图片
        positiveZ: './skybox/pz.jpg', // 正Z方向的图片
        negativeZ: './skybox/nz.jpg'  // 负Z方向的图片
      },
    }),
  });
});
```
# 加载特定类型的地图
## 加载高德地图
```javascript
<script setup>  
import * as Cesium from 'cesium'; // 导入 Cesium 库  
import { onMounted } from 'vue'; // 从 Vue 中引入 onMounted API  

onMounted(() => {  
  // 创建 Cesium 视图器  
  const viewer = new Cesium.Viewer('cesiumContainer');  

  // 如果需要叠加高德/百度注记地图则添加以下代码  
  viewer.imageryLayers.addImageryProvider(  
    new Cesium.UrlTemplateImageryProvider({  
      url: 'http://webrd01.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=2&scale=1&style=8', // 设置高德地图的 URL 模板  
      layer: 'AnnoLayer', // 设置图层名称  
      style: 'default', // 设置样式  
      format: 'image/jpeg', // 设置图像格式  
      tileMatrixSetID: 'GoogleMapsCompatible', // 设置瓦片矩阵集 ID  
    })  
  );  
});  
</script>  

<template>  
  <div id="cesiumContainer"></div> <!-- Cesium 视图容器 -->  
</template>
```
## 加载mapbox的地图

[styleId见查看](https://docs.mapbox.com/api/maps/styles/)
```javascript
<script setup>
import * as Cesium from 'cesium';
import { onMounted } from 'vue';

onMounted(() => {
  // 创建 Cesium 视图器
  const viewer = new Cesium.Viewer('cesiumContainer');
  // 将 Mapbox 地图添加到图层中
  const mapbox = viewer.imageryLayers.addImageryProvider(new Cesium.MapboxStyleImageryProvider({
    styleId: 'outdoors-v12', // Mapbox 地图 ID
    accessToken: 'pk.eyJ1IjoiaGdjb2RlNTk2OSIsImEiOiJjbTE3ejh6Zm0weGprMmpxeDhha3dxMzYyIn0.73jueC5DbqxUWlI9XbOiGQ' // 替换为你的 Mapbox 访问令牌
  }));
  mapbox.alpha = 0.7
});
</script>
```
## 加载地形和水纹效果
只加载地形也可以直接

```javascript
 const viewer = new Cesium.Viewer('cesiumContainer', {
      terrain: Cesium.Terrain.fromWorldTerrain(),
    });  
```

```javascript
<script setup>
import * as Cesium from 'cesium';
import { onMounted } from 'vue';

onMounted(async () => {
  // 创建 Cesium 视图器
  const viewer = new Cesium.Viewer('cesiumContainer', {
    baseLayerPicker: false,
    // 暂时不设置 terrainProvider，稍后异步加载
  });

  try {
    // 异步加载地形数据
    const terrainProvider = await Cesium.CesiumTerrainProvider.fromIonAssetId(1, {
      requestVertexNormals: true, // 请求顶点法线，用于提高光照效果
      requestWaterMask: true, // 请求水面遮罩，用于水面效果
    });

    // 设置地形提供者
    viewer.terrainProvider = terrainProvider;
  } catch (error) {
    console.error('Failed to load terrain:', error);
  }
});
</script>
```
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/91ccb4aa42cb4c18b11a1e5abce249d4.png)
## 加载osm城市建筑

```javascript
onMounted(async () => {
  const viewer = new Cesium.Viewer('cesiumContainer');

  try {
    // 使用 async/await 语法等待异步操作完成
    const buildingsTileset = await Cesium.createOsmBuildingsAsync();
    viewer.scene.primitives.add(buildingsTileset);
  } catch (error) {
    console.error('加载 3D 建筑数据失败:', error);
  }
});
```

# 相机视角
## 相机位置设置
**相机视角设置后，点击首页按钮可定位**
```javascript
// 相机视角设置后，点击首页按钮可定位
Cesium.Camera.DEFAULT_VIEW_RECTANGLE = Cesium.Rectangle.fromDegrees(
  80.5, // 西边
  4.4, // 南边
  135.4,// 东边
  60.2  // 北边 
)
onMounted(() => {
  const viewer = new Cesium.Viewer('cesiumContainer');
})
```
## 相机的俯仰角以及翻滚角

```javascript
onMounted(() => {
  // 创建 Cesium 视图器
  // 'cesiumContainer' 是 HTML 中容器的 ID，用于指定 Cesium 地图的显示位置
  const viewer = new Cesium.Viewer('cesiumContainer');

  // 设置相机的位置和朝向
  viewer.scene.camera.setView({
    // 目标位置，指定相机需要聚焦的点
    destination: Cesium.Cartesian3.fromDegrees(115.85, 28.68, 500), // 目标位置（经度、纬度、高度）
    // 相机的朝向，定义相机的旋转角度
    orientation: {
      // 相机在水平面上的旋转角度，单位是弧度
      // 0 表示正北方向，正值表示向东看
      heading: Cesium.Math.toRadians(20.0), // 方向（以弧度为单位）
      // 相机在垂直面上的旋转角度，单位是弧度
      // 负值表示向下看，正值表示向上看
      pitch: Cesium.Math.toRadians(-45), // 俯仰角（以弧度为单位）
      // 相机绕自身轴的旋转角度，单位是弧度
      // 通常设置为 0，除非需要特殊的旋转效果
      roll: 0.0 // 滚转角（以弧度为单位）
    }
  });
});
```
## 飞往某地

```javascript
<script setup>
import * as Cesium from 'cesium';
import { onMounted, onUnmounted, ref } from 'vue';

const viewer = ref(null);

const flytocity = () => {
  if (viewer.value) {
    viewer.value.camera.flyTo({
      destination: Cesium.Cartesian3.fromDegrees(115.85, 28.68, 500),
      orientation: {
        heading: Cesium.Math.toRadians(0),
        pitch: Cesium.Math.toRadians(-20),
        roll: 0,
      }
    });
  }
};

onMounted(() => {
  // 创建 Cesium 视图器
  viewer.value = new Cesium.Viewer('cesiumContainer');
});

onUnmounted(() => {
  // 销毁 Cesium 视图器，释放资源
  if (viewer.value) {
    viewer.value.destroy();
    viewer.value = null;
  }
});
</script>
```
## 键盘控制相机

```javascript
onMounted(() => {
  const viewer = new Cesium.Viewer('cesiumContainer');
  // 添加键盘事件监听器
  document.addEventListener('keydown', (e) => {
    // 获取相机离地面的高度
    const height = viewer.camera.positionCartographic.height;
    const moveRate = height / 100;
    if (e.key === "w") {
      // 设置相机向前移动
      viewer.camera.moveForward(moveRate);
    } else if (e.key === "s") {
      // 设置相机向后移动
      viewer.camera.moveBackward(moveRate);
    } else if (e.key === "a") {
      // 设置相机向左移动
      viewer.camera.moveLeft(moveRate);
    } else if (e.key === "d") {
      // 设置相机向右移动
      viewer.camera.moveRight(moveRate);
    } else if (e.key === "q") {
      // 相机向左
      viewer.camera.lookLeft(Cesium.Math.toRadians(1));
    } else if (e.key === "e") {
      // 相机向右
      viewer.camera.lookRight(Cesium.Math.toRadians(1));
    } else if (e.key === "r") {
      // 向上抬头
      viewer.camera.lookUp(Cesium.Math.toRadians(1));
    } else if (e.key === "f") {
      // 向下低头
      viewer.camera.lookDown(Cesium.Math.toRadians(1));
    } else if (e.key === "g") {
      // 逆时针旋转  
      viewer.camera.twistLeft(Cesium.Math.toRadians(1));
    } else if (e.key === "h") {
      // 顺时针旋转  
      viewer.camera.twistRight(Cesium.Math.toRadians(1));
    }
  });
})
```
# 地图上添加点
## 添加点

```javascript
onMounted(() => {
  // 创建 Cesium 视图器实例，附加到页面上的 'cesiumContainer' 元素
  const viewer = new Cesium.Viewer('cesiumContainer');

  // 使用 flyTo 方法设置相机的初始位置和朝向
  // 相机将平滑地飞行到指定的位置和朝向
 ......
  // 创建一个点实体并添加到视图中
  const point = viewer.entities.add({
    // 定位点的位置，使用 Cartesian3.fromDegrees 方法从经纬度和高度创建一个三维点
    position: Cesium.Cartesian3.fromDegrees(115.84949, 28.68948, 303),

    // 点的属性，定义了点的显示样式
    point: {
      pixelSize: 10, // 点的大小，以像素为单位
      color: Cesium.Color.RED, // 点的颜色，这里设置为红色
      outlineColor: Cesium.Color.WHITE, // 点的轮廓颜色，这里设置为白色
      outlineWidth: 4, // 点的轮廓宽度，以像素为单位
    },
  });
});
```
## 添加标签

```javascript
  // 添加文字标签
  const label = viewer.entities.add({
    position: Cesium.Cartesian3.fromDegrees(115.84949, 28.68948, 303),
    label: {
      text: '这是一个标签', // 标签的文字内容
      font: '24px sans-serif', // 字体大小和字体类型，微软雅黑更美观
      fillColor: Cesium.Color.RED, // 文字颜色，白色更显眼
      outlineColor: Cesium.Color.BLACK, // 文字轮廓颜色，黑色增强对比
      outlineWidth: 4, // 文字轮廓宽度
      style: Cesium.LabelStyle.FILL_AND_OUTLINE, // 文字样式，填充和轮廓
      pixelOffset: new Cesium.Cartesian2(0, -20), // 文字偏移量，调整文字位置
      backgroundPadding: new Cesium.Cartesian2(10, 10), // 背景填充的边距
      horizontalOrigin: Cesium.HorizontalOrigin.CENTER, // 水平对齐方式
      verticalOrigin: Cesium.VerticalOrigin.BOTTOM, // 垂直对齐方式
      eyeOffset: new Cesium.Cartesian3(0, 0, -10), // 避免文字被地形遮挡
    },
  });
```
## 加载3D模型
如果需要加载其他格式的 3D 模型，通常需要先将其转换为 glTF、glb 或 3D Tiles 格式

```javascript
<script setup>
import * as Cesium from 'cesium';
import { onMounted } from 'vue';
onMounted(async () => {  // 将onMounted回调定义为异步函数
  const viewer = new Cesium.Viewer('cesiumContainer');
  try {
    // 加载并显示飞机模型
    const airplaneModel = await Cesium.Model.fromGltfAsync({
      url: './无人机.glb', // 替换为你的飞机模型路径
      modelMatrix: Cesium.Transforms.eastNorthUpToFixedFrame(
        Cesium.Cartesian3.fromDegrees(115.84949, 28.68948, 350) // 设置位置
      ),
      scale: 10.0 // 根据需要调整模型大小
    });
    viewer.scene.primitives.add(airplaneModel);
  } catch (error) {
    console.error("Error loading airplane model:", error);
  }
})
</script>
```
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/b4887f0099224039843529399b60eba6.png)
# 加载GeoJson格式的数据
## 加载geojson
```javascript
// 当组件挂载到DOM后触发
onMounted(async () => {
  const viewer = new Cesium.Viewer('cesiumContainer');
  // GeoJSON文件的URL路径
  const geojsonUrl = 'https://geo.datav.aliyun.com/areas_v3/bound/360100_full.json';
  try {
    // 使用Cesium.GeoJsonDataSource.load方法异步加载并解析指定的GeoJSON文件
    // 第二个参数是样式选项，用于设置加载数据的外观（如边线颜色、填充颜色和边线宽度）
    const dataSource = await Cesium.GeoJsonDataSource.load(geojsonUrl, {
      // 使用Cesium.Color.fromCssColorString结合alpha值来设定带透明度的颜色
      stroke: Cesium.Color.fromCssColorString('#000000'),
      fill: Cesium.Color.fromCssColorString('#25b1f3').withAlpha(0.5), // 填充
      strokeWidth: 3, // 设置边线宽度为3像素
    });
    // 将加载的数据源添加到viewer的数据源集合中，以便可以在地球上显示
    viewer.dataSources.add(dataSource);
  } catch (error) {
    console.error('Error loading GeoJSON:', error);
  }
});
```
## 给geojson数据的每一个区域设置不同的颜色

```javascript
onMounted(async () => {
  const viewer = new Cesium.Viewer('cesiumContainer');
  // GeoJSON文件的URL路径
  const geojsonUrl = 'https://geo.datav.aliyun.com/areas_v3/bound/360100_full.json';
  try {
    // 异步加载GeoJSON数据
    const dataSource = await Cesium.GeoJsonDataSource.load(geojsonUrl);
    // 将加载的数据源添加到viewer的数据源集合中
    viewer.dataSources.add(dataSource);
    // 获取所有实体
    const entities = dataSource.entities.values;
    // console.log(entities);
    // 遍历所有实体，并为每个实体设置不同的样式
    for (let i = 0; i < entities.length; i++) {
      const entity = entities[i];
      // 根据你的逻辑生成一个颜色，这里简单地使用了index来区分颜色
      // 实际应用中可以根据属性值或其他逻辑来确定颜色
      const color = Cesium.Color.fromRandom({ alpha: 1.0 });
      // 设置多边形的填充颜色和边线颜色
      if (entity.polygon) {
        entity.polygon.material = new Cesium.ColorMaterialProperty(color.withAlpha(0.5)); // 填充颜色及透明度
        entity.polygon.outlineColor = Cesium.Color.BLACK; // 边线颜色
        entity.polygon.outlineWidth = 2; // 边线宽度
      }
    }
    // 相机飞行到数据集的位置以便查看
    viewer.zoomTo(dataSource);
  } catch (error) {
    console.error('Error loading GeoJSON:', error);
  }
});
```
**效果如下**
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/943f23eaa4ba4a8bbac51d1b5be3bdf7.png)
