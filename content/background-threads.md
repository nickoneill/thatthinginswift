---
date: 2014-07-12T17:56:14-07:00
title: "Background Threads"
---
I was going to call this "Grand Central Dispatch" but then I remembered this is supposed to be digestible chunks of information about Swift, not huge diatribes about the state of such-and-such tool. So, let's continue with the simple task we have set out for us: moving to and from the background thread.

We've stumbled upon an easy one here as the syntax is not significantly different than in Objective-C. First, the version we are accustomed to:

{{% prism "objectivec" %}}
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	// do some task
	dispatch_async(dispatch_get_main_queue(), ^{
		// update some UI
	});
});
{{% /prism %}}

The only notable difference is that Swift code can use trailing closures, removing the need to remember to close the function parentheses later on:

{{% prism "swift" %}}
let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
dispatch_async(dispatch_get_global_queue(priority, 0)) {
	// do some task
	dispatch_async(dispatch_get_main_queue()) {
		// update some UI
	}
}
{{% /prism %}}

Though if you're using Swift and doing a lot of work in the background and taking action on main when that's done, you may want to consider this clever operator by [Josh Smith](http://ijoshsmith.com):

{{% prism "swift" %}}
{ /* do some task */ } ~> { /* update some UI */}
{{% /prism %}}

Yes, you do have to include [this other bit of code](http://ijoshsmith.com/2014/07/05/custom-threading-operator-in-swift/) to use this operator but it really speaks to the power of implementing operators that do neat, compact things in Swift. Would I use it in code that someone else has to maintain? Maybe not.
