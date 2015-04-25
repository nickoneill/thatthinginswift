---
date: 2015-04-25T11:56:14-07:00
title: "Common String Manipulations"
htmltitle: "Common String Manipulations in Swift"
description: "Does that string start with 'x'?"
---
Swift definitely eschews some traditional string manipulation patterns that we're used to seeing both in Objective-C and other programming languages.

Say you're not that familiar with Objective-C and you're thinking of ways to test if a particular string starts with some other string. Maybe you'd try a regex first:

{{% prism objectivec %}}
// yes, some languages actually ask you to know this stuff
/^(start)/
{{% /prism %}}

But for sure some people who have been writing Obj-C for a while will take offense to this. They'd rather do it this way:

{{% prism objectivec %}}
[string hasPrefix:@"start"];
{{% /prism %}}

And since we can bridge between `String` and `NSString` seamlessly, maybe that's the way you'd do it too:

{{% prism swift %}}
string.hasPrefix("start")
{{% /prism %}}

Hell, that's the way I'd do it. It's simple and clear, it doesn't take any cleverness to figure out what's going on. But - just for the exercise - we're preparing for a day where `NSString` doesn't exist anymore. How can we be most Swifty?

{{% prism swift %}}
let asRange = identifier.rangeOfString("at")
if let asRange = asRange where asRange.startIndex == identifier.startIndex {
    // yep, starts with "at"
}
{{% /prism %}}

Ranges are a particularly confusing part of strings in Swift so at least this exercise will give us some insight into how they work. Firstly, our range from `rangeOfString` returns an optional (nil if it doesn't appear in the string). Now (as of *Swift 1.2*) that we can make more complex `if let` statements, we can even check if the beginning of the range is the start of the original string, all in one line.

OK, so now that you've identified that a string starts with some substring, maybe you want to get the rest of that string?

Objective-C users will again cry foul: "*We already have a way to do this!*" And they're right. Using `substringFromIndex` and counterparts is an easy way to get this done in Objective-C.

But what's this? `substringFromIndex` in Swift no longer takes and integer but a `String.Index`?

Lucky for us, we have a working knowledge of `String.Index` from our range exercise earlier and we know we can easily coax one out of our starting string with `startIndex`.

But we're using `substringFromIndex` which means we want to get a substring starting at some index *after* the start, so we need to get an index later down the string. Enter your new friend `advance` which will "advance" the string index by an integer amount of steps. Get used to this guy, he comes up a lot with ranges.

Finally we can use our familiar `substringFromIndex` method in Swift. The whole thing spelled out for you:

{{% prism swift %}}
identifier.substringFromIndex(advance(identifier.startIndex, 2))
{{% /prism %}}