//: [上一节](@previous) - [目录](Index)

import RxSwift

/*:
## Combination operators

我们可以用下面的这些操作来组合多个序列。

Operators that work with multiple source Observables to create a single Observable.
*/

/*:

### `startWith`

在一个序列前插入一个值。

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/startwith.png)

*/
example("startWith") {
    
    let subscription = Observable.of(4, 5, 6, 7, 8, 9)
        .startWith(3)
        .startWith(2)
        .subscribe {
            print($0)
    }
}

/*:
我们可以看到输出是 2 3 4 5 6 7 8 9 ，在 4 前面插入了一个 3 ，然后又在 3 前面插入了一个 2 。有什么用呢，当然有用啦。我们可以用这样的方式添加一些默认的数据。当然也可能我们会在末尾添加一些默认数据，这个时候需要使用 `concat` 。
*/

/*:
### `combineLatest`

当两个序列中的任何一个发射了数据时，`combineLatest` 会结合并整理每个序列发射的最近数据项。

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/combinelatest.png)

来看一个例子。

*/
example("combineLatest 1") {
    let intOb1 = PublishSubject<String>()
    let intOb2 = PublishSubject<Int>()
    let intOb3 = PublishSubject<Int>()
    
    _ = Observable.combineLatest(intOb1, intOb2) {
        "(\($0) \($1))"
        }
        .subscribe {
            print($0)
    }
    
    intOb1.on(.Next("A"))
    
    intOb2.on(.Next(1))
    
    intOb1.on(.Next("B"))
    
    intOb2.on(.Next(2))
    
}

/*
输出是 (A 1) (B 1) (B 2) 。可以看到每当有一个序列发射值得时候， `combineLatest` 都会结合一次发射一个值。需要注意的有两点：

* 我们都要去传入 `resultSelector` 这个参数，一般我们做尾随闭包，这个是对两（多）个序列值的处理方式，上面的例子就是将序列一和二的值变成字符串，中间加个空格，外面再包一个`()` .
* Rx 在 `combineLatest` 上的实现，只能结合 8 个序列。再多的话就要自己去拼接了。
*/

/*:
来看一个有趣的 combineLatest 2 例子：
可以很容易判断序列最终发射了 5 次，因为最长的序列是 5 次。但是数据并没有和想象中的结果一样。
直观的看，我们期待的是：

2
0  1  2  3
0  1  2  3  4
-------------
0  3  8  15 20
// TODO: - 等待加图

事实上因为线程是单一的，实际的发射是这样的：

2  
   0  1  2  3
               0  1  2  3  4
----------------------------
               0  5  10 15 20

*/

example("combineLatest 2") {
    let intOb1 = Observable.just(2)
    let intOb2 = Observable.of(0, 1, 2, 3)
    let intOb3 = Observable.of(0, 1, 2, 3, 4)
    
    _ = Observable.combineLatest(intOb1, intOb2, intOb3) {
//        ($0 + $1) * $2
        "\($0) \($1) \($2)"
        }
        .subscribe {
            print($0)
    }

}

/*:
再看一个 combineLatest 2 T 的例子，我想这会帮你理解这个和上一个有什么不同。
*/

example("combineLatest 2 T") {
    let intOb1 = Observable.just(2)
    let intOb2 = ReplaySubject<Int>.create(bufferSize: 1)
    intOb2.onNext(0)
    let intOb3 = Observable.of(0, 1, 2, 3, 4)
    intOb2.onNext(1)
    
    _ = Observable.combineLatest(intOb1, intOb2, intOb3) {
        //        ($0 + $1) * $2
        "\($0) \($1) \($2)"
        }
        .subscribe {
            print($0)
    }
    intOb2.onNext(2)
    intOb2.onNext(3)
    
}

/*:
还有一个有趣的事情，来看 combineLatest 3 的例子：
你可以直接在 Array （元素为 `ObservableType` ）上直接调用 `combineLatest` 。
*/

example("combineLatest 3") {
    let intOb1 = Observable.just(2)
    let intOb2 = Observable.of(0, 1, 2, 3)
    let intOb3 = Observable.of(0, 1, 2, 3, 4)
    
    _ = [intOb1, intOb2, intOb3].combineLatest { intArray -> Int in
        Int((intArray[0] + intArray[1]) * intArray[2])
        }
        .subscribe { (event: Event<Int>) -> Void in
            print(event)
    }
}

