import Foundation
import XCPlayground

public func example(description: String, action: () -> ()) {
    print("\n--- \(description) example ---")
    action()
}

public func playgroundShouldContinueIndefinitely() {
    XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
}