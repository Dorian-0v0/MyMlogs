

**1995 年，GoF（Gang of Four，四人组/四人帮）合作出版了《设计模式：可复用面向对象软件的基础》一书，共收录了 23 种设计模式，从此树立了软件设计模式领域的里程碑，人称【GoF设计模式】。**

## 为什么要学习设计模式

设计模式的本质是面向对象设计原则的实际运用，是对类的封装性、继承性和多态性以及类的  关系和组合关系的充分理解。

具体要理解原理以及应用场景。

#### 23种设计模式如下：

**创建模型：(怎么创建一个对象)**

- 单例模式、工厂模式、抽象工厂模式、建造者模式、原型模式。

**结构模型：**

- 适配器模式、桥接模式、装饰模式、组合模式、外观模式、享元模式、代理模式。

**行为模型：**

- 模板方法模式、命令模式、迭代器模式、观察者模式、中介者模式、备忘录模式、解释器模式、状态模式、策略模式、职责链模式、访问者模式。

## OOP七大原则

### 1.开闭原则（Open-Closed Principle）

**定义**：软件实体应该**对扩展开放，对修改关闭**。即在不修改已有代码的基础上，通过增加新的代码来实现新功能。

```java
interface Shape {
    void draw();
}

class Circle implements Shape {
    @Override
    public void draw() {
        // 绘制圆形的逻辑
    }
}

class Square implements Shape {
    @Override
    public void draw() {
        // 绘制正方形的逻辑
    }
}

class Triangle implements Shape {
    @Override
    public void draw() {
        // 绘制三角形的逻辑
    }
}
```

### 2.里氏替换原则（Liskov Substitution Principle）

**定义**：子类对象必须能够替换掉它们的父类对象，并且**不破坏系统的正确性**。即子类可以扩展父类的行为，但不能改变父类的行为。

```java
class Bird {
    public void move() {
        // 移动的逻辑
    }
}

class FlyingBird extends Bird {
    @Override
    public void move() {
        // 飞行的逻辑
    }
}

class Ostrich extends Bird {
    @Override
    public void move() {
        // 行走的逻辑
    }
}
```

将`Bird`类的`fly`方法改为`move`方法，`FlyingBird`类和`Ostrich`类分别实现不同的移动方式，这样`Ostrich`类就不会改变父类的行为，符合里氏替换原则。

### 3.依赖倒置原则（Dependency Inversion Principle）

**定义**：高层模块不应依赖于低层模块，二者都应该依赖于抽象；抽象不应依赖于细节，细节应依赖于抽象。即要**面向接口（或者抽象类）编程，而不是具体的实现类**。

```java
interface Device {
    void turnOn();
    void turnOff();
}

class Light implements Device {
    @Override
    public void turnOn() {
        // 开灯的逻辑
    }

    @Override
    public void turnOff() {
        // 关灯的逻辑
    }
}

class Fan implements Device {
    @Override
    public void turnOn() {
        // 开风扇的逻辑
    }

    @Override
    public void turnOff() {
        // 关风扇的逻辑
    }
}

class RemoteControl {
    private Device device;

    public RemoteControl(Device device) {
        this.device = device;
    }

    public void pressOn() {
        device.turnOn();
    }

    public void pressOff() {
        device.turnOff();
    }
}
```

通过定义一个`Device`接口，不同的电器设备实现这个接口，`RemoteControl`类依赖于`Device`接口，而不是具体的实现类，这样当添加新的电器设备时，只需要添加一个新的实现类，**而不需要修改`RemoteControl`类**，符合依赖倒置原则。

### 4.单一职责原则（Single Responsibility Principle）

**定义**：一个类只负责一项职责，不应承担过多的职责。如果一个类负责多个职责，当其中一个职责发生变化时，可能会导致其他职责受到影响。

```java
class Eater {
    public void eat() {
        // 吃东西的逻辑
    }
}

class Mover {
    public void move() {
        // 移动的逻辑
    }
}

class Sleeper {
    public void sleep() {
        // 睡觉的逻辑
    }
}
```

