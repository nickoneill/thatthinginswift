// Playground - noun: a place where people can play

import UIKit
import XCPlayground


XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)

let queuePriority = DISPATCH_QUEUE_PRIORITY_BACKGROUND

class aThing {

    var someArray: [String] = Array(count: 20, repeatedValue: "ok")

    func appendToArray(string: String) {
//        objc_sync_enter(self)

        for i in 0..<10 {
            self.someArray.append(string)
        }

        println("appending \(string)")
        println(self.someArray)
//        objc_sync_exit(self)
    }

    func doAThing() {

        dispatch_async(dispatch_get_global_queue(queuePriority, 0)) {
            self.appendToArray("food")
        }

        dispatch_async(dispatch_get_global_queue(queuePriority, 0)) {
            self.appendToArray("mead")
        }
    }
}

let thing = aThing()
thing.doAThing()

let wait = Int64(4 * NSEC_PER_SEC)
let time = dispatch_time(DISPATCH_TIME_NOW, wait)
dispatch_after(time, dispatch_get_global_queue(queuePriority, 0)) { () -> Void in
    println("finshing")
    println(thing.someArray)
}
