---
title: "Migrating from Swift 2 to Swift 3, Part 1"
date: "2016-09-01"
description: "Automatic migration from Xcode"
draft: true
---
As we approach the release of Xcode 8 and Swift 3, we face the inevitable task of upgrading our old Swift 2.x code to the new syntax in Swift 3, including the major reworking of Foundation and UIKit names that has become known as the *Grand Renaming*.

If you've been through a major Swift version change before, you know the drill: Xcode will offer to convert your source automatically to the new syntax which will usually get you 80% of the way to building successfully. The last 20% is made up of usage that Xcode couldn't determine the correct fix for. It's up to you to fix these items manually before your project will build again.

> And __yes__, for the moment [you can stick with Swift 2.3 in Xcode 8](/swift-2-xcode-8/)

First off, the automatic conversion by Xcode is a great place to start. It'll handle most of the easy changes for you. You should, of course, review these changes to see what's being changed an ensure none of the underlying logic is modified. But you should also want to know the state of your code! 

Here are some common types of automatic conversions that Xcode will provide for you:

### Underscores in method signatures

The biggest change you'll probably see in your code is lots of method signatures gaining `_` as their first external parameter. This is to counter the new syntax that *requires* using the first parameter name by default when calling a method. Rather than changing all your method calls, it's easier for Xcode to behave as it did in Swift 2.x and keep those calls the same.

However, the thinking behind using the first parameter name is sound! You'll still want to make those changes so you have first argument names, but that's a change that can be done during your manual conversion phase or in a post-conversion cleanup.

### Private becomes fileprivate

All your declarations that were formerly `private` will now be `fileprivate` which is the new keyword that behaves exactly as `private` did previously, restricting access to the current file. The new `private` allows access only within the current declaration, restricting access even further than before.

In many cases where you're simply being safe by restricting access to an API, you can change this back to `private` as it was before without an issue. However, if you're an avid extension user you might want to stick with `fileprivate` as these properties won't be visible to extensions in the current file with `private`.

### Grand Transition Renaming

There are a lot of items that fall into this bucket and are renamed automatically for you, here's some common ones that you'll likely run into:

The NS (NextStep!) prefix has been removed from the vast majority of APIs and many singleton-like patterns (*sharedX*, *defaultY*, etc) are no longer methods but properties. In addition, what used to be `sharedManager` or `sharedApplication` is now just `shared`. 

* `NSNotificationCenter.defaultCenter()` is now `NotificationCenter.default` with additional renaming such as `postNotificationName` -> `post`
* Names for notifications are no longer strings but enums of the type `Notification.Name`
* `NSBundle.mainBundle().pathForResource` is now `Bundle.main.path` 🌟
* `.respondsToSelector()` is now `.responds(to: #selector())`
* `componentsSeparatedByString(".")` is now `components(separatedBy: ".")`
* `NSUserDefaults.standardUserDefaults()` is now `UserDefaults.standard` with additional renaming such as `objectForKey()` -> `object(forKey:)`
* `NSProcessInfo.processInfo` is now `ProcessInfo.processInfo`
* `enumerate()` on arrays and dictionaries is now `enumerated()`
* `NSFileManager.defaultManager()` is now `FileManager.default`
* `NSDate` is now just `Date`! 🌟
* `NSDateFormatter` is now just `DateFormatter`
* `NSUTF8StringEncoding` is now much more reasonably named with `String.Encoding.utf8`
* `dispatch_queue_create` and similar have been drastically simplified to names such as `DispatchQueue` 🌟

One note from an item that was *not* converted: Your Swift strings are still `String` and their Objective-C counterparts are still `NSString` because they're distinct and removing the *NS* prefix would obviously cause some weird collisions.

Maybe you've been feeling the unswifty-ness of those old Objective-C naming conventions and using some better ones already. If not, now is a great time to get a handle on the better naming conventions for Swift and starting to adopt them in your code.

In addition to the naming conventions, many of these types get proper mutability handling when using `let` and `var` like you would see in a native Swift struct.

### Multiple unwrapping conditionals

Previously you could trim additional `let`s from the inside of conditional unwraps but this is no longer the case:

```swift
// this won't work in Swift 3
if let x = optionallyGetX(), y = optionallyGetY() { ... }

// much better
`if let x = optionallyGetX(), let y = optionallyGetY() { ... }`
```

The additional `let`s and `var`s must now be in place!

### Conditions no longer contain where

Earlier syntax would let you insert `where` into conditionals, making your `if let` statements feel a bit more like natural English. No longer is this the case, they've been replaced with  a simple comma 😢

```swift
// previously
if let x = optionallyGetX() where x == true

// now, just commas
if let x = optionallyGetX(), x == true
```


---

These are just some of the big items you'll run into when looking at your diffs after running the Xcode automatic migration. But even that probably won't get you to a buildable state. Next, we'll investigate the manual changes you might need to make before your app is completely converted to Swift 3.
