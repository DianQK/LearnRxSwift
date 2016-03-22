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

Operators that evaluate one or more Observables or items emitted by Observables.

*/

/*:
### `takeUntil`

Discard any items emitted by an Observable after a second Observable emits an item or terminates.

![]( https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/takeuntil.png )

[More info in reactive.io website]( http://reactivex.io/documentation/operators/takeuntil.html )
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
    originalSequence.on(.Next(4))
    
    whenThisSendsNextWorldStops.on(.Next(1))
    
    originalSequence.on(.Next(5))
}


/*:
### `takeWhile`

Mirror items emitted by an Observable until a specified condition becomes false

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/takewhile.png)

[More info in reactive.io website]( http://reactivex.io/documentation/operators/takewhile.html )
*/
example("takeWhile") {
    
    let sequence = PublishSubject<Int>()
    
    _ = sequence
        .takeWhile { int in
            int < 4
        }
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
## Mathematical and Aggregate Operators

Operators that operate on the entire sequence of items emitted by an Observable

*/

/*:
### `concat`

Emit the emissions from two or more Observables without interleaving them.

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/concat.png)

[More info in reactive.io website]( http://reactivex.io/documentation/operators/concat.html )
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
}


/*:


### `reduce`

Apply a function to each item emitted by an Observable, sequentially, and emit the final value.
This function will perform a function on each element in the sequence until it is completed, then send a message with the aggregate value. It works much like the Swift `reduce` function works on sequences.

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/reduce.png)

[More info in reactive.io website]( http://reactivex.io/documentation/operators/reduce.html )

*/
example("reduce") {
    _ = Observable.of(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
        .reduce(0, accumulator: +)
        .subscribe {
            print($0)
    }
}

/*:
## Connectable Observable Operators

A Connectable Observable resembles an ordinary Observable, except that it does not begin emitting items when it is subscribed to, but only when its connect() method is called. In this way you can wait for all intended Subscribers to subscribe to the Observable before the Observable begins emitting items.

Specialty Observables that have more precisely-controlled subscription dynamics.
*/

func sampleWithoutConnectableOperators() {
    
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

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/publishconnect.png)

[More info in reactive.io website]( http://reactivex.io/documentation/operators/publish.html )
*/
func sampleWithMulticast() {
    
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
Ensure that all observers see the same sequence of emitted items, even if they subscribe after the Observable has begun emitting items.

publish = multicast + replay subject

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/replay.png)

[More info in reactive.io website]( http://reactivex.io/documentation/operators/replay.html )
*/
func sampleWithReplayBuffer0() {
    
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
    
    print("--- sampleWithReplayBuffer2 ---\n")
    
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
Convert an ordinary Observable into a connectable Observable.

publish = multicast + publish subject

so publish is basically replay(0)

[More info in reactive.io website]( http://reactivex.io/documentation/operators/publish.html )
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

playgroundShouldContinueIndefinitely()

//: [目录](@Index) - [下一节 >>](@next)
