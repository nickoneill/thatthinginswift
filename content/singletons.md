---
date: 2014-07-10T10:02:03-07:00
title: "Singletons"
---
Singletons are a touchy subject in Objective-C. Plenty of people eschew the use of globals entirely and thus have no interest in implementing singletons. I prefer an approach that uses singletons in the cases where they're the best (clearest, most functional) tool for the job, global-haters be damned.

If you're not familiar, a singleton is an object which is instantiated exactly once. Only one copy of this object exists and the state is shared and reachable by any other object - I'm sure you can already see how this can be abused to form poorly constructed code.

Since I am not a singleton hardliner, I use them in Objective-C and I expect to use them in Swift as well. Let's look at the old way:

{{% prism "objectivec" %}}
@implementation SomeManager

+ (id)sharedManager {
	static SomeManager *staticManager = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		staticManager = [[self alloc] init];
	});
	return staticManager;
}

@end
{{% /prism %}}

Usage:

{{% prism "objectivec" %}}
[SomeManager sharedManager];
{{% /prism %}}

*Yep, there are a few different ways to do this in Objective-C.* I used to use the `@synchronized` pattern - and `@synchronized` is still the best way to do simple locking in Objective-C - but `dispatch_once` is the solution that matches the problem best and it's the clearest. For an unfamiliar programmer, it's not exactly clear what `@synchronized` does. Even after you look it up in the docs it takes a moment to think through the different situations where it may be called and what the effects are. `dispatch_once` is simple. It does what it says and understanding the implications are pretty easy.

This line of thinking is going to influence our choice of singleton patterns because there are already a ton of ways to implement a singleton in Swift.

As noted in [this git repo](https://github.com/hpique/SwiftSingleton), at least three different ways to make singletons in Swift are remotely valid. Finding the correct one is a pain but if we apply the same principles as for Objective-C, I think we can pick a winner.

The obvious port of `dispatch_once` to Swift is understandable but it seems verbose for a common pattern in a new language. It turns out that we can construct a singleton using type properties in significantly less code:

{{% prism "swift" %}}
let _SomeManagerSharedInstance = SomeManager()

class SomeManager {
	class var sharedInstance: SomeManager {
		return _SomeManagerSharedInstance
	}
}
{{% /prism %}}

With usage:

{{% prism "swift" %}}
SomeManager.sharedInstance
{{% /prism %}}

The downside of this approach is cluttering the global namespace. `_SomeManagerSharedInstance` is always sitting there, waiting for someone to stumble upon it. We can potentially solve this in future Swift releases with private global constants or private class constants, neither of which exist in Swift beta 3.

For now, though, I think this approach is the most understandable. The alternative, nested structs, are confusing and the gain for no global clutter is minor, particularly because we shouldn't have many of these singletons in the first place.

I'll update this post at a later time if improvements to Swift bring a better method for singletons but this seems pretty satisfactory for now.
