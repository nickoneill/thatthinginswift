---
date: 2015-03-23T17:56:14-07:00
title: "Switches and Optionals"
description: "Switches provide a nice shortcut for nil testing"
---
I may be straying from our traditional “things you know how how to do in Objective-C" bit -- unwrapping is not a thing we needed before Swift -- but I can’t help but share this pattern I’ve been using.

As I get more and more accustomed to the places that optionals belong in my Swift code, I keep finding new ways to handle those clunky spots where they feel unwieldy. This is great because I really like the idea of optionals. There are so many ideas in programming that can be thought of as either always having a value or sometimes being nil, so the distinction is apt. Finding ways to handle optionals gracefully makes me even more convinced they’re a great choice for Swift.

One of those spots where optionals were feeling clunky was configuring `UITableViewCell` object from some state `enum` which happened to be optional because it was loaded asynchronously. Using `if let` blocks everywhere was a pain, particularly in this case because they were always immediately followed by a `switch` statement which was leading down the path to the [Pyramid of Doom](http://blog.scottlogic.com/2014/12/08/swift-optional-pyramids-of-doom.html).

Here’s how it might have looked before:

{{% prism swift %}}
// somewhere else we've defined our enum as such:
enum Status {
  case Available
  case Unavailable
  case Unknown
}

// unwrap...
if let status = self.status {
  // and then figure out our status
  switch status {
  case .Available, .Unavailable:
    println("a status")
  default:
    println("no status")
  }
} else {
  println("no status")
}
{{% /prism %}}

Fortunately, we can combine these two statements with some interesting syntax and then extend that to deal with optionals in different ways.

We know that optionals are actually an `enum` type made up of `.Some(A)` and `.None`. This represents the cases that we can encounter when we have an optional: either some type or nothing.

We can use this in our `switch` to check optionals without having to do that same step beforehand. Try this:

{{% prism swift %}}
switch self.status {
case .Some:
  println("a status")
default:
  println("no status")
}
{{% /prism %}}

Sanity restored to our indentation. I mentioned configuring `UITableViewCell` instances previously because you need to look at your state in a few different places like `cellForRowAtIndexPath:` and `didSelectCellAtIndexPath:`. Trimming these down a level of indentation makes this feel like less of a pain and often you can combine two common states (no state and unknown state) in a single case rather than both the outer `if let` statement and the inner `switch`.

Now the extended part: even if you don’t configure your table views this way, you can still use this method when checking multiple optionals for nil. We simply make a switch statement where the only valid case for the inputs is `.Some` and the rest hit the default case.

Here’s a situation where you have multiple optional inputs to validate and not a lot of code needed to do it<sup><a href="#noteone">[1]</a></sup>:

{{% prism swift %}}
switch (self.textValidation, self.passwordValidation) {
case (.Some, .Some):
  println("both look good!")
default:
  println("something was nil...")
}
{{% /prism %}}

There are a few more powerful uses for `switch` along these lines, including conditional cases with `where` and ignoring inputs with `_` but hopefully we'll get to those in another post.

The Swift `switch` continues to amaze and I doubt this will be the last time I bring it up on this blog. We’re almost a year into our public understanding of Swift and new ways to solve problems are still being “discovered.” That’s pretty great.

---

<sup><span id="noteone">[1]</span></sup> OK, I admit that this won’t be needed for long since Swift 1.2 will let us [chain `if let` optionals](http://nshipster.com/swift-1.2/) but you might still use a `switch` for this considering how powerful and clear they are over lots of nested `if`s and `else`s.
