//: [上一节](@previous) - [目录](Index)

import RxSwift

/*:
## 其他操作符
这一章节我们来看一些比较实用的操作符，虽然我归在其他中，但并不代表这不重要。
*/


/*:
## 一些实用的操作符
我们经常会用到的~ 之前的各种操作其实都有用到。
*/

/*:
### `subscribe`

操作序列的发射物和通知， `subscribe` 系列也就是连接序列和观察者的操作符，顾名思义就是订阅。

这一部分理解起来很轻松，都是同样的订阅，只是 API 的花样多一些。

下面这个是：

public func subscribe(on: (event: RxSwift.Event<Self.E>) -> Void) -> Disposable

就是说我们接收到的是事件，在这里一般通过 switch case 获取对应结果。

*/

example("subscribe") {
    let sequenceOfInts = PublishSubject<Int>()
    
    _ = sequenceOfInts
        .subscribe {
            print($0)
    }
    
    sequenceOfInts.on(.Next(1))
    sequenceOfInts.on(.Completed)
}

/*:

### `subscribeNext`

`subscribeNext` 只订阅 Next 事件。

public func subscribeNext(onNext: (Self.E) -> Void) -> Disposable

因为只有一种事件，这里的 API 传入的就是事件中包含的具体的值了。

*/
example("subscribeNext") {
    let sequenceOfInts = PublishSubject<Int>()
    
    _ = sequenceOfInts
        .subscribeNext {
            print($0)
    }
    
    sequenceOfInts.on(.Next(1))
    sequenceOfInts.on(.Completed)
}


/*:

### `subscribeCompleted`

`subscribeCompleted` 只订阅 Completed 事件。

public func subscribeCompleted(onCompleted: () -> Void) -> Disposable

*/

example("subscribeCompleted") {
    let sequenceOfInts = PublishSubject<Int>()
    
    _ = sequenceOfInts
        .subscribeCompleted {
            print("It's completed")
    }
    
    sequenceOfInts.on(.Next(1))
    sequenceOfInts.on(.Completed)
}


/*:

### `subscribeError`

`subscribeError` 只订阅 Error 事件。

*/

example("subscribeError") {
    let sequenceOfInts = PublishSubject<Int>()
    
    _ = sequenceOfInts
        .subscribeError { error in
            print(error)
    }
    
    sequenceOfInts.on(.Next(1))
    sequenceOfInts.on(.Error(NSError(domain: "Examples", code: -1, userInfo: nil)))
}

/*:
由以上几种订阅操作符，我们可以用下面这种姿势处理各种事件：
*/

example("subscribe 2") {
    let sequenceOfInts = PublishSubject<Int>()
    
    let observableOfInts = sequenceOfInts.share()
    
    _ = observableOfInts
        .subscribeNext {
            print($0)
    }
    
    _ = observableOfInts
        .subscribeError { error in
            print(error)
    }
    
    sequenceOfInts.on(.Next(1))
    sequenceOfInts.on(.Error(NSError(domain: "Examples", code: -1, userInfo: nil)))
}

/*:
当然啦，还有一个 `subscribe` 供我们使用：

public func subscribe(onNext onNext: (Self.E -> Void)? = default, onError: (ErrorType -> Void)? = default, onCompleted: (() -> Void)? = default, onDisposed: (() -> Void)? = default) -> Disposable

> 注：
你可能会看到还有一个 `subscribe` ：

public func subscribeOn(scheduler: ImmediateSchedulerType) -> RxSwift.Observable<Self.E>

从返回的是一个序列可以看出这个并非是订阅操作，这是一个关于线程的故事，我们放到下一章讲解。

*/

/*:
### `doOn`

注册一个动作作为原始序列生命周期事件的占位符。

好吧，理解起来还是很迷茫的，可以参考下图：

![]( http://reactivex.io/documentation/operators/images/do.c.png )

对比其他操作符，底下的部分应该是一个序列，这里并不是。你可以把 `doOn` 理解成在任意的地方插入一个“插队订阅者”，这个“插队订阅者”不会对序列的变换造成任何影响。 `doOn` 和 `subscribe` 有很多类似的 API 。

*/
example("doOn") {
    let sequenceOfInts = PublishSubject<Int>()
    
    _ = sequenceOfInts
        .doOn {
            print("Intercepted event \($0)")
        }
        .subscribe {
            print($0)
    }
    
    sequenceOfInts.on(.Next(1))
    sequenceOfInts.on(.Completed)
}


/*:
## 条件和布尔操作
*/

/*:
### `takeUntil`
 
当另一个序列开始发射值时，忽略原序列发射的值。

![]( https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/takeuntil.png )

*/

