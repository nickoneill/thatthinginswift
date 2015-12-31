---
title: "Guard Statements"
date: "2015-12-30"
htmltitle: "Guard Statements in Swift"
description: ""
---
Guard statements joined us in Swift 2.0 to much fanfare.

Guard combines two powerful concepts that we're used to in Swift: unwrapping optionals and powerful pattern matching. The former allows us to avoid the pyramid of doom or its alternative, the very long `if let` statement. The latter attaches simple but powerful pattern matching with the `where` clause so we can further vet the results we're validating.

### When to use `guard`

If you've got a view controller with a few `UITextField` elements or some other type of user input, you'll immediately notice that you must unwrap the `textField.text` optional to get to the text inside (if any!). `isEmpty` won't do you any good here, without any input the text field will simply return nil.

So you have a few of these which you unwrap and eventually pass to a function that posts them to a server endpoint. We don't want the server code to have to deal with `nil` values or mistakenly send invalid values to the server so we'll unwrap those input values with guard first.

{{< highlight swift >}}
func submit() {
    guard let name = nameField.text else {
        show("No name to submit")
        return
    }

    guard let address = addressField.text else {
        show("No address to submit")
        return
    }

    guard let phone = phoneField.text else {
        show("No phone to submit")
        return
    }

    sendToServer(name, address: address, phone: phone)
}
{{< /highlight >}}

Here's the [method signature](http) for the `sendToServer` function:

{{< highlight swift >}}
func sendToServer(name: String, address: String, phone: String)
{{< /highlight >}}

You'll notice that it takes non-optional `String` values as parameters, hence the guard unwrapping beforehand. The unwrapping is a little unintuitive because we're used to unwrapping with `if let` which unwraps values for use _inside_ a block. Here the guard statement has an associated block but it's actually an `else` block - i.e. the thing you do if the unwrapping fails - the values are unwrapped straight into the same context as the statement itself.

// separation of concerns

### Without `guard`

Without using `guard`, we'd end up with a big pile of code that resembles a [pyramid of doom](http). This doesn't scale well for adding new fields to our form or make for very _readable_ code. Indentation can be difficult to follow, particularly with so many `else` statements at each fork.

{{< highlight swift >}}
func nonguardSubmit() {
    if let name = nameField.text {
        if let address = addressField.text {
            if let phone = phoneField.text {
                sendToServer(name, address: address, phone: phone)
            } else {
                show("no phone to submit")
            }
        } else {
            show("no address to submit")
        }
    } else {
        show("no name to submit")
    }
}
{{< /highlight >}}

Yes, we could even combine all these `if let` statements into a single statement separated with commas but we would loose the ability to figure out which statement failed and present a message to the user.

### Validation and testing with `guard`

One argument against using guard is that it encourages large and less testable functions by combining tests for multiple values all in the same place. If used naively, this could be true but with the proper use, `guard` allows us to smartly separate concerns, letting the view controller deal with managing the view elements while the value validation for these elements can sit in a fully tested validation class or extension.

Let's take a look at a naively constructed `guard` statement with validation:

{{< highlight swift >}}
guard let name = nameField.text where name.characters.count > 3 && name.characters.count <= 16, let range = name.rangeOfCharacterFromSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) where range.startIndex == range.endIndex else {
    show("name failed validation")
    return
}

submit(name)
{{< /highlight >}}

You can probably tell we're stuffing too much functionality into a single function here. Not only do we check for existence of the name field, we also check that the name is between 3 and 16 characters in length and that it contains no newlines or whitespaces. Not only is this busy enough to be nearly unreadable, it's unlikely to be tested because we can't validate the name field without interacting with the UI and submitting the name to the server.

Realistically, this view controller could be handling 5 inputs and each should be checked for validity before it's submitted. Each one could look just like this, leading to a truly massive view controller.

{{< highlight swift >}}
func () {
    guard let name = nameField.text where isValid(name) else {
        show("name failed validation")
        return
    }

    submit(name)
}

func isValid(name: String) -> Bool {
    // check the name is between 4 and 16 characters
    if !(4...16 ~= name.characters.count) {
        return false
    }

    // check that name doesn't contain whitespace or newline characters
    let range = name.rangeOfCharacterFromSet(.whitespaceAndNewlineCharacterSet())
    if let range = range where range.startIndex != range.endIndex {
        return false
    }

    return true
}
{{< /highlight >}}
