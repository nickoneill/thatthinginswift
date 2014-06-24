+++
title = "String Formatting"
date = 2014-06-24T04:54:37Z
+++

We've all grown to love the [string format specifiers doc](https://developer.apple.com/library/ios/documentation/cocoa/conceptual/Strings/Articles/formatSpecifiers.html) from Apple and because it was baked into NSString, it was super easy to use in Objective-C. Here's something you might do:

> NSLog(@"The current time is %02d:%02d", 10, 4);

Things are not all that different in swift. While we can't do this right from the swift String type, we can easily use NSString to accomplish our goals.

> NSString(format: "The current time is %02d:%02d", 10, 4)

And since NSString and String are interchangable in swift, you can easily use the NSString formatters and pass the results right back as swift Strings.
