## TypeScript的基本介绍

包含于JavaScript，就是JavaScript加上Type

为 JavaScript 添加了 **静态类型** 和其他高级特性。TypeScript 最终会被编译成标准的 JavaScript 代码，可以在任何支持 JavaScript 的环境中运行（如浏览器、Node.js）。

```typescript
const num : number = 19 // TS声明变量类型
const age = 19 // JavaScript声明变量类型
```

```typescript
function greet(name: string): string {
  return `Hello, ${name}!`;
}
greet("Alice"); // ✅ 正确
greet(123);     // ❌ 编译时报错：参数类型不匹配
```

#### 如何编译TS文件

Ts在线运行：https://www.typescriptlang.org/play

1. 安装 TypeScript：

   ```
   npm install -g typescript
   ```

2. 编译 TS 文件：

   ```
   tsc your-file.ts
   ```

4. 运行 JS 文件

​	直接使用 Node.js 执行编译后的 JS 文件：

```
node your-file.js
```

#### 如果运行TS文件

#### **1. 安装 `ts-node`**

```
npm install -g ts-node  # 全局安装
```

**2. 直接运行 TS 文件**

```
ts-node hello.ts
```

## TS里的常用类型介绍

| 类型        | 示例                                                    | 用途             | 备注                           |
| :---------- | :------------------------------------------------------ | :--------------- | :----------------------------- |
| `number`    | `let age: number = 30`                                  | 数值类型         | 包括整数和浮点数               |
| `string`    | `let name: string = "Alice"`                            | 字符串           | 包括文本内容                   |
| `boolean`   | `let isDone: boolean = false`                           | 布尔值           | 只能为 `true` 或 `false`       |
| `Array`     | `let list: number[] = [1, 2, 3]`                        | 数组             | 可以指定数组元素的类型         |
| `Tuple`     | `let person: [string, number] = ["Alice", 30]`          | 固定长度数组     | 元素类型和顺序固定             |
| `interface` | `interface User { name: string; age: number }`          | 定义对象结构     | 用于描述对象的形状             |
| `enum`      | `enum Color { Red, Green, Blue }`                       | 枚举值           | 为一组常量赋予有意义的名称     |
| `any`       | `let data: any = "anything"`                            | 任意类型（慎用） | 不进行类型检查，可能引发错误   |
| `unknown`   | `let input: unknown`                                    | 安全的顶层类型   | 需要类型检查后才能使用         |
| `union`     | \`let id: string                                        | number           | 多类型选择                     |
| `type`      | `type Point = { x: number; y: number }`                 | 类型别名         | 为复杂类型创建别名             |
| `never`     | `function error(): never { throw new Error("Error"); }` | 永不返回         | 表示函数不会正常返回           |
| `void`      | `function greet(): void { console.log("Hello!"); }`     | 表示没有返回值   | 常用于函数返回类型             |
| `object`    | `let obj: object = { key: "value" };`                   | 表示非原始类型   | 不推荐直接使用，建议用具体类型 |

## TS里的用法

### 类型断言

有时TS可能无法完全准确地推断出变量的类型。此时，可以通过类型断言来明确指定类型。

**类型断言不会改变实际的运行时类型，它只是在==编译阶段影响类型检查。==**

有两种写法

```typescript
const message = "Hello, world!";
const length = (<string>message).length; // 使用尖括号语法
const length2 = (message as string).length; // 使用 as 语法
```

### 类型声明与限制

```typescript
// 声明一个变量 v4，类型可以是字符串（string）或 null，并赋值为 null。
let v4: string | null = null; 
// 声明一个变量 v5，类型是字面量联合类型，只能是1 2 3 
let v5: 1 | 2 | 3 = 2;
```

### 元组

**固定长度和类型**

```typescript
let person: [string, number] = ['Alice', 30];
person = [42, 'Bob']; // 错误！类型不匹配
```

**剩余元素**

```typescript
let tuple: [string, ...number[]];
tuple = ["Hello", 1, 2, 3]; // 正确
// tuple = ["Hello"]; // 错误，至少需要一个数字
```

**可选参数**

在类型的后面加上?

```typescript
let person: [string, number?] = ['Alice', 30];
```

### 接口

```typescript
interface Person {
  name: string;
  age: number;
  greet(): void; // 方法
}
// 使用接口
const user: Person = {
  name: "Alice",
  age: 25,
  greet() {
    console.log(`Hello, ${this.name}!`);
  },
};
```

### 泛型

```typescript
function identity<T>(arg: T): T {
  return arg;
}