example("takeUntil") {
    let originalSequence = PublishSubject<Int>()
    let whenThisSendsNextWorldStops = PublishSubject<Int>()
    
    _ = originalSequence
        .takeUntil(whenThisSendsNextWorldStops)
        .subscribe {
            print($0)
    }
    
    originalSequence.on(.Next(1))
    originalSequence.on(.Next(2))
    originalSequence.on(.Next(3))
    
    whenThisSendsNextWorldStops.on(.Next(1))
    
    originalSequence.on(.Next(4))
}

/*:
不难理解，在 `whenThisSendsNextWorldStops` 发射 1 时，观察者不在关心 `originalSequence` 了。
*/

/*:
### `takeWhile`

根据一个状态判断是否继续向下发射值。这其实类似于 `filter` 。需要注意的就是 `filter` 和 `takeWhile` 什么时候更能清晰表达你的意思，就用哪个。

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/takewhile.png)

*/
example("takeWhile") {
    
    let sequence = PublishSubject<Int>()
    
    _ = sequence
        .takeWhile { $0 < 4 }
        .subscribe {
            print($0)
    }
    
    sequence.on(.Next(1))
    sequence.on(.Next(2))
    sequence.on(.Next(3))
    sequence.on(.Next(4))
    sequence.on(.Next(5))
}

/*:
### `amb`
 
 ![]( http://reactivex.io/documentation/operators/images/amb.png )
 
 `amb` 用来处理发射序列的操作，不同的是， `amb` 选择先发射值的序列，自此以后都只关注这个先发射序列，抛弃其他所有序列。
 
 有两种使用版本供选择。

 */

example("amb 1") {
    let intSequence1 = PublishSubject<Int>()
    let intSequence2 = PublishSubject<Int>()
    let intSequence3 = PublishSubject<Int>()
    
    let _ = [intSequence1, intSequence2, intSequence3].amb()
        .subscribe {
        print($0)
    }
    
    intSequence2.onNext(10) // intSequence2 最先发射
    intSequence1.onNext(1)
    intSequence3.onNext(100)
    intSequence1.onNext(2)
    intSequence3.onNext(200)
    intSequence2.onNext(20)
    
}

example("amb 2") {
    let intSequence1 = PublishSubject<Int>()
    let intSequence2 = PublishSubject<Int>()
    
    let _ = intSequence1.amb(intSequence2).subscribe { // 只用于比较两个序列
        print($0)
    }
    
    intSequence2.onNext(10) // intSequence2 最先发射
    intSequence1.onNext(1)
    intSequence1.onNext(2)
    intSequence2.onNext(20)
    
}

/*:
## 计算和聚合操作
*/

/*:
### `concat`

 串行的合并多个序列。你可能会想起 `switchLatest` 操作符，他们有些类似，都是将序列整理到一起。不同的就是 `concat` 不会在丢弃旧序列的任何一个值。全部按照序列发射的顺序排队发射。

![]( https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/concat.png )

*/

example("concat") {
    let var1 = BehaviorSubject(value: 0)
    let var2 = BehaviorSubject(value: 200)
    
    // var3 is like an Observable<Observable<Int>>
    let var3 = BehaviorSubject(value: var1)
    
    let d = var3
        .concat()
        .subscribe {
            print($0)
    }
    
    var1.on(.Next(1))
    var1.on(.Next(2))
    var1.on(.Next(3))
    var1.on(.Next(4))
    
    var3.on(.Next(var2))
    
    var2.on(.Next(201))
    
    var1.on(.Next(5))
    var1.on(.Next(6))
    var1.on(.Next(7))
    var1.on(.Completed)
    
    var2.on(.Next(202))
    var2.on(.Next(203))
    var2.on(.Next(204))
    var2.on(.Completed)
    
//    var3.on(.Completed)
}

/*:
看到这个操作符了，说明这些操作不需要冗长的解释了。只是注意一点 `var2` 发射完毕 `var3` 并没有结束哦。
 */

