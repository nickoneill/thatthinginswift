---
title: "Migrating from Swift 2 to Swift 3, Part 2"
date: "2016-09-06"
description: "Manual changes to convert to Swift 3"
draft: true
---
After the easy stuff comes the not-so-easy stuff: 

For the stuff that Xcode knows how to convert, it still can't convert every usage in every way for you so you're left with a mishmash of errors that won't build.

Lots of these unconverted API calls can be fix-it'd by Xcode (why they were not converted automatically with the rest of them is beyond me) so usually clicking on the build errors and selecting the fix-it option will rename the correct parts for you.

In addition, some APIs don't get converted automatically even though major changes have been made, such as the `CGPath` APIs I mention below.


### Fetched results controller types
Fetched results controllers now have associated types that they return. This was automatically converted to `AnyObject` by Xcode but required revision to the actual type before the whole project would successfully compile.

`NSFetchedResultsController<AnyObject>`

Error message:

~~     override func prefersStatusBarHidden() -> Bool {
~~         return true
~~     }

methods turn into computed properties

~~	override var prefersStatusBarHidden: Bool {
~~         return true
~~ }
~~ 
~~ override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
~~         return UIInterfaceOrientationMask.portrait
~~ }
~~ 

### Notifications are enum-y by default

You might have been wrapping your `NotificationCenter` names in enums before, now you can use the new `Notification` type to help you with this.

? inherit this?

## Changes to advanceBy

If you're seeing references to something like `String.CharacterView corresponding to \`start\`` where `start` is the name of an `Index` you've used (usually `startIndex` or `endIndex`), you were probably inserting something into the string or getting a substring using `advanceBy`. The use of `advanceBy` has changed however, these operations have been moved and renamed on the collection which is now responsible for incrementing and decrementing its indices.

Previously you would use `advanceBy` on the index to get a different index:
~~let nums = [0,1,2,3,4,5,6,7,8,9]
~~let start = nums.startIndex
~~let middleIndex = start.advanceBy(5)

Now you can simplify this by using the methods on the collection itself and `offsetBy`:
~~let middleIndex = num.index(num.startIndex, offsetBy: 3)

## NSPredicate

NSPredicate still lives in Objective-C world and will no longer take `Bool` values without wrapping them in NSNumber

## Core Graphics in Swift 3

`let path = CGMutablePath()`

~~// prev
~~CGPathMoveToPoint(path, nil, x, y)
~~// now
~~path.move(to: CGPoint(x: x, y: y))
~~ // similar
~~path.addLine(to: CGPoint(x: x, y: x))
~~// CGPathAddArc becomes...
~~path.addArc(center: CGPoint(x: rect.origin.x + radius, y: rect.origin.y + rect.size.height - radius), radius: radius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI) / 2, clockwise: true)

The most confusing part of these transitions is that separate x and y arguments are combined into `CGPoint` objects, leaving us with one less argument than we expected.