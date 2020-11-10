# LEGOFastApp

`LEGOFastApp` 是一个 `iOS` 脚手架的项目，其目的是为您节省手动 `Create a new Xcode Project` 和寻找以及配置一些依赖库的时间，只要 `clone` 或者下载项目，更改项目名、`App` 名、资源名等，即可投入开发生产。

## Features

- [x] 对项目进行目录的合理分配，若不满意您可自行调整；
- [x] 提供更改项目名的脚本文件 `project_rename.swift`；
- [x] 对 `UINavigationController` 和 `UIViewController` 进行了基础性封装，重写了 `UINavigationBar`；
- [x] 封装转场动画同 `UIViewController` 和 `UINavigationController` 的繁琐交互，开发者只需要专注于转场动画和交互动画的效果编写；
- [x] 在 `CoreData` 的基础上，对数据库进行二次封装，提供异步 `CRUD` 和批量处理等功能；
- [x] 基于 `Kingfisher` 的基础，进行图片缓存的二次封装；
- [x] 提供对称加密、单向散列等基础工具类；
- [x] 提供 `UIKit`、`String`、`UserDefaults` 等相关拓展。

## Installation

`LEGOFastApp` 通过 `git clone` 下载到本地目录后，可以选择更改工程名或直接开发，如果需要更换工程名，请在运行 `pod install` 之前先运行 `project_rename.swift` 去更换工程名。

### 工程名更改

