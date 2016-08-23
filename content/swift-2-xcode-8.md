---
title: "Using Swift 2.3 in Xcode 8"
date: "2016-08-23"
htmltitle: "Using Swift 2.3 in Xcode 8"
description: "Upgrade to Xcode 8 without migrating to Swift 3"
---

We're well into the betas of Xcode 8 which will contain the final release of Swift 3, hopefully set for release around the first couple weeks of September. With this next release of Xcode, we're encouraged to update our Swift syntax to Swift 3 from 2.2 but - and this is unique to this major Xcode release so far - we're not quite required to do so.

There's a single build setting that will let you continue building your Swift projects with a Swift version that's mostly similar in syntax to your existing projects from Xcode 7: __Use Legacy Swift Language Version__

Just drop into your project's build settings and search for `legacy swift` to find the correct build setting, then switch the setting to __YES__ to opt-in to Swift 2.3 rather than Swift 3 in Xcode 8.

{{<figure src="/images/legacy-swift.png" title="Use Legacy Swift Language Version in Xcode 8">}}

## Swift 2.3

The primary changes in Swift 2.3 should end up being minor items such as nullability changes in core Objective-C libraries which will make moving your code from Xcode 7.3 to 8 pretty easy.

You'll be able to get the benefits in Xcode 8 without having to move to Swift 3. These are improvements such as the Memory Debugger, Editor Extensions and my personal favorite: less unintentional changes to xib and Storyboard files!

<div class="hidden">
If you'd like to read up on more of the changes you'll be seeing when you convert your code to Swift 3, you can check out our [Swift 3 migration tips post]().
</div>