---
title: "String Format Specifiers"
htmltitle: "String Formatting with NSString in Swift"
date: 2014-06-24T04:54:37Z
description: "Ease of use first, fancy formatting second"
---

We've all grown to love the [string format specifiers doc](https://developer.apple.com/library/ios/documentation/cocoa/conceptual/Strings/Articles/formatSpecifiers.html) from Apple and because it was baked into NSString, it was super easy to use in Objective-C. Here's something you might do:

{{% prism objectivec %}}NSLog(@"The current time is %02d:%02d", 10, 4);{{% /prism %}}

While standard string interpolation is useful in Swift, all the power of format specifiers aren't available using the interpolation syntax. Luckily the format specifiers have been added into the `String` type during beta. <strike>While we can't do this right from the Swift `String` type, we can easily use `NSString` to accomplish our goals.</strike>

{{% prism swift %}}let timeString = String(format: "The current time is %02d:%02d", 10, 4){{% /prism %}}

And since `NSString` and `String` are interchangeable in Swift, you can easily use the one formatter or another and pass the results right back to Objective-C or Swift.
