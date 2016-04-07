---
title: "macOS Speculation for WWDC 2016"
date: "2016-04-02"
description: "Does macOS mean bringing iOS to the desktop?"
draft: true
---

This is a little different than the creative code exercises we usually do here at **That Thing in Swift**, but here goes:

---

[All this talk about macOS](http://daringfireball.net/linked/2016/03/30/macos) had me thinking about what we'll see at WWDC this year and when I read Brent’s reminder about the ever-present threat of [bringing UIKit to the Mac](http://inessential.com/2016/04/01/uikit_for_macs), these ideas started to click together in unexpected ways.

Brent and I have some different opinions on how UIKit could be brought to the Mac. His vision is a bit more vanilla: shoehorn menus and AppleScript and everything else into UIKit for OS X because it might bring some new developers from iOS to the Mac. Mine is a bit more of a shakeup - not unheard of for Apple - and it also resolves the "boring" parts that Brent brings up about Mac development.

First, some backstory: UIKit is the framework that we use on iOS to develop UI concepts that feel at home on the iPhone and iPad. You can make an entirely custom UI if you want (think full screen games made in Unity) but as soon as you need to accept user input or pick a photo from the library, you need to talk to UIKit. AppKit is the predecessor to UIKit for the Mac. AppKit is significantly different (menu bars! keyboard shortcuts!) and has much more flexibility because of the platform it lives on. Developers have long expected the unification of AppKit and UIKit but we haven't heard an official Peep about it yet.

### Converging from both sides

OS X has always danced around a "simpler" form of desktop applications. Dashboard/Konfabulator and Today View widgets were made with the idea that there are some apps that just don't need a full desktop app experience to be useful. You can almost think of dashboard widgets as the original iPhone apps: no file pickers, no menus, they just do one thing really well. They've never been very popular on the desktop but they've also been hamstrung by second-class treatment - Dashboard widgets are written in javascript and the Today View is visually inflexible. It feels like there's some space between shitty display-only widgets and full-on desktop apps that hasn't been explored on the Mac.

Apple has been approaching this problem from the opposite side as well: Apple really pioneered the idea of non-bite-sized content creation of the iPhone and iPad with Pages, Keynote, iMovie, etc. These apps really push the boundaries of what an app is expected to do and how much real work you can get done on an iPad. Apple certainly doesn't own all the best productivity apps in the iOS platform but Multitasking and Smart Keyboards prove they're 100% behind the idea that the iPad is a productivity device. The iPad has made more progress towards productivity than the Mac has made towards simplicity but they're definitely converging.

### Previously

Like most Apple software features, the concept as a whole isn't particularly novel


The implementation details are what matters when  of 

With this history of failure, the ____ seems dim for macOS before it's even reached the hands of developers. Fortunately, Apple has a history of spending more time in development 

### The macOS we'll see at WWDC

Let's paint a picture of what you'll see at WWDC, starting with a desktop Mac with a screen that looks like multitasking on the iPad. You can do this today with El Capitan's split view but it feels weird with apps that do custom things with the title bar (I'm looking at you Chrome) and it feels way better on a iPad than it ever does (even with the stock apps) on a Mac. Your apps are always full screen and can be split and resized if you want more apps on the same screen. Splitting windows in emacs is super powerful, Apple needs to put a real slick coat of paint on it and give it a marketing name.

> some mocked up screenshot with more than two splits

I've been waiting for this part for years: There's no desktop showing through the cracks because there is no desktop. Your files are saved and sorted into an iCloud-like system where searching rules and navigating folders is a thing of the past. The apps that run in this new macOS zone are written exclusively for the new UIKit framework and can't be run outside of it like a "normal" desktop app.

The Finder is still there in the background because there are no macOS apps yet (other than the stock apps), but I'm not so sure about the future of a Finder-based OS X. Apple is never hesitant to divide a platform into __those that release regularly__ and __those that fall behind__ and this is another one of those times for developers. The last time we saw this on the Mac was the 64-bit transition (2012?) and before that, the PowerPC transition (announced 2006, removed support in 2009). iOS sees these sorts of transitions far more often with screen sizes and support for newer specialized hardware.

macOS apps aren't dumb like dashboard widgets, think of them as bigger, better versions of productivity apps on the iPad. They simply lose the extraneous stuff that has driven people towards post-PC devices in the last few years. Refining the experience down to the essentials has always been the right choice and the choice that Apple usually makes. These new apps refine the idea of a desktop app down to the basics, giving an iOS-y simplicity to the desktop. AppKit developers will be encouraged to rewrite their apps for the new UIKit, iOS developers are encouraged to bring all their iOS apps onto macOS, and new macOS apps will only be available via the Mac App Store.