/*:
### `zip`

`zip` 和 `combineLatest` 相似，不同的是每当所有序列都发射一个值时， `zip` 才会发送一个值。它会等待每一个序列发射值，发射次数由最短序列决定。结合的值都是一一对应的。

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/zip.png)

*/
example("zip 1") {
    let intOb1 = PublishSubject<String>()
    let intOb2 = PublishSubject<Int>()
    
    _ = Observable.zip(intOb1, intOb2) {
        "(\($0) \($1))"
        }
        .subscribe {
            print($0)
    }
    
    intOb1.on(.Next("A"))
    
    intOb2.on(.Next(1))
    
    intOb1.on(.Next("B"))
    
    intOb1.on(.Next("C"))
    
    intOb2.on(.Next(2))
}

/*:
可以在这个例子中看到和 combineLatest 1 不同，这里的 `zip` 会配对的进行合并，也就是说 intOb1 虽然发射了 "C" ，但是 `zip` 仍然是结合 "B" 2 。
*/

/*:
下面这个 zip 2 的例子就更明显了：
*/

example("zip 2") {
    let intOb1 = Observable.of(0, 1)
    let intOb2 = Observable.of(0, 1, 2, 3)
    let intOb3 = Observable.of(0, 1, 2, 3, 4)
    
    _ = Observable.zip(intOb1, intOb2, intOb3) {
        ($0 + $1) * $2
        }
        .subscribe {
            print($0)
    }
}

/*:
### `merge`

`merge` 会将多个序列合并成一个序列，序列发射的值按先后顺序合并。要注意的是 `merge` 操作的是序列，也就是说序列发射序列才可以使用 merge 。来看例子：

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/merge.png)
*/
example("merge 1") {
    let subject1 = PublishSubject<Int>()
    let subject2 = PublishSubject<Int>()
    
    _ = Observable.of(subject1, subject2)
        .merge()
        .subscribe {
            print($0)
    }
    
    subject1.on(.Next(20))
    subject1.on(.Next(40))
    subject1.on(.Next(60))
    subject2.on(.Next(1))
    subject1.on(.Next(80))
    subject1.on(.Next(100))
    subject2.on(.Next(1))
}

/*:
我们通过 `of` 操作将 subject1 和 subject2 作为序列的值按顺序发射。这里发射的就是序列，我们才可以调用 `merge` 这个操作。
*/

/*:
来看这个 merge 2 的例子：
merge 可以传递一个 `maxConcurrent` 的参数，你可以通过传入指定的值说明你想 merge 的最大序列。直接调用 `merge()` 会 merge 所有序列。你可以试试将这个 merge 2 的例子中的 `maxConcurrent` 改为 1 ，可以看到 `subject2` 发射的值都没有被合并进来。
*/
example("merge 2") {
    let subject1 = PublishSubject<Int>()
    let subject2 = PublishSubject<Int>()

    _ = Observable.of(subject1, subject2)
        .merge(maxConcurrent: 2)
        .subscribe {
            print($0)
    }
    subject1.on(.Next(20))
    subject1.on(.Next(40))
    subject1.on(.Next(60))
    subject2.on(.Next(1))
    subject1.on(.Next(80))
    subject1.on(.Next(100))
    subject2.on(.Next(1))
    
}


/*:
### `switchLatest`

`switchLatest` 和 `merge` 有一点相似，都是用来合并序列的。然而这个合并并非真的是合并序列。事实是每当发射一个新的序列时，丢弃上一个发射的序列。来看下面的例子：

![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/switch.png)
*/
example("switchLatest") {
    let var1 = Variable(0)
    
    let var2 = Variable(200)
    
    // var3 是一个 Observable<Observable<Int>>
    let var3 = Variable(var1.asObservable())
    
    let d = var3
        .asObservable()
        .switchLatest()
        .subscribe {
            print($0)
    }
    
    var1.value = 1
    var1.value = 2
    var1.value = 3
    var1.value = 4
    
    var3.value = var2.asObservable() // 我们在这里新发射了一个序列
    
    var2.value = 201
    
    var1.value = 5 // var1 发射的值都会被忽略
    var1.value = 6
    var1.value = 7
}

/*:
好了，到这里我们就可以尝试做点东西看看了，下一节我们来熟悉一下创建、变换、过滤、合并的操作。
*/

//: [目录](@Index) - [下一节 >>](@next)
