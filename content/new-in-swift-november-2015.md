---
title: "New in Swift, November 2015"
date: "2015-11-07"
tags: ["new-in-swift"]
description: "Apple TV, Phone Numbers, Swift Summit and Storage"
---
November's top picks for new Swift libraries or tools! Plus a special rundown from Swift Summit in San Francisco.

**The new Apple TV**

The new Apple TV release means we have a plethora of new example code that runs on the device. Two notable items I saw were this emulator frontend [Provenance](https://github.com/jasarien/Provenance) and a [streaming BBC frontend](https://github.com/Auntie-Player/apple-tv).

These represent the two styles of Apple TV apps you're likely to see on your device: the standard style video streaming app and the more customized draw-whatever-on-screen app. If I were creating an Apple TV app and needed a place to start, I'd probably look at one of these.

- - -

[**PhoneNumberKit**](https://github.com/marmelroy/PhoneNumberKit)

For those of you using google's libPhoneNumber to validate or parse phone numbers in your app, PhoneNumberKit attempts to be a pure Swift implementation of the same thing. Alpha software at the moment but this could be a much easier (and lighter!) way to use phone numbers in your apps.

- - -

[**fastlane deliver**](https://github.com/fastlane/deliver)

Not new but new to me! If you're frustrate with the process of uploading and filling in information for iTunes Connect during TestFlight or App Store distribution, `deliver` is for you.

It's a simple command that keeps all your app metadata in text / image files with your project and can sync them up *or* down to iTunes Connect for you. The features around autodetection of screenshot sizes are *awesome*.

Fastlane, by the way, recently joined the Fabric team inside Twitter. Congrats to those involved!

- - -

Swift Summit was held in San Francisco in the last couple days of October and yours truly presented and attended. A couple notes about code from the conference:

[Kristina Thai's talk on building watch apps](http://www.kristinathai.com/wp-content/uploads/2014/09/Compelling-Watch-App.pdf) hits my biggest complaint about watch apps so far; there are a million watch apps that do nothing useful. Really consider what interaction you're building for before starting your watch app!

I haven't worked much with futures/promises in Swift but I am a fan of using them for Javascript work. If you find asynchronous image loading or network requests a pain, give Thomas Visser's [BrightFutures](https://github.com/Thomvis/BrightFutures) library a shot. There's also a bit of example code showing how BrightFutures can be used to improve existing code that was used during Thomas' presentation here: [https://github.com/Thomvis/SFSwiftSummit2015](https://github.com/Thomvis/SFSwiftSummit2015)

If you're starting to write your own protocols in Swift, I highly suggest keeping [Greg Heo's talk](http://swiftunboxed.com/protocols/swift-standard-library-protocols-lessons/) handy. It runs down the protocols in the standard library and should inform everything from naming to functionality in your own protocols.


Sam Soffes talked about building tables with [Static](https://github.com/venmo/Static). If you've experimented with protocols, structs and table views in Swift, you've probably come up with something similar but Static is fully featured and supported by Venmo.

There were a few more that I don't see online yet, I'll update as I find them.

- - -

Finally, to round out the code from Swift Summit, I live-coded the beginnings of a struct serialization library that I'm calling *Storage*.

Storage is native opinionated serialization for Swift. Other attempts at serialization want to re-create `NSKeyedArchiver` with all of its flaws but we can clearly do better with Swift. The goal is to have minimal code to store basic data, similar to how you might use `NSKeyedArchiver` or `NSUserDefaults` but in a swifty way that doesn't feel burdensome.

[Storage is on github](https://github.com/nickoneill/Storage) now with preliminary support for archiving lots of types (including structs) with minimal boilerplate code. I'll be writing a more detailed post about the use cases for Storage (which are many!) in the coming week so stay tuned. If you're interested in helping out, please check our issue tracker!

- - -

As always, keep in touch on [Twitter](https://twitter.com/objctoswift) for more of this sort of thing during the rest of the month.