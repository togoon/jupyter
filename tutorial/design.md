
# 设计模式实现

设计模式(Design pattern)是一套被反复使用, 多数人知晓的, 经过分类编目的, 代码设计经验的总结. 使用设计模式是为了可重用代码, 让代码更容易被他人理解, 保证代码可靠性.  毫无疑问, 设计模式于己于他人于系统都是多赢的, 设计模式使代码编制真正工程化, 设计模式是软件工程的基石, 如同大厦的一块块砖石一样. 项目中合理的运用设计模式可以完美的解决很多问题, 每种模式在现在中都有相应的原理来与之对应, 每一个模式描述了一个在我们周围不断重复发生的问题, 以及该问题的核心解决方案, 这也是它能被广泛应用的原因. 简单说:
模式:在某些场景下, 针对某类问题的某种通用的解决方案. 
场景:项目所在的环境
问题:约束条件, 项目目标等
解决方案:通用, 可复用的设计, 解决约束达到目标. 

## 设计模式分类
创建型模式:对象实例化的模式, 创建型模式用于解耦对象的实例化过程. 
结构型模式:把类或对象结合在一起形成一个更大的结构. 
行为型模式:类和对象如何交互, 及划分责任和算法. 


## 创建型模式
简单工厂(Simple Factory):一个工厂类根据传入的参量决定创建出那一种产品类的实例. 
工厂方法模式(Factory Method):定义一个创建对象的接口, 让子类决定实例化那个类. 
抽象工厂模式(Abstract Factory):创建相关或依赖对象的家族, 而无需明确指定具体类. 
生成器模式(Builder 建造者)
原型模式(Prototype):通过复制现有的实例来创建新的实例. 
单例模式(Singleton):某个类只能有一个实例, 提供一个全局的访问点. 

## 结构型模式
适配器模式(Adapter):将一个类的方法接口转换成客户希望的另外一个接口. 
桥接模式(Bridge):将抽象部分和它的实现部分分离, 使它们都可以独立的变化. 
组合模式(Composite):将对象组合成树形结构以表示""部分-整体""的层次结构. 
装饰模式(Decorator):动态的给对象添加新的功能. 
外观模式(Facade):对外提供一个统一的方法, 来访问子系统中的一群接口. 
享元模式(Flyweight 蝇量):通过共享技术来有效的支持大量细粒度的对象. 
代理模式(Proxy):为其他对象提供一个代理以便控制这个对象的访问. 
建造者模式:封装一个复杂对象的构建过程, 并可以按步骤构造. 

## 行为型模式
责任链模式(Chain of Responsibility):将请求的发送者和接收者解耦, 使的多个对象都有处理这个请求的机会. 
命令模式(Command):将命令请求封装为一个对象, 使得可以用不同的请求来进行参数化. 
迭代器模式(Iterator):一种遍历访问聚合对象中各个元素的方法, 不暴露该对象的内部结构. 
中介者模式(Mediator):用一个中介对象来封装一系列的对象交互. 
备忘录模式(Memento):在不破坏封装的前提下, 保持对象的内部状态. 
观察者模式(Observer):对象间的一对多的依赖关系. 
状态模式(State):允许一个对象在其对象内部状态改变时改变它的行为. 
策略模式(Strategy):定义一系列算法, 把他们封装起来, 并且使它们可以相互替换. 
模板方法模式(Template Method):定义一个算法结构, 而将一些步骤延迟到子类实现. 
访问者模式(Vistor):在不改变数据结构的前提下, 增加作用于一组对象元素的新功能. 
解释器模式:给定一个语言, 定义它的文法的一种表示, 并定义一个解释器. 



# 软件设计原则与SOLID原则

## 优秀设计的特征

1. 代码复用
代码复用是减少开发成本时最常用的方式之一. 其意图非常明显:与其反复从头开发, 不如在新对象中重用已有代码. 
2. 扩展性
变化是程序员生命中唯一不变的事情.  因此在设计程序架构时, 所有有经验的开发者会尽量选择支持未来任何可能变更的方式. 

## 设计原则

1. 封装变化的内容
找到程序中的变化内容并将其与不变的内容区分开, 该原则的主要目的是将变更造成的影响最小化. 
封装包括:
方法层面的封装:将复杂的逻辑抽取到一个单独的方法中, 并对原始方法隐藏该逻辑. 
类层面的封装:将一些相关联的变量和方法抽取到一个新类中会让程序更加清晰和简洁. 
2. 面向接口开发, 而不是面向实现
面向接口进行开发, 而不是面向实现;依赖于抽象类型, 而不是具体类. 
如果无需修改已有代码就能轻松对类进行扩展, 那就可以说这样的设计是灵活的. 
让我们再来看一个关于猫的例子, 看看这个说法是否正确:一只可以吃任何食物的猫(Cat)要比只吃香肠的猫更加灵活. 无论如何你都可给第一只猫喂香肠, 因为香肠是"任何食物"的一个子集;当然, 你也可以喂这只猫任何食物. 
确定一个对象对另一对象的确切需求:它需执行哪些方法?
在一个新的接口或抽象类中描述这些方法. 
让被依赖的类实现该接口. 
现在让有需求的类依赖于这个接口,  而不依赖于具体的类. 你仍可与原始类中的对象进行互动, 但现在其连接将会灵活得多. 
从下图可以看出, 右侧(面向接口开发)的代码比左侧(面向实现开发)的代码更加灵活, 但也更加复杂. 
3. 组合优于继承
继承可能是类之间最明显, 最简便的代码复用方式. 如果你有两个代码相同的类,  就可以为它们创建一个通用的基类, 然后将相似的代码移动到其中. 
不过, 继承这件事通常只有在程序中已包含大量类, 且修改任何东西都非常困难时才会引起关注. 下面就是此类问题的清单:
子类不能减少超类的接口. 你必须实现父类中所有的抽象方法, 即使它们没什么用. 
在重写方法时, 你需要确保新行为与其基类中的版本兼容. 这一点很重要, 因为子类的所有对象都可能被传递给以超类对象为参数的任何代码, 相信你不会希望这些代码崩溃的. 
继承打破了超类的封装, 因为子类拥有访问父类内部详细内容的权限. 此外还可能会有相反的情况出现, 那就是程序员为了进一步扩展的方便而让超类知晓子类的内部详细内容. 
子类与超类紧密耦合. 超类中的任何修改都可能会破坏子类的功能. 
通过继承复用代码可能导致平行继承体系的产生. 继承通常仅发生在一个维度中. 只要出现了两个以上的维度, 你就必须创建数量巨大的类组合, 从而使类层次结构膨胀到不可思议的程度. 
组合是代替继承的一种方法. 继承代表类之间的"是"关系(汽车是交通工具), 而组合则代表"有"关系(汽车有一个引擎). 
必须一提的是, 这个原则也能应用于聚合(一种更松弛的组合变体, 一个对象可引用另一个对象, 但并不管理其生命周期). 例如:一辆汽车上有司机, 但是司机也可能会使用另一辆汽车, 或者选择步行而不使用汽车. 
3.1 继承
继承在多个维度上扩展一个类(汽车类型 × 引擎类型 × 驾驶类型), 可能导致子类组合的数量爆炸. 
3.2 组合
组合将不同"维度"的功能抽取到各自的类层次结构中. 

## SOLID原则

1. 单一职责原则(Single Responsibility Principle)
修改一个类的原因只能有一个. 
尽量让每个类只负责软件中的一个功能, 并将该功能完全封装(你也可称之为隐藏)在该类中. 
这条原则的主要目的是减少复杂度. 你不需要费尽心机地去构思如何仅用 200 行代码来实现复杂设计, 实际上完全可以使用十几个清晰的方法. 
当程序规模不断扩大, 变更不断增加后, 真实问题才会逐渐显现出来. 到了某个时候, 类会变得过于庞大, 以至于你无法记住其细节. 查找代码将变得非常缓慢, 你必须浏览整个类, 甚至整个程序才能找到需要的东西. 程序中实体的数量会让你的大脑堆栈过载, 你会感觉自己对代码失去了控制. 
还有一点:如果类负责的东西太多, 那么当其中任何一件事发生改变时, 你都必须对类进行修改. 而在进行修改时, 你就有可能改动类中自己并不希望改动的部分. 
如果你开始感觉在同时关注程序特定方面的内容时有些困难的话, 请回忆单一职责原则并考虑现在是否应将某些类分割为几个部分. 
我们有几个理由来对 雇员 Employee 类进行修改. 第一个理由与该类的主要工作(管理雇员数据)有关. 但还有另一个理由:时间表报告的格式可能会随着时间而改变, 从而使你需要对类中的代码进行修改. 
解决该问题的方法是将与打印时间表报告相关的行为移动到一个单独的类中. 这个改变让你能将其他与报告相关的内容移动到一个新的类中

2. 开闭原则(Open/closed Principle)
对于扩展, 类应该是"开放"的;对于修改, 类则应是"封闭"的. 
本原则的主要理念是在实现新功能时能保持已有代码不变. 如果你可以对一个类进行扩展, 可以创建它的子类并对其做任何事情(如新增方法或成员变量, 重写基类行为等), 那么它就是开放的. 有些编程语言允许你通过特殊关键字(例 如 final )来限制对于类的进一步扩展,  这样类就不再是"开放"的了. 如果某个类已做好了充分的准备并可供其他类使用的话(即其接口已明确定义且以后不会修改), 那么该类就是封闭(你可以称之为完整)的. 
如果一个类已经完成开发, 测试和审核工作, 而且属于某个框架或者可被其他类的代码直接使用的话, 对其代码进行修改就是有风险的. 你可以创建一个子类并重写原始类的部分内容以完成不同的行为, 而不是直接对原始类的代码进行修改. 这样你既可以达成自己的目标, 但同时又无需修改已有的原始类客户端. 
这条原则并不能应用于所有对类进行的修改中. 如果你发现类中存在缺陷, 直接对其进行修复即可, 不要为它创建子类. 子类不应该对其父类的问题负责. 
你的电子商务程序中包含一个计算运输费用的订单(Order)类, 该类中所有运输方法都以硬编码的方式实现. 如果你需要添加一个新的运输方式, 那就必须承担对 订单 类造成破坏的可能风险来对其进行修改. 
你可以通过应用策略模式来解决这个问题. 首先将运输方法抽取到拥有同样接口的不同类中. 

