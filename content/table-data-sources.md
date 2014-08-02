---
title: "Dequeueing Table Cells"
date: "2014-07-30"
---
Dequeueing table cells is almost purely UIKit API calls so why is this something we might have difficulty doing in Swift? In a word, optionals.

While optionals as a concept may have been the best way to deal with interop with nils in Objective-C, I've seen a lot of confusion for how to use them in practice and there are a few subtleties in dequeueing table cells that really bring the confusion out in people.

First, in Objective-C:

{{% prism "objectivec" %}}
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

if (!cell) {
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

cell.textLabel.text = @"A cell";
{{% /prism %}}

Pretty simple, we just check if we can dequeue a cell and make a new one if not. We do the same thing in Swift but we have to deal with a few unusual concepts:

{{% prism "swift" %}}
var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell

if !cell {
	cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
}

cell!.textLabel.text = "A cell"
{{% /prism %}}
First, the potentially dequeued cell might be `nil` so we're already dealing with an optional. Moreover, the dequeued cell might be some `UITableViewCell` subclass so it's actually returned as `AnyObject?` and we downcast it to the class we know it is. The incantation for downcasting an optional is that `as?` we used, a combination of new concepts if you're coming straight from Objective-C and potentially the source of confusion here.

This highlights a big point for people coming from Objective-C to Swift, and one I'll restate often: the APIs really haven't changed and you can use them just about as you did before, but the finer points of Swift takes some getting used to. As long as you understand the reasons why optionals and constructs like `AnyObject` exist in Swift you shouldn't have too much trouble.