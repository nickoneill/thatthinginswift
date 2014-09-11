---
title: “Value and Reference Types“
date: "2014-08-19"
draft: true
description: ""
---
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
