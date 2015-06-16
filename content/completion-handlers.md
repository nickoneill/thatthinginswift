---
title: "Completion Handlers"
htmltitle: "Completion Handlers in Swift"
date: 2014-06-26T10:54:37Z
description: "Finally, no more bolted on F***ing Block Syntax"
---

We do a lot of asynchronous work on mobile devices in an effort to keep our code from blocking the main thread. Previously that meant a lot of delegate methods but more recent advances in Objective-C allowed us to return values to blocks as completion handlers. No doubt, we will have to do a lot of this in swift as well.

Here's a function definition from Objective-C that makes use of the completion block pattern and the associated syntax to use it:

{{< highlight objectivec >}}
- (void)hardProcessingWithString:(NSString *)input withCompletion:(void (^)(NSString *result))block;

[object hardProcessingWithString:@"commands" withCompletion:^(NSString *result){
	NSLog(result);
}];
{{< /highlight >}}

*Thanks [Fucking Block Syntax](http://fuckingblocksyntax.com)! I can never remember this stuff either*

Swift is given some opportunity to improve on this since it doesn't have to be some afterthought language addition, it can be baked in from the very beginning.

The result may look complex (as all functions-in-function-declarations do) but is really simple. It's just a function definition that takes a function as an argument so as long as you understand nesting this should quickly become clear:

{{< highlight swift >}}
func hardProcessingWithString(input: String, completion: (result: String) -> Void) {
	...
	completion("we finished!")
}
{{< /highlight >}}

The completion closure here is just a function that takes a string and returns  void. At first this sounds backwards - this takes a string as an argument? We want to *return* a string! - but we don't really want to return a string, that would mean we've blocked until we return. Instead, we're calling a function that the callee has given us and providing them with the associated arguments.

Using completion handlers is easier than declaring them though, thanks to a clever way to shorten function calls from the swift team:

{{< highlight swift >}}
hardProcessingWithString("commands") {
	(result: String) in
	println("got back: \(result)")
}
{{< /highlight >}}

This is a trailing closure, something we can use whenever the last argument is a closure. Using the somewhat strange `{() in }` syntax, we magically have the results that we passed the closure back in our async function. I really have yet to plumb the depths of swift to understand what makes this syntax tick, but for now I'm happy it works.
