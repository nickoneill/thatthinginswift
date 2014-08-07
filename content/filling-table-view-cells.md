---
title: "Filling Table Views"
date: "2014-08-07"
tags: [""]
description: "Switches and tuples make filling table views easy again"
---
Here's a great example of how the language features in Swift take an old pattern and put a fresh spin on it - that is, they let us use less code and write more clearly.

If you've filled a `UITableView` programmatically that has the slightly bit of structure to it then you've problem run into Objective-C code that looks like this (from a contact page):

{{% prism 'objectivec' %}}
if (indexPath.section == 0) {
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Twitter"
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Blog"
    } else {
        cell.textLabel.text = @"Contact Us"
    }
} else {
    if (indexPath.row == 0) {
        cell.textLabel.text = @"nameone"
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"nametwo"
    } else {
        cell.textLabel.text = @"namethree"
    }
}
{{% /prism %}}

The first problem with this is the nested if/else blocks. This is a mess, particularly when the code changes indentations so frequently. It's just plain hard to read. Secondly, there's a lot of extraneous code in here. We could break `indexPath.section` and `indexPath.row` out into variables to reduce some of it but it doesn't reduce the amount of code we're writing overall by that much. Lastly, the indexes that we're accessing are largely hidden. You have to follow the indentations to know where section 0 ends and then we use blanket else statements for the last item to reduce code at the expense of clarity. You really have to know the structure of the table view before you start editing this code.

My first instinct when rewriting this code was to use Swift's improved `switch` statements on the `indexPath` which leads to less nesting and more clarity but the code is still filled with extraneous declarations for `NSIndexPath` objects. Enter tuples.

We can define a standin tuple that takes the `indexPath` values and then is easily created at each case statement with minimal code:

{{% prism 'swift' %}}
let shortPath = (indexPath.section, indexPath.row)
switch shortPath {
case (0, 0):
    cell.textLabel.text = "Twitter"
case (0, 1):
    cell.textLabel.text = "Blog"
case (0, 2):
    cell.textLabel.text = "Contact Us"
case (1, 0):
    cell.textLabel.text = "nameone"
case (1, 1):
    cell.textLabel.text = "nametwo"
case (1, 2):
    cell.textLabel.text = "namethree"
default:
    cell.textLabel.text = "¯\\_(ツ)_/¯"
}
{{% /prism %}}

Note that we have to do *something* for the default case because switch statements must be exhaustive and we probably shouldn't list every tuple of two integers. Instead we'll just provide a default cell text that looks obviously broken if we run into it.

Now we have a clear idea of the structure of our table but with concise code that is obvious to anyone who needs to modify it in the future, all thanks to Swift switches and tuples.