---
title: "Upgrade your TableViews with Loading State"
date: "2016-04-18"
htmltitle: "Upgrade your TableViews with Loading State in Swift"
description: "Easily track your table loading state with enums and associated types"
previewCode: table-state
---

[@Javi](https://twitter.com/javi) briefly mentioned the Fabric approach to dealing with table views at the [Swift user group meetup](http://www.meetup.com/swift-language/events/229694736/) the other night, opting for an `enum` that represented the state of the table as loading, failed or loaded with an associated type (the data for the table view). Here's a simple example:

{{<highlight swift>}}
enum TableState {
    case Loading
    case Failed
    case Items([String])
}
{{</highlight>}}

If you're just using an array (or optional array) for your table data, there's only so much you can say about the state of the operation that's supposed to be gathering and inserting data for your table views. I will admit to tracking this sort of thing as a `Bool` property on the view controller - `hasLoadedData` or something - but that's messy and it's not immediately obvious what data loading operation you're tracking.

It would be nice to be able to infer the state of a table from the data structure alone. Previously we might have written table view code that pulled data from an optional array, letting the `.None` state indicate that the data hasn't loaded yet and any `.Some` state (even with an empty array) means the data has been loaded.

But there's more than just a loading and loaded state on most asynchronously loaded table views. Usually we'll want to track if the data has failed to load for some reason (no network connection, server error codes, etc) and display some useful message in that case so the user isn't waiting for something to happen. Now we've added a third state and maybe a `loadedDataError` optional to our view controller and that's starting to make your view controller sad 😢

### Simplify with Enums and Protocols 

The enum above goes a long way towards making our view controller more readable and representing the state of our table view data. But we end up with a lot of switches in our code which is messy. There are proponents of the idea that enum switches should never exist outside of the enum definition (I'm not 100% on board with this idea but at least in this case it makes our code more readable). So let's extend our enum a bit:

{{<highlight swift>}}
enum TableStateString {
    case Loading
    case Failed
    case Items([String])

    var count: Int {
        switch self {
        case let .Items(items):
            return items.count
        default:
            return 1
        }
    }

    func value(row: Int) -> String {
        switch self {
        case .Loading:
            return "Loading..."
        case .Failed:
            return "Failed"
        case let .Items(items):
            let item = items[row]
            return item
        }
    }
}
{{</highlight>}}

We've added a computed property to get the number of rows to show and a method to return the value for a particular row.

Now we can use this in our view controller as follows. Note our addition of table view reloading when the data changes by reacting to the new value in `didSet`!

{{<highlight swift>}}
class TableStateViewController: UIViewController {
    var tableState = TableStateString.Loading {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    func loadItems() {
        tableState = .Failed
        // or
        tableState = .Items(["One","Two","Three","Four","Five"])
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableState.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        let value = tableState.value(indexPath.row)
        cell.textLabel?.text = value

        return cell
     }
}
{{</highlight>}}

In this simple example we just display the value in a single table view cell if the result is `Failed` or `Loading` but there are more visually pleasing options such as [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet) which you can display when receiving either of those states as well.

Of course we're just using a simple `String` type as our table view data here, we're inserting a standard table cell and setting the text label from our list of strings. This is straightforward to write for the `String` type alone if you'd like to generate a `StringTableState` for some specific part of your app that only needs strings. But plenty of table views get their data from structs or classes and we usually have many different tables with many different data types in a single app.

Luckily, this is Swift and there's a lot we can do with generics to provide a `TableState` that works for all sorts of types. Here's a more general implementation of `TableState` that works for all types, provided your type conforms to the simple `TableValuable` (ugh, better name suggestions?) protocol.

{{<highlight swift>}}
protocol TableValuable {
    associatedtype TableItem
    static func loadingValue() -> TableItem
    static func failedValue() -> TableItem
    func value() -> TableItem
}

enum TableState<T: TableValuable> {
    case Loading
    case Failed
    case Items([T])

    var count: Int {
        switch self {
        case let .Items(items):
            return items.count
        default:
            return 1
        }
    }

    func value(row: Int) -> T.TableItem {
        switch self {
        case .Loading:
            return T.loadingValue()
        case .Failed:
            return T.failedValue()
        case let .Items(items):
            let item = items[row]
            return item.value()
        }
    }
}

// and implementing TableValuable on String

extension String: TableValuable {
    typealias TableItem = String

    static func failedValue() -> TableItem {
        return "Failed..."
    }

    static func loadingValue() -> TableItem {
        return "Loading..."
    }

    func value() -> TableItem {
        return self
    }
}
{{</highlight>}}

It's an interesting exercise in using *associated types* in protocols and enums if you haven't got your feet wet with those yet. One line of note is the call to get the associated type from an enum case: `case let .Items(items):` which is incredibly addictive once you start using associated types. I've never seen this sort of object attachment on enums in another language and yet once the idea gets in your head, you realize the myriad use cases for it.

### Extra tips

Perhaps the best part about this code is that it's just over 30 lines of comprehensible Swift. If you've got a case where there are more states than just `Loading`, `Failed` and `Loaded` in some particular part of your app, it's straightforward to modify a few places to be more appropriate for your use case. It's definitely more of a *micro-framework* than an actual framework, I'm even hesitant to provide a CocoaPods / Carthage compatible project for it instead of just [the gist](https://gist.github.com/nickoneill/f9aa63a5563bec81ac13c384b58a0df1).

My favorite part of this mechanism is how it encourages you to break what is usually a large table view data source into smaller components. Rather than configuring a table cell in `cellForRowAtIndexPath`, you now have an extension on your list object (`String` or otherwise) that is ripe for setting your cell configuration or at least returning the data relevant to that cell.

You might already have a protocol that all your table view data types conform to - `TableCellConfigurable` perhaps - and it's trivial to require your state data source to be both `TableValuable` and `TableCellConfigurable`. Again, protocol oriented programming in Swift really shines. 

---

We only have an associated type on the `.Items` case in the enum but if you've got an `ErrorType` for everything that goes wrong in your application, you can also set an associated type on the `.Failed` enum case to your error type and further track the cause of errors, perhaps to customize the failure message in your app. Customize the `value(row: Int) -> T.TableItem` method to return either a specially crafted row data type or you can implement a `error() -> ErrorType?` method if you want to return your raw errors as a separate type from your data type.