使用 `project_rename.swift` 之前，需要确保 `project_rename.swift` 有执行权限，如何给脚本提供权限，您可以咨询 [谷歌](https://www.google.com/) 或者 [度娘](https://www.baidu.com/)，脚本运行如下所示：
```

# run script
$ ./project_rename.swift "$OLD_PROJECT_NAME" "$NEW_PROJECT_NAME"
  
```

### 开源库下载

`Podfile` 中已经添加了一些比较成熟、常用的优秀开源库，您可以在 `Podfile` 中随意添加、更改、删除依赖库。

目前已添加的优秀开源库有：

- [x] [`Moya`](https://github.com/Moya/Moya)：网络请求库，在 `API` 设计上更加灵活优秀，单例测试 `so easy`；
- [x] [`Kingfisher`](https://github.com/onevcat/Kingfisher)：喵神的作品，算是 `Swift` 上的 “`SDWebImage`”；
- [x] [`XCGLogger`](https://github.com/DaveWoodCom/XCGLogger)：`Swift` 上优秀的日志框架之一，支持日志分级、沙盒缓存、存储管理等；
- [x] [`LEGONavigationController-Swift`](https://github.com/legokit/LEGONavigationController-Swift)：重写了 `UINavigationBar`，避免系统 `BUG`；
- [x] [`SnapKit`](https://github.com/SnapKit/SnapKit)：`Swift` 上自动布局的利器；
- [x] [`HandyJSON`](https://github.com/alibaba/HandyJSON)：阿里出品，实现 `Swift` 上的 `JSON` 转 `Model` 功能。

安装第三方库只需要运行：

```

pod install
  
```

## Project Structure

项目的目录结构划分如下表所示，项目目录划分纯属个人开发者使用习惯，您可以自行调整和拓展。

| 一级目录 | 二级目录 | 三级目录 | 备注 | 
| :-----| :---- | :---- | :---- |
| `Class` |  |  | 业务模块相关 |
|  | `Base` |  | 基础模块 |
|  |  | `Controllers` | 对 `UIViewController` 等进行封装，可直接继承 |
|  | `Main` |  | 主页模块 |
|  |  | `Controllers` |  |
| `Expand` |  |  | 拓展模块，包括数据库、网络、系统类拓展、工具类、常量等复用性高的代码 |
|  | `Tools` |  | 工具模块 |
|  | `Extension` |  | 系统拓展 |
|  | `Transitions` |  | `ViewController` 转场动画封装相关模块 |
|  | `ImageCache` |  | 缓存模块 |
|  | `Macro` |  | 常量模块 |
|  | `DataBase` |  | 数据库模块 |
| `Assets.xcassets` |  |  | 图片资源 |
| `Supporting Files` |  |  | 项目支持 |
| `Resources` |  |  | 其他资源 |
| `Vendor` |  |  | 第三方静态库 |

## Usage

为了能够帮助您快速在此项目基础上进行业务开发，将主要介绍下关键模块的一些使用。

### BaseViewController 和 BaseNavigationController

您可以根据需要继承 `Base` 目录下的 `BaseViewController` 或 `BaseNavigationController`，其中，`BaseNavigationController` 的父类是 `LEGONavigationController`。

`LEGONavigationController` 直接将系统的 `navigationBar` 隐藏掉，避免了一些系统 `Bug` 以及相关 `UI` 设置的繁琐，同时提供了一个替代 `navigationBar` 的 `LEGONavigationView`，使用如下：
```swift
// 设置背景颜色，使用原生可没那么简单(╥╯^╰╥)
legoNaviationParam.backgroundColor = UIColor.gray
// 设置标题
self.navigationView().setTitle(text: "Hello World")
self.navigationView().setBackButton {
    // Action...
}
```

继承 `BaseViewController` 有一定的约束，子类必须实现 `AbstractViewController` 协议，这点设计上有点借鉴 `Java` 的抽象类机制，`OC` 和 `Swift` 上没有抽象类这种概念，简单的理解就是 `BaseViewController` 提供了通用的方法，当通用的方法不满足子类的需要时，由 `AbstractViewController` 提供可变内容，这样做的好处有：

1. 父类负责定义规范，通过协议来约束和拓展子类；
2. 在不需要子类的参与下，便可以完成业务逻辑的实现（编译环节不报错）；
3. 父类实现了通用的方法，灵活可变的具体业务交由子类实现，调用者不需要关心。

### 转场动画

`BaseViewController` 和 `BaseNavigationController` 已经实现了自定义转场动画所需要的协议，`<UINavigationControllerDelegate>` 和 `<UIViewControllerTransitioningDelegate>`，您继承 `BaseViewController` 的时候，需要实现 `AbstractViewController`，`AbstractViewController` 有两个接口：
```swift
var animationController: BaseAnimationController? { get }
var interactionController: BaseInteractionController? { get }
```

`AbstractViewController` 对这两个接口有默认的实现，返回 `nil` 则使用系统自带的转场动画，您如果需要自定义转场动画，可以按照以下步骤：

1. 创建的 `Class XXViewController` 继承 `BaseViewController` 并实现 `AbstractViewController` 协议；
2. 新建一个 `Class XXAnimationController`，继承 `BaseAnimationController`，并实现 `AbstractAnimation` 协议的 `animateTransition(transitionContext:fromVC:toVC:fromView:toView:)`方法，提供转场的动画逻辑；
3. 如果转场需要交互（不需要交互直接到第4步），需要新建一个 `Class XXInteractionController`，继承 `BaseInteractionController`，并实现 `AbstractInteraction` 协议的 `wireToViewController(_:forOperation)`， 提供转场的交互逻辑；
4. 在 `XXViewController` 中将 `XXAnimationController` 和 `XXInteractionController`（可选，若没有不需要返回）实例化并返回，即可使用自定义转场动画。

目前项目中已经实现了 `UINavigationViewController` 的 `Push` 由下到上和 `Pop` 由上到下的可交互转场动画，以供参考。

### CoreData

```swift
// 1. Entitie 需要实现 Persistable 协议的 fetchRequest() 方法
extension Entitie: Persistable {
    @nonobjc static func fetchRequest() -> NSFetchRequest<Entitie> {
        return NSFetchRequest<Book>(entityName: "Entitie")
    }
}

// 2.初始化数据表
private let repository = Repository<Entitie>(context: CoreDataStack.share.context)

// 3、数据查询
self.bookRepository.query(with: nil, sortDescriptors: nil) { (results, error) in
    guard error == nil else { 
        // 错误处理
        return
    }
    // 数据处理
}

// 4、数据更新或插入
self.repository.save(with: nil) { (entitie) in
    // 更新数据
} complete: { (error) in
    // 完成回调
}

// 5、数据删除
let predicate = ...
self.bookRepository.delete(with: predicate) { (error) in
    guard error == nil else {
        // 错误处理
        return
    }
    // 成功处理
}


```
示例提供了单个数据的 `CRUD`，批量处理基本上也是同样操作。

### Kingfisher

`Kingfisher` 基本上是一个很成熟的框架，封装细节上也很完美，支持内存缓存和磁盘缓存，`ImageCacheManager` 提供了磁盘路径设置、关闭iCloud同步。

```swift
 func storeToDisk(_:forKey:iCloudEnable:completionHandler:)
```

### 日志管理

日志管理使用的是 `XCGLogger`，在此基础上进行了封装：

1. 日志保存到沙盒 `Document` 目录下；
2. 单个文件最大 `maxFileSize` 为 `10Mb`；
3. 单个日志活跃最长时间 `maxTimeInterval` 为 `24h`；
4. 沙盒日志数量 `targetMaxLogFiles` 为7份；
5. 提供标记，以区分日志等级。

```swift
log.verbose(#function)
log.debug(#function)
log.info(#function)
log.notice(#function)
log.warning(#function)
log.error(#function)
log.severe(#function)
log.alert(#function)
log.emergency(#function)
```

### 其他

增加了一些我本人认为有帮助的工具类和系统拓展类，您可以尝试使用下。


## Author

machenshuang@yy.com，chenshuangma@foxmail.com

## License

`LEGOFastApp` is available under the MIT license. See the LICENSE file for more info.





