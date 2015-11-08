---
title: "Dequeueing Table Cells"
date: "2014-07-30"
htmltitle: "Dequeueing Table View Cells in Swift"
description: "Translating Objective-C to Swift code is not always hard"
---
<hr />
**Hey! Listen!** This article has changed significantly since it was originally posted about downcasting optionals returned from the iOS 6-era `dequeueReusableCellWithIdentifier:`. I've since changed it to contain the correct usage of `dequeueReusableCellWithIdentifier:forIndexPath:` which always returns a cell so that visitors know the correct code to use at first glance.

<!---
Downcasting a returned `AnyObject` is still a point of potential confusion so I've moved it to [here](http://).
-->
<hr />

Dequeueing a table (or collection) cell is almost entirely UIKit API calls and they translate directly to Swift. Since iOS 7 we've been able to dequeue a guarenteed cell (no optionals or nil checks needed, thanks [@olebegemann](https://twitter.com/olebegemann/status/498753146697838593)) as long as we have a prototype cell in the storyboard or have used one of `registerClass:forCellWithReuseIdentifier:` / `registerNib:forCellWithReuseIdentifier:`.

First, in Objective-C:

{{< highlight objectivec >}}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

	cell.textLabel.text = @"A cell";

	return cell;
}
{{< /highlight >}}

Pretty simple, dequeue a reusable cell and customize it to your liking. Then return the cell as requested. The same thing in Swift:

{{< highlight swift >}}
func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
	let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell

	cell.textLabel.text = "A cell"

	return cell
}
{{< /highlight >}}

This highlights a big point for people coming from Objective-C to Swift, and one I'll restate often: the APIs haven't changed (or have changed very little) and you can use them just about as you did before. Transitioning to Swift syntax is the hardest part, particularly mentally translating all those Objective-C methods you remember into their equivalents in Swift.

In this case, we don't have to think much about the new constructs in Swift to get to the optimal code. Balancing between the approach that we used in Objective-C and more Swift-like approaches (see [Filling Table Views](/filling-table-view-cells/)) is an important part of our job as developers, particularly during these first few months of Swift.
