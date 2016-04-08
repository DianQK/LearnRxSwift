//: [上一节](@previous) - [目录](Index)

import RxSwift

struct Error: ErrorType {}

let observable1 = Observable<Int>.create { observer in
    observer.onNext(1)
    observer.onNext(2)
    observer.onNext(3)
    observer.onNext(4)
    observer.onNext(5)
    observer.onCompleted()
    return NopDisposable.instance
    }

let observable2 = Observable<Int>.create { observer in
    observer.onNext(11)
    observer.onNext(22)
    observer.onError(Error())
    return NopDisposable.instance
}

let observable3 = Observable<Int>.create { observer in
    observer.onNext(111)
    observer.onNext(222)
    observer.onNext(333)
    observer.onCompleted()
    return NopDisposable.instance
}

_ = observable1.flatMap { value -> Observable<Int> in
    if value == 2 {
        return observable2
    } else {
        return observable3
    }
    }.subscribe {
        print($0)
}

//: [目录](@Index) - [下一节 >>](@next)
