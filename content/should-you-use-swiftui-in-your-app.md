---
date: 2019-08-24T10:02:03-07:00
title: "Should you write your app in SwiftUI?"
description: "Pros and cons of adopting SwiftUI for your app on iOS 13"
---

I’ve hit a few roadblocks when working on [Read & Share](https://readandshare.app) and I’m working on building separate screens in isolation while I wait for improvements from the next Xcode and SwiftUI beta (maybe next week?) to really tie things together.

It’s frustrating to not be able to move forward on the whole app flow, and I will admit that once or twice I thought about rewriting the app without SwiftUI. But at the end of the day I’m making something fun for myself, I don’t have a huge deadline looming and I wanted to learn something new that I can use to prepare for the future of Swift.

Over the next few months as we hit iOS 13 release and beyond, more and more folks will be able to start using SwiftUI to develop new parts of existing apps or start apps from scratch and ask themselves if they should jump into SwiftUI - and for the pedants in the crowd, I’m using SwiftUI to mean both the SwiftUI and Combine frameworks.

Here are my thoughts from using SwiftUI for the last few months and if you should write your next app using SwiftUI:

## Pros
**It’s easy to get started with the basics**. Apple has a really great set of tutorials for getting used to building UIs with SwiftUI and even interacting with UIKit components from SwitfUI.

If you want a taste of how developing in SwiftUI feels, these tutorials are great at walking through the logical steps of building one part of an app. Between the visual previews that are provided on the tutorials and the speed at which you can preview your work in Xcode, this 

**Lastly, let’s not forget the experience of learning something new.** You’ll be learning something new, but with some of the Swifty comforts you’ve become used to. This is actually pretty fun! You can usually iterate quickly and solve your problems (as long as you don’t run into functionality blockers) like the ones that are common during the beta phase.

## Cons
Starting with the obvious one: your SwiftUI apps will only work on devices with iOS 13 and higher. For those of you with a large existing install base, offering 

**More complex tasks don’t have good example code yet.** Rather than just searching stack overflow for how to accomplish a task, you might have to read the Apple docs and figure out how to put together multiple pieces that have never been written about before.

**Error messages can be misleading.** Just like the Swift releases of yesteryear, error messages from using Combine and SwiftUI are not always the most readable or the most accurate messages.

I’ve seen frequent complaints about using `[.top, .bottom]` as padding `EdgeSet` when in fact the error was something I was doing in modifiers that follow the element the error pointed at.

A lot of these new tools are powered by generics in Swift so error messages complaining about `T` and `U` might actually be complaining about your own types that the compiler isn’t yet reasoning about correctly.

**The real power of Xcode 11 comes from working in Catalina.** If you’re like me and happy to jump into iOS betas after the public releases start coming out but much more hesitant about macOS betas, you’ll find that Xcode 11 on 10.14.x doesn’t have the live preview and SwiftUI refactoring power that some of the Apple tutorials mention. 

These extra features are only available in 10.15 and unless you want to take that dive early, you’ll have to wait until you upgrade your main computer to take advantage of them.