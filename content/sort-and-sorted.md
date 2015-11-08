---
title: Sort and Sorted
date: 2015-02-11
htmltitle: "Sorting Arrays in Swift"
description: Easy sorting in Swift
---
I usually dread sorting in Objective-C because there are too many different ways to do it and too many magical syntax items that I can never remember. Swift simplifies a bit, building a more tightly coupled sorting mechanism into `Array`, though still relying on magical syntax comparators in some more complex cases.

The method in Objective-C that feels closest to Swift is probably `sortedArrayUsingComparator:` which should be given a block with two arguments of type `id`. The block then returns either `NSOrderedAscending`, `NSOrderedDescending` or `NSOrderedSame` depending on the ordering of the items - and it’s up to you to compare the two objects in the comparator block and determine the `NSComparisonResult`.

Here’s a simple example:

{{< highlight objectivec >}}
NSArray *numbers = @[@0, @2, @3, @5, @10, @2];
NSArray *sortedNumbers = [numbers sortedArrayUsingComparator:^NSComparisonResult(id first, id second) {
  if (first > second) {
    return NSOrderedDescending;
  } else {
    return NSOrderedAscending;
  }

  return NSOrderedSame;
}];
{{< /highlight >}}

I have a couple issues with this. Most obvious to me is the usage of `id` in the comparison block. Objective-C doesn't know the type information of the elements in the `NSArray` so it makes sense that you have to figure out what they are yourself. Lots of opportunity for runtime crashes here.

Second is the incredible verbosity of the block. You have to cover every result yourself and the compiler gives you absolutely no help.

Since we can use our standard Objective-C types in Swift, we could rewrite this exact thing with some `AnyObject` substitutions and slightly different syntax. It's unpleasant, so I won't even give you an example. However, Swift gives us a couple new tools that are better suited for the task.

If you were going to rewrite a way to sort things in Swift, you might end up with the `sorted` function:

{{< highlight swift >}}
func sortFunc(num1: Int, num2: Int) -> Bool {
    return num1 < num2
}

let numbers = [0, 2, 3, 5, 10, 2]
let sortedNumbers = sorted(numbers, sortFunc)
{{< /highlight >}}

This provides us with a lot of type safety and some reduced verbosity. `sorted` knows that `sortFunc` only deals in arrays of type `Int` so we can't create a sorting function where `num1` and `num2` are type `String` and use it here (it won't even compile!).

You'll notice we're also providing a simple `Bool` result as opposed to an `NSComparisonResult` type. That's simpler to understand and less work for us.

I think we can do a little better though. I usually like to sort arrays in place, and sometimes on a property of the objects listed. We can tackle both of these things in an easy to understand and Swifty way with the array method `sort`.

{{< highlight swift >}}
var numbers = [0, 2, 3, 5, 10, 2]
numbers.sort {
  return $0 < $1
}
{{< /highlight >}}

By using `sort`, we're sorting in place (the results will be in `numbers`, not another new array), using a trailing closure and removing the explicit types for shorthand argument names `$0` and `$1`. The best part of all this shorthand is that we don't loose any of the type information. The compiler will refuse any operation that we can't do on an `Int`.

All that good stuff aside, the previous example might be better for an array of `Int`s as you sort `Int` arrays frequently. When we start dealing with more novel data structures this shorthand really starts to shine.

For example, when listing contacts from a user's phone in a `UITableView`, it's nice to provide a quick reference for letters with `sectionIndexTitlesForTableView`. I created a little data structure that looks like this:

{{< highlight swift >}}
class ContactLetter {
  let letter: String
  var contacts: [CellContact]
}
{{< /highlight >}}

When sorting an array of `ContactLetter` objects, you want to sort by some internal property, like `letter` in this case. `sort` makes this incredibly easy:

{{< highlight swift >}}
self.contacts.sort {
  $0.letter.localizedCaseInsensitiveCompare($1.letter) == NSComparisonResult.OrderedAscending
}
{{< /highlight >}}

And your contact list is nicely sorted for inclusion in your table view.
