---
title: Value and Reference Types
htmltitle: "Value and Reference Types in Swift"
date: "2014-09-17"
description: "Know your type differences and use the right one"
---

{{% playground tips="Switch the definition of an object between struct and class to see how the data changes" filename="ValueAndReferenceTypes.zip" %}}

Since we took a rather long hiatus before iOS 8 rolled out, I figure we would start again with a simple introduction to value and reference types in Swift as well as a test of our new demo playgrounds.

A couple weeks ago, Apple posted a short article about the difference between [value and reference types in Swift](https://developer.apple.com/swift/blog/?id=10). **The short and long of it is that `struct`, `enum` and `tuple` objects are all value types and objects defined as `class` are reference types.** Value type data is copied when you assign it around whereas reference type data is passed by reference and points to the same underlying data.

We’re used to dealing with reference types in Objective-C. For those of you coming from an Objective-C background, this example should not strike you as surprising:

{{< highlight objectivec >}}
DemoObject *obj1 = [[DemoObject alloc] init];
obj1.name = @"hello";

DemoObject *obj2 = obj1;
obj2.name = @"what";

// prints “what what”
NSLog(@"%@ %@",obj1.name,obj2.name);
{{< /highlight >}}

Though it’s possible to pass around values in Objective-C, you’re probably used to this kind of thing because you deal with mostly `NSObject` subclasses, not a lot of base C types.

The difference in Swift is expressed succinctly in the *Value and Reference Types* post but I’ll reproduce the above example in Swift to demonstrate.

As a struct (i.e. a **value** type):

{{< highlight swift >}}
struct DemoObject {
    var name = "hello"
}

var obj1 = DemoObject()
var obj2 = obj1

obj2.name = "what"

// prints “hello what”
println("\(obj1.name) \(obj2.name)")
{{< /highlight >}}

And as a class (i.e. a **reference** type):

{{< highlight swift >}}
class DemoObject {
    var name = "hello"
}

var obj1 = DemoObject()
var obj2 = obj1

obj2.name = "what"

// prints “what what”
println("\(obj1.name) \(obj2.name)")
{{< /highlight >}}

Literally, the only thing different between the two examples is `struct` and `class` in the object definition. This effect is best seen for yourself. Download the example playground at the top of this post and try it out yourself.

<!-- When you're done here, move on to when you want to use value types over reference types in Swift with [Mutability and Synchronization](/mutability-and-synchronization). -->
