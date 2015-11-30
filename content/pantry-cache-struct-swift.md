---
title: Pantry, a light struct caching library
date: "2015-11-30"
htmltitle: "Pantry, a light struct caching library"
description: "The missing light persistence layer for Swift"
---
Looking through one of my recent Swift apps, I realized how frequently I persist (or want to persist) little pieces of data.

* Feature flags (does the user have access to x?)
* User preferences (turn on/off reminder notifications)
* Tracking flow (has the user been on this screen before?)
* Sharing data (pre-populate fields with previously entered data)

And whenever I think about what to use for persistence, I think back to this post on NSHipster:

<br />
![NSHipster](/images/nshipster-nskeyedarchiver.png)
<br /><br />

And that's totally true for Objective-C. NSKeyedArchiver was the way to go for many projects. But we’ve come to expect a different definition of “**Not a Pain in the Ass**” since transitioning from Objective-C to Swift and for this case, I think we deserve something better than `NSKeyedArchiver`. Not just something written in Swift (of which there are a few) but something that feels at home with the rest of your Swift code.

### This is Pantry, a simple and opinionated way to store basic types and structs in Swift with no setup ###

<br />
<div align="center">
<img src="/images/pantry.png" alt="Pantry" />
</div>
<br /><br />

This started as a project to simply store native structs because that's something that `NSKeyedArchiver` simply *cannot* do. I use structs everywhere and I was frustrated by having to turn those into `@objc WhateverClass: NSObject` if I wanted to persist them for any meaningful length of time.

It's grown out of that initial use case to be slightly more general because that's how I've been using it. As soon I realized I could store structs easily, I've started thinking about what I could accomplish by persisting basic types in a really straightforward way.

It's best shown rather than explained, let's get to a few use cases:

### Simple Expiring Cache Functionality ###

At its most basic, Pantry is a nice cache layer for basic types. In this example, a feature is turned on or off by some expensive operation (network request, lots of processing, etc) but the status could change somewhat frequently so we don't want to fetch it once and cache it forever.

Instead, we check for a Pantry value and report the results if it exists. If it doesn't exist, we'll do our expensive operation and then set the result as a cached `Bool` for 10 minutes.

{{<highlight swift>}}
if let available: Bool = Pantry.unpack("promptAvailable") {
    completion(available: available)
} else {
    anExpensiveOperationToDetermineAvailability({ (available) -> () in
      Storage.pack(available, key: "promptAvailable", expires: .Seconds(60 * 10))
      completion(available: available)
    })
}
{{</highlight>}}

At the end of 10 minutes, `Pantry.unpack()`` will return nil again and you can do your expensive operation to determine the status.

The benefit of using Pantry over some of the existing options like [AwesomeCache](https://github.com/aschuch/AwesomeCache) or [Haneke](https://github.com/Haneke/HanekeSwift) is that you can also store structs with minimal boilerplate code, so your cache that was maybe unstructured dictionary values with magic keys or multiple cache values is now just one strongly typed struct with transparent contents.

### Automagic Persistent Variables ###

Perhaps the most interesting use case I've created when working with Pantry is the concept of a property on a class or struct that is automatically persisted across launches. This feels weird and unintuitive at first but I've found a few places where it's immensely helpful.

Luckily, between Pantry and Swift, this is pretty easy to set up.

{{<highlight swift>}}
var autopersist: String? {
    set {
        if let newValue = newValue {
            Pantry.pack(newValue, key: "autopersist")
        }
    }
    get {
        return Pantry.unpack("autopersist")
    }
}
{{</highlight>}}

This is a standard property on your view controller or what-have-you. It’s written to disk whenever you write to the variable and read from disk whenever you read it. That’s nothing special by itself but the simplicity is what makes this a nice part of your overall view controller composition.

And, just like before, this is a simple example with a `String` where a struct with a few useful fields could be substituted.

### The Alternatives ###

In both of these situations, you’d have to write a lot more code dealing with `NSKeyedArchiver` just to get this functionality working with the standard `NSCoding` compliant types. Defining where your cache lives, managing reading and writing and even thinking about how your data is stored.

With Pantry, you get one-line reads and writes for basic types and a minimal amount of setup code (just on the decoding step, not both ways!) gives you support for arbitrary structs. It’s significantly less effort than the alternative.

### Goals for Pantry ###

A couple driving goals I have:
* Ease of use/understanding
* Minimal boilerplate code
* Speed

And, just as importantly, things we don't need to do:
* Objective-C support
* Queries
* Cache format control

I want to be clear about the things I don’t consider important for two reasons:

a) A tool doesn’t have to support every use case. In fact, I’d say the best tools for the job are those that are built with a clear vision of one job in mind. And thanks to open source software, you can adapt this for another job if that makes it better for you.

b) The user doesn’t have to decide every detail. Yes, we could let you decide if you want your data in binary or plist format, or encrypted on disk. But that’s more decisions for you and more chance that some of you will get it wrong. Instead, we’ll do the work to make sure it conforms to our goals: easy, simple and fast.

### Previously, Storage ###

I presented the notable parts of how Pantry works at Swift Summit SF in October only at the time it was called **Storage**. One persistent question was about how well this would hold up for large objects with lots of structs and sub-structs, or how to query these objects. I realized afterwards that the name Storage was misleading: it’s not a general purpose storage for your app but it’s great for these smaller use cases that I’ve outlined here. It’s still early enough that the change to Pantry was painless and quick.

For cases with large networks of objects, you're always better off going with a real data store like Core Data or [Realm](https://realm.io/). Pantry is never going to do those things because that's not one of our goals. Plenty of people have devoted plenty of hours to make these tools great, you should use them as they're intended.

But these things work great side-by-side. From my perspective, there is a need for minimal, easily accessible way to store and retrieve small data in Swift, regardless of your primary storage mechanism. Pantry is currently beta software but I’ve written lots of tests and I’m using it in production today. Come help out at [github](https://github.com/nickoneill/Pantry) or just start using it in your projects with Cocoapods or Carthage.

Pantry is the second open source framework that has spawned from our work on [treat](https://treatHQ.com) - the first was [PermissionScope](https://github.com/nickoneill/PermissionScope) which recently passed 1700 stars on Github. Get in touch if this kind of thing interests you.