将不同的职责分离到不同的类中，每个类只负责一个职责，这样当其中一个职责发生变化时，不会影响到其他职责。

### 5.接口分离原则（Interface Segregation Principle）

**定义**：客户端不应该依赖于它不使用的接口。即一个类对另一个类的依赖应该建立在最小的接口上，而不是一个庞大的接口。

```java
interface Printer {
    void print();
}

interface Scanner {
    void scan();
}

interface Fax {
    void fax();
}

class SimplePrinter implements Printer {
    @Override
    public void print() {
        // 打印的逻辑
    }
}

class MultiFunctionPrinter implements Printer, Scanner, Fax {
    @Override
    public void print() {
        // 打印的逻辑
    }

    @Override
    public void scan() {
        // 扫描的逻辑
    }

    @Override
    public void fax() {
        // 传真逻辑
    }
}
```

将`Machine`接口拆分成`Printer`、`Scanner`和`Fax`三个接口，不同的设备类实现不同的接口，这样每个设备类只依赖它需要的接口，符合接口分离原则。

### 6. 迪米特法则 (Law of Demeter, LoD) 或最少知识原则

一个对象应该对其他对象有最少的了解，只与直接的朋友通信，避免与陌生类耦合

```java
// 违反LoD
class Customer {
    private Wallet wallet;
    
    public Wallet getWallet() {
        return wallet;
    }
}

class Wallet {
    private float money;
    
    public float getMoney() {
        return money;
    }
}

// 使用时
Customer customer = new Customer();
float money = customer.getWallet().getMoney(); // 违反了LoD

// 遵循LoD的改进
class Customer {
    private Wallet wallet;
    
    public float getPayment(float amount) {
        if(wallet != null) {
            return wallet.getMoney(amount);
        }
        return 0;
    }
}

class Wallet {
    private float money;
    
    public float getMoney(float amount) {
        if(money >= amount) {
            money -= amount;
            return amount;
        }
        return 0;
    }
}

// 使用时
Customer customer = new Customer();
float money = customer.getPayment(100); // 更好的方式
```

### 7.合成复用原则（Composite Reuse Principle）

**定义**：尽量使用对象组合，而不是继承来达到复用的目的。即**通过将已有的对象作为成员变量的方式，来实现代码的复用，而不是通过继承**。

```java
class Bird {
    public void fly() {
        // 飞行的逻辑
    }
}

class Singer {
    public void sing() {
        // 唱歌的逻辑
    }
}

class SuperBird {
    private Bird bird;
    private Singer singer;

    public SuperBird(Bird bird, Singer singer) {
        this.bird = bird;
        this.singer = singer;
    }

    public void fly() {
        bird.fly();
    }

    public void sing() {
        singer.sing();
    }
}
```

通过将`Bird`类和`Singer`类作为`SuperBird`类的成员变量，实现代码的复用，这样`SuperBird`类不会受到`Bird`类和`Singer`类变化的影响，符合合成复用原则。

## 创建模型

### 单例设计模式

它确保一个类只有一个实例，并提供一个全局访问点来获取该实例。单例模式主要用于控制**对某些共享资源的访问，例如配置管理器、连接池、线程池、日志对象等。**

#### 如何实现

##### 一、**饿汉式单例**

**类加载时就急切地创建实例**，不管你后续用不用得到，这也是饿汉式的来源，简单但**不支持延迟加载实例**，如果一直不使用会浪费内存。

```java
public class Singleton {
	// 本类创建的对象，类加载时创建
    private static final Singleton instance = new Singleton();
	// 私有构造器
    private Singleton() {}
	// 提供唯一的公共访问方式
    public static Singleton getInstance() {
        return instance;
    }
}
```

##### 二、**使用饿汉式单例**

```java
Singleton instance = Singleton.getInstance();

Singleton instance1 = Singleton.getInstance();

// 判断获取到的两个是否是同一个对象
System.out.println(instance == instance1);
```

##### **三、懒汉式单例**