<blockquote class="twitter-tweet" data-conversation="none" data-cards="hidden" data-partner="tweetdeck"><p lang="en" dir="ltr"><a href="https://twitter.com/brentsimmons">@brentsimmons</a> Depends on the future of the Mac. Is it the tool nerds use to make iOS apps or the device your grandma uses to keep photos</p>&mdash; Nick O&#39;Neill (@nickoneill) <a href="https://twitter.com/nickoneill/status/715978928721149953">April 1, 2016</a></blockquote>

I was trying to make this point in under 140 characters on Twitter but it ballooned into this post. The idea isn't to dumb down the Mac experience, it's to bring the simplicity and familiarity of iOS apps to the Mac.

### What this means for the Developer

The new macOS is announced at WWDC for a reason: developers are the only way this transition can work. New macOS apps are written using the new unified UIKit framework and Apple wants the legions of iOS developers they've created to start putting their content on the Mac. For all the reasons Brent mentioned above, AppKit development is way harder than UIKit development and the giant box of unknowns keeps people away from the Mac. Sharing lots of code between your iOS app and its macOS counterpart is going to make that significantly easier, and you'll be able to deploy to watchOS, iOS, tvOS and macOS with a (greatly) unified framework.

For some of the most up-to-date iOS apps (notably the ones that are designed for iPad screen sizes), **your app already works on macOS**. Hopefully you enabled bitcode on your latest project. For most people, the name of the game to get your app on macOS is Size Classes and you're going to want to support a bunch of them if you want to be resizable in the many different orientations that your app can be displayed in macOS. With this comes significantly better support for previewing and modifying autolayout constraints for size classes in Xcode.

Swift is obviously the language of choice when it comes to this transition, but Objective-C isn't going away anytime soon and you can continue to create new projects in Objective-C or use it in parts of your mainly-Swift app. UIKit unification isn't exactly news to the Swift team, they've been planning for it:

* swift 2's `@available` lets us develop classes that work across iOS and macOS, resolving minor differences between the OSes with built-in OS checking
* As mentioned above, size classes are a huge benefit to those working across devices. They're minimally helpful for iPhones alone but they begin to show strength for multitasking on the iPad. They'll really shine across shared iPad and macOS layouts
* `UITraitCollection` is a UIKit class that gives more information about supported sizes and capabilities for the devices we're running on, including force touch support

And the best part about the developer announcements? The new macOS comes with unified Xcode for iPad and macOS. It's Apple's way of saying that this new macOS paradigm isn't just for simple widget-style apps from iOS, we're going to create something that actually helps you get work done and feels faster than your current workflow.

> mockup for xcode in this new split mode

### Final Thoughts

Why do I think we'll see a version of macOS and UIKit at WWDC this year? No inside sources here, but it would explain a few things:

* UIKit isn't on the Mac. Perhaps the best argument that UIKit isn't going to be used to develop standard OS X apps is that it hasn't happened yet, there's some deeper thought going on about how it should be done
* iTunes isn't getting a redesign because it's being redesigned as the macOS Music and iTunes Store apps (like on iOS)
* 

Andrew Ambrosino has written [the next best thing about macOS speculation](https://medium.com/swlh/macos-it-s-time-to-take-the-next-step-ee7871ccd3c7), his ideas on convergence of the two platforms and leaving the old navigable filesystem behind are spot on. I don't think he's put a lot of thought into UIKit on the Mac though; the AppKit vs UIKit label isn't what's keeping Google Inbox and Netflix from creating native apps for the Mac, it's the fact that you have to rethink the whole app to adhere to menu bars and keyboard shortcut conventions on a different platform. Taking an iOS-based approach to macOS apps means you have to add a few features to fit in, not rethink the whole structure. Pretty mockups though. Remove the window controls and go full screen and that's about the same thing I expect.

Apple's benefits:

* A fresh new face for macOS to drive new customers. The Mac market share has been increasing but there's only so much you can do to convince people they want a traditional computer these days. Many iPhone users have never been Mac users. Give them something that feels more like a desktop iPhone with a bigger screen and a keyboard to drive Mac sales.

Developer benefits:

* Write (most of) your app once, deploy it to all the platforms. It would be criminal to suggest that Apple hasn't been going in this direction for the last few years, watchOS and tvOS apps are truly designed around already having an iOS app that you can extend to these new platforms. The Mac is the odd man out in this situation and it requires a whole new bucket of AppKit-specific knowledge to   develop a shared codebase for OS X.