## 输入输出相关
```java
Scanner scan = new Scanner(System.in);  
String word = scan.next();  //next是遇到空格自动停止
nextLine// 遇到换行停止
int number = scan.nextInt(); // 获取整数输入 

nextInt(); // 接收一个 int 整数
nextLong(); // 接收 long 类型整数
nextFloat(); // 接收 float 类型小数
nextDouble(); // 接收 double 类型小数
next(); // 接收读取不带空格的字符串
nextLine(); // 接收读取整段字符串

printf 方法中的格式字符串 "%.2f"
将浮点数格式化为小数点后保留两位数字

// 要求空格输入：类似于：43 62 12 43
 for(int i = 0; i < 3; i++){
  arr[i] = scanner.nextInt();
}
```
## 数值运算BigDecimal 
BigDecimal 类型的数整数和小数都可以表示任意大的，**但是不可变且线程安全。**
```java
import java.math.*;
// 创建BigDecimal：使用new
BigDecimal num1 = new BigDecimal("0.1");  
   // 加法  
BigDecimal sum = num1.add(num2);  
  // 减法  
BigDecimal difference = num1.subtract(num2);  
 // 乘法  
BigDecimal product = num1.multiply(num2);  
 // 除法  // 指定四舍五入
BigDecimal quotient = num1.divide(num2, 2, RoundingMode.HALF_UP);  
 // 四舍五入到小数点后2位  
 BigDecimal roundedNumber = number.setScale(2, RoundingMode.HALF_UP); 
```
## 
BigInteger可以表示任意大的整数
## 字符串相关处理的方法
```java
import java.util.*; // 导包
// 将输入的字符串转为字符数组，方便遍历
char[] str = scan.next().toCharArray(); 
String string = new String(str); // 转为string  
StringBuilder stringBuilder = new StringBuilder(new String(str ));  // 转为stringBuilder 

// 使用StringBuilder字符串重构字符串
StringBuilder newstr = new StringBuilder();
newstr.append(str[i - 1]); // 尾部追加

// 字符串转为StringBuilder
String str = "Hello, World!";  
StringBuilder stringBuilder = new StringBuilder(str); 
char ch = sb.charAt(1); // e，获取字符
sb.setCharAt(1, 'a'); // 替换特定位置的字符
sb.reverse(); // 逆转


## 集合
**Collection 接口的通用方法**
```java
add(T t) // 添加元素
remove(int index) // 移除元素
size()// 返回元素的个数
isEmpty()// 是否为空
contains(T t) // 是否包含t
clear() // 移除集合中的所有元素。
```
### hashset
基本的方法

**使用hash表去重以及数组与hashset的互相转换**
```java
int[] nums = {1, 2, 3, 4, 5};  
HashSet<Integer> set = new HashSet<>();  
// 数组去重 
for (int num : nums) {  
    set.add(num);  
}  

 // HashSet 转数组（尽量使用Integer来接收set里的Integer）  
Integer[] array = set.toArray(new Integer[0]);  
```
### Map
常用方法
**键（Key）必须是唯一的**
1. **put(K key, V value)**：将键（key）/值（value）对存放到Map集合中。
2. **get(Object key)**：返回指定键对应的值，没有该key对应的值则返回`null`。
3. **size()**：返回Map集合中数据量，准确说是返回`key-value`的组合数量。
4. **getOrDefault(K key, Object value)**：方法获取指定`key`对应的`value`，==**如果找不到`key`，则返回设定的默认值。**==
### 栈和队列
```java
// 创建栈
Stack <Integer> stack = new Stack<>();  
// 创建队列
Queue<Integer> queue = new LinkedList<>();
```
**栈常用方法**
1. **push(Object element)**：把对象压入栈顶部。
2. **pop()**：移除栈顶的对象，并作为此函数的返回值返回该对象。
3. **peek()**：查看栈顶的对象，==**但不从栈中移除它。**==
4. **isEmpty()**：测试栈是否为空。

**队列常用方法**
add(T t)：添加元素
Object poll()：删除并返回队列头部被删除的那个元素。没有返回null（remove也可以）
Object peek()：返回队列头元素，但不删除。没有返回null（和栈的peek一样）
### 排序
```java
Integer[] arr = {32, 4, 65, 18, 63, 75};  
// 顺序排序 
Arrays.sort(arr, (o1, o2) -> o1 - o2);
// 逆序排序
Arrays.sort(arr, (o1, o2) -> o2 - o1);
// 数组转为集合
List<Integer> list = new ArrayList<>(Arrays.asList(arr)); // 使用 Arrays.asList()  
// 集合的排序
Collections.sort(list, (o1, o2) -> o2 - o1); // 使用 Collections.sort()  
```
多使用使用Arrays工具类里的equals（==内容要一样，包括顺序==），sort，asList方法

### 二分查找通用模板
```java
        int[] arr = {32,54,66,74,123,133,145};
        int l = -1, r = arr.length; // 规定左右范围
        int tar = 65; // 目标值
        while(l + 1 != r){
            int mid = (l + r) / 2;
            if(arr[mid] >= tar){ 
        // 我是要找的索引是满足:arr[index] >= tar,即等于返回index，大于返回第一个大于tar的元素，索引值位r。
                r = mid;
            }else{
                l = mid;
            }
        }
        System.out.println(r);
```
#### 浮点数二分查找
[切绳子-洛谷](https://www.luogu.com.cn/problem/P1577)
```java
import java.util.*;
import java.lang.Math;
// 1:无需package
// 2: 类名必须Main, 不可修改
public class Main {
    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        int N = scan.nextInt(); // N个绳子
        int K = scan.nextInt(); // K条长度相同
        double[] arr = new double[N]; // 每一条绳子的长度
        double sum = 0.0;
        for(int i = 0; i < N; i++){
            arr[i] = scan.nextDouble();
            sum += arr[i]; 
        }
        double r = sum / K;
        double l = 0.01;
        while((int)l*100 < (int)r*100){
            double mid = l + (r - l) / 2;
            int coun = 0;
            for(int i = 0; i < N; i++){
                coun+=((int)(arr[i] / mid));
            }
            if(coun >= K){
                l = mid;
            }else{
                r = mid;
            }
        }
        System.out.printf("%.2f", l);
        scan.close();
    }
}
```
## 题目的时间和空间复杂度
==**现代计算机每秒可处理约 10^7 ∼ 10^8次操作**==
<br>所以下面的表格最大计算的到==10^6==为止。
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/2260eca18302424e96fc2c1e54835fdc.png)

一个int数组最多可以存储2^31 - 1个数，大约为：==Integer.MAX_VALUE==
内存大小排序：**TB >GB> MB> KB> B(byte:字节) >bits（比特）** 
1 TB = 1024GB
1 GB = 1024 MB
1 MB = 1024 KB
1 KB = 1024 Bytes
1 Byte = 8bits
### 空间复杂度
int的范围数量级为10e9（数组的索引 **[ i ]** 是用 int 类型）
long为10e18

更大就使用：BigInteger 
**256 MB** = 256 * 1024 * 8 kB = 256 * 1024 * 1024 * 8 b = 2147483648 b;  
int 4 字节 = 4 B = 32 b  
int nums[67108864] 就为最大了  （6 X 10的7次方）
### 时间复杂度
**根据数据范围推测时间复杂度：**

1. 当题目数据 \( n \leq 100 \) 时： \( O(n^3) \) 或 \( 10^6 \)
2. 当题目数据 \( n \leq 1000 \) 时： \( O(n^2) \) 或者 \( O(n^2 \log n) \)
3. 当题目数据 \( n \leq 10^5 \) 时： \( O(n) \) 或者 \( O(n \log n) \)
4. 当题目数据 \( n \leq 10^9 \) 时： \( O(\sqrt{n}) \)
## 数学运算以及数论
对9取模：==相当于一个数x除以9余多少：x % 9==
### **同余定理**
**(a+b)%n=[(a%n)+(b%n)]%n 取模的分配律**
**(a - b) % c == 0   ⇔   a % c == b % c**

### 最大公因数和最小公倍数的求法
```java
// gcd:最大公因数
    public static int gcd(int a,int b){
        return b == 0 ? a : gcd(b, a % b);
    }

// lcm：最小公倍数
    public static int lcm(int a,int b){
        return a/gcd(a, b)*b;
    }