懒汉式单例（Lazy Initialization）**在使用时才创建实例**，“确实懒”（😂）。这种实现方式需要考虑线程安全问题，因此一般会带上 [synchronized 关键字](https://javabetter.cn/thread/synchronized-1.html)。

```java
public class Singleton {
    private static Singleton instance;

    private Singleton() {}

    public static synchronized Singleton getInstance() {
        if (instance == null) {
            instance = new Singleton();
        }
        return instance;
    }
}
```

##### **四、双重检查锁**

双重检查锁用 synchronized 同步代码块替代了 synchronized 同步方法。并且在 instance 前加上 [volatile 关键字](https://javabetter.cn/thread/volatile.html)，防止指令重排，因为 `instance = new Singleton()` 并不是一个原子操作，可能会被重排序，导致其他线程获取到未初始化完成的实例。

```java
class Singleton {
    private static volatile Singleton instance; // 防止指令重排，出现空指针

    private Singleton() {}

    public static Singleton getInstance() {
        if (instance == null) {
            synchronized (Singleton.class) { // 方法里加锁判断
                if (instance == null) {
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
}
```

##### **五、静态内部类**

当第一次加载 Singleton 类时并不会初始化 SingletonHolder，只有在第一次调用 getInstance 方法时才会导致 SingletonHolder 被加载，从而实例化 instance。

```java
public class Singleton {
    private Singleton() {}

    private static class SingletonHolder {
        private static final Singleton INSTANCE = new Singleton();
    }

    public static Singleton getInstance() {
        return SingletonHolder.INSTANCE;
    }
}
```

##### **六、枚举**<span style="color: red">**（推荐）**</span>

使用[枚举（Enum）](https://javabetter.cn/basic-extra-meal/enum.html)实现单例是最简单的方式，不仅不需要考虑线程同步问题，还能防止反射攻击和序列化问题。

```java
public enum Singleton {
    INSTANCE;
    // 可以添加实例方法
}
```

#### 如何破坏

- 序列化与反序列化：单例类实现Serializable接口，将对象写入文件后读取，每次读取到的是不同对象
- 反射：将无参构造通过反射设置为可见，然后创建对象，创建得到的是不同对象

### 工厂设计模式（创建对象依赖与对象工厂，而不是直接new）

在java中，万物皆对象，这些对象都需要创建，如果创建的时候直接new该对象，就会对该对象耦合严重。假如我们要更换对象，所有new对象的地方都需要修改一遍。这显然违背了软件设计的开闭原则。如果我们使用工厂来生产对象，我们就只和工厂打交道就可以，彻底解对象解耦，如果要更换对象，直接在工厂里面换该对象即可，达到了对象解耦的目的；所以说，工厂模式最大的优点就是：**解耦**。

**简单工厂包含如下角色：**

- 抽象产品：定义了产品的规范，描述了产品的主要特性和功能。
- 具体产品：实现或继承抽象产品的子类。
- 具体工厂：提供了创建产品的方法，调用者通过该方法来获取产品。

##### 一、简单工厂模式

它引入了创建者的概念，将实例化的代码从应用程序的业务逻辑中分离出来。简单工厂模式包括一个工厂类，它提供一个方法用于创建对象。

```java
class SimpleFactory {
   public static Transport createTransport(String type){// 通过工厂类的静态方法来创建不同的对象
        if ("truck".equalsIgnoreCase(type)) {
            return new Truck();
        } else if ("ship".equalsIgnoreCase(type)) {
            return new Ship();
        }
        return null;
    }

    public static void main(String[] args) {
        Transport truck = SimpleFactory.createTransport("truck");
        truck.deliver();

        Transport ship = SimpleFactory.createTransport("ship");
        ship.deliver();
    }
}
```

缺点：如果之后交通工具工厂还要创建新的交通工具，比如自行车，那么又要修改工厂类的代码，**违背了开闭原则。（对扩展开放，对修改关闭**）

##### 二、**工厂方法模式**

定义一个创建对象的接口，但由子类决定要实例化的类是哪一个。工厂方法让类的实例化推迟到子类进行。

工厂方法模式的主要角色：

- **抽象工厂 (Abstract Factory)**：提供了创建产品的接口，调用者通过它访问具体工厂的工厂方法来创建产品。
- **具体工厂 (Concrete Factory)**：主要是实现抽象工厂中的抽象方法，完成具体产品的创建。
- **抽象产品 (Product)**：定义了产品的规范，描述了产品的主要特性和功能。
- **具体产品 (Concrete Product)**：实现抽象产品角色所定义的接口，由具体工厂来创建，它具体工厂之间——对应。

```java
interface Transport {   // 抽象产品 
    void deliver();
}

class Truck implements Transport { // 具体产品
    @Override
    public void deliver() {
        System.out.println("在陆地上运输");
    }
}

class Ship implements Transport { // 具体产品
    @Override
    public void deliver() {
        System.out.println("在海上运输");
    }
}

interface TransportFactory { // 抽象工厂
    Transport createTransport();
}

class TruckFactory implements TransportFactory { // 具体工厂
    @Override
    public Transport createTransport() {
        return new Truck();
    }
}

class ShipFactory implements TransportFactory { // 具体工厂
    @Override
    public Transport createTransport() {
        return new Ship();
    }
}

public class FactoryMethodPatternDemo {
    public static void main(String[] args) {
        TransportFactory truckFactory = new TruckFactory();
        Transport truck = truckFactory.createTransport();
        truck.deliver();

        TransportFactory shipFactory = new ShipFactory();
        Transport ship = shipFactory.createTransport();
        ship.deliver();
    }
}
```

- 以上的优点：**在不修改已有代码的基础上，通过增加新的代码（实现接口）来实现新功能**

- 以上的缺点：**每增加一个产品就要增加一个具体产品类别和一个对应的具体工厂类**，这增加了系统的复杂度。

**应用：**

**前端应用**

1. **组件的动态创建**
   根据不同条件动态创建不同类型的UI组件，例如根据用户角色加载不同的菜单或界面元素。
2. **主题或样式工厂**
   提供不同的主题（比如暗色主题和亮色主题），通过工厂创建对应的样式对象，实现界面风格的切换。

##### 三、抽象工厂

定义了一个创建一组相关或相互依赖对象的接口，而不需要指定它们具体的类。比如创建小米工厂，这样的话既可以生成路由器、手机、电脑。

假设我们需要为不同操作系统(Windows和Mac)创建一套UI组件(按钮和复选框)。

```java
// 抽象产品：按钮
interface Button {
    void render();
    void onClick();
}

// 抽象产品：复选框
interface Checkbox {
    void render();
    void onCheck();
}

// 抽象工厂
interface GUIFactory {
    Button createButton();
    Checkbox createCheckbox();
}

// 具体产品：Windows按钮
class WindowsButton implements Button {
    @Override
    public void render() {
        System.out.println("渲染一个Windows风格的按钮");
    }
    
    @Override
    public void onClick() {
        System.out.println("Windows按钮点击事件处理");
    }
}

// 具体产品：Windows复选框
class WindowsCheckbox implements Checkbox {
    @Override
    public void render() {
        System.out.println("渲染一个Windows风格的复选框");
    }
    
    @Override
    public void onCheck() {
        System.out.println("Windows复选框选中事件处理");
    }
}

// 具体产品：Mac按钮
class MacButton implements Button {
    @Override
    public void render() {
        System.out.println("渲染一个Mac风格的按钮");
    }
    
    @Override
    public void onClick() {
        System.out.println("Mac按钮点击事件处理");
    }
}

// 具体产品：Mac复选框
class MacCheckbox implements Checkbox {
    @Override
    public void render() {
        System.out.println("渲染一个Mac风格的复选框");
    }
    
    @Override
    public void onCheck() {
        System.out.println("Mac复选框选中事件处理");
    }
}

// 具体工厂：Windows工厂
class WindowsFactory implements GUIFactory {
    @Override
    public Button createButton() {
        return new WindowsButton();
    }
    
    @Override
    public Checkbox createCheckbox() {
        return new WindowsCheckbox();
    }
}

// 具体工厂：Mac工厂
class MacFactory implements GUIFactory {
    @Override
    public Button createButton() {
        return new MacButton();
    }
    
    @Override
    public Checkbox createCheckbox() {
        return new MacCheckbox();
    }
}

// 客户端代码
public class Application {
    private Button button;
    private Checkbox checkbox;
    
    public Application(GUIFactory factory) {
        button = factory.createButton();
        checkbox = factory.createCheckbox();
    }
    
    public void render() {
        button.render();
        checkbox.render();
    }
    
    public static void main(String[] args) {
        // 根据配置或环境选择具体工厂
        GUIFactory factory;
        String osName = System.getProperty("os.name").toLowerCase();
        
        if (osName.contains("win")) {
            factory = new WindowsFactory();
        } else {
            factory = new MacFactory();
        }
        
        Application app = new Application(factory);
        app.render();
    }
}
```

不过，缺点还是有的，如果产品族新增了产品，那么我就不得不去为每一个产品族的工厂都去添加新产品的生产方法，违背了开闭原则。

### 建造者模式

使用体验如下：

```java
public static void main(String[] args) {
    Student student = Student.builder()   //获取建造者
            .id(1)    //逐步配置各个参数
            .age(18)
            .grade(3)
            .name("小明")
            .awards("ICPC-ACM 区域赛 金牌", "LPL 2022春季赛 冠军")
            .build();   //最后直接建造我们想要的对象
}
```

可以看到这个学生类的属性是非常多的，所以构造方法不是一般的长，如果我们现在直接通过new的方式去创建，光是填参数就麻烦，我们还得一个一个对应着去填，一不小心可能就把参数填到错误的位置了。

**具体实现方法**

```java
public class Student {
    private final int id;
    private final String name;
    private final int age;
    private final int grade;
    private final List<String> awards;

    // 私有构造函数，只能通过建造者创建
    private Student(Builder builder) {
        this.id = builder.id;
        this.name = builder.name;
        this.age = builder.age;
        this.grade = builder.grade;
        this.awards = builder.awards;
    }

    // 静态方法获取建造者
    public static Builder builder() {
        return new Builder();
    }

    // 建造者内部类
    public static class Builder {
        private int id;
        private String name;
        private int age;
        private int grade;
        private List<String> awards = new ArrayList<>();

        // 私有构造方法
        private Builder() {}

        public Builder id(int id) {
            this.id = id;
            return this;
        }

        public Builder name(String name) {
            this.name = name;
            return this;
        }

        public Builder age(int age) {
            this.age = age;
            return this;
        }

        public Builder grade(int grade) {
            this.grade = grade;
            return this;
        }

        public Builder awards(String... awards) {
            this.awards.addAll(Arrays.asList(awards));
            return this;
        }

        // 构建Student对象
        public Student build() {
            // 这里可以添加参数校验逻辑
            if (name == null || name.isEmpty()) {
                throw new IllegalArgumentException("姓名不能为空");
            }
            if (age <= 0) {
                throw new IllegalArgumentException("年龄必须大于0");
            }
            return new Student(this);
        }
    }

    // getter方法
    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    public int getGrade() {
        return grade;
    }

    public List<String> getAwards() {
        return Collections.unmodifiableList(awards);
    }

    @Override
    public String toString() {
        return "Student{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", age=" + age +
                ", grade=" + grade +
                ", awards=" + awards +
                '}';
    }
```

### 原型模式

它通过**复制现有对象（原型）来创建新对象**，而不是通过`new`关键字实例化。这种模式特别适用于创建成本较高的对象，或者需要动态配置的对象。

在Java中，原型模式通常通过**实现`Cloneable`接口并重写`Object.clone()`**方法来实现。

```java
        Prototype original = new Prototype("原始值");
        Prototype copy = original.clone(); // 克隆之后的值
```

#### 深浅拷贝问题

1. **浅拷贝**：

   浅拷贝是指创建一个新对象，然后将原对象的非静态字段复制到新对象中。**对于基本数据类型，直接复制值；对于引用类型，只复制引用地址，而不复制引用的对象本身**。

   **实现方法**：默认的`clone()`方法就是浅拷贝

2. **深拷贝**：

   深拷贝是指创建一个新对象，然后递归地复制原对象及其引用的所有对象。对于引用类型字段，会创建新的对象并复制内容到新的内存里，而不仅仅是复制引用。

   1. 可以**通过序列化/反序列化**实现
   2. 重写`clone()`方法，**递归调用引用对象**的clone方法

## 结构模型

### 类/对象适配器模式

就好比如电源适配器，将常规的220V电压转为5V

## 行为模型

### 责任链模式

它允许你将请求沿着处理链传递，直到有一个处理者能够处理该请求为止。**有三个角色**：

1. **Handler（抽象处理者）**：定义处理请求的接口，通常包含一个处理请求的方法和一个设置下一个处理者的方法。
2. **ConcreteHandler（具体处理者）**：实现抽象处理者的具体类，处理它负责的请求，如果不能处理则传递给下一个处理者。
3. **Client（客户端）**：创建处理链并向链上的第一个处理者提交请求。

```java
import java.util.*;

// 抽象处理者类，定义了责任链的基本结构
abstract class TaskHandler {
    private TaskHandler nextHandler; // 指向下一个处理者的引用
    
    // 设置责任链中的下一个处理者
    public void setNextHandler(TaskHandler nextHandler) {
        this.nextHandler = nextHandler;
    }
    
    // 处理任务的方法
    public void handleTask(Task task) {
        if (canHandle(task)) {
            // 如果当前处理者可以处理任务，就处理
            process(task);
        } else if (nextHandler != null) {
            // 否则，将任务传递给链中的下一个处理者
            nextHandler.handleTask(task);
        } else {
            // 如果没有处理者可以处理此任务，输出提示
            System.out.println("No handler available for task: " + task.getName());
        }
    }
    
    // 判断当前处理者是否能处理任务（由子类实现）
    protected abstract boolean canHandle(Task task);
    
    // 处理任务（由子类实现）
    protected abstract void process(Task task);
}

// 任务类，包含任务的基本信息
class Task {
    private String name; // 任务名称
    private String type; // 任务类型
    
    public Task(String name, String type) {
        this.name = name;
        this.type = type;
    }
    
    public String getName() { return name; }
    public String getType() { return type; }
}

// 具体处理者1 - 处理数据相关任务
class DataProcessingHandler extends TaskHandler {
    @Override
    protected boolean canHandle(Task task) {
        // 任务类型为 "data" 时由此处理
        return "data".equalsIgnoreCase(task.getType());
    }
    
    @Override
    protected void process(Task task) {
        System.out.println("Processing data task: " + task.getName());
        // 这里写具体的数据处理逻辑
    }
}

// 具体处理者2 - 处理文件相关任务
class FileProcessingHandler extends TaskHandler {
    @Override
    protected boolean canHandle(Task task) {
        // 任务类型为 "file" 时由此处理
        return "file".equalsIgnoreCase(task.getType());
    }
    
    @Override
    protected void process(Task task) {
        System.out.println("Processing file task: " + task.getName());
        // 具体文件处理逻辑
    }
}

// 具体处理者3 - 处理网络请求任务
class NetworkRequestHandler extends TaskHandler {
    @Override
    protected boolean canHandle(Task task) {
        // 任务类型为 "network" 时由此处理
        return "network".equalsIgnoreCase(task.getType());
    }
    
    @Override
    protected void process(Task task) {
        System.out.println("Processing network request: " + task.getName());
        // 具体网络请求处理逻辑
    }
}

// 客户端程序入口
public class ChainOfResponsibilityDemo {
    public static void main(String[] args) {
        // 创建各个处理者实例
        TaskHandler dataHandler = new DataProcessingHandler(); // 数据任务处理者
        TaskHandler fileHandler = new FileProcessingHandler(); // 文件任务处理者
        TaskHandler networkHandler = new NetworkRequestHandler(); // 网络请求处理者
        
        // 设置责任链顺序：数据处理 -> 文件处理 -> 网络请求处理
        dataHandler.setNextHandler(fileHandler);
        fileHandler.setNextHandler(networkHandler);
        
        // 创建一组任务
        List<Task> tasks = Arrays.asList(
            new Task("Import user data", "data"),        // 数据任务
            new Task("Upload backup file", "file"),      // 文件任务
            new Task("Fetch API data", "network"),       // 网络请求任务
            new Task("Generate report", "report")        // 无对应处理者的任务
        );
        
        // 依次处理每个任务，通过责任链
        tasks.forEach(dataHandler::handleTask);
    }
}
```

应用场景：

1. **缓冲处理与过滤**：在请求到达最终处理器之前，可以进行过滤、验证、修改等。
2. **请求的分级处理**：有多个处理层次（如权限验证、日志记录、业务处理），请求按照层级逐级传递，直至被处理或拒绝。
3. **解耦发送者和接收者：**发送者只关心将请求传递到责任链的开始，不需要知道链中具体哪个环节会处理它。责任链中的每个对象负责判断自己是否能处理请求，不能则将请求传递给下一个对象。

### 策略模式

**特别适合优化程序中的复杂条件分支语句（if-else）。**

在策略模式中，有三个角色：上下文、策略接口和具体策略。

- **策略接口**：定义所有支持算法的公共接口。
- **具体策略**：实现策略接口的类，提供具体的算法实现。
- **上下文**：使用策略的类。通常包含一个引用指向策略接口，可以在运行时改变其具体策略。

**就比如线程池里拒绝策略**

- **AbortPolicy**：抛出`RejectedExecutionException`，阻止任务提交（默认行为）。
- **CallerRunsPolicy**：让调用者线程自己执行任务，减缓提交速度。即由提交任务的线程自己执行该任务。
- **DiscardPolicy**：直接丢弃任务，不做任何处理。
- **DiscardOldestPolicy**：当队列已满，新的任务到来时，会丢弃队列中**最旧的任务**（不是新的任务），然后将新任务加入队列。

**缺点：**

- 客户端必须知道所有的策略类，并自行决定使用哪个策略类。
- 策略模式将会造成很多策略类。

## 模板方法

它定义了算法的骨架，将某些步骤推迟到子类中实现。这种模式允许子类在不改变算法结构的情况下重新定义算法的某些特定步骤。

```java
// 抽象类，定义算法的模板结构
abstract class AbstractClass {
    
    // 模板方法，定义整个算法的骨架，不能被子类重写
    public final void templateMethod() {
        step1();    // 执行第1步（已实现）
        step2();    // 执行第2步（由子类实现）
        step3();    // 执行第3步（钩子方法，子类可覆盖）
    }
    
    // 具体方法，提供模板方法调用的公共实现，不允许被子类重写
    private void step1() {
        System.out.println("AbstractClass: 执行步骤1");
    }
    
    // 抽象方法，必须由具体子类提供实现
    protected abstract void step2();
    
    // 钩子方法，子类可覆盖以提供扩展行为；也有默认实现
    protected void step3() {
        System.out.println("AbstractClass: 执行默认步骤3");
    }
}

// 具体实现类A，重写了所有需要自定义的步骤
class ConcreteClassA extends AbstractClass {
    @Override
    protected void step2() {
        System.out.println("ConcreteClassA: 实现步骤2");
    }
    
    @Override
    protected void step3() {
        System.out.println("ConcreteClassA: 覆盖步骤3");
    }
}

// 具体实现类B，只实现了抽象方法step2()，使用默认的step3()
class ConcreteClassB extends AbstractClass {
    @Override
    protected void step2() {
        System.out.println("ConcreteClassB: 实现步骤2");
    }
    // 不覆盖step3()，采用父类的默认实现
}

// 测试类，演示模板方法的使用
public class TemplateMethodDemo {
    public static void main(String[] args) {
        // 创建具体类A的实例
        AbstractClass classA = new ConcreteClassA();
        // 调用模板方法，执行一系列定义好的步骤
        classA.templateMethod();
        
        System.out.println("----------");
        
        // 创建具体类B的实例
        AbstractClass classB = new ConcreteClassB();
        // 执行模板方法，注意这里只是不同的实现效果
        classB.templateMethod();
    }
}
```

#### 特点

1. **模板方法通常是final的**：定义整个方法步骤，在模板方法里一次性执行，不能被子类重写。



