---
title: "Quick Help and Third Party Documentation"
htmltitle: "Xcode Quick Help and Documentation in Swift"
date: "2014-08-13"
description: "Inline usage docs come to Swift"
---
> You may also want to check out the [Swift Documentation](http://nshipster.com/swift-documentation/) post from NSHipster.

Beta 5 brought us some notable improvements in optionals and ranges but also the beginning of Quick Help in Swift. I didn't realize that Quick Help was a "hidden" feature of Xcode until I mentioned it at the [SF Swift Meetup](http://www.meetup.com/San-Francisco-SWIFT-developers/) last week and realized some were unfamiliar. As luck would have it, we're now able to discuss how to document Swift in a similar way as our Objective-C.

First, a quick introduction to Quick Help in Xcode 5 or 6. Find a UIKit class or method in your code and hold your `option` key down while hovering over it. You should see a question mark cursor like this:

![The Quick Help cursor](/images/quickhelp-cursor.jpg)

Clicking on the that link should bring up a small popover like this one with details on the class or method:

![The Quick Help menu](/images/quickhelp-menu.jpg)

This is all powered by inline documentation; snippets of text that precede class or method definitions and provide a quick look into the important parts of the code, like parameter and return types, or text describing cases where you might use the code. In Objective-C, there were a few different formats that you could use but in general documentation looked like this:

{{% prism objectivec %}}/**
  * Sends an API request to 4sq for venues around a given location with an optional text search
  *
  * @param location A CLLocation for the user's current location
  * @param query An optional search query
  * @param completion A block which is called with venues, an array of FoursquareVenue objects
  * @return No return value
*/
- (void)requestVenues:(CLLocation *location) withQuery:(NSString *query) andCompletion:(void (^)(NSArray *))completion { … }
{{% /prism %}}

Apple has lots of words around writing the kind of documentation it calls [**HeaderDoc**](https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/HeaderDoc/intro/intro.html) and that format applies for lots of other languages, not just C-like ones.

However, like many things related to Swift, Apple has taken an opportunity to reboot the documentation platform with the new language. With Swift, we now have something that feels similar, but is not quite the same:

{{% prism swift %}}/**
Sends an API request to 4sq for venues around a given location with an optional text search

:param: location    A CLLocation for the user's current location
:param: query       An optional search query
:param: completion  A closure which is called with venues, an array of FoursquareVenue objects

:returns: No return value
*/
func requestVenues(location: CLLocation, query: String?, completion: (venues: [FoursquareVenue]?) -> Void) { … }
{{% /prism %}}

The formatting is based on an open source project called [reStructuredText](http://docutils.sourceforge.net/docs/user/rst/quickref.html) which, even though I lament the fragmentation of quick markup languages, seems particularly suited to documentation use with lots of ways to easily link to related code.

However, the Swift/Xcode 6 support is limited so far. You can create basic text, lists and just a few “field lists” (like `:param:` and `:returns:`), which is everything you need to add basic documentation but I expect more features to show up in the next few betas to round out support for this new documentation format.

So, as a reminder, if you're writing code that has the remote possibility of someone else using or interacting with it, do them a favor and write some quick inline docs. You can think of it as a step 1 in planning a new method or class, just whip up a quick idea of what you want it to input and output, then go on to writing the code itself. Once your code settles into a semi-stable state, you'll find it pretty easy to clean up your pre-documentation and add any extra details you may have discovered while implementing it.
