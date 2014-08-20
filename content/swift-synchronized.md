---
title: “Mutability and Locking“
date: "2014-08-17"
draft: true
description: ""
---
The most recent blog post on the Apple Swift blog, [Value and Reference Types](https://developer.apple.com/swift/blog/?id=10), reminded me of using `@synchronized` in Objective-C and some digging about how best to achieve the same thing in Swift. That is, after all, the whole point of this blog.

I suspect that at least a few iOS developers are unfamiliar with the details of locking in Objective-C simply because we had to think about concurrency only in very limited scenarios. Most of the time is spent on the main thread dealing with updating UI and doing trivial data transformation that won’t prevent us from achieving 60 frames per second. Occasionally you toss a blocking task to a [background thread](/background-threads/) but rarely do we need to think about more than one task needing access to mutable data at the same time.

Obviously this depends greatly on your situation and the kind of apps you’re building but I find it to be mostly true in my work and I suspect many others agree. You can get away with quite a lot of background tasks without knowing a damn thing about mutability and locking. Considering that we’re dealing with the same class of apps and the same APIs, I don’t expect the situation will change with Swift (and it will probably be easier as I’ll explain shortly).

Back to the newest Apple Swift blog post. The short and long of it is that `struct`, `enum` and `tuple` objects are all value types and objects defined as `class` are reference types. Value type data is copied when you assign it around whereas reference type data is passed by reference and points to the same underlying data.

We’re used to dealing with reference types in Objective-C. This example should not strike you as a surprise:

{{% prism objectivec %}}MatchObject *obj1 = [[MatchObject alloc] init];
obj1.name = @"hello";

MatchObject *obj2 = obj1;
obj2.name = @"what";

// prints “what what”
NSLog(@"%@ %@",obj1.name,obj2.name);
{{% /prism %}}

Though it’s possible to pass around values in Objective-C, you’re probably used to this kind of thing because you deal with mostly `NSObject` subclasses, not a lot of base C types.

The difference in Swift is expressed succinctly in the *Value and Reference Types* post but I’ll reproduce the above example in Swift to demonstrate.

As a struct (i.e. a value type):
{{% prism swift %}}struct MatchObject {
    var name = "hello"
}

var obj1 = MatchObject()
var obj2 = obj1

obj2.name = "what"

// prints “hello what”
println("\(obj1.name) \(obj2.name)")
{{% /prism %}}

And as a class (i.e. a reference type):
{{% prism swift %}}class MatchObject {
    var name = "hello"
}

var obj1 = MatchObject()
var obj2 = obj1

obj2.name = "what"

// prints “what what”
println("\(obj1.name) \(obj2.name)")
{{% /prism %}}

Literally, the only thing different between the two examples is `struct` and `class` in the object definition.

In addition to the push for more constants in Swift (you know to use `let` whenever possible, right?), these value types help prevent weird concurrency issues when you’re changing data that other threads are trying to access.

So let’s say you *know* you’re going to run into these issues either because you’re changing a `var` or  