3. 里氏替换原则(Liskov Substitution Principle)
当你扩展一个类时,  记住你应该要能在不修改客户端代码的情况下将子类的对象作为父类对象进行传递. 
这意味着子类必须保持与父类行为的兼容. 在重写一个方法时, 你要对基类行为进行扩展, 而不是将其完全替换. 
替换原则是用于预测子类是否与代码兼容, 以及是否能与其超类对象协作的一组检查. 这一概念在开发程序库和框架时非常重要, 因为其中的类将会在他人的代码中使用——你是无法直接访问和修改这些代码的. 
与有着多种解释方式的其他设计模式不同, 替代原则包含一组对子类(特别是其方法)的形式要求. 让我们来仔细看看这些要求. 
子类方法的参数类型必须与其超类的参数类型相匹配或更加抽象.  
假设某个类有个方法用于给猫咪喂食: feed(Cat c) . 客户端代码总是会将"猫(cat)"对象传递给该方法. 
好的方式:假如你创建了一个子类并重写了前面的方法, 使其能够给任何"动物(animal, 即'猫'的超类)"喂 食: feed(Animal c) . 如果现在你将一个子类对象而非超类对象传递给客户端代码, 程序仍将正常工作. 该方法可用于给任何动物喂食, 因此它仍然可以用于给传递给客户端的任何"猫"喂食. 
不好的方式: 你创建了另一个子类且限制喂食方法仅接 受 "孟 加 拉 猫 (BengalCat,  一 个 '猫' 的 子 类)": feed(BengalCat c) . 如果你用它来替代链接在某个对象中的原始类, 客户端中会发生什么呢?由于该方法只能对特殊种类的猫进行喂食, 因此无法为传递给客户端的普通猫提供服务, 从而将破坏所有相关的功能. 
子类方法的返回值类型必须与超类方法的返回值类型或是其子类别相匹配.  
假如你的一个类中有一个方法 buyCat(): Cat .  客户端代码执行该方法后的预期返回结果是任意类型的"猫". 
好的方式:子类将该方法重写为: buyCat(): BengalCat . 客户端将获得一只"孟加拉猫", 自然它也是一只"猫", 因此一切正常. 
不好的方式: 子类将该方法重写为: buyCat(): Animal . 现在客户端代码将会出错, 因为它获得的是自己未知的动物种类(短吻鳄?熊?), 不适用于为一只"猫"而设计的结构. 
子类中的方法不应抛出基础方法预期之外的异常类型.  
换句话说, 异常类型必须与基础方法能抛出的异常或是其子类别相匹配. 这条规则源于一个事实:客户端代码的 try-catch代码块针对的是基础方法可能抛出的异常类型. 因此, 预期之外的异常可能会穿透客户端的防御代码, 从而使整个应用崩溃. 
对于绝大部分现代编程语言,  特别是静态类型的编程语言(Java 和 C# 等等), 这些规则已内置于其中. 如果违反了这些规则, 你将无法对程序进行编译. 
子类不应该加强其前置条件.  
例如, 基类的方法有一个 int类型的参数. 如果子类重写该方法时, 要求传递给该方法的参数值必须为正数(如果该值为负则抛出异常), 这就是加强了前置条件. 客户端代码之前将负数传递给该方法时程序能够正常运行, 但现在使用子类的对象时会使程序出错. 
子类不能削弱其后置条件.  
假如你的某个类中有个方法需要使用数据库, 该方法应该在接收到返回值后关闭所有活跃的数据库连接. 
你创建了一个子类并对其进行了修改, 使得数据库保持连接以便重用. 但客户端可能对你的意图一无所知. 由于它认为该方法会关闭所有的连接, 因此可能会在调用该方法后就马上关闭程序, 使得无用的数据库连接对系统造成"污染". 
超类的不变量必须保留.  
这很可能是所有规则中最不"形式"的一条. 不变量是让对象有意义的条件. 例如, 猫的不变量是有四条腿, 一条尾巴和能够喵喵叫等. 不变量让人疑惑的地方在于它们既可通过接口契约或方法内的一组断言来明确定义, 又可暗含在特定的单元测试和客户代码预期中. 
不变量的规则是最容易违反的, 因为你可能会误解或没有意识到一个复杂类中的所有不变量. 因此, 扩展一个类的最安全做法是引入新的成员变量和方法, 而不要去招惹超类中已有的成员. 当然在实际中, 这并非总是可行. 
子类不能修改超类中私有成员变量的值.  
什么?这难道可能吗?原来有些编程语言允许通过反射机制来访问类的私有成员. 还有一些语言(Python 和 JavaScript)没有对私有成员进行任何保护. 

4. 接口隔离原则(Interface Segregation Principle)
客户端不应被强迫依赖于其不使用的方法. 
尽量缩小接口的范围, 使得客户端的类不必实现其不需要的行为. 
根据接口隔离原则, 你必须将"臃肿"的方法拆分为多个颗粒度更小的具体方法. 客户端必须仅实现其实际需要的方法. 否则, 对于"臃肿"接口的修改可能会导致程序出错, 即使客户端根本没有使用修改后的方法. 
继承只允许类拥有一个超类, 但是它并不限制类可同时实现的接口的数量. 因此, 你不需要将大量无关的类塞进单个接口. 你可将其拆分为更精细的接口, 如有需要可在单个类中实现所有接口, 某些类也可只实现其中的一个接口. 
假如你创建了一个程序库, 它能让程序方便地与多种云计算供应商进行整合. 尽管最初版本仅支持阿里云服务, 但它也覆盖了一套完整的云服务和功能. 
假设所有云服务供应商都与阿里云一样提供相同种类的功能. 但当你着手为其他供应商提供支持时, 程序库中绝大部分的接口会显得过于宽泛. 其他云服务供应商没有提供部分方法所描述的功能. 
尽管你仍然可以去实现这些方法并放入一些桩代码, 但这绝不是优良的解决方案. 更好的方法是将接口拆分为多个部分. 能够实现原始接口的类现在只需改为实现多个精细的接口即可. 其他类则可仅实现对自己有意义的接口. 
与其他原则一样, 你可能会过度使用这条原则. 不要进一步划分已经非常具体的接口. 记住, 创建的接口越多, 代码就越复杂. 因此要保持平衡. 

5. 依赖倒置原则(Dependency Inversion Principle)
高层次的类不应该依赖于低层次的类.  两者都应该依赖于抽象接口. 抽象接口不应依赖于具体实现. 具体实现应该依赖于抽象接口. 
通常在设计软件时, 你可以辨别出不同层次的类. 
低层次的类实现基础操作(例如磁盘操作, 传输网络数据和连接数据库等). 
高层次类包含复杂业务逻辑以指导低层次类执行特定操作. 
有时人们会先设计低层次的类,  然后才会开发高层次的类. 当你在新系统上开发原型产品时, 这种情况很常见. 由于低层次的东西还没有实现或不确定, 你甚至无法确定高层次类能实现哪些功能. 如果采用这种方式, 业务逻辑类可能会更依赖于低层原语类. 
依赖倒置原则建议改变这种依赖方式. 
作为初学者,  你最好使用业务术语来对高层次类依赖的低层次操作接口进行描述.  例如,  业务逻辑应该调用 名 为 openReport(file) 的 方 法,  而 不 是 openFile(x) , readBytes(n) 和 closeFile(x) 等一系列方法.  这些接口被视为是高层次的. 
现在你可基于这些接口创建高层次类, 而不是基于低层次的具体类. 这要比原始的依赖关系灵活很多. 
一旦低层次的类实现了这些接口, 它们将依赖于业务逻辑层, 从而倒置了原始的依赖关系. 
依赖倒置原则通常和开闭原则共同发挥作用:你无需修改已有类就能用不同的业务逻辑类扩展低层次的类. 
在本例中, 高层次的预算报告类(BudgetReport)使用低层次的数据库类(MySQLDatabase)来读取和保存其数据. 这意味着低层次类中的任何改变(例如当数据库服务器发布新版本时)都可能会影响到高层次的类, 但高层次的类不应关注数据存储的细节. 
要解决这个问题, 你可以创建一个描述读写操作的高层接口, 并让报告类使用该接口代替低层次的类. 然后你可以修改或扩展低层次的原始类来实现业务逻辑声明的读写接口. 
其结果是原始的依赖关系被倒置:现在低层次的类依赖于高层次的抽象. 

## 面向对象机制
封装, 隐藏内部实现
继承, 复用现有代码
多态, 改写对象行为

## 重构方法
静态 -> 动态
早绑定 -> 晚绑定
继承 -> 组合
编译时依赖 -> 运行时依赖
紧耦合 -> 松耦合

## 面向对象设计原则
依赖倒置原则(DIP Dependence Inversion Principle) (编译时依赖)
高层模块(稳定)不应该依赖于低层模块(变化), 二者都应该依赖于抽象(稳定) . 
抽象(稳定)不应该依赖于实现细节(变化) , 实现细节应该依赖于抽象(稳定). 
开放封闭原则(OCP Open Close Principle)
对扩展开放, 对更改封闭.  尽可能不要动源代码
类模块应该是可扩展的, 但是不可修改. 
单一职责原则(SRP Single Responsibility Principle)
一个类应该仅有一个引起它变化的原因. 
变化的方向隐含着类的责任. 
Liskov 替换原则(LSP Liskov Substitution Principle)
子类必须能够替换它们的基类(IS-A). 
继承表达类型抽象. 
接口隔离原则(ISP Interface Segregation Principle)
不应该强迫客户程序依赖它们不用的方法. 
接口应该小而完备. 
优先使用对象组合, 而不是类继承 (CRP Composite Reuse Principle)
类继承通常为"白箱复用", 对象组合通常为"黑箱复用". 
继承在某种程度上破坏了封装性, 子类父类耦合度高.  • 而对象组合则只要求被组合的对象具有良好定义的接口, 耦合度低. 
封装变化点
使用封装来创建对象之间的分界层, 让设计者可以在分界层的 一侧进行修改, 而不会对另一侧产生不良的影响, 从而实现层次间的松耦合. 
针对接口编程, 而不是针对实现编程
不将变量类型声明为某个特定的具体类, 而是声明为某个接口. 
客户程序无需获知对象的具体类型, 只需要知道对象所具有的接口. 
减少系统中各部分的依赖关系, 从而实现"高内聚, 松耦合" 的类型设计方案. 

# 创建型模式

## 1. 工厂方法模式(Factory Method)

在工厂模式中, 我们在创建对象时不会对客户端暴露创建逻辑, 并且是通过使用一个共同的接口来指向新创建的对象. 工厂模式作为一种创建模式, 一般在创建复杂对象时, 考虑使用;在创建简单对象时, 建议直接new完成一个实例对象的创建. 

1.1, 简单工厂模式
主要特点是需要在工厂类中做判断, 从而创造相应的产品, 当增加新产品时, 需要修改工厂类. 使用简单工厂模式, 我们只需要知道具体的产品型号就可以创建一个产品. 
缺点:工厂类集中了所有产品类的创建逻辑, 如果产品量较大, 会使得工厂类变的非常臃肿. 

```c++
/*
关键代码:创建过程在工厂类中完成. 
*/
​
#include <iostream>
​
using namespace std;
​
//定义产品类型信息
typedef enum
{
    Tank_Type_56,
    Tank_Type_96,
    Tank_Type_Num
}Tank_Type;
​
//抽象产品类
class Tank
{
public:
    virtual const string& type() = 0;
};
​
//具体的产品类
class Tank56 : public Tank
{
public:
    Tank56():Tank(),m_strType("Tank56")
    {
    }
​
    const string& type() override
    {
        cout << m_strType.data() << endl;
        return m_strType;
    }
private:
    string m_strType;
};
​
//具体的产品类
class Tank96 : public Tank
{
public:
    Tank96():Tank(),m_strType("Tank96")
    {
    }
    const string& type() override
    {
        cout << m_strType.data() << endl;
        return m_strType;
    }
​
private:
    string m_strType;
};
​
//工厂类
class TankFactory
{
public:
    //根据产品信息创建具体的产品类实例, 返回一个抽象产品类
    Tank* createTank(Tank_Type type)
    {
        switch(type)
        {
        case Tank_Type_56:
            return new Tank56();
        case Tank_Type_96:
            return new Tank96();
        default:
            return nullptr;
        }
    }
};
​
​
int main()
{
    TankFactory* factory = new TankFactory();
    Tank* tank56 = factory->createTank(Tank_Type_56);
    tank56->type();
    Tank* tank96 = factory->createTank(Tank_Type_96);
    tank96->type();
​
    delete tank96;
    tank96 = nullptr;
    delete tank56;
    tank56 = nullptr;
    delete factory;
    factory = nullptr;
​
    return 0;
}
```




Creator.h:

```c++
#ifndef  CREATOR_H_
#define  CREATOR_H_
​
#include <memory>
#include "Product.h"
​
// 抽象工厂类 生产电影
class Factory {
 public:
    virtual std::shared_ptr<Movie> get_movie() = 0;
};
​
#endif  // CREATOR_H_
```

ConcreteCreator.h:

```c++
#ifndef CONCRETE_CREATOR_H_
#define CONCRETE_CREATOR_H_
​
#include <memory>
#include "Creator.h"
#include "ConcreteProduct.h"
​
// 具体工厂类 中国生产者
class ChineseProducer : public Factory {
 public:
    std::shared_ptr<Movie> get_movie() override { return std::make_shared<ChineseMovie>(); }
};
// 具体工厂类 日本生产者
class JapaneseProducer : public Factory {
 public:
    std::shared_ptr<Movie> get_movie() override { return std::make_shared<JapaneseMovie>(); }
};
// 具体工厂类 美国生产者
class AmericanProducer : public Factory {
 public:
    std::shared_ptr<Movie> get_movie() override { return std::make_shared<AmericanMovie>(); }
};
​
#endif  // CONCRETE_CREATOR_H_
```

Product.h:

```c++
#ifndef  PRODUCT_H_
#define  PRODUCT_H_
​
#include <string>
​
// 抽象产品类 电影
class Movie {
 public:
    virtual std::string get_a_movie() = 0;
};
​
#endif  // PRODUCT_H_
ConcreteProduct.h:
#ifndef  CONCRETE_PRODUCT_H_
#define  CONCRETE_PRODUCT_H_
​
#include <iostream>
#include <string>
#include "Product.h"
​
// 具体产品类 电影::国产电影
class ChineseMovie : public Movie {
 public:
    std::string get_a_movie() override {
        return "<让子弹飞>";
    }
};
​
// 具体产品类 电影::日本电影
class JapaneseMovie : public Movie {
 public:
    std::string get_a_movie() override {
        return "<千与千寻>";
    }
};
​
// 具体产品类 电影::美国电影
class AmericanMovie : public Movie {
 public:
    std::string get_a_movie() override {
        return "<钢铁侠>";
    }
};
​
#endif  // CONCRETE_PRODUCT_H_
```

main.cpp:

```c++
#include "ConcreteCreator.h"
​
int main() {
    std::shared_ptr<Factory> factory;
    std::shared_ptr<Movie> product;
​
    // 这里假设从配置中读到的是Chinese(运行时决定的)
    std::string conf = "China";
​
    // 程序根据当前配置或环境选择创建者的类型
    if (conf == "China") {
        factory = std::make_shared<ChineseProducer>();
    } else if (conf == "Japan") {
        factory = std::make_shared<JapaneseProducer>();
    } else if (conf == "America") {
        factory = std::make_shared<AmericanProducer>();
    } else {
        std::cout << "error conf" << std::endl;
    }
​
    product = factory->get_movie();
    std::cout << "获取一部电影: " << product->get_a_movie() << std::endl;
}
```

编译运行:
$g++ -g main.cpp -o factorymethod -std=c++11
$./factorymethod 
获取一部电影: <让子弹飞>

## 2. 抽象工厂模式(Abstract Factory)

AbstractFactory.h:

```c++
#ifndef  ABSTRACT_FACTORY_H_
#define  ABSTRACT_FACTORY_H_
​
#include <memory>
#include "AbstractProduct.h"
​
// 抽象工厂类 生产电影和书籍类等
class Factory {
 public:
    virtual std::shared_ptr<Movie> productMovie() = 0;
    virtual std::shared_ptr<Book> productBook() = 0;
};
​
#endif  // ABSTRACT_FACTORY_H_
ConcreteFactory.h:
#ifndef CONCRETE_FACTORY_H_
#define CONCRETE_FACTORY_H_
​
#include <memory>
#include "AbstractFactory.h"
#include "ConcreteProduct.h"
​
// 具体工厂类 中国生产者
class ChineseProducer : public Factory {
 public:
    std::shared_ptr<Movie> productMovie() override {
        return std::make_shared<ChineseMovie>();
    }
​
    std::shared_ptr<Book> productBook() override {
        return std::make_shared<ChineseBook>();
    }
};
​
// 具体工厂类 日本生产者
class JapaneseProducer : public Factory {
 public:
    std::shared_ptr<Movie> productMovie() override {
        return std::make_shared<JapaneseMovie>();
    }
​
    std::shared_ptr<Book> productBook() override {
        return std::make_shared<JapaneseBook>();
    }
};
​
#endif  // CONCRETE_FACTORY_H_
```

AbstractProduct.h:

```c++
#ifndef  ABSTRACT_PRODUCT_H_
#define  ABSTRACT_PRODUCT_H_
​
#include <string>
​
// 抽象产品类 电影
class Movie {
 public:
    virtual std::string showMovieName() = 0;
};
​
// 抽象产品类 书籍
class Book {
 public:
    virtual std::string showBookName() = 0;
};
​
#endif  // ABSTRACT_PRODUCT_H_
```

ConcreteProduct.h:

```c++
#ifndef  CONCRETE_PRODUCT_H_
#define  CONCRETE_PRODUCT_H_
​
#include <iostream>
#include <string>
#include "AbstractProduct.h"
​
// 具体产品类 电影::国产电影
class ChineseMovie : public Movie {
    std::string showMovieName() override {
        return "<让子弹飞>";
    }
};
​
// 具体产品类 电影::日本电影
class JapaneseMovie : public Movie {
    std::string showMovieName() override {
        return "<千与千寻>";
    }
};
​
// 具体产品类 书籍::国产书籍
class ChineseBook : public Book {
    std::string showBookName() override {
        return "<三国演义>";
    }
};
​
// 具体产品类 书籍::日本书籍
class JapaneseBook : public Book {
    std::string showBookName() override {
        return "<白夜行>";
    }
};
​
#endif  // CONCRETE_PRODUCT_H_
```

main.cpp:

```c++
#include <iostream>
#include "AbstractFactory.h"
#include "ConcreteFactory.h"
​
​
int main() {
    std::shared_ptr<Factory> factory;
​
    // 这里假设从配置中读到的是Chinese(运行时决定的)
    std::string conf = "China";
​
    // 程序根据当前配置或环境选择创建者的类型
    if (conf == "China") {
        factory = std::make_shared<ChineseProducer>();
    } else if (conf == "Japan") {
        factory = std::make_shared<JapaneseProducer>();
    } else {
        std::cout << "error conf" << std::endl;
    }
​
    std::shared_ptr<Movie> movie;
    std::shared_ptr<Book> book;
    movie = factory->productMovie();
    book = factory->productBook();
    std::cout << "获取一部电影: " << movie->showMovieName() << std::endl;
    std::cout << "获取一本书: " << book->showBookName() << std::endl;
}
```

编译运行:
$g++ -g main.cpp -o abstractfactory -std=c++11
$./abstractfactory 
获取一部电影: <让子弹飞>
获取一本书: <三国演义>


##  3. 生成器模式(Builder)

Product.h:

```c++
#ifndef  PRODUCT_H_
#define  PRODUCT_H_
​
#include <string>
#include <iostream>
​
// 产品类 车
class Car {
 public:
    Car() {}
    void set_car_tire(std::string t) {
        tire_ = t;
        std::cout << "set tire: " << tire_ << std::endl;
    }
    void set_car_steering_wheel(std::string sw) {
        steering_wheel_ = sw;
        std::cout << "set steering wheel: " << steering_wheel_ << std::endl;
    }
    void set_car_engine(std::string e) {
        engine_ = e;
        std::cout << "set engine: " << engine_ << std::endl;
    }
​
 private:
    std::string tire_;            // 轮胎
    std::string steering_wheel_;  // 方向盘
    std::string engine_;          // 发动机
​
};
​
#endif  // PRODUCT_H_
```

Builder.h:

```c++
#ifndef  BUILDER_H_
#define  BUILDER_H_
​
#include "Product.h"
​
// 抽象建造者
class CarBuilder {
 public:
    Car getCar() {
        return car_;
    }
​
    // 抽象方法
    virtual void buildTire() = 0;
    virtual void buildSteeringWheel() = 0;
    virtual void buildEngine() = 0;
​
 protected:
    Car car_;
};
​
#endif  // BUILDER_H_
```

ConcreteBuilder.h:

```c++
#ifndef CONCRETE_BUILDER_H_
#define CONCRETE_BUILDER_H_
​
#include "Builder.h"
​
// 具体建造者 奔驰
class BenzBuilder : public CarBuilder {
 public:
    // 具体实现方法
    void buildTire() override {
        car_.set_car_tire("benz_tire");
    }
    void buildSteeringWheel() override {
        car_.set_car_steering_wheel("benz_steering_wheel");
    }
    void buildEngine() override {
        car_.set_car_engine("benz_engine");
    }
};
​
// 具体建造者 奥迪
class AudiBuilder : public CarBuilder {
 public:
    // 具体实现方法
    void buildTire() override {
        car_.set_car_tire("audi_tire");
    }
    void buildSteeringWheel() override {
        car_.set_car_steering_wheel("audi_steering_wheel");
    }
    void buildEngine() override {
        car_.set_car_engine("audi_engine");
    }
};
​
#endif  // CONCRETE_BUILDER_H_
```

Director.h:

```c++
#ifndef  DIRECTOR_H_
#define  DIRECTOR_H_
​
#include "Builder.h"
​
class Director {
 public:
    Director() : builder_(nullptr) {}
​
    void set_builder(CarBuilder *cb) {
        builder_ = cb;
    }
​
    // 组装汽车
    Car ConstructCar() {
        builder_->buildTire();
        builder_->buildSteeringWheel();
        builder_->buildEngine();
        return builder_->getCar();
    }
​
 private:
    CarBuilder* builder_;
};
​
#endif  // DIRECTOR_H_
```

main.cpp:

```c++
#include "Director.h"
#include "ConcreteBuilder.h"
​
int main() {
    // 抽象建造者(一般是动态确定的)
    CarBuilder* builder;
    // 指挥者
    Director* director = new Director();
    // 产品
    Car car;
​
    // 建造奔驰
    std::cout << "==========construct benz car==========" << std::endl;
    builder = new BenzBuilder();
    director->set_builder(builder);
    car = director->ConstructCar();
    delete builder;
​
    // 建造奥迪
    std::cout << "==========construct audi car==========" << std::endl;
    builder = new AudiBuilder();
    director->set_builder(builder);
    car = director->ConstructCar();
    delete builder;
​
    std::cout << "==========done==========" << std::endl;
    delete director;
}
```

编译运行:
$g++ -g main.cpp -o builder -std=c++11
$./builder 
==========construct benz car==========
set tire: benz_tire
set steering wheel: benz_steering_wheel
set engine: benz_engine
==========construct audi car==========
set tire: audi_tire
set steering wheel: audi_steering_wheel
set engine: audi_engine
==========done==========

##  4. 原型模式(Prototype)

Prototype.h:

```c++
#ifndef PROTOTYPE_H_
#define PROTOTYPE_H_
​
// 抽象原型类
class Object {
 public:
    virtual Object* clone() = 0;
};
​
#endif  // PROTOTYPE_H_
ConcretePrototype.h:
#ifndef CONCRETE_PROTOTYPE_H_
#define CONCRETE_PROTOTYPE_H_
​
#include <iostream>
#include <string>
#include "Prototype.h"
​
​
// 邮件的附件
class Attachment {
 public:
    void set_content(std::string content) {
        content_ = content;
    }
    std::string get_content() {
        return content_;
    }
​
 private:
    std::string content_;
};
​
// 具体原型: 邮件类
class Email : public Object {
 public:
    Email() {}
    Email(std::string text, std::string attachment_content) : text_(text), attachment_(new Attachment()) {
        attachment_->set_content(attachment_content);
    }
    ~Email() {
        if (attachment_ != nullptr) {
            delete attachment_;
            attachment_ = nullptr;
        }
    }
​
    void display() {
        std::cout << "------------查看邮件------------" << std::endl;
        std::cout << "正文: " << text_ << std::endl;
        std::cout << "邮件: " << attachment_->get_content() << std::endl;
        std::cout << "------------查看完毕------------" << std::endl;
    }
​
    // 深拷贝
    Email* clone() override {
        return new Email(this->text_, this->attachment_->get_content());
    }
​
    void changeText(std::string new_text) {
        text_ = new_text;
    }
​
    void changeAttachment(std::string content) {
        attachment_->set_content(content);
    }
​
 private:
    std::string text_;
    Attachment *attachment_ = nullptr;
};
​
#endif  // CONCRETE_PROTOTYPE_H_
```

main.cpp:

```c++
#include "ConcretePrototype.h"
​
#include <cstdio>
​
int main() {
    Email* email = new Email("最初的文案", "最初的附件");
    Email* copy_email = email->clone();
    copy_email->changeText("新文案");
    copy_email->changeAttachment("新附件");
    std::cout << "original email:" << std::endl;
    email->display();
    std::cout << "copy email:" << std::endl;
    copy_email->display();
​
    delete email;
    delete copy_email;
}
```

编译运行:
$g++ -g main.cpp -o prototype -std=c++11
$./prototype 
original email:
------------查看邮件------------
正文: 最初的文案
邮件: 最初的附件
------------查看完毕------------
copy email:
------------查看邮件------------
正文: 新文案
邮件: 新附件
------------查看完毕------------

## 5. 单例模式(Singleton)

5.1 线程不安全的懒汉单例模式
注意懒汉模式在不加锁情况下是线程不安全的. 

Singleton.h:

构造函数私有:即单例模式只能在内部私有化
实例对象static:保证全局只有一个
外界通过GetInstance()获取实例对象

```c++
#ifndef SINGLETON_H_
#define SINGLETON_H_
​
#include <iostream>
#include <string>
​
class Singleton {
 public:
    static Singleton* GetInstance() {
        if (instance_ == nullptr) {
            instance_ = new Singleton();
        }
        return instance_;
    }
 private:
    Singleton() {}
    static Singleton* instance_;
};
​
#endif  // SINGLETON_H_
```

Singleton.cpp:

```c++
#include "Singleton.h"
​
// 静态变量instance初始化不要放在头文件中, 如果多个文件包含singleton.h会出现重复定义问题
Singleton* Singleton::instance_ = nullptr;
main.cpp:
#include <iostream>
#include "Singleton.h"
​
int main() {
    Singleton *s1 = Singleton::GetInstance();
    Singleton *s2 = Singleton::GetInstance();
​
    std::cout << "s1地址: " << s1 << std::endl;
    std::cout << "s2地址: " << s2 << std::endl;
    return 0;
}
```

编译运行:
$g++ -g main.cpp Singleton.cpp -std=c++11 -o singleton
$./singleton 
s1地址: 0x95a040
s2地址: 0x95a040

5.2 线程安全的懒汉单例模式

上述代码并不是线程安全的, 当多个线程同时调用Singleton::GetInstance(), 可能会创建多个实例从而导致内存泄漏(会new多次但我们只能管理唯一的一个instance_), 我们这里简单通过互斥锁实现线程安全. 

Singleton.h:

```c++
#ifndef SINGLETON_H_
#define SINGLETON_H_
​
#include <iostream>
#include <string>
#include <mutex>
​
class Singleton {
public:
    static Singleton* GetInstance() {
        if (instance_ == nullptr) {
            // 加锁保证多个线程并发调用getInstance()时只会创建一个实例
            m_mutex_.lock();
            if (instance_ == nullptr) {
                instance_ = new Singleton();
            }
            m_mutex_.unlock();
        }
        return instance_;
    }
private:
    Singleton() {}
    static Singleton* instance_;
    static std::mutex m_mutex_;
};
​
#endif  // SINGLETON_H_
```

Singleton.cpp:

```c++
#include "Singleton.h"
​
// 静态变量instance初始化不要放在头文件中, 如果多个文件包含singleton.h会出现重复定义问题
Singleton* Singleton::instance_ = nullptr;
std::mutex Singleton::m_mutex_;
main.cpp:
#include <iostream>
#include "Singleton.h"
​
int main() {
    Singleton *s1 = Singleton::GetInstance();
    Singleton *s2 = Singleton::GetInstance();
​
    std::cout << "s1地址: " << s1 << std::endl;
    std::cout << "s2地址: " << s2 << std::endl;
    return 0;
}

5.3 饿汉单例模式代码

Singleton.h:
#ifndef SINGLETON_H_
#define SINGLETON_H_
​
class Singleton {
 public:
    static Singleton* GetInstance() {
        return instance_;
    }
​
 private:
    Singleton() {}
    static Singleton* instance_;
};
​
#endif  // SINGLETON_H_
Singleton.cpp:
#include "Singleton.h"
​
Singleton* Singleton::instance_ = new Singleton();
main.cpp:
#include <iostream>
#include "Singleton.h"
​
int main() {
    Singleton *s1 = Singleton::GetInstance();
    Singleton *s2 = Singleton::GetInstance();
​
    std::cout << "s1地址: " << s1 << std::endl;
    std::cout << "s2地址: " << s2 << std::endl;
    return 0;
}

编译运行:
$g++ -g main.cpp Singleton.cpp -std=c++11 -o singleton
$./singleton 
s1地址: 0x18a8040
s2地址: 0x18a8040
5.4 Meyers' Singleton
Meyers' Singleton是Scott Meyers提出的C++单例的推荐写法. 它将单例对象作为局部static对象定义在函数内部:
#ifndef SINGLETON_H_
#define SINGLETON_H_
​
class Singleton {
 public:
    static Singleton& GetInstance() {
        static Singleton instance;
        return instance;
    }
    Singleton(const Singleton&) = delete;
    Singleton& operator=(const Singleton&) = delete;
​
 private:
    Singleton() {}
};
​
#endif  // SINGLETON_H_
优点:
解决了普通单例模式全局变量初始化依赖(C++只能保证在同一个文件中声明的static遍历初始化顺序和其遍历声明的顺序一致, 但是不能保证不同文件中static遍历的初始化顺序)
缺点:
需要C++11支持(C++11保证static成员初始化的线程安全)
性能问题(同懒汉模式一样, 每次调用GetInstance()方法时需要判断局部static变量是否已经初始化, 如果没有初始化就会进行初始化, 这个判断逻辑会消耗一点性能)

# 结构型模式

## 1. 适配器模式(Adapter)

考虑经典的"方钉和圆孔"的问题, 我们要做的是让方钉适配圆孔. 
适配器让方钉假扮成一个圆钉(RoundPeg), 其半径等于方钉(SquarePeg)横截面对角线的一半(即能容纳方钉的最小外接圆的半径). 
ClientInterface.h:
#ifndef CLIENT_INTERFACE_H_
#define CLIENT_INTERFACE_H_
​
// 圆钉: 客户端接口, 在C++中定义成抽象基类
class RoundPeg {
 public:
    RoundPeg() {}
    virtual int get_radius() = 0;
};
​
#endif  // CLIENT_INTERFACE_H_
Adapter.h:
#ifndef ADAPTER_H_
#define ADAPTER_H_
​
#include <cmath>
#include "Service.h"
#include "ClientInterface.h"
​
// 方钉适配器: 该适配器能让客户端将方钉放入圆孔中
class SquarePegAdapter : public RoundPeg {
 public:
    explicit SquarePegAdapter(SquarePeg* sp) : square_peg_(sp) {}
    int get_radius() override {
        return square_peg_->get_width() * sqrt(2) / 2;
    }
​
 private:
    SquarePeg* square_peg_;
};
​
#endif  // ADAPTER_H_
Service.h:
#ifndef SERVICE_H_
#define SERVICE_H_
​
// 方钉: 适配者类, 即和客户端不兼容的类
class SquarePeg {
 public:
    explicit SquarePeg(int w) : width_(w) {}
    int get_width() {
        return width_;
    }
​
 private:
    int width_;
};
​
#endif  // SERVICE_H_
Client.h:
#ifndef CLIENT_H_
#define CLIENT_H_
​
#include "ClientInterface.h"
​
// 圆孔: 客户端类
class RoundHole {
 public:
    explicit RoundHole(int r) : radius_(r) {}
    int get_radius() {
        return radius_;
    }
    bool isFit(RoundPeg* rp) {
        return radius_ >= rp->get_radius();
    }
​
 private:
    int radius_;
};
​
#endif  // CLIENT_H_
main.cpp:
#include <iostream>
#include "Client.h"
#include "Adapter.h"
​
int main() {
    // 半径为10的圆孔
    RoundHole* hole = new RoundHole(10);
​
    // 半径分别为5和20的大小方钉 + 它们的适配器
    SquarePeg* samll_square_peg = new SquarePeg(5);
    SquarePeg* large_square_peg = new SquarePeg(20);
    SquarePegAdapter* small_square_peg_adapter = new SquarePegAdapter(samll_square_peg);
    SquarePegAdapter* large_square_peg_adapter = new SquarePegAdapter(large_square_peg);
​
    // hole->isFit(samll_square_peg);  // 编译报错
    // hole->isFit(large_square_peg);  // 编译报错
    if (hole->isFit(small_square_peg_adapter)) {
        std::cout << "small square peg fits the hole" << std::endl;
    } else {
        std::cout << "small square peg don't fit the hole" << std::endl;
    }
    if (hole->isFit(large_square_peg_adapter)) {
        std::cout << "large square peg fits the hole" << std::endl;
    } else {
        std::cout << "large square peg don't fit the hole" << std::endl;
    }
}

编译运行:
$g++ -g main.cpp -o adapter -std=c++11
$./adapter
small square peg fits the hole
large square peg don't fit the hole

## 2. 桥接模式(Bridge)

Abstraction.h:
#ifndef ABSTRACTION_H_
#define ABSTRACTION_H_
​
#include <string>
#include "Implementation.h"
​
// 抽象类: Pen
class Pen {
 public:
    virtual void draw(std::string name) = 0;
    void set_color(Color* color) {
        color_ = color;
    }
​
 protected:
    Color* color_;
};
​
#endif  // ABSTRACTION_H_
RefinedAbstraction.h:
#ifndef REFINED_ABSTRACTION_H_
#define REFINED_ABSTRACTION_H_
​
#include <string>
#include "Abstraction.h"
​
// 精确抽象类: BigPen
class BigPen : public Pen {
 public:
    void draw(std::string name) {
        std::string pen_type = "大号钢笔绘制";
        color_->bepaint(pen_type, name);
    }
};
​
// 精确抽象类: SmallPencil
class SmallPencil : public Pen {
 public:
    void draw(std::string name) {
        std::string pen_type = "小号铅笔绘制";
        color_->bepaint(pen_type, name);
    }
};
​
#endif  // REFINED_ABSTRACTION_H_
Implementation.h:
#ifndef IMPLEMENTATION_H_
#define IMPLEMENTATION_H_
​
#include <string>
#include <iostream>
​
// 实现类接口: 颜色
class Color {
 public:
    virtual void bepaint(std::string pen_type, std::string name) = 0;
};
​
#endif  // IMPLEMENTATION_H_
ConcreteImplementation.h:
#ifndef CONCRETE_IMPLEMENTATION_H_
#define CONCRETE_IMPLEMENTATION_H_
​
#include <string>
#include "Implementation.h"
​
// 具体实现类: Red
class Red : public Color {
 public:
    void bepaint(std::string pen_type, std::string name) override {
        std::cout << pen_type << "红色的" << name << "." << std::endl;
    }
};
​
// 具体实现类: Green
class Green : public Color {
 public:
    void bepaint(std::string pen_type, std::string name) override {
        std::cout << pen_type << "绿色的" << name << "." << std::endl;
    }
};
​
​
#endif  // CONCRETE_IMPLEMENTATION_H_
main.cpp:
#include "ConcreteImplementation.h"
#include "RefinedAbstraction.h"
​
int main() {
    // 客户端根据运行时参数获取对应的Color和Pen
    Color* color = new Red();
    Pen* pen = new SmallPencil();
​
    pen->set_color(color);
    pen->draw("太阳");
​
    delete color;
    delete pen;
}

编译运行:
$g++ -g main.cpp -o bridge -std=c++11
$./bridge 
小号铅笔绘制红色的太阳.

## 3. 组合模式(Composite)

本例我们将借助「组合模式」帮助你在图形编辑器中实现一系列的几何图形. 
组合图形(CompoundGraphic)是一个容器, 它可以由多个包括容器在内的子图形构成. 组合图形和简单图形拥有相同的方法. 但是组合图形自身并不完成具体工作, 而是将请求递归地传递给自己的子项目, 然后"汇总"结果. 
通过所有图形类所共有的接口, 客户端代码可以与所有图形互动. 因此, 客户端不知道与其交互的是简单图形还是组合图形. 客户端可以与非常复杂的对象结构进行交互, 而无需与组成该结构的实体类紧密耦合. 
Component.h:
#ifndef COMPONENT_H_
#define COMPONENT_H_
​
// 组件接口会声明组合中简单和复杂对象的通用操作, C++中实现成抽象基类. 
class Graphic {
 public:
    virtual void move2somewhere(int x, int y) = 0;
    virtual void draw() = 0;
};
​
#endif  // COMPONENT_H_
Leaf.h:
#ifndef LEAF_H_
#define LEAF_H_
​
#include <cstdio>
#include "Component.h"
​
// 叶节点类代表组合的中断对象. 叶节点对象中不能包含任何子对象. 
// 叶节点对象通常会完成实际的工作, 组合对象则仅会将工作委派给自己的子部件. 
​
// 点
class Dot : public Graphic {
 public:
    Dot(int x, int y) : x_(x), y_(y) {}
    void move2somewhere(int x, int y) override {
        x_ += x;
        y_ += y;
        return;
    }
    void draw() override {
        printf("在(%d,%d)处绘制点\n", x_, y_);
        return;
    }
​
 private:
    int x_;
    int y_;
};
​
// 圆
class Circle : public Graphic {
 public:
    explicit Circle(int r, int x, int y) : radius_(r), x_(x), y_(y) {}
    void move2somewhere(int x, int y) override {
        x_ += x;
        y_ += y;
        return;
    }
    void draw() override {
        printf("以(%d,%d)为圆心绘制半径为%d的圆\n", x_, y_, radius_);
    }
​
 private:
    // 半径与圆心坐标
    int radius_;
    int x_;
    int y_;
};
​
#endif  // LEAF_H_
Composite.h:
#ifndef COMPOSITE_H_
#define COMPOSITE_H_
​
#include <map>
#include "Component.h"
​
// 组合类表示可能包含子项目的复杂组件. 组合对象通常会将实际工作委派给子项目, 然后"汇总"结果. 
class CompoundGraphic : public Graphic {
 public:
    void add(int id, Graphic* child) {
        childred_[id] = (child);
    }
    void remove(int id) {
        childred_.erase(id);
    }
    void move2somewhere(int x, int y) override {
        for (auto iter = childred_.cbegin(); iter != childred_.cend(); iter++) {
            iter->second->move2somewhere(x, y);
        }
    }
    void draw() override {
        for (auto iter = childred_.cbegin(); iter != childred_.cend(); iter++) {
            iter->second->draw();
        }
    }
​
 private:
    // key是图表id, value是图表指针
    std::map<int, Graphic*> childred_;
};
​
#endif  // COMPOSITE_H_
main.cpp:
#include "Composite.h"
#include "Leaf.h"
​
int main() {
    // 组合图
    CompoundGraphic* all = new CompoundGraphic();
​
    // 添加子图
    Dot* dot1 = new Dot(1, 2);
    Circle *circle = new Circle(5, 2, 2);
    CompoundGraphic* child_graph = new CompoundGraphic();
    Dot* dot2 = new Dot(4, 7);
    Dot* dot3 = new Dot(3, 2);
    child_graph->add(0, dot2);
    child_graph->add(1, dot3);
​
    // 将所有图添加到组合图中
    all->add(0, dot1);
    all->add(1, circle);
    all->add(2, child_graph);
​
    // 绘制
    all->draw();
​
    delete all;
    delete dot1;
    delete dot2;
    delete dot3;
    delete circle;
    return 0;
}

编译运行:
$g++ -g main.cpp -o composite -std=c++11
$./composite 
在(1,2)处绘制点
以(2,2)为圆心绘制半径为5的圆
在(4,7)处绘制点
在(3,2)处绘制点

## 4. 装饰模式(Decorator)

正常情况下磁盘中的数据文件可以直接读取, 但是对于敏感数据需要进行压缩和加密. 我们需要实现两个装饰器, 它们都改变了从磁盘读写数据的方式
加密:对数据进行脱敏处理
压缩:对数据进行压缩处理
Component.h:
#ifndef COMPONENT_H_
#define COMPONENT_H_
​
#include <string>
​
// 部件: 是具体部件和装饰类的共同基类, 在C++中实现成抽象基类
class DataSource {
 public:
    virtual void writeData(std::string data) = 0;
};
​
#endif  // COMPONENT_H_
ConcreteComponent.h:
#ifndef CONCRETE_COMPONENT_H_
#define CONCRETE_COMPONENT_H_
​
#include <string>
#include <cstdio>
#include <iostream>
#include "Component.h"
​
// 具体组件提供操作的默认实现, 这些类在程序中可能会有几个变体
class FileDataSource : public DataSource {
 public:
    explicit FileDataSource(std::string file_name) : file_name_(file_name) {}
    void writeData(std::string data) override {
        printf("写入文件%s中: %s\n", file_name_.c_str(), data.c_str());
        return;
    }
​
 private:
    std::string file_name_;
};
​
#endif  // CONCRETE_COMPONENT_H_
BaseDecorator.h:
#ifndef BASE_DECORATOR_H_
#define BASE_DECORATOR_H_
​
#include <string>
#include "Component.h"
​
// 装饰基类和其他组件遵循相同的接口. 该类的主要任务是定义所有具体装饰的封装接口. 
// 封装的默认实现代码中可能会包含一个保存被封装组件的成员变量, 并且负责对其进行初始化. 
class DataSourceDecorator : public DataSource {
 public:
    explicit DataSourceDecorator(DataSource* ds) : data_source_(ds) {}
    void writeData(std::string data) override {
        data_source_->writeData(data);
    }
​
 protected:
    DataSource* data_source_;  // component
};
​
#endif  // BASE_DECORATOR_H_
ConcreteDecorator.h:
#ifndef CONCRETE_DECORATOR_H_
#define CONCRETE_DECORATOR_H_
​
#include <string>
#include "BaseDecorator.h"
​
// 加密装饰器
class EncryptionDecorator : public DataSourceDecorator {
 public:
    using DataSourceDecorator::DataSourceDecorator;
    void writeData(std::string data) override {
        // 1. 对传递数据进行加密(这里仅简单实现)
        data = "已加密(" + data + ")";
        // 2. 将加密后数据传递给被封装对象 writeData(写入数据)方法
        data_source_->writeData(data);
        return;
    }
};
​
// 压缩装饰器
class CompressionDecorator : public DataSourceDecorator {
 public:
    using DataSourceDecorator::DataSourceDecorator;
    void writeData(std::string data) override {
        // 1. 对传递数据进行压缩(这里仅简单实现)
        data = "已压缩(" + data + ")";
        // 2. 将压缩后数据传递给被封装对象 writeData(写入数据)方法
        data_source_->writeData(data);
        return;
    }
};
​
#endif  // CONCRETE_DECORATOR_H_
main.cpp:
#include "ConcreteComponent.h"
#include "ConcreteDecorator.h"
​
int main() {
    FileDataSource* source1 = new FileDataSource("stdout");
​
    // 将明码数据写入目标文件
    source1->writeData("tomocat");
​
    // 将压缩数据写入目标文件
    CompressionDecorator* source2 = new CompressionDecorator(source1);
    source2->writeData("tomocat");
​
    // 将压缩且加密数据写入目标文件
    EncryptionDecorator* source3 = new EncryptionDecorator(source2);
    source3->writeData("tomocat");
​
    delete source1;
    delete source2;
    delete source3;
}

编译运行:
$g++ -g main.cpp -o decorator -std=c++11
$./decorator 
写入文件stdout中: tomocat
写入文件stdout中: 已压缩(tomocat)
写入文件stdout中: 已压缩(已加密(tomocat))

## 5. 外观模式(Facade)

计算机本身是一个及其复杂的系统, 我们通过外观模式屏蔽电脑开机这一动作背后复杂子系统的运作. 
Facade.h:
#ifndef FACADE_H_
#define FACADE_H_
​
#include "SubSystem.h"
​
class ComputerOperator {
 public:
    ComputerOperator() {
        memory_ = new Memory();
        processor_ = new Processor();
        hard_disk_ = new HardDisk();
        os_ = new OS();
    }
    ~ComputerOperator() {
        delete memory_;
        delete processor_;
        delete hard_disk_;
        delete os_;
        memory_ = nullptr;
        processor_ = nullptr;
        hard_disk_ = nullptr;
        os_ = nullptr;
    }
​
    void powerOn() {
        std::cout << "正在开机..." << std::endl;
        memory_->selfCheck();
        processor_->run();
        hard_disk_->read();
        os_->load();
        std::cout << "开机成功!" << std::endl;
    }
​
 private:
    Memory* memory_;
    Processor* processor_;
    HardDisk* hard_disk_;
    OS* os_;
};
​
#endif  // FACADE_H_
SubSystem.h:
#ifndef SUB_SYSTEM_H_
#define SUB_SYSTEM_H_
​
#include<iostream>
​
// 内存
class Memory {
 public:
    Memory() {}
    void selfCheck() {
        std::cout << "内存自检中..." << std::endl;
        std::cout << "内存自检完成!" << std::endl;
    }
};
​
// 处理器
class Processor {
 public:
    Processor() {}
    void run() {
        std::cout << "启动CPU中..." << std::endl;
        std::cout << "启动CPU成功!" << std::endl;
    }
};
​
// 硬盘
class HardDisk {
 public:
    HardDisk() {}
    void read() {
        std::cout << "读取硬盘中..." << std::endl;
        std::cout << "读取硬盘成功!" << std::endl;
    }
};
​
// 操作系统
class OS {
 public:
    OS() {}
    void load() {
        std::cout << "载入操作系统中..." << std::endl;
        std::cout << "载入操作系统成功!" << std::endl;
    }
};
​
#endif  // SUB_SYSTEM_H_
main.cpp:
#include "Facade.h"
​
int main() {
    ComputerOperator* computer_operator = new ComputerOperator();
    computer_operator->powerOn();
    delete computer_operator;
}

编译运行:
$g++ -g main.cpp -std=c++11 -o facade
$./facade 
正在开机...
内存自检中...
内存自检完成!
启动CPU中...
启动CPU成功!
读取硬盘中...
读取硬盘成功!
载入操作系统中...
载入操作系统成功!
开机成功!

## 6. 享元模式(Flyweight)

在本例中, 享元模式能有效减少在画布上渲染数百万个树状对象时所需的内存. 
Flyweight.h:
#ifndef FLYWEIGHT_H_
#define FLYWEIGHT_H_
​
#include <string>
​
// 享元类包含了树类型的部分状态, 这些成员变量保存的数值对于特定树而言是唯一的. 
// 很多树木之间包含共同的名字, 颜色和纹理, 如果在每棵树中都存储这些数据就会浪费大量内存. 
// 因此我们将这些「内在状态」导出到一个单独的对象中, 然后让众多的单个树对象去引用它. 
class TreeType {
 public:
    TreeType(std::string n, std::string c, std::string t) :
        name_(n), color_(c), texture_(t) {}
    void draw(std::string canvas, double x, double y) {
        // 1. 创建特定类型, 颜色和纹理的位图
        // 2. 在画布坐标(x,y)处绘制位图
        return;
    }
​
 private:
    std::string name_;
    std::string color_;
    std::string texture_;
};
​
#endif  // FLYWEIGHT_H_
Context.h:
#ifndef CONTEXT_H_
#define CONTEXT_H_
​
#include <string>
#include "Flyweight.h"
​
// 情景对象包含树类型的「外在状态」, 程序中可以创建数十亿个此类对象, 因为它们体积很小: 仅有两个浮点坐标类型和一个引用成员变量
class Tree {
 public:
    Tree(double x, double y, TreeType* t) : x_(x), y_(y), type_(t) {}
    void draw(std::string canvas) {
        return type_->draw(canvas, x_, y_);
    }
​
 private:
    double x_;
    double y_;
    TreeType* type_;
};
​
#endif  // CONTEXT_H_
FlyweightFactory.h:
#ifndef FLYWEIGHT_FACTORY_H_
#define FLYWEIGHT_FACTORY_H_
​
#include <map>
#include <string>
#include <mutex>
#include "Flyweight.h"
​
// 享元工厂: 决定是否复用已有享元或者创建一个新的对象, 同时它也是一个单例模式
class TreeFactory {
 public:
    static TreeFactory* getInstance() {
        if (instance_ == nullptr) {
            mutex_.lock();
            if (instance_ == nullptr) {
                instance_ = new TreeFactory();
            }
            mutex_.unlock();
        }
        return instance_;
    }
    TreeType* getTreeType(std::string name, std::string color, std::string texture) {
        std::string key = name + "_" + color + "_" + texture;
        auto iter = tree_types_.find(key);
        if (iter == tree_types_.end()) {
            // 新的tree type
            TreeType* new_tree_type = new TreeType(name, color, texture);
            tree_types_[key] = new_tree_type;
            return new_tree_type;
        } else {
            // 已存在的tree type
            return iter->second;
        }
    }
​
 private:
    TreeFactory() {}
    static TreeFactory* instance_;
    static std::mutex mutex_;
​
    // 共享池, 其中key格式为name_color_texture
    std::map<std::string, TreeType*> tree_types_;
};
​
#endif  // FLYWEIGHT_FACTORY_H_
FlyweightFactory.cpp:
#include "FlyweightFactory.h"
​
TreeFactory* TreeFactory::instance_ = nullptr;
std::mutex TreeFactory::mutex_;
Client.h:
#ifndef CLIENT_H_
#define CLIENT_H_
​
#include <vector>
#include <iostream>
#include <string>
#include "FlyweightFactory.h"
#include "Context.h"
​
// Forest包含数量及其庞大的Tree
class Forest {
 public:
    void planTree(double x, double y, std::string name, std::string color, std::string texture) {
        TreeType* type = TreeFactory::getInstance()->getTreeType(name, color, texture);
        Tree tree = Tree(x, y, type);
        trees_.push_back(tree);
    }
    void draw() {
        for (auto tree : trees_) {
            tree.draw("canvas");
        }
    }
​
 private:
    std::vector<Tree> trees_;
};
​
#endif  // CLIENT_H_
main.cpp:
#include "Client.h"
​
int main() {
    Forest* forest = new Forest();
​
    // 在forest中种植很多棵树
    for (int i = 0; i < 500; i++) {
        for (int j = 0; j < 500; j++) {
            double x = i;
            double y = j;
            // 树类型1: 红色的杉树
            forest->planTree(x, y, "杉树", "红色", "");
            // 树类型2: 绿色的榕树
            forest->planTree(x, y, "榕树", "绿色", "");
            // 树类型3: 白色的桦树
            forest->planTree(x, y, "桦树", "白色", "");
        }
    }
​
    forest->draw();
​
    delete forest;
}

编译运行:
$g++ -g main.cpp FlyweightFactory.cpp -std=c++11 -o flyweight
$./flyweight 

## 7. 代理模式(Proxy)

本例演示如何使用代理模式在第三方视频程序库中添加延迟初始化和缓存. 
程序库提供了视频下载类. 但是该类的效率非常低. 如果客户端程序多次请求同一视频, 程序库会反复下载该视频, 而不会将首次下载的文件缓存下来复用. 
代理类实现和原下载器相同的接口, 并将所有工作委派给原下载器. 不过, 代理类会保存所有的文件下载记录, 如果程序多次请求同一文件, 它会返回缓存的文件. 
ServiceInterface.h:
#ifndef SERVICE_INTERFACE_H_
#define SERVICE_INTERFACE_H_
​
#include <string>
​
// 远程服务接口
class ThirdPartyTVLib {
 public:
    virtual std::string listVideos() = 0;
    virtual std::string getVideoInfo(int id) = 0;
};
​
#endif  // SERVICE_INTERFACE_H_
​
Service.h:
#ifndef SERVICE_H_
#define SERVICE_H_
​
#include <string>
#include "ServiceInterface.h"
​
// 视频下载类
// 该类的方法可以向远程视频后端服务请求信息, 请求速度取决于用户和服务器的网络状况
// 如果同时发送大量请求, 即使所请求的信息一模一样, 程序的速度依然会变慢
class ThirdPartyTVClass : public ThirdPartyTVLib {
 public:
    std::string listVideos() override {
        // 向远程视频后端服务发送一个API请求获取视频信息, 这里忽略实现
        return "video list";
    }
​
    std::string getVideoInfo(int id) override {
        // 向远程视频后端服务发送一个API请求获取某个视频的元数据, 这里忽略实现
        return "video info";
    }
};
​
#endif  //  SERVICE_H_
Proxy.h:
#ifndef PROXY_H_
#define PROXY_H_
​
#include <string>
#include "ServiceInterface.h"
​
// 为了节省网络带宽, 我们可以将请求缓存下来并保存一段时间
// 当代理类接受到真实请求后才会将其委派给服务对象
class CachedTVClass : public ThirdPartyTVLib {
 public:
    explicit CachedTVClass(ThirdPartyTVLib* service) : service_(service), need_reset_(false), list_cache_(""), video_cache_("") {}
    void reset() {
        need_reset_ = true;
    }
​
    std::string listVideos() override {
        if (list_cache_ == "" || need_reset_) {
            list_cache_ = service_->listVideos();
        }
        return list_cache_;
    }
​
    std::string getVideoInfo(int id) override {
        if (video_cache_ == "" || need_reset_) {
            video_cache_ = service_->getVideoInfo(id);
        }
        return video_cache_;
    }
​
 private:
    ThirdPartyTVLib* service_;
    std::string list_cache_;
    std::string video_cache_;
    bool need_reset_;
};
​
#endif  // PROXY_H_
Client.h:
#ifndef CLIENT_H_
#define CLIENT_H_
​
#include <string>
#include <cstdio>
#include "Service.h"
​
// 之前直接与服务对象交互的 GUI 类不需要改变, 前提是它仅通过接口与服务对象交互. 
// 我们可以安全地传递一个代理对象来代替真实服务对象, 因为它们都实现了相同的接口. 
class TVManager {
 public:
    explicit TVManager(ThirdPartyTVLib* s) : service_(s) {}
    void renderVideoPage(int id) {
        std::string video_info = service_->getVideoInfo(id);
        // 渲染视频页面, 这里忽略实现
        printf("渲染视频页面: %s\n", video_info.c_str());
        return;
    }
    void renderListPanel() {
        std::string videos = service_->listVideos();
        // 渲染视频缩略图列表, 这里忽略实现
        printf("渲染视频缩略图列表: %s\n", videos.c_str());
        return;
    }
​
 private:
    ThirdPartyTVLib* service_;
};
​
#endif  // CLIENT_H_
main.cpp:
#include "Client.h"
#include "Service.h"
#include "Proxy.h"
​
int main() {
    ThirdPartyTVClass* aTVService = new ThirdPartyTVClass();
    CachedTVClass* aTVProxy = new CachedTVClass(aTVService);
    TVManager* manager = new TVManager(aTVProxy);
​
    manager->renderVideoPage(1);
    manager->renderListPanel();
​
    delete aTVService;
    delete aTVProxy;
    delete manager;
}

编译运行:
$g++ -g main.cpp -std=c++11 -o proxy
$./proxy 
渲染视频页面: video info
渲染视频缩略图列表: video list

# 行为型模式

## 1. 责任链模式(Chain of Responsibility)

在本例中, 员工申请处理票据需要上报给上级, 如果上级无权处理就上报给更高的上级. 
Handler.h:
#ifndef HANDLER_H_
#define HANDLER_H_
​
// 抽象处理者, 在C++中是抽象基类
class ApproverInterface {
 public:
    // 添加上级
    virtual void setSuperior(ApproverInterface* superior) = 0;
    // 处理票据申请, 参数是票据面额
    virtual void handleRequest(double amount) = 0;
};
​
#endif  // HANDLER_H_
BaseHandler.h:
#ifndef BASE_HANDLER_H_
#define BASE_HANDLER_H_
​
#include <string>
#include "Handler.h"
​
class BaseApprover : public ApproverInterface {
 public:
    BaseApprover(double mpa, std::string n) : max_processible_amount_(mpa), name_(n), superior_(nullptr) {}
    // 设置上级
    void setSuperior(ApproverInterface* superior) {
        superior_ = superior;
    }
    // 处理票据
    void handleRequest(double amount) {
        // 可处理时直接处理即可
        if (amount <= max_processible_amount_) {
            printf("%s处理了该票据, 票据面额:%f\n", name_.c_str(), amount);
            return;
        }
        // 无法处理时移交给上级
        if (superior_ != nullptr) {
            printf("%s无权处理, 转交上级...\n", name_.c_str());
            superior_->handleRequest(amount);
            return;
        }
        // 最上级依然无法处理时报错
        printf("无人有权限处理该票据, 票据金额:%f\n", name_.c_str(), amount);
    }
​
 private:
    double max_processible_amount_;  // 可处理的最大面额
    std::string name_;
    ApproverInterface* superior_;
};
​
#endif  // BASE_HANDLER_H_
ConcreteHandler.h:
#ifndef CONCRETE_HANDLER_H_
#define CONCRETE_HANDLER_H_
​
#include <string>
#include <cstdio>
#include "BaseHandler.h"
​
// 具体处理者: 组长(仅处理面额<=10的票据)
class GroupLeader : public BaseApprover {
 public:
    explicit GroupLeader(std::string name) : BaseApprover(10, name) {}
};
​
// 具体处理者: 经理(仅处理面额<=100的票据)
class Manager : public BaseApprover {
 public:
    explicit Manager(std::string name) : BaseApprover(100, name) {}
};
​
​
// 具体处理者: 老板(仅处理面额<=1000的票据)
class Boss : public BaseApprover {
 public:
    explicit Boss(std::string name) : BaseApprover(1000, name) {}
};
​
​
​
#endif  // CONCRETE_HANDLER_H_
main.cpp:
#include "ConcreteHandler.h"
​
int main() {
    // 请求处理者: 组长, 经理和老板
    GroupLeader* group_leader = new GroupLeader("张组长");
    Manager* manager = new Manager("王经理");
    Boss* boss = new Boss("李老板");
​
    // 设置上级
    group_leader->setSuperior(manager);
    manager->setSuperior(boss);
​
    // 不同面额的票据统一先交给组长审批
    group_leader->handleRequest(8);
    group_leader->handleRequest(88);
    group_leader->handleRequest(888);
    group_leader->handleRequest(8888);
​
    delete group_leader;
    delete manager;
    delete boss;
​
    return 0;
}

编译运行:
$g++ main.cpp -std=c++11 -o chainofresponsibility
$./chainofresponsibility 
张组长处理了该票据, 票据面额:8.000000
张组长无权处理, 转交上级...
王经理处理了该票据, 票据面额:88.000000
张组长无权处理, 转交上级...
王经理无权处理, 转交上级...
李老板处理了该票据, 票据面额:888.000000
张组长无权处理, 转交上级...
王经理无权处理, 转交上级...
无人有权限处理该票据, 票据金额:8888.000000

## 2. 命令模式(Command)

本例中, 我们用遥控器(Controller)控制电视(TV). 
Invoker.h:
#ifndef INVOKER_H_
#define INVOKER_H_
​
#include <memory>
#include "Command.h"
​
// 触发者: 遥控器
class Controller{
 public:
    Controller() {}
    // 设置命令
    void setCommand(std::shared_ptr<Command> cmd) {
        cmd_ = cmd;
    }
    // 执行命令
    void executeCommand() {
        cmd_->execute();
    }
​
 private:
    std::shared_ptr<Command> cmd_;
};
​
#endif  // INVOKER_H_
Command.h:
#ifndef COMMAND_H_
#define COMMAND_H_
​
// 命令接口, C++中为抽象基类
class Command {
 public:
    virtual void execute() = 0;
};
​
#endif  // COMMAND_H_
ConcreteCommand.h:
#ifndef CONCRETE_COMMAND_H_
#define CONCRETE_COMMAND_H_
​
#include <memory>
#include "Command.h"
#include "Receiver.h"
​
// 具体命令类: 打开电视
class TVOpenCommand : public Command{
 public:
    explicit TVOpenCommand(std::shared_ptr<Television> tv) : tv_(tv) {}
​
    void execute() {
        tv_->open();
    }
​
 private:
    std::shared_ptr<Television> tv_;
};
​
// 具体命令类: 关闭电视
class TVCloseCommand : public Command{
 public:
    explicit TVCloseCommand(std::shared_ptr<Television> tv) : tv_(tv) {}
​
    void execute() {
        tv_->close();
    }
​
 private:
    std::shared_ptr<Television> tv_;
};
​
​
// 具体命令类: 切换频道
class TVChangeCommand : public Command{
 public:
    explicit TVChangeCommand(std::shared_ptr<Television> tv) : tv_(tv) {}
    void execute() {
        tv_->changeChannel();
    }
​
 private:
    std::shared_ptr<Television> tv_;
};
​
#endif  // CONCRETE_COMMAND_H_
Receiver.h:
#ifndef RECEIVER_H_
#define RECEIVER_H_
​
#include <iostream>
​
// 接受者: 电视
class Television{
 public:
    void open() {
        std::cout << "打开电视机!" << std::endl;
    }
​
    void close() {
        std::cout << "关闭电视机!" << std::endl;
    }
​
    void changeChannel(){
        std::cout << "切换电视频道!" << std::endl;
    }
};
​
#endif  // RECEIVER_H_
main.cpp:
#include "Invoker.h"
#include "ConcreteCommand.h"
​
int main() {
    // 接收者: 电视机
    std::shared_ptr<Television> tv = std::make_shared<Television>();
​
    // 命令
    std::shared_ptr<Command> openCommand = std::make_shared<TVOpenCommand>(tv);
    std::shared_ptr<Command> closeCommand = std::make_shared<TVCloseCommand>(tv);
    std::shared_ptr<Command> changeCommand = std::make_shared<TVChangeCommand>(tv);
​
    // 调用者: 遥控器
    std::shared_ptr<Controller> controller = std::make_shared<Controller>();
​
    // 测试
    controller->setCommand(openCommand);
    controller->executeCommand();
    controller->setCommand(closeCommand);
    controller->executeCommand();
    controller->setCommand(changeCommand);
    controller->executeCommand();
}

编译运行:
$g++ main.cpp -std=c++11 -o command
$./command 
打开电视机!
关闭电视机!
切换电视频道!

## 3. 迭代器模式(Iterator)

Iterator.h:
#ifndef ITERATOR_H_
#define ITERATOR_H_
​
#include <string>
​
// 抽象迭代器
class TVIterator{
 public:
    virtual void setChannel(int i) = 0;
    virtual void next() = 0;
    virtual void previous() = 0;
    virtual bool isLast() = 0;
    virtual std::string currentChannel() = 0;
    virtual bool isFirst() = 0;
};
​
#endif  // ITERATOR_H_
ConcreteIterator.h:
#ifndef CONCRETE_ITERATOR_H_
#define CONCRETE_ITERATOR_H_
​
#include <string>
#include <vector>
#include "Iterator.h"
​
// 具体迭代器
class SkyworthIterator : public TVIterator{
 public:
    explicit SkyworthIterator(std::vector<std::string> &tvs) : tvs_(tvs) {}
​
    void next() override {
        if (current_index_ < tvs_.size()) {
            current_index_++;
        }
    }
​
    void previous() override {
        if (current_index_ > 0) {
            current_index_--;
        }
    }
​
    void setChannel(int i) override {
        current_index_ = i;
    }
​
    std::string currentChannel() override {
        return tvs_[current_index_];
    }
​
    bool isLast() override {
        return current_index_ == tvs_.size();
    }
​
    bool isFirst() override {
        return current_index_ == 0;
    }
​
 private:
    std::vector<std::string> &tvs_;
    int current_index_ = 0;
};
​
#endif  // CONCRETE_ITERATOR_H_
Collection.h:
#ifndef COLLECTION_H_
#define COLLECTION_H_
​
#include <memory>
#include "Iterator.h"
​
// 抽象集合
class Television {
 public:
    virtual std::shared_ptr<TVIterator> createIterator() = 0;
};
​
#endif  // COLLECTION_H_
​
ConcreteCollection.h:
#ifndef CONCRETE_COLLECTION_H_
#define CONCRETE_COLLECTION_H_
​
#include <vector>
#include <string>
#include <memory>
#include "Collection.h"
#include "ConcreteIterator.h"
​
class SkyworthTelevision : public Television {
 public:
    std::shared_ptr<TVIterator> createIterator() {
        return std::make_shared<SkyworthIterator>(tvs_);
    }
​
    void addItem(std::string item) {
        tvs_.push_back(item);
    }
​
 private:
    std::vector<std::string> tvs_;
};
​
#endif  // CONCRETE_COLLECTION_H_
main.cpp:
#include <iostream>
#include "ConcreteCollection.h"
​
int main() {
    SkyworthTelevision stv;
    stv.addItem("CCTV-1");
    stv.addItem("CCTV-2");
    stv.addItem("CCTV-3");
    stv.addItem("CCTV-4");
    stv.addItem("CCTV-5");
​
    auto iter = stv.createIterator();
    while (!iter->isLast()) {
        std::cout << iter->currentChannel() << std::endl;
        iter->next();
    }
    return 0;
}
编译运行:
$g++ main.cpp -std=c++11 -o iterator
$./iterator 
CCTV-1
CCTV-2
CCTV-3
CCTV-4
CCTV-5

## 4. 中介者模式(Mediator)

Component.h:
#ifndef COMPONENT_H_
#define COMPONENT_H_
​
#include "Mediator.h"
#include <cstdio>
#include <string>
​
enum PERSON_TYPE {
    kUnknown,
    kLandlord,
    kTenant,
};
​
// 组件基类
class Colleague {
 public:
    void set_mediator(Mediator *m) {
        mediator_ = m;
    }
    Mediator* get_mediator() {
        return mediator_;
    }
    void set_personType(PERSON_TYPE pt) {
        person_type_ = pt;
    }
    PERSON_TYPE get_person_type() {
        return person_type_;
    }
    virtual void ask() = 0;
    virtual void answer() = 0;
 private:
    Mediator* mediator_;
    PERSON_TYPE person_type_;
};
​
// 具体组件1: 房东
class Landlord : public Colleague {
 public:
    Landlord() {
        name_ = "unknown";
        price_ = -1;
        address_ = "unknown";
        phone_number_ = "unknown";
        set_personType(kUnknown);
    }
​
    Landlord(std::string name, int price, std::string address, std::string phone_number) {
        name_ = name;
        price_ = price;
        address_ = address;
        phone_number_ = phone_number;
        set_personType(kLandlord);
    }
​
    void answer() override {
        printf("房东姓名:%s 房租:%d 地址:%s 电话:%s\n", name_.c_str(), price_, address_.c_str(), phone_number_.c_str());
    }
​
    void ask() override {
        printf("房东%s查看租客信息: \n", name_.c_str());
        this->get_mediator()->operation(this);
    }
​
 private:
    std::string name_;
    int price_;
    std::string address_;
    std::string phone_number_;
};
​
// 具体组件2: 租客
class Tenant : public Colleague {
 public:
    Tenant() {
        name_ = "unknown";
    }
    explicit Tenant(std::string name) {
        name_ = name;
        set_personType(kTenant);
    }
    void ask() {
        printf("租客%s询问房东信息:\n", name_.c_str());
        this->get_mediator()->operation(this);
    }
    void answer() {
        printf("租客姓名: %s\n", name_.c_str());
    }
​
 private:
    std::string name_;
};
​
#endif  // COMPONENT_H_
ConcreteMediator.h:
#ifndef CONCRETE_MEDIATOR_H_
#define CONCRETE_MEDIATOR_H_
​
#include <vector>
#include <string>
#include "Component.h"
#include "Mediator.h"
​
// 具体中介类: 房产中介
class Agency : public Mediator {
 public:
    void registerMethod(Colleague* person) override {
        switch (person->get_person_type()) {
            case kLandlord:
                landlord_list_.push_back(reinterpret_cast<Landlord*>(person));
                break;
            case kTenant:
                tenant_list_.push_back(reinterpret_cast<Tenant*>(person));
                break;
            default:
                printf("wrong person\n");
        }
    }
​
    void operation(Colleague* person) {
        switch (person->get_person_type()) {
            case kLandlord:
                for (int i = 0; i < tenant_list_.size(); i++) {
                    tenant_list_[i]->answer();
                }
                break;
            case kTenant:
                for (int i = 0; i < landlord_list_.size(); i++) {
                    landlord_list_[i]->answer();
                }
                break;
            default:
                break;
        }
    }
​
 private:
    std::vector<Landlord*> landlord_list_;
    std::vector<Tenant*> tenant_list_;
};
​
#endif  // CONCRETE_MEDIATOR_H_
​
Mediator.h:
#ifndef MEDIATOR_H_
#define MEDIATOR_H_
​
#include <string>
​
class Colleague;
​
// 抽象中介者
class Mediator {
 public:
    // 声明抽象方法
    virtual void registerMethod(Colleague*) = 0;
    // 声明抽象方法
    virtual void operation(Colleague*) = 0;
};
​
#endif  // MEDIATOR_H_
​
main.cpp:
#include <iostream>
#include "ConcreteMediator.h"
#include "Component.h"
​
int main() {
    // 房产中介
    Agency *mediator = new Agency();
​
    // 三位房东
    Landlord *l1 = new Landlord("张三", 1820, "天津", "1333");
    Landlord *l2 = new Landlord("李四", 2311, "北京", "1555");
    Landlord *l3 = new Landlord("王五", 3422, "河北", "1777");
    l1->set_mediator(mediator);
    l2->set_mediator(mediator);
    l3->set_mediator(mediator);
    mediator->registerMethod(l1);
    mediator->registerMethod(l2);
    mediator->registerMethod(l3);
​
    // 两位租客
    Tenant *t1 = new Tenant("Zhang");
    Tenant *t2 = new Tenant("Yang");
    t1->set_mediator(mediator);
    t2->set_mediator(mediator);
    mediator->registerMethod(t1);
    mediator->registerMethod(t2);
​
    // 业务逻辑
    t1->ask();
    std::cout << std::endl;
    l1->ask();
​
    delete mediator;
    delete l1;
    delete l2;
    delete l3;
    delete t1;
    delete t2;
}

编译运行:
$g++ -g main.cpp -o mediator -std=c++11
$./mediator 
租客Zhang询问房东信息:
房东姓名:张三 房租:1820 地址:天津 电话:1333
房东姓名:李四 房租:2311 地址:北京 电话:1555
房东姓名:王五 房租:3422 地址:河北 电话:1777
​
房东张三查看租客信息: 
租客姓名: Zhang
租客姓名: Yang

## 5. 备忘录模式(Memento)

Memento.h:
#ifndef MEMENTO_H_
#define MEMENTO_H_
​
#include <string>
​
// 备忘录类保存编辑器的过往状态
class Snapshot {
 public:
    Snapshot(std::string text, int x, int y, double width)
        : text_(text), cur_x_(x), cur_y_(y), selection_width_(width) {}
    std::string get_text() {
        return text_;
    }
    int get_cur_x() {
        return cur_x_;
    }
    int get_cur_y() {
        return cur_y_;
    }
    double get_selection_width() {
        return selection_width_;
    }
​
 private:
    const std::string text_;
    const int cur_x_;
    const int cur_y_;
    const double selection_width_;
};
​
#endif  // MEMENTO_H_
Originator.h:
#ifndef ORIGINATOR_H_
#define ORIGINATOR_H_
​
#include <cstdio>
#include <string>
#include <memory>
#include "Memento.h"
​
// 原发器中包含了一些可能会随时间变化的重要数据
// 它还定义了在备忘录中保存自身状态的方法, 以及从备忘录中恢复状态的方法
class Editor {
 public:
    void setText(std::string text) {
        text_ = text;
    }
    void setCursor(int x, int y) {
        cur_x_ = x;
        cur_y_ = y;
    }
    void setSelectionWidth(double width) {
        selection_width_ = width;
    }
​
    // 在备忘录中保存当前的状态
    std::shared_ptr<Snapshot> createSnapshot() {
        // 备忘录是不可变的对象, 因此原发器会将自身状态作为参数传递给备忘录的构造函数
        auto res = std::make_shared<Snapshot>(text_, cur_x_, cur_y_, selection_width_);
        printf("创建编辑器快照成功, text:%s x:%d y:%d width:%.2f\n", text_.c_str(), cur_x_, cur_y_, selection_width_);
        return res;
    }
​
    void resotre(std::shared_ptr<Snapshot> sptr_snapshot) {
        text_ = sptr_snapshot->get_text();
        cur_x_ = sptr_snapshot->get_cur_x();
        cur_y_ = sptr_snapshot->get_cur_y();
        selection_width_ = sptr_snapshot->get_selection_width();
        printf("恢复编辑器状态成功, text:%s x:%d y:%d width:%.2f\n", text_.c_str(), cur_x_, cur_y_, selection_width_);
    }
​
 private:
    // 文本
    std::string text_;
    // 光标位置
    int cur_x_;
    int cur_y_;
    // 当前滚动条位置
    double selection_width_;
};
​
#endif  // ORIGINATOR_H_
Caretaker.h:
#ifndef CARETAKER_H_
#define CARETAKER_H_
​
#include <memory>
#include "Memento.h"
#include "Originator.h"
​
class Command {
 public:
    explicit Command(Editor* e) : editor_(e) {}
    void makeBackup() {
        backup_ = editor_->createSnapshot();
    }
    void undo() {
        if (backup_) {
            editor_->resotre(backup_);
        }
    }
​
 private:
    Editor *editor_;
    std::shared_ptr<Snapshot> backup_;
};
​
#endif  // CARETAKER_H_
main.cpp:
#include "Caretaker.h"
​
int main() {
    // 创建原发器和负责人
    Editor editor;
    Command command(&editor);
​
    // 定义初始状态
    editor.setText("TOMOCAT");
    editor.setCursor(21, 34);
    editor.setSelectionWidth(3.4);
​
    // 保存状态
    command.makeBackup();
​
    // 更改编辑器状态
    editor.setText("KKKK");
    editor.setCursor(111, 222);
    editor.setSelectionWidth(111.222);
​
    // 撤销
    command.undo();
​
    return 0;
}

编译运行:
$g++ -g main.cpp -o memento -std=c++11
$./memento
创建编辑器快照成功, text:TOMOCAT x:21 y:34 width:3.40
恢复编辑器状态成功, text:TOMOCAT x:21 y:34 width:3.40

## 6. 观察者模式(Observer)

Publisher.h:
#ifndef PUBLISHER_H_
#define PUBLISHER_H_
​
#include <vector>
#include <iostream>
#include "Subscriber.h"
​
class Cat {
 public:
    // 注册观察者
    void attach(AbstractObserver* observer) {
        observers_.push_back(observer);
    }
​
    // 注销观察者
    void detach(AbstractObserver* observer) {
        for (auto it = observers_.begin(); it !=observers_.end(); it++) {
            if (*it == observer) {
                observers_.erase(it);
                break;
            }
        }
    }
​
    void cry() {
        std::cout << "猫叫!" << std::endl;
        for (auto ob : observers_) {
            ob->response();
        }
    }
​
 private:
    std::vector<AbstractObserver*> observers_;
};
​
#endif  // PUBLISHER_H_
Subscriber.h:
#ifndef SUBSCRIBER_H_
#define SUBSCRIBER_H_
​
class AbstractObserver {
 public:
    virtual void response() = 0;
};
​
#endif  // SUBSCRIBER_H_
ConcreteSubscriber.h:
#ifndef CONCRETE_SUBSCRIBER_H_
#define CONCRETE_SUBSCRIBER_H_
​
#include <iostream>
#include "Subscriber.h"
​
// 具体观察者1: 老鼠
class Mouse : public AbstractObserver {
 public:
    void response() override {
        std::cout << "老鼠逃跑" << std::endl;
    }
};
​
// 具体观察者2: 狗
class Dog : public AbstractObserver {
 public:
    void response() override {
        std::cout << "狗追猫" << std::endl;
    }
};
​
​
#endif  // CONCRETE_SUBSCRIBER_H_
main.cpp:
#include "Publisher.h"
#include "ConcreteSubscriber.h"
​
int main() {
    // 发布者
    Cat cat;
​
    // 观察者
    Mouse mouse;
    Dog dog;
​
    // 添加订阅关系
    cat.attach(&mouse);
    cat.attach(&dog);
​
    // 发布消息
    cat.cry();
    return 0;
}

编译运行:
$g++ -g main.cpp -o observer -std=c++11
$./observer
猫叫!
老鼠逃跑
狗追猫

## 7. 状态模式(State)

Context.h:
#ifndef CONTEXT_H_
#define CONTEXT_H_
​
#include <string>
#include <memory>
​
class AbstractState;
​
// 论坛账号
class ForumAccount {
 public:
    explicit ForumAccount(std::string name);
    void set_state(std::shared_ptr<AbstractState> state) {
        state_ = state;
    }
    std::shared_ptr<AbstractState> get_state() {
        return state_;
    }
    std::string get_name() {
        return name_;
    }
    void downloadFile(int score);
    void writeNote(int score);
    void replyNote(int score);
​
 private:
    std::shared_ptr<AbstractState> state_;
    std::string name_;
};
​
#endif  // CONTEXT_H_
Context.cpp:
#include "Context.h"
​
#include "ConcreteState.h"
#include <string>
​
ForumAccount::ForumAccount(std::string name)
    : name_(name), state_(std::make_shared<PrimaryState>(this)) {
    printf("账号%s注册成功!\n", name.c_str());
}
​
void ForumAccount::downloadFile(int score) {
    state_->downloadFile(score);
}
​
void ForumAccount::writeNote(int score) {
    state_->writeNote(score);
}
​
void ForumAccount::replyNote(int score) {
    state_->replyNote(score);
}
State.h:
#ifndef STATE_H_
#define STATE_H_
​
#include <string>
#include <cstdio>
#include "Context.h"
​
class AbstractState {
 public:
    virtual void checkState() = 0;
​
    void set_point(int point) {
        point_ = point;
    }
    int get_point() {
        return point_;
    }
    void set_state_name(std::string name) {
        state_name_ = name;
    }
    std::string get_state_name() {
        return state_name_;
    }
    ForumAccount* get_account() {
        return account_;
    }
​
    virtual void downloadFile(int score) {
        printf("%s下载文件, 扣除%d积分. \n", account_->get_name().c_str(), score);
        point_ -= score;
        checkState();
        printf("%s剩余积分为%d, 当前级别为%s. \n", account_->get_name().c_str(), point_, account_->get_state()->get_state_name().c_str());
    }
​
    virtual void writeNote(int score) {
        printf("%s发布留言, 增加%d积分. \n", account_->get_name().c_str(), score);
        point_ += score;
        checkState();
        printf("%s剩余积分为%d, 当前级别为%s. \n", account_->get_name().c_str(), point_, account_->get_state()->get_state_name().c_str());
    }
​
    virtual void replyNote(int score) {
        printf("%s回复留言, 增加%d积分. \n", account_->get_name().c_str(), score);
        point_ += score;
        checkState();
        printf("%s剩余积分为%d, 当前级别为%s. \n", account_->get_name().c_str(), point_, account_->get_state()->get_state_name().c_str());
    }
​
 protected:
    ForumAccount* account_;
    int point_;
    std::string state_name_;
};
​
#endif  // STATE_H_
ConcreteState.h:
#ifndef CONCRETE_STATE_H_
#define CONCRETE_STATE_H_
​
#include <cstdio>
#include "State.h"
​
// 具体状态类: 新手
class PrimaryState : public AbstractState {
 public:
    explicit PrimaryState(AbstractState* state) {
        account_ = state->get_account();
        point_ = state->get_point();
        state_name_ = "新手";
    }
    explicit PrimaryState(ForumAccount *account) {
        account_ = account;
        point_ = 0;
        state_name_ = "新手";
    }
    void downloadFile(int score) override {
        printf("对不起, %s没有下载文件的权限!\n", account_->get_name().c_str());
    }
    void checkState() override;
};
​
// 具体状态类: 高手
class MiddleState : public AbstractState {
 public:
    explicit MiddleState(AbstractState* state) {
        account_ = state->get_account();
        point_ = state->get_point();
        state_name_ = "高手";
    }
​
    void writeNote(int score) override {
        printf("%s发布留言, 增加%d积分. \n", account_->get_name().c_str(), score * 2);
        point_ += score * 2;
        checkState();
        printf("%s剩余积分为%d, 当前级别为%s. \n", account_->get_name().c_str(), point_, account_->get_state()->get_state_name().c_str());
    }
    void checkState() override;
};
​
// 具体状态类: 专家
class HighState : public AbstractState {
 public:
    explicit HighState(AbstractState* state) {
        account_ = state->get_account();
        point_ = state->get_point();
        state_name_ = "专家";
    }
​
    void writeNote(int score) override {
        printf("%s发布留言, 增加%d积分. \n", account_->get_name().c_str(), score * 2);
        point_ += score * 2;
        checkState();
        printf("%s剩余积分为%d, 当前级别为%s. \n", account_->get_name().c_str(), point_, account_->get_state()->get_state_name().c_str());
    }
​
    virtual void downloadFile(int score) {
        printf("%s下载文件, 扣除%d积分. \n", account_->get_name().c_str(), score / 2);
        point_ -= score / 2;
        checkState();
        printf("%s剩余积分为%d, 当前级别为%s. \n", account_->get_name().c_str(), point_, account_->get_state()->get_state_name().c_str());
    }
​
    void checkState() override;
};
​
#endif  // CONCRETE_STATE_H_
​
ConcreteState.cpp:
#include "ConcreteState.h"
​
#include <memory>
​
void PrimaryState::checkState() {
    if (point_ >= 1000) {
        account_->set_state(std::make_shared<HighState>(this));
    } else if (point_ >= 100) {
        account_->set_state(std::make_shared<MiddleState>(this));
    }
}
​
void MiddleState::checkState() {
    if (point_ >= 1000) {
        account_->set_state(std::make_shared<HighState>(this));
    } else if (point_ < 100) {
        account_->set_state(std::make_shared<PrimaryState>(this));
    }
}
​
void HighState::checkState() {
    if (point_ < 100) {
        account_->set_state(std::make_shared<PrimaryState>(this));
    } else if (point_ < 1000) {
        account_->set_state(std::make_shared<HighState>(this));
    }
}
main.cpp:
#include "Context.h"
​
int main() {
    // 注册新用户
    ForumAccount account("TOMOCAT");
    account.writeNote(20);
    account.downloadFile(20);
    account.replyNote(100);
    account.writeNote(40);
    account.downloadFile(80);
    account.writeNote(1000);
    account.downloadFile(80);
    return 0;
}

编译运行:
$g++ -g main.cpp Context.cpp ConcreteState.cpp -o state -std=c++11
$./state 
账号TOMOCAT注册成功!
TOMOCAT发布留言, 增加20积分. 
TOMOCAT剩余积分为20, 当前级别为新手. 
对不起, TOMOCAT没有下载文件的权限!
TOMOCAT回复留言, 增加100积分. 
TOMOCAT剩余积分为120, 当前级别为高手. 
TOMOCAT发布留言, 增加80积分. 
TOMOCAT剩余积分为200, 当前级别为高手. 
TOMOCAT下载文件, 扣除80积分. 
TOMOCAT剩余积分为120, 当前级别为高手. 
TOMOCAT发布留言, 增加2000积分. 
TOMOCAT剩余积分为2120, 当前级别为专家. 
TOMOCAT下载文件, 扣除40积分. 
TOMOCAT剩余积分为2080, 当前级别为专家. 

## 8. 策略模式(Strategy)

Strategy.h:
#ifndef STRATEGY_H_
#define STRATEGY_H_
​
#include <vector>
​
// 抽象策略类: 排序
class Sort {
 public:
    virtual void sortVector(std::vector<int> &arr) = 0;
};
​
#endif  // STRATEGY_H_
ConcreteStrategy.h:
#ifndef CONCRETE_STRATEGY_H_
#define CONCRETE_STRATEGY_H_
​
#include <vector>
#include <string>
#include <utility>
#include <iostream>
#include "Strategy.h"
​
// 打印vector内容
void printVector(const std::string prefix, const std::vector<int> &vi) {
    std::cout << prefix;
    for (auto i : vi) {
        std::cout << " " << i;
    }
    std::cout << std::endl;
}
​
// 具体策略类: 冒泡排序
class BubbleSort : public Sort {
 public:
    void sortVector(std::vector<int> &vi) override {
        printVector("冒泡排序前:", vi);
        int len = vi.size();
        // 轮次: 从1到n-1轮
        for (int i = 0; i < len - 1; ++i) {
            // 优化: 判断本轮是否有交换元素, 如果没交换则可直接退出
            bool is_exchange = false;
​
            for (int j = 0; j < len - i - 1; ++j) {
                if (vi[j] > vi[j+1]) {
                    std::swap(vi[j], vi[j+1]);
                    is_exchange = true;
                }
            }
​
            // 如果本轮无交换, 则可以直接退出
            if (!is_exchange) {
                printVector("冒泡排序后:", vi);
                return;
            }
        }
        printVector("冒泡排序后:", vi);
    }
};
​
// 具体策略类: 选择排序
class SelectionSort : public Sort {
 public:
    void sortVector(std::vector<int> &vi) override {
        printVector("选择排序前:", vi);
        // 需要进行 n-1 轮
        for (int i = 0; i < vi.size() - 1; ++i) {
            // 找到此轮的最小值下标
            int min_index = i;
            for (int j = i + 1; j < vi.size(); ++j) {
                if (vi[j] < vi[min_index]) {
                    min_index = j;
                }
            }
​
            std::swap(vi[i], vi[min_index]);
        }
        printVector("选择排序后:", vi);
    }
};
​
// 具体策略类: 插入排序
class InsertionSort : public Sort {
 public:
    void sortVector(std::vector<int> &vi) override {
        printVector("插入排序前:", vi);
        // 第一轮不需要操作, 第二轮比较一次, 第n轮比较 n-1 次
        for (int i = 1; i < vi.size(); ++i) {
            // 存储待插入的值和下标
            int insert_value = vi[i];
            int j = i - 1;
​
            while (j >= 0 && vi[j] > insert_value) {
                vi[j + 1] = vi[j];  // 如果左侧的已排序元素比目标值大, 那么右移
                j--;
            }
​
            // 注意这里insert_index 需要+1
            vi[j + 1] = insert_value;
        }
        printVector("插入排序后:", vi);
    }
};
​
#endif  // CONCRETE_STRATEGY_H_
Context.h:
#ifndef CONTEXT_H_
#define CONTEXT_H_
​
#include <vector>
#include "Strategy.h"
​
class ArrayHandler {
 public:
    void sortVector(std::vector<int> &arr) {
        return sort_->sortVector(arr);
    }
    void setSortStrategy(Sort* sort) {
        sort_ = sort;
    }
​
 private:
    Sort *sort_;
};
​
#endif  // CONTEXT_H_
main.cpp:
#include <vector>
#include <algorithm>
#include <random>
#include <iostream>
#include "ConcreteStrategy.h"
#include "Context.h"
​
std::vector<int> test_array = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25};
​
int main() {
    ArrayHandler array_handler;
​
    {
        // 冒泡排序
        BubbleSort* bubble_sort = new BubbleSort();
        auto rng = std::default_random_engine {};
        std::shuffle(std::begin(test_array), std::end(test_array), rng);
        array_handler.setSortStrategy(bubble_sort);
        array_handler.sortVector(test_array);
        delete bubble_sort;
    }
​
    {
        // 选择排序
        SelectionSort* select_sort = new SelectionSort();
        auto rng = std::default_random_engine {};
        std::shuffle(std::begin(test_array), std::end(test_array), rng);
        array_handler.setSortStrategy(select_sort);
        array_handler.sortVector(test_array);
        delete select_sort;
    }
​
    {
        // 插入排序
        InsertionSort* insert_sort = new InsertionSort();
        auto rng = std::default_random_engine {};
        std::shuffle(std::begin(test_array), std::end(test_array), rng);
        array_handler.setSortStrategy(insert_sort);
        array_handler.sortVector(test_array);
        delete insert_sort;
    }
    return 0;
}

编译运行:
$g++ -g main.cpp -o strategy -std=c++11
$./strategy 
冒泡排序前: 19 21 5 6 12 4 13 20 1 22 11 14 18 2 24 23 9 10 16 3 7 17 15 25 8
冒泡排序后: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
选择排序前: 19 21 5 6 12 4 13 20 1 22 11 14 18 2 24 23 9 10 16 3 7 17 15 25 8
选择排序后: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
插入排序前: 19 21 5 6 12 4 13 20 1 22 11 14 18 2 24 23 9 10 16 3 7 17 15 25 8
插入排序后: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25

## 9. 模板方法模式(Template Method)

AbstractClass.h:
#ifndef ABSTRACT_METHOD_H_
#define ABSTRACT_METHOD_H_
​
#include <iostream>
​
// 抽象类: 银行业务办理流程
class BankTemplateMethod {
 public:
    void takeNumber() {
        std::cout << "排队取号. " << std::endl;
    }
​
    virtual void transact() = 0;
​
    void evalute() {
        std::cout << "反馈评分. " << std::endl;
    }
​
    void process() {
        takeNumber();
        transact();
        evalute();
    }
};
​
#endif  // ABSTRACT_METHOD_H_
ConcreteClass.h:
#ifndef CONCRETE_METHOD_H_
#define CONCRETE_METHOD_H_
​
#include "AbstractClass.h"
​
// 具体类: 存款
class Deposit : public BankTemplateMethod {
 public:
    void transact() override {
        std::cout << "存款..." << std::endl;
    }
};
​
// 具体类: 取款
class Withdraw : public BankTemplateMethod {
 public:
    void transact() override {
        std::cout << "取款..." << std::endl;
    }
};
​
// 具体类: 转账
class Transfer : public BankTemplateMethod {
 public:
    void transact() override {
        std::cout << "转账..." << std::endl;
    }
};
​
#endif  // CONCRETE_METHOD_H_
main.cpp:
#include "ConcreteClass.h"
​
int main() {
    // 存款
    BankTemplateMethod* deposit = new Deposit();
    deposit->process();
    delete deposit;
​
    // 取款
    BankTemplateMethod* withdraw = new Withdraw();
    withdraw->process();
    delete withdraw;
​
    // 转账
    BankTemplateMethod* transfer = new Transfer();
    transfer->process();
    delete transfer;
}

编译运行:
$g++ -g main.cpp -o templatemethod -std=c++11
$./templatemethod 
排队取号. 
存款...
反馈评分. 
排队取号. 
取款...
反馈评分. 
排队取号. 
转账...
反馈评分. 

## 10. 访问者模式(Vistor)

Visitor.h:
#ifndef VISTOR_H_
#define VISTOR_H_
​
#include <string>
​
class Apple;
class Book;
​
// 抽象访问者
class Vistor {
 public:
    void set_name(std::string name) {
        name_ = name;
    }
​
    virtual void visit(Apple *apple) = 0;
    virtual void visit(Book *book) = 0;
​
 protected:
    std::string name_;
};
​
#endif  // VISTOR_H_
ConcreteVisitor.h:
#ifndef CONCRETE_VISTOR_H_
#define CONCRETE_VISTOR_H_
​
#include <iostream>
#include "Visitor.h"
​
// 具体访问者类: 顾客
class Customer : public Vistor {
 public:
    void visit(Apple *apple) {
        std::cout << "顾客" << name_ << "挑选苹果. " << std::endl;
    }
​
    void visit(Book *book) {
        std::cout << "顾客" << name_ << "买书. " << std::endl;
    }
};
​
// 具体访问者类: 收银员
class Saler : public Vistor {
 public:
    void visit(Apple *apple) {
        std::cout << "收银员" << name_ << "给苹果过称, 然后计算价格. " << std::endl;
    }
​
    void visit(Book *book) {
        std::cout << "收银员" << name_ << "计算书的价格. " << std::endl;
    }
};
​
#endif  // CONCRETE_VISTOR_H_
Element.h:
#ifndef ELEMENT_H_
#define ELEMENT_H_
​
#include "Visitor.h"
​
// 抽象元素类
class Product {
 public:
    virtual void accept(Vistor *vistor) = 0;
};
​
#endif  // ELEMENT_H_
ConcreteElement.h:
#ifndef CONCRETE_ELEMENT_H_
#define CONCRETE_ELEMENT_H_
​
#include "Element.h"
​
// 具体产品类: 苹果
class Apple : public Product {
 public:
    void accept(Vistor *vistor) override {
        vistor->visit(this);
    }
};
​
// 具体产品类: 书籍
class Book : public Product {
 public:
    void accept(Vistor *vistor) override {
        vistor->visit(this);
    }
};
​
​
#endif  // CONCRETE_ELEMENT_H_
Client.h:
#ifndef CLIENT_H_
#define CLIENT_H_
​
#include <list>
#include "Visitor.h"
#include "Element.h"
​
// 购物车
class ShoppingCart {
 public:
    void accept(Vistor *vistor) {
        for (auto prd : prd_list_) {
            prd->accept(vistor);
        }
    }
​
    void addProduct(Product *product) {
        prd_list_.push_back(product);
    }
​
    void removeProduct(Product *product) {
        prd_list_.remove(product);
    }
​
 private:
    std::list<Product*> prd_list_;
};
​
#endif  // CLIENT_H_
main.cpp:
#include "Client.h"
#include "ConcreteElement.h"
#include "ConcreteVisitor.h"
​
int main() {
    Book book;
    Apple apple;
    ShoppingCart basket;
​
    basket.addProduct(&book);
    basket.addProduct(&apple);
​
    Customer customer;
    customer.set_name("小张");
    basket.accept(&customer);
​
    Saler saler;
    saler.set_name("小杨");
    basket.accept(&saler);
​
    return 0;
}

编译运行:
$g++ -g main.cpp -o vistor -std=c++11
$./vistor 
顾客小张买书. 
顾客小张挑选苹果. 
收银员小杨计算书的价格. 
收银员小杨给苹果过称, 然后计算价格. 

Reference
[1] https://zhuanlan.zhihu.com/p/94877789
[2] https://blog.csdn.net/sinat_21107433/article/details/102616501
[3] https://design-patterns.readthedocs.io/zh_CN/latest/creational_patterns/factory_method.html
[4] https://blog.csdn.net/lxq1997/article/details/88135496


