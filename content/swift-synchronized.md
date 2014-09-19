---
title: Synchronized in Swift
date: "2014-08-17"
description: "Keeping mutable data safe when using background threads"
draft: false
---

{{% playground %}}

One of the recent blog posts on the Apple Swift blog, [Value and Reference Types](https://developer.apple.com/swift/blog/?id=10), reminded me of using `@synchronized` in Objective-C and I did some digging about how best to achieve the same in Swift. That is, after all, the whole point of this thing.

I suspect that at least a few iOS developers are unfamiliar with the details of locking in Objective-C simply because we had to think about concurrency only in very limited scenarios. Most of the time is spent on the main thread dealing with updating UI and doing trivial data transformation that won’t prevent us from achieving 60 frames per second. Occasionally you toss a blocking task to a [background thread](/background-threads/) but rarely do we need to think about more than one task needing access to mutable data at the same time.

This depends greatly on your situation and the kind of apps you’re building but I find it to be mostly true in my work because I tend to focus on UI-based apps that are technically (computer science-wise) fairly simple. You can get away with quite a lot of background tasks without knowing a damn thing about mutability and when you should be locking. Considering that we’re dealing with the same class of apps and the same APIs, I don’t expect the situation will change with Swift.

But let’s say you *know* you’re going to run into these issues either because you’re changing a single `var` on multiple threads or managing data in a few arrays in lots of different places. You've got to know how to lock mutable data structures so you don't run into weird and usually inexplicable behavior.

Even though we don't have access to the same `@synchronized` keyword that we used in Objective-C, we can access the underlying API and form our own easy to use closure-based locking mechanism.

Here's what we did in Objective-C



One of the benefits of using value types over clases is that value types help prevent weird concurrency issues when you’re changing data that other threads are trying to access. The less shared mutability you have, the better off you are when working on multiple threads.
