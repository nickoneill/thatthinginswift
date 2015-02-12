//
//
// a playground from That Thing in Swift

import UIKit
import XCPlayground

// IMPORTANT NOTE
// open the timeline with cmd-opt-enter to see the results in the console output

// our Swift version of synchronized
// comment out the enter/exit lines to see unusual results
func synchronized(toLock: NSLock, closure: () -> Void) {
//    objc_sync_enter(toLock)
//    toLock.lock()
    closure()
//    toLock.unlock()
//    objc_sync_exit(toLock)
}

// build an initial array with some data
var someArray: [String] = Array(count: 2, repeatedValue: "xxx")

// this function simply loops x times and appends a passed string
// to the array, using our Swift version of @synchronized
func appendToArray(string: String) {
    let lock = NSLock()
    synchronized(lock) {
        for i in 0..<10 {
            someArray.append(string)
        }
        println("appending \(string)")
        println(someArray)
    }
}

// starting two background threads to append things to the same array
let queuePriority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
dispatch_async(dispatch_get_global_queue(queuePriority, 0)) {
    appendToArray("zzz")
}

dispatch_async(dispatch_get_global_queue(queuePriority, 0)) {
    appendToArray("vvv")
}

// after 2 seconds, print out the resulting array
let wait = Int64(2 * NSEC_PER_SEC)
let time = dispatch_time(DISPATCH_TIME_NOW, wait)
dispatch_after(time, dispatch_get_global_queue(queuePriority, 0)) { () -> Void in
    println(someArray)
}

// continue running so our final array print occurs
XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)
