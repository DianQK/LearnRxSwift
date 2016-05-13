/*:
# RxSwift 基本概念

> 如果需要运行 Playground 示例，请先按以下步骤操作：

1. 打开 `LearnRxSwift.xcworkspace`
2. 编译运行 `RxSwift` scheme
3. 在 `LearnRxSwift.xcworkspace` 中打开 `Rx`
4. 选择 `View > Show Debug Area`
*/

/*:
## 本章目录:

1. [创建序列 Observable](Observable)
2. [什么是 Subject](Subject)
3. [变换 Observables](Transforming)
4. [过滤 Observables](Filtering)
5. [合并 Observables](Combining)
6. [错误处理](Error_Handing)
7. [其他操作符](Other)

*/

//: [目录](Index) - [下一节 >>](@next)

import RxSwift


class Foo {
    let bar: Int
    
    init(bar: Int) {
        self.bar = bar
    }
    
    deinit {
        print("Deinit \(bar)")
    }
}




enum ErrorSS: Int, ErrorType {
    case Foo = 2
    
    var _code: Int {
        return rawValue
    }
}


print(ErrorSS.Foo._code)


