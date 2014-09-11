---
title: Mutability and Locking
date: "2014-08-17"
description: ""
draft: false
---

{{% playground %}}

The most recent blog post on the Apple Swift blog, [Value and Reference Types](https://developer.apple.com/swift/blog/?id=10), reminded me of using `@synchronized` in Objective-C and some digging about how best to achieve the same thing in Swift. That is, after all, the whole point of this blog.

I suspect that at least a few iOS developers are unfamiliar with the details of locking in Objective-C simply because we had to think about concurrency only in very limited scenarios. Most of the time is spent on the main thread dealing with updating UI and doing trivial data transformation that won’t prevent us from achieving 60 frames per second. Occasionally you toss a blocking task to a [background thread](/background-threads/) but rarely do we need to think about more than one task needing access to mutable data at the same time.

Obviously this depends greatly on your situation and the kind of apps you’re building but I find it to be mostly true in my work because I tend to focus on UI-based apps that are technically (computer science-wise) fairly simple. You can get away with quite a lot of background tasks without knowing a damn thing about mutability and locking. Considering that we’re dealing with the same class of apps and the same APIs, I don’t expect the situation will change with Swift (and it will probably be easier as I’ll explain shortly).


In addition to the push for more constants in Swift (you know to use `let` whenever possible, right?), these value types help prevent weird concurrency issues when you’re changing data that other threads are trying to access.

So let’s say you *know* you’re going to run into these issues either because you’re changing a `var` or  