```
### 前缀和优化
```java
long[] sums = new long[N]; //前缀和数组
int[] arr = new int[N]; // 数组
long sum = 0; // 求前缀和
for (int i = 0; i < N; i++) {
      arr[i] = scan.nextInt();
      sum+=arr[i];
      sums[i] = sum;
}
对于求[i, j]范围的和，表达式就是：sum[j] - sum[i - 1] 
// i - 1为0时，sums[0] = 0
```


#### P8649 [蓝桥杯 2017 省 B] k 倍区间
**题目描述**

给定一个长度为 $N$ 的数列，$A_1,A_2, \cdots A_N$，如果其中一段连续的子序列 $A_i,A_{i+1}, \cdots A_j(i \le j)$ 之和是 $K$ 的倍数，我们就称这个区间 $[i,j]$ 是 $K$ 倍区间。

你能求出数列中总共有多少个 $K$ 倍区间吗？

**输入格式**

第一行包含两个整数 $N$ 和 $K$ $(1 \le N,K \le 10^5)$。

以下 $N$ 行每行包含一个整数 $A_i$ $(1 \le A_i \le 10^5)$。

**输出格式**

输出一个整数，代表 $K$ 倍区间的数目。
**输入输出样例 #1**
**输入 #1**

```
5 2
1  
2  
3  
4  
5
```
 **输出 #1**

```
6
```
**提示**
时限 2 秒, 256M。
```java
   Scanner scan = new Scanner(System.in);
        long N = scan.nextLong(); // n个数
        int K = scan.nextInt(); // 数%K
        long sum = 0; // 求总数
        long[] hashrest = new long[K]; // 余数hash表
        hashrest[0] = 1; // 对于求[i, j]范围的和，表达式就是：sum[j] - sum[i - 1]
        for (int i = 0; i < N; i++) {
            sum += scan.nextLong();
            hashrest[(int) (sum % K)]++;
        }
        long count = 0;
        for (long num : hashrest) {
            count += (num * (num - 1) / 2);
        }
        System.out.println(count);
        scan.close();
```
## 动态规划
### 线性动态规划
[最长递增子序列](https://leetcode.cn/problems/longest-increasing-subsequence/description/?envType=study-plan-v2&envId=top-100-liked)
```java
class Solution {
    public int lengthOfLIS(int[] nums) {
   // 以arr[i]结尾的最长连续子序列的长度
        int[] dp = new int[nums.length]; 
        dp[0] = 1;
        int res = 1;
        for (int i = 1; i < nums.length; i++) {
            dp[i] = 1;
            for (int j = i - 1; j >= 0; j--) {
                if (nums[j] < nums[i]) { 
     // 先找0~i之间数是否小于nums，小于就可以和nums[i]组成序列
                    dp[i] = Math.max(dp[j] + 1, dp[i]);
                }
            }
            res = dp[i] > res ? dp[i] : res;
        }
        return res;
    }
}
```
## DFS
**将任务抽象为一个二叉决策树**
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/b4fecc76294a4d69b3d475f9c91792e2.png)


# 蓝桥杯刷题
### 1、判断1~2020的所有数字里一共有多少个2
方法一<br>
>**str.toCharArray()**:将一个字符串转为字符数组
```java
  Scanner scan = new Scanner(System.in);
        //在此输入您的代码...
        int count = 0;
        for(int i = 1; i < 2021; i++){ // 注意是1到2020
          String numstr = i + "";
          for(char c : numstr.toCharArray()){
            if(c == '2'){
              count ++;
            }
          }
        }
        System.out.println(count);
        scan.close();
```
方法二
> while(num > 0){ // 这个循环条件搭配num/=10来使用<br>
    int i = num % 10; // 可以获取一个数字每一位上的数值<br>
    ......<br>
    num /= 10<br>
}
```java
 Scanner scan = new Scanner(System.in);
        //在此输入您的代码...
        int count = 0;
        for(int i = 1; i < 2021; i++){
          int num = i;
          while(num != 0){ // 
            if(num % 10 == 2){
              count ++;
            }
            num = num / 10;
          }
        }
        System.out.println(count);
        scan.close();
```
### 2、关于内存的计算
```java
    long a = 256L*1024*1024*8; // Java中默认的一个数字就是int类型，所以要在开始的数字转为long类型
    long num = a>>5; // 除以2的5次方
    System.out.println(num);
```

### 3、求成绩的最大值、最小值、平均值
```java
import java.util.*; // 直接导入这些包
import java.lang.*;
     Scanner scan = new Scanner(System.in); 
        int n = scan.nextInt(); // 获取输入的整数
        List<Integer> ints = new ArrayList<>();
        Double sum = 0.0;
        for(int i = 0; i < n; i++){
          Integer num = scan.nextInt();
          sum+=num;
          ints.add(num);
        }
        System.out.println(Collections.max(ints)); // 求最大值使用Collections工具类
        System.out.println(Collections.min(ints));
        System.out.printf("%.2f", sum / n); // 类似于C语言的四舍五入
        //在此输入您的代码...
        scan.close();
```

### 4、看一下java里的小数精确运算，和big类型的数值
