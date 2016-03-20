//: [上一节](@previous) - [目录](Index)

import RxSwift

/*:
## 变换 Observables

下面的这些操作符可以变换一个序列发射的值。这样我们的序列功能就强大了许多，创建，然后进行变换。甚至这里就类似于一条生产线。先做出一个原型，然后再进行各种加工，最后出我们想要的成品。
*/

/*:
### `map`

map 就是用你指定的方法去**变换每一个值**，这里非常类似 Swift 中的 map ，特别是对 SequenceType 的操作，几乎就是一个道理。一个一个的改变里面的值，并返回一个新的 functor 。

![map](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/map.png)
*/

let disposeBag = DisposeBag()


let originalSequence = Observable.of(1, 2, 3)
    
originalSequence
    .map { number in
        number * 2
    }
    .subscribe { print($0) }
    .addDisposableTo(disposeBag)

/*:
#### `mapWithIndex`

这是一个和 map 一起的操作，唯一的不同就是我们有了 **index** ，注意第一个是序列发射的值，第二个是 index 。
*/

originalSequence
    .mapWithIndex { number, index in
        number * index
    }
    .subscribe { print($0) }
    .addDisposableTo(disposeBag)

/*:
### `flatMap`

将一个序列发射的值**转换成序列**，然后将他们压平到一个序列。这也类似于 SequenceType 中的 `flatMap` 。

![flatMap](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/flatmap.png)

我们来看这个有趣的例子：
*/

let sequenceInt = Observable.of(1, 2, 3)

let sequenceString = Observable.of("A", "B", "C", "D", "E", "F", "--")

sequenceInt
    .flatMap { (x:Int) -> Observable<String> in
        print("from sequenceInt \(x)")
        return sequenceString
    }
    .subscribe {
        print($0)
    }
    .addDisposableTo(disposeBag)

/*:
可以看到每当 `sequenceInt` 发射一个值，最终订阅者都会依次收到 `A` `B` `C` `D` `E` `F` `--` ，但不会收到 Complete 。也就是说我们将三次转换的三个序列都压在了一起。只是这里的变换是每当发射一个整数，就发射一系列的字母和符号 `--` 。这很有意思，比简单的 map 强大很多。当你遇到数据异步变换或者更复杂的变换，记得尝试 `flatMap` 。比如像这样：

Observable.of(1, 2, 4)
.flatMap {  fetch($0) }
.subscribe {
print($0)
}
.addDisposableTo(disposeBag)
*/

/*:
#### `flatMapFirst`

将一个序列发射的值**转换成序列**，然后将他们压平到一个序列。这也类似于 SequenceType 中的 `flatMap` 。

![flatMap](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/flatmap.png)
*/

/*:
#### `flatMapLatest`

将一个序列发射的值**转换成序列**，然后将他们压平到一个序列。这也类似于 SequenceType 中的 `flatMap` 。

![flatMap](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/flatmap.png)
*/


/*:
#### `flatMapIndex`

将一个序列发射的值**转换成序列**，然后将他们压平到一个序列。这也类似于 SequenceType 中的 `flatMap` 。

![flatMap](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/flatmap.png)

*/



/*:
### `scan`

应用一个 accumulator (累加) 的方法遍历一个序列，然后**返回累加的结果**。此外我们还需要一个初始的累加值。实时上这个操作就类似于 Swift 中的 `reduce` 。

![scan](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/scan.png)
*/

let sequenceToSum = Observable.of(0, 1, 2, 3, 4, 5)

sequenceToSum
    .scan(0) { acum, elem in
        acum + elem
    }
    .subscribe {
        print($0)
    }.addDisposableTo(disposeBag)

/*:
图片就对应了这段代码的意思，每接收到一个值，就和上一次的累加值加起来并发射。这是一个很有趣的功能，你可以参见一下官方的计算器 Demo ，很有意思。记得，这里的 `scan` 以及 `reduce`  可不仅仅是只能用来累加，这是一个遍历所有值得过程，所以你可以在这做任何你想做的操作。
*/

/*:
### `reduce`
和 `scan` 非常相似，唯一的不同是， `reduce` 会在序列结束时才发射最终的累加值。就是说，最终**只发射一个最终累加值**
*/

sequenceToSum
    .reduce(0) { acum, elem in
        acum + elem
    }
    .subscribe {
        print($0)
    }.addDisposableTo(disposeBag)

/*:
### `buffer`
在特定的线程，定期定量收集序列发射的值，然后发射这些的值的集合。

![buffer](http://reactivex.io/documentation/operators/images/Buffer.png)
*/

sequenceToSum
    .buffer(timeSpan: 5, count: 2, scheduler: MainScheduler.instance)
    .subscribe {
        print($0)
    }.addDisposableTo(disposeBag)

/*:
### `window`

window 和 buffer 非常类似。唯一的不同就是 window 发射的是序列， buffer 发射一系列值。

![window](http://reactivex.io/documentation/operators/images/window.C.png)

我想这里对比 buffer 的图解就很好理解 window 的行为了。

我们可以看 API 的不同：
/// buffer
public func buffer(timeSpan timeSpan: RxSwift.RxTimeInterval, count: Int, scheduler: SchedulerType) -> RxSwift.Observable<[Self.E]>
/// window
public func window(timeSpan timeSpan: RxSwift.RxTimeInterval, count: Int, scheduler: SchedulerType) -> RxSwift.Observable<RxSwift.Observable<Self.E>>
从返回结果可以看到 `buffer` 返回的序列发射的值是 `[Self.E]` ，而 `window` 是 `RxSwift.Observable<Self.E>` 。
*/

sequenceToSum
    .window(timeSpan: 5, count: 2, scheduler: MainScheduler.instance)
    .subscribe {
        print($0)
    }.addDisposableTo(disposeBag)


//: [目录](@Index) - [下一节 >>](@next)