const num = identity<number>(10); // 类型推断可省略：identity(10)
const str = identity<string>("TS");
```

### 类型别名

```typescript
type MyUserName = string | number
let a: MyUserName = 'abc'
let a: MyUserName = 2
```

## React里怎么使用Ts

### 组件规范

#### 函数组件

```tsx
import React from 'react';

interface UserProps {
  name: string;
  age: number;
  isActive?: boolean;
  onClick: () => void;
}

// 通常是从父组件传递的 props，使用解构赋值提取各个属性：
export const UserComponent: React.FC<UserProps> = ({ name, age, isActive = true, onClick }) => { // 这是一个函数式组件（React.FC），它的 props 类型为 UserProps。
  return (
    <div style={{ border: '1px solid black', padding: '10px', margin: '10px' }}>
      <h2>{name} ({age} years old)</h2>
      <p>Status: {isActive ? 'Active' : 'Inactive'}</p>
      <button onClick={onClick}>Click Me</button>
    </div>
  );
};

// 其它地方使用
  {/* 使用UserComponent，并传入必要的props */}
      <UserComponent 
        name="张三" 
        age={25} 
        onClick={handleUserClick} 
      />

      {/* 还可以传递可选的isActive属性 */}
      <UserComponent 
        name="李四" 
        age={30} 
        isActive={false} 
        onClick={() => alert('李四的按钮被点击')}
      />

	const userData = {
    name: "Alice",
    age: 25,
    isActive: true,
    onClick: () => console.log("User clicked!")
  };
 <UserComponent {...userData} />
  {/* 或者显式提供默认值 */}
 <UserComponent {...userData} isActive={false} />
```

#### 类组件

```tsx
import React, { Component } from 'react';

interface MyComponentProps {
  title: string; // 传入参数类型规范
}

interface MyComponentState {
  count: number; // 组件内部状态管理
}
// 函数式组件
class MyComponent extends Component<MyComponentProps, MyComponentState> { 
  constructor(props: MyComponentProps) {
    super(props); // 参数
    // 初始化状态
    this.state = {
      count: 0,
    };
  }

  // 方法：递增计数器
  increment = () => {
    this.setState(prevState => ({ count: prevState.count + 1 }));
  };

  render() {
    const { title } = this.props;
    const { count } = this.state;

    return (
      <div>
        <h1>{title}</h1>
        <p>Count: {count}</p>
        <button onClick={this.increment}>Increment</button>
      </div>
    );
  }
}

export default MyComponent;

// 具体使用
 <MyComponent title="第一个计数器" />
<MyComponent 
    title="第一个用户" 
    user={user1} 
    />
```

| 方面             | `MyComponentProps`                              | `MyComponentState`                          |
| ---------------- | ----------------------------------------------- | ------------------------------------------- |
| 作用             | **外部传入的属性（props）**                     | 由组件自身**维护和更新**（使用 `setState`） |
| 变化性           | **不可直接修改**（是只读的）                    | 当 state 变化时，组件会重新渲染             |
| 生命周期中的表现 | 在组件创建时提供初始值，更新props会触发重新渲染 | 通过`setState`更新，触发渲染                |

### Hooks 类型规范

#### useState

```tsx
// 基本类型可以自动推断
const [count, setCount] = useState(0);

// 复杂类型需要显式声明
interface User {
  id: number;
  name: string;
}

const [user, setUser] = useState<User | null>(null);
```