/*:

### `reduce`
 
 不多解释了，和 Swift 的 `reduce` 差不多。只是要记得它和 `scan` 一样不仅仅只是用来求和什么的。注意和 `scan` 不同 `reduce` 只发射一次，真的就和 Swift 的 `reduce` 相似。还有一个 `toArray` 的便捷操作，我想你会喜欢。

![]( https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/reduce.png )

*/
example("reduce") {
    _ = Observable.of(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
        .reduce(0, accumulator: +)
        .subscribe {
            print($0)
    }
}

/*:
## 连接操作
 
可连接的序列和一般的序列基本是一样的，不同的就是你可以用可连接序列调整序列发射的实际。只有当你调用 `connect` 方法时，序列才会发射。比如我们可以在所有订阅者订阅了序列后开始发射。下面的几个例子都是无限执行的，你可以自行调用每个函数感受不同的操作的结果。

*/

/*:
 下面这个例子是没有进行连接操作，可以看到 5 秒之后的第二个订阅者开始订阅，于是它和第一个订阅者产生了不同步。这个时候就需要连接操作了。
 */

func sampleWithoutConnectableOperators() {
    
    print("--- sampleWithoutConnectableOperators sample ---")
    
    let int1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    
    _ = int1
        .subscribe {
            print("first subscription \($0)")
    }
    
    delay(5) {
        _ = int1
            .subscribe {
                print("second subscription \($0)")
        }
    }
    
}

//sampleWithoutConnectableOperators()

/*:
### `multicast`
 
 来看一个连接操作，这个 `multcast` 使用起来有些麻烦，不过也更强大，传入一个 Subject ，每当序列发射值时都会传个这个 Subject 。问我这有什么用，我也不清楚，不过你可以用这个做一些辅助的记录操作，至少你不应该将这个 Subject 作为主要逻辑。

![]( https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/publishconnect.png )

*/

/*:
> 下面这个 sampleWithMulticast 请结合上面的图片理解。
 */

func sampleWithMulticast() {
    
    print("--- sampleWithMulticast sample ---")
    
    let subject1 = PublishSubject<Int64>()
    
    _ = subject1
        .subscribe {
            print("Subject \($0)")
    }
    
    let int1 = Observable<Int64>.interval(1, scheduler: MainScheduler.instance)
        .multicast(subject1)
    
    _ = int1
        .subscribe {
            print("first subscription \($0)")
    }
    
    delay(2) {
        int1.connect()
    }
    
    delay(4) {
        _ = int1
            .subscribe {
                print("second subscription \($0)")
        }
    }
    
    delay(6) {
        _ = int1
            .subscribe {
                print("third subscription \($0)")
        }
    }
    
}

// sampleWithMulticast()


/*:
### `replay`
 
`replay` 这个操作可以让所有订阅者同一时间收到相同的值。 
 就相当于 `multicast` 中传入了一个 `ReplaySubject` .

 publish = multicast + replay subject
 
 > 至于其中的参数，你可以回顾一下 `ReplaySubject` 是什么，当然也有一个好玩的方法去理解他。跑一边下面的 `sampleWithReplayBuffer0` 和 `sampleWithReplayBuffer2` ，如果还不够就写一个 `sampleWithReplayBuffer4` 跑一下吧。对比一下他们的区别，记得每次只跑一个。
 > `shareReplay` 就相当于将 `replay` 中的参数设置为无限大。

![]( https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/replay.png )

*/

func sampleWithReplayBuffer0() {
    
    print("--- sampleWithReplayBuffer0 sample ---")
    
    let int1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        .replay(0)
    
    _ = int1
        .subscribe {
            print("first subscription \($0)")
    }
    
    delay(2) {
        int1.connect()
    }
    
    delay(4) {
        _ = int1
            .subscribe {
                print("second subscription \($0)")
        }
    }
    
    delay(6) {
        _ = int1
            .subscribe {
                print("third subscription \($0)")
        }
    }
    
}

// sampleWithReplayBuffer0()


func sampleWithReplayBuffer2() {
    
    print("--- sampleWithReplayBuffer2 sample ---")
    
    let int1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        .replay(2)
    
    _ = int1
        .subscribe {
            print("first subscription \($0)")
    }
    
    delay(2) {
        int1.connect()
    }
    
    delay(4) {
        _ = int1
            .subscribe {
                print("second subscription \($0)")
        }
    }
    
    delay(6) {
        _ = int1
            .subscribe {
                print("third subscription \($0)")
        }
    }
    
}

// sampleWithReplayBuffer2()


/*:
### `publish`
 
 其实这个和开始的 `sampleWithMulticast` 是一样的效果。

 publish = multicast + publish subject

*/

func sampleWithPublish() {
    
    let int1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        .publish()
    
    _ = int1
        .subscribe {
            print("first subscription \($0)")
    }
    
    delay(2) {
        int1.connect()
    }
    
    delay(4) {
        _ = int1
            .subscribe {
                print("second subscription \($0)")
        }
    }
    
    delay(6) {
        _ = int1
            .subscribe {
                print("third subscription \($0)")
        }
    }
    
}

// sampleWithPublish()

/*:
### `refCount`
 
 这个是一个可连接序列的操作符。
 
 ![]( http://reactivex.io/documentation/operators/images/publishRefCount.c.png )
 
 它可以将一个可连接序列变成普通的序列。
*/

playgroundShouldContinueIndefinitely()

//: [目录](@Index) - [下一节 >>](@next)
