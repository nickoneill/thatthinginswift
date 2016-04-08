---
title: "Faux Dependency Injection for Storyboards"
date: "2016-04-07"
description: "Automatically pass properties through view controllers"
previewCode: dependency-injection
---
I do a lot of work where I have to set up views and view controllers for a large number of screens and I have to admit that I enjoy using Storyboards for most of it. I know it's a polarizing subject with iOS developers and there are lots of specific instances where Storyboards don't work or work poorly, but for the most part my process for using Storyboards is hassle-free. I attribute a large part of this to doing as much layout as possible in Storyboards and keeping configuration in code, either as [initialization closures](https://thatthinginswift.com/kill-your-viewdidload/) or in object subclasses.

However, my biggest issue with Storyboards is lack of dependency injection. If you're developing views entirely in code, you can customize your initialization methods to take required (or optional) parameters that influence the loading and display of your view controller.

Consider a profile screen that shows the current user's profile picture, username, email, etc. We could load our current user from our session singleton and configure the views in `viewDidLoad` and immediately configure our views with the user's data. But if we want to share this screen for displaying profiles of other users, we have to do some extra work by implementing some session singleton method for getting the data for the other users. That doesn't feel nice, and definitely not very Swifty.

Instead, it'd be better to pass the user object that we want to display into our profile view controller on initialization and then be able to use that data in `viewDidLoad` to set the detailed data in our views. If you're building your app entirely in code, this is straightforward to accomplish because you can create the initialization method for your view controller and use that specific method when you want to push your profile onto the screen:

{{<highlight swift>}}
class ProfileViewController: UIViewController {
    var profileUser: User

    init(user: User) {
        profileUser = user

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainViewController: UIViewController {
    @IBAction func profile() {
        let currentUser = User(name: "Nick", userpicURL: NSURL(string: "https://thatthinginswift.com/profile.png"))

        let profile = ProfileViewController(user: currentUser)
        navigationController?.pushViewController(profile, animated: true)
    }
}
{{</highlight>}}

We don't control the call to `ProfileViewController`'s init method (`initWithCoder`, actually) when using a Storyboard so we're out of luck there. I've been using the `prepareForSegue` method to add any data that the upcoming view controller needs which does the job, albeit with too much boilerplate code for my liking. There's a good rundown of this method at [Natasha the Robot](https://www.natashatherobot.com/ios-view-controller-data-injection-with-storyboards-and-segues-in-swift/) last week, here's the short example:

{{<highlight swift>}}
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "profile" {
        let currentUser = User(name: "Nick", userpicURL: NSURL(string: "https://thatthinginswift.com/profile.png"))

        let dest = segue.destinationViewController as! ProfileViewController
        dest.profileUser = currentUser
    }
}
{{</highlight>}}

`prepareForSegue` is really the only option for setting these values before the new view controller takes over, so any workaround we're going to make is going to revolve around `prepareForSegue`. Luckily it occurs before `viewDidLoad` for the new view controller and `viewDidLoad` is typically the first time you take control in a view controller so (for the most part) you can behave as though `profileUser` always existed since initialization.

---

The first solution I came up with is a `UIViewController` subclass I call `PreparedViewController` and it overrides `prepareForSegue`, reflects on the properties of the current view controller and the segue destination controller and automatically copies values that have a given prefix. It's tiny, so we can just show the code and usage:

{{<highlight swift>}}
class PreparedViewController: UIViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController

        // get any destination properties with our prefix
        let prepProps = Mirror(reflecting: dest).children.filter { ($0.label ?? "").hasPrefix("prepCtx") }
        for prop in prepProps {
            // check for a property on the current view controller with the same name
            let selfProps = Mirror(reflecting: self).children.filter { ($0.label ?? "") == prop.label }
            // unwrap everything and set via KVC
            if let sameProp = selfProps.first, childObject = sameProp.value as? AnyObject, label = prop.label {
                dest.setValue(childObject, forKey: label)
            }
        }
    }
}

class ViewController: PreparedViewController {
    let prepCtxFloat = 40.5
    let regularFloat = 20.1
}

// segue between ViewController and SecondViewController set in Storyboard

class SecondViewController: UIViewController {
    var prepCtxFloat: Float = 0
    var regularFloat: Float?

    override func viewDidLoad() {
        // prepCtxFloat is now 40.5
    }
}
{{</highlight>}}

In this case, `SecondViewController`'s `prepCtxFloat` will be set to 40.5 automatically during the segue because the property names match, `regularFloat` won't move between `ViewController` and `SecondViewController` because it doesn't have the required `prepCtx` prefix.

This approach uses key value coding to accomplish the assignment which isn't exactly a problem - UIViewController is an NSObject subclass anyway - but it's brittle if the types don't match. You could add some more strict type checking to prevent crashes, that's information that `Mirror` will provide, but there's no way to get compile-time information about which transitions will work.

The other gotcha is that the receiving view controller's properties must be `var` and must have an initial value (i.e. they can't be optional because that's not compatible with Objective-C and thus KVC, you'll get a `this class is not key value coding-compliant` error if you try this with an optional). Maybe not a big deal for simple values, but you'll soon dread creating large dummy objects to be held only until `prepareForSegue` replaces them. Default values in a world where optionals are the real solution also rub me the wrong way.

The second solution I came up with is almost not worth mentioning: a protocol that requires a common `segueContext` dictionary in each view controller and syncs them during `prepareForSegue`. The protocol-ness means you'd still have to call `syncContext` or something during segue. And I'm not sure I want to go back to a world where I have to remember which type is which when unwrapping all these magic strings from a dictionary. *All the complexity of a JSON parser but available to you whenever you perform a segue!*

---

This is the second time I've run into an implementation that could have been greatly improved by something like native Swift KVC support. It's a bit unfortunate - but understandable - that something KVC-like has been pushed to post-3.0 work, we'll just have to wait a bit longer before these kinds of tools can be seamless.
