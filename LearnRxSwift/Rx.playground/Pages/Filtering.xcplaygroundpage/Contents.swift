//: [上一节](@previous) - [目录](Index)

import RxSwift

playgroundShouldContinueIndefinitely()

/*:
## 过滤 Observable

当我们有了变换操作时，就可以做很多事情了，然而有了过滤操作，对于队列的处理就更加轻松了。
过滤操作就是指去掉我们不喜欢的值，不再继续向下发射我们讨厌的值。

*/

/*:
### `filter`

filter 应该是最常用的一种过滤操作了。传入一个返回 `bool` 的闭包决定是否去掉这个值。

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/filter.png)

*/

let disposeBag = DisposeBag()

example("filter") {
    Observable.of(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
        .filter {
            $0 % 2 == 0
        }
        .subscribe {
            print($0)
        }
        .addDisposableTo(disposeBag)
}


/*:
可以从这个例子中看到我们过滤掉了所有奇数。 `filter` 有一个很常见的场景，黑名单，就比如朋友圈，产品狗突然想来一个黑名单功能，这时我们一个 `filter` 就完成了。
*/

/*:
### `distinctUntilChanged`

阻止发射与上一个重复的值。

*/

example("distinctUntilChanged") {
Observable.of(1, 2, 3, 1, 1, 4)
    .distinctUntilChanged()
    .subscribe {
        print($0)
    }
    .addDisposableTo(disposeBag)
}

/*:
可以看到后半段序列 1 1 4 的第二个 1 被阻止掉了。
*/

/*:
### `take`

只发射指定数量的值。

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/take.png)

*/

example("take") {
Observable.of(1, 2, 3, 4, 5, 6)
    .take(3)
    .subscribe {
        print($0)
    }
    .addDisposableTo(disposeBag)
}

/*:
可以看到经过 take(3) 之后，只发射了前三个值。
*/

/*:
### `takeLast`

只发射序列结尾指定数量的值。

> 这里要注意，使用 `takeLast` 时，序列一定是有序序列，`takeLast` 需要序列结束时才能知道最后几个是哪几个值。所以 `takeLast` 会等序列结束才向后发射值。如果你需要舍弃前面的某些值，你需要的是 `skip` 。

*/

example("takeLast") {
Observable.of(1, 2, 3, 4, 5, 6)
    .takeLast(3)
    .subscribe {
        print($0)
    }
    .addDisposableTo(disposeBag)
}

/*:
可以看到经过 takeLast(3) 之后，只发射了后三个值。
*/

/*:
### `skip`

忽略指定数量的值。

*/

example("skip") {
Observable.of(1, 2, 3, 4, 5, 6)
    .skip(3)
    .subscribe {
        print($0)
    }
    .addDisposableTo(disposeBag)
}

/*:
可以看到经过 skip(3) 之后，前三个值并没有继续发射下去。
*/

/*:
### `debounce` / `throttle`

仅在过了一段指定的时间还没发射数据时才发射一个数据，换句话说就是 `debounce` 会抑制发射过快的值。注意这一操作需要指定一个线程。来看下面这个例子。

> `debounce` 和 `throttle` 是同一个东西。

*/

example("debounce / throttle") {
Observable.of(1, 2, 3, 4, 5, 6)
    .debounce(1, scheduler: MainScheduler.instance)
    .subscribe {
        print($0)
    }
    .addDisposableTo(disposeBag)
}

/*:
可以看到只发射了一个 6 ，因为这个序列发射速度是非常快的，所以过滤掉了前面发射的值。有一个很常见的应用场景，比如点击一个 Button 会请求一下数据，然而总有刁民想去不停的点击，那这个 `debounce` 就很有用了。
*/

/*:
### `elementAt`

使用 `elementAt` 就只会发射一个值了，也就是指发射序列指定位置的值，比如 `elementAt(2)` 就是只发射第二个值。

> 注意序列的计算也是从 0 开始的。

*/

example("elementAt") {
Observable.of(1, 2, 3, 4, 5, 6)
    .elementAt(2)
    .subscribe {
        print($0)
    }
    .addDisposableTo(disposeBag)
}

/*:
可以看到值发射了一个 3 ，也就是序列的第二个值。这个也有一些应用场景，比如点击几次就如何如何的。
*/

/*:
### `single`

`single` 就类似于 `take(1)` 操作，不同的是 `single` 可以抛出两种异常： `RxError.MoreThanOneElement` 和 `RxError.NoElements` 。当序列发射多于一个值时，就会抛出 `RxError.MoreThanOneElement` ；当序列没有值发射就结束时， `single` 会抛出 `RxError.NoElements` 。

*/

example("single") {
    Observable.of(1, 2, 3, 4, 5, 6)
        .single()
        .subscribe {
            print($0)
        }
        .addDisposableTo(disposeBag)
}

/*:
可以看到，我们的示例中抛出了 `Sequence contains more than one element.` 的异常。
*/

/*:
### `sample`

`sample` 就是抽样操作，按照 `sample` 中传入的序列发射情况进行抽样。

> 如果源数据没有再发射值，抽样序列就不发射，也就是说不会重复抽样。

*/

example("sample") {
Observable<Int>.interval(0.1, scheduler: SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
    .take(100)
    .sample(Observable<Int>.interval(1, scheduler: SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background)))
    .subscribe {
        print($0)
    }
    .addDisposableTo(disposeBag)
}

/*:
在这个例子中我们使用 `interval` 创建了每 0.1s 递增的无限序列，同时用 `take` 只留下前 100 个值。抽样序列是一个每 1s 递增的无限序列。
*/

/*:
以上就是基本的过滤操作了，记得用它们去掉讨厌的数据。
*/

//: [目录](@Index) - [下一节 >>](@next)
