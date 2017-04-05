# RxSwift 学习指导索引

Hi, 因为年代久远，加之早期对书写文章的熟练程度不足，这个系列暂无继续更新的计划，如果您仍然对我写的文章或是 Demo 感兴趣。您可以 star https://github.com/DianQK/rx-sample-code 项目，这里包含了许多场景下使用 Rx 处理的方式，目前已有十多个 Target 供您参考，除此之外您还可以在我的博客中找到最近更新的文章。

https://blog.dianqk.org
https://medium.com/@DianQK

:) 放心~博客和 https://github.com/DianQK/rx-sample-code 会持续更新。今年晚些时候还会有一个相对完善的电子书（免费在线阅读、付费下载 pdf、纸质书购买）供阅读，这整理了上面博客以及 demo 中绝大部分的内容，并增加了一些目前还来不及更新到博客上的文章，我会统一加到这里。

## RxSwift 系列教程

* **前言**
  * [000 前言：一起来学习 RxSwift](http://t.swift.gg/d/3-000-rxswift)
  * [000 阅读提示：读一下又不会怀孕](http://t.swift.gg/d/4-000)
  * [000 参考资源](http://t.swift.gg/d/25-000)

* **初章 体验 Rx**
  * [001 初章 第一节：为什么要学习并使用 RxSwift](http://t.swift.gg/d/5-001-rxswift)
  * [002 初章 第二节：创建一个 tableView](http://t.swift.gg/d/6-002-tableview)
  * [003 初章 第三节：网络层的简单示例](http://t.swift.gg/d/7-003)

* **第二章 Rx 序列基本操作**
  * [004 第二章 第一节： Rx 基本概念](http://t.swift.gg/d/15-004-rx)
  * [005 第二章 第二节：创建序列 Observable](http://t.swift.gg/d/17-005-observable)
  * [006 第二章 第三节：什么是 Subject](http://t.swift.gg/d/18-006-subject)
  * [007 第二章 第四节：变换序列](http://t.swift.gg/d/19-007)
  * [008 第二章 第五节：过滤序列](http://t.swift.gg/d/20-008)
  * [009 第二章 第六节：组合序列](http://t.swift.gg/d/26-009)
  * [010 第二章 第七节：复习](http://t.swift.gg/d/27-010)
  * [011 第二章 第八节：错误处理](http://t.swift.gg/d/28-011)
  * [012 第二章 第九节：其他操作符](http://t.swift.gg/d/29-012)
  * ~~ [013 第二章 第二节：补充](http://t.swift.gg) ~~ *占坑*

* **第三章 在 Rx 中切换线程**
  * [014 第三章 第一节：线程介绍](http://t.swift.gg/d/30-014)
  * [015 第三章 第二节：线程切换](http://t.swift.gg/d/31-015)
  * [016 第三章 第三节：封装线程](http://t.swift.gg/d/32-016)
  * ~~ [017 第三章 第四节：不要滥用线程](http://t.swift.gg) ~~ *占坑*
  * ~~ [017 第三章 第四节：补充](http://t.swift.gg) ~~ *占坑*

* ** 第四章 RxCocoa **
  * [019 第四章 第一节： RxCocoa 的 API](http://t.swift.gg/d/33-019-rxcocoa-api)
  * [020 第四章 第二节： RxExtensions 介绍](http://t.swift.gg/d/34-020-rxextensions)
  * [021 第四章 第三节： Units](http://t.swift.gg/d/39-021-units)
  * [022 第四章 第五节： RxDelegate](http://t.swift.gg/d/41-022-rxdelegate)
  * ~~ [023 第四章 第四节： RxAnimation](http://t.swift.gg/) ~~ *占坑*
  * ~~ [024 第四章 第四节：补充](http://t.swift.gg) ~~ *占坑*

## 番外 Tips

* [101 番外：为什么 label.rx_text 不是 ObservableType](http://t.swift.gg/d/16-101-label-rx-text-observabletype)
* [102 番外：更优雅的处理 TableView Select](http://t.swift.gg/d/14-102-tableview-select)
* [在实践中应用 RxSwift 1 － 使用 Result 传递值](http://t.swift.gg/d/56-rxswift-1-result)
* [在实践中应用 RxSwift 2 － 使用函数式复用代码](http://t.swift.gg/d/57-rxswift-2)
* [RxSwift 下的 map 与 flatMap](http://t.swift.gg/d/58-rxswift-map-flatmap)
* [在实践中应用 RxSwift 3 处理 Cell](http://t.swift.gg/d/60-rxswift-3-cell)

（称之为教程有些夸张了~跑。。。

## 参考资源

以下是我简单整理的一些可以用来参考学习的文章和指导，同时我的文章也会参考这些文章，表示感谢。

### Github

* 官方的项目中已经给出了很好的例子 [RxExample](https://github.com/ReactiveX/RxSwift)
* [RxSwiftCommunity](https://github.com/RxSwiftCommunity)
* [RxGitHubAPI](https://github.com/FengDeng/RxGitHubAPI)

### Repo

* [RxAlamofire](https://github.com/RxSwiftCommunity/RxAlamofire) Alamofire 的 Rx 扩展
* [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources) 方便建立 `UITableView` 和 `UICollectionView` 的 DataSource
* [RxOptional](https://github.com/RxSwiftCommunity/RxOptional) 过滤可选
* [RxGitHubAPI](https://github.com/FengDeng/RxGitHubAPI) Github API

### Demo

* [RxPagination](https://github.com/tryswift/RxPagination) try! Swift 大会 POP Demo
* [RxDemo](https://github.com/DianQK/RxDemo) gank.io
* [RxSwiftWeather](https://github.com/DianQK/RxSwiftWeather) 修改自 [SwiftWeather](https://github.com/JakeLin/SwiftWeather)
* [RxSwiftGram](https://github.com/Dwar3xwar/RxSwiftGram)

## 文档 & 博客

* [ReactiveX 文档中文翻译](https://mcxiaoke.gitbooks.io/rxdocs/content/)
* [Rx Design Guidelines](http://download.microsoft.com/download/4/E/4/4E4999BA-BC07-4D85-8BB1-4516EC083A42/Rx Design Guidelines.pdf)
* [Introduction to Rx](http://www.introtorx.com)
* [Functional Programming in Javascript](http://reactivex.io/learnrx/)
* [ReactiveCocoa 讨论会](http://blog.devtang.com/2016/01/03/reactive-cocoa-discussion/)
* [李忠的博客](http://limboy.me)
* [美团 RAC 技术博客](http://tech.meituan.com/tag/ReactiveCocoa)
* [Haskell 学习](http://learnyouahaskell.com/chapters)
* [DengFeng 的 Blog](http://fengdeng.github.io)
* [](http://www.thedroidsonroids.com/blog/ios/rxswift-by-examples-1-the-basics/)

> 排名顺序仅仅是我整理的时间排的，都是很好的文章。

## LICENSE

MIT
