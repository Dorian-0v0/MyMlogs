# GeoTools的使用

## 求解两点距离

一、导入依赖

```xml
    <dependencies>    
		<dependency>
            <groupId>org.geotools</groupId>
            <artifactId>gt-geometry</artifactId>
            <version>24.5</version>
        </dependency>
        <dependency>
            <groupId>org.geotools</groupId>
            <artifactId>gt-epsg-hsql</artifactId>
            <version>24.5</version>
        </dependency>
    </dependencies>

    <repositories>
        <repository>
            <id>osgeo</id>
            <name>OSGeo Release Repository</name>
            <url>https://repo.osgeo.org/repository/release/</url>
            <snapshots><enabled>false</enabled></snapshots>
            <releases><enabled>true</enabled></releases>
        </repository>
        <repository>
            <id>osgeo-snapshot</id>
            <name>OSGeo Snapshot Repository</name>
            <url>https://repo.osgeo.org/repository/snapshot/</url>
            <snapshots><enabled>true</enabled></snapshots>
            <releases><enabled>false</enabled></releases>
        </repository>
    </repositories>
```

二、计算方法

```java
public class GeotoolsUtils {
    /**
     * 计算两点间距离（单位：米）
     *
     * @param startLng 起点经度
     * @param startLat 起点纬度
     * @param endLng   终点经度
     * @param endLat   终点纬度
     * @return 两点间距离（米）
     */
    public static double calculateDistance(double startLng, double startLat,
                                         double endLng, double endLat) throws TransformException {
        CoordinateReferenceSystem crs = org.geotools.referencing.crs.DefaultGeographicCRS.WGS84;
        GeodeticCalculator gc = new GeodeticCalculator(crs);
        JTSFactoryFinder.getGeometryFactory(null);
        Coordinate coord1 = new Coordinate(startLng, startLat);
        Coordinate coord2 = new Coordinate(endLng, endLat);
        gc.setStartingPosition(org.geotools.geometry.jts.JTS.toDirectPosition(coord1, crs));
        gc.setDestinationPosition(org.geotools.geometry.jts.JTS.toDirectPosition(coord2, crs));
        return gc.getOrthodromicDistance() / 1000;
    }
}
```