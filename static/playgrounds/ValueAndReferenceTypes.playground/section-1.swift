// Value and Reference Types
// http://thatthinginswift.com/value-and-reference-types/
//
// a playground from That Thing in Swift

import UIKit

// switch the definition of `DemoObject` by commenting out
// one of two lines below, you'll note the differences produced
// by the last `print` statement

//class DemoObject {
struct DemoObject {
    var name = "hello"
}

var obj1 = DemoObject()
var obj2 = obj1

obj2.name = "what"

// if you're using the struct type, this should output "hello what"
// for the class type, this should output "what what"
print("\(obj1.name) \(obj2.name)")
