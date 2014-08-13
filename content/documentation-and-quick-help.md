---
title: "Third Party Documentation and Quick Help"
date: "2014-08-11"
tags: [""]
description: ""
---
Beta 5 brought us some notable improvements in optionals and ranges but also the beginning of Quick Help in Swift. I didn't realize that Quick Help was a "hidden" feature of Xcode until I mentioned it at the [SF Swift Meetup](www.meetup.com/San-Francisco-SWIFT-developers/) last week and realized some were unfamiliar. As luck would have it, we're now able to discuss how to document Swift in a similar way as our Objective-C.

First, a quick introduction to Quick Help in Xcode 5 or 6. Find a UIKit class or method in your code and hold your `option` key down while hovering over it. You should see a question mark cursor like this:

![The Quick Help cursor](/images/quickhelp-cursor.jpg)

Clicking on the that link should bring up a small popover like this one with details on the class or method:

![The Quick Help menu](/images/quickhelp-menu.jpg)

This is all powered by inline documentation; snippets of text that precede class or method definitions and provide a quick look into the important parts of the code, like parameter and return types, or text describing cases where you might use the code.

{{% prism objectivec %}}
/**
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

However, like many things related to Swift, Apple has taken an opportunity to reboot the documentation platform with the new language. We now get something that feels similar, but is not quite the same:

{{% prism swift %}}/**
Sends an API request to 4sq for venues around a given location with an optional text search

:param: location    A CLLocation for the user's current location
:param: query       An optional search query
:param: completion A closure which is called with venues, an array of FoursquareVenue objects

:returns: Void
*/
func requestVenues(location: CLLocation, query: String?, completion: (venues: [FoursquareVenue]?) -> Void) { … }
{{% /prism %}}

The formatting is based on an open source project called [reStructuredText](http://docutils.sourceforge.net/docs/user/rst/quickref.html) which, even though I lament the fragmentation of quick markup languages like markdown, seems particularly suited to documentation use.

It’s fairly limited so far. You can create basic text, lists and just a few “field lists” (like `:param:` and `:returns:` - everything you need to add basic documentation -  but I expect more features to show up in the next few betas to round out support for this new documentation format.

As we know, working with Swift is only so 