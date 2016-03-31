//: [上一节](@previous) - [目录](Index)
/*:
## 什么是 Subject

> 在继续讲解 Observable 前，我想我们先来看看 Subject 是什么。后面我们偶尔会用到，官方也是这样的顺序。

我们可以把 Subject 当作一个桥梁（或者说是代理），就是说 Subject 既是 Observable 也是 Observer 。

* 作为一个 Observer ，它可以订阅序列
* 同时作为一个 Observable ，它可以转发或者发射数据。

> 在这里， Subject 还有一个特别的功能，就是将冷序列变成热序列，订阅后重新发送嘛，冷就变成了热。

*/

import RxSwift

/*:

## PublishSubject

当有观察者订阅 `PublishSubject` 时，`PublishSubject` 会发射订阅之后的数据给这个观察者。

> 于是这里存在丢失数据的问题，如果需要全部数据，我推荐改用 `ReplaySubject` 。

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/publishsubject.png)

如果序列因为错误终止发射序列，此时 `PublishSubject` 就不会发射数据，只是传递这次错误事件。

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/publishsubject_error.png)

*/

example("publishSubject") {

    let publishSubject = PublishSubject<String>()

    _ = publishSubject.subscribe { e in
            print("Subscription: 1, event: \(e)")
        }

    publishSubject.on(.Next("a"))
    publishSubject.on(.Next("b"))

    _ = publishSubject.subscribe { e in /// 我们可以在这里看到，这个订阅只收到了两个数据，只有 "c" 和 "d"
        print("Subscription: 2, event: \(e)")
        }

    publishSubject.on(.Next("c"))
    publishSubject.on(.Next("d"))

}
/*:

## ReplaySubject

和 `PushblishSubject` 不同，不论观察者什么时候订阅， `ReplaySubject` 都会发射完整的数据给观察者。

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/replaysubject.png)

*/

example("replaySubject") {

let replaySubject = ReplaySubject<String>.createUnbounded()

_ = replaySubject.subscribe { e in
    print("Subscription: 1, event: \(e)")
    }

replaySubject.on(.Next("a"))
replaySubject.on(.Next("b"))

_ = replaySubject.subscribe { e in /// 我们可以在这里看到，这个订阅收到了四个数据
    print("Subscription: 2, event: \(e)")
    }

replaySubject.on(.Next("c"))
replaySubject.on(.Next("d"))

}

/*:
事实上 `ReplaySubject` 还有一个方法 `public static func create(bufferSize bufferSize: Int) -> ReplaySubject<Element>` ，我们可以通过制定具体的 buffer 来确定我们要保留多少个值留给即将订阅的观察者。
*/

/*:

## BehaviorSubject

当一个观察者订阅一个 `BehaviorSubject` ，它会发送原序列最近的那个值

When an observer subscribes to a `BehaviorSubject`, it begins by emitting the item most recently emitted by the source Observable (or a seed/default value if none has yet been emitted) and then continues to emit any other items emitted later by the source Observable(s).

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/behaviorsubject.png)

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/behaviorsubject_error.png)
*/

example("behaviorSubject") {
let behaviorSubject = BehaviorSubject(value: "z")
_ = behaviorSubject.subscribe { e in
    print("Subscription: 1, event: \(e)")
    }

behaviorSubject.on(.Next("a"))
behaviorSubject.on(.Next("b"))

_ = behaviorSubject.subscribe { e in /// 我们可以在这里看到，这个订阅收到了四个数据
    print("Subscription: 2, event: \(e)")
    }

behaviorSubject.on(.Next("c"))
behaviorSubject.on(.Next("d"))
behaviorSubject.on(.Completed)
}

/*:
`Variable` 是 `BehaviorSubject` 的一个封装。相比 `BehaviorSubject` ，它不会因为错误终止也不会正常终止，是一个无限序列。
*/
example("variable") {
let variable = Variable("z")
_ = variable.asObservable().subscribe { e in
    print("Subscription: 1, event: \(e)")
    }
variable.value = "a"
variable.value = "b"
_ = variable.asObservable().subscribe { e in
    print("Subscription: 1, event: \(e)")
    }
variable.value = "c"
variable.value = "d"
}
/*:
我们最常用的 Subject 应该就是 Variable 。它满足了我们很多需求，订阅时就发射一次最近的序列，我们只需要在这里保留完整的数据，那每一个订阅者都可以获得完整的数据。通常我们会用它做数据源，例子请参见 [初章 第三节 创建一个 TableView]() 。
*/

/*:
好了~ 我们现在填一个坑了，补上了前面的 Variable 是什么。
*/

//: [目录](@Index) - [下一节 >>](@next)
