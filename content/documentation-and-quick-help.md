---
title: "Third Party Documentation and Quick Help"
date: "2014-08-11"
tags: [""]
description: ""
---
Beta 5 brought us some notable improvements in optionals and ranges but also the beginning of support for Quick Help in Swift. I didn't realize that Quick Help was a "hidden" feature of Xcode until I mentioned it to someone at the [SF Swift Meetup](www.meetup.com/San-Francisco-SWIFT-developers/) last week who was unfamiliar. As luck would have it, we're now able to discuss how to document Swift in a similar way as our Objective-C.

First, if you're unfamiliar with Quick Help in Xcode 5 or 6, find a UIKit class or method in your code and hold your `option` key down while hovering over it. You should see a question mark cursor like this:

![The Quick Help cursor](/images/quickhelp-cursor.jpg)

Clicking on 

http://docutils.sourceforge.net/docs/user/rst/quickref.html


![The Quick Help menu](/images/quickhelp-menu.jpg)

Third party documentation has changed ever so slightly in Swift and I wanted to take the opportunity to highlight a feature that was introduced in Xcode 5 which I've come to appreciate while using Swift.

First, the feature: while documentation-browsing tools like Dash and even the integrated Xcode docs window are great, sometimes you want to have a peek at the documentation for this particular method, not the whole class. Enter Quick Help.

As shown above, option-clicking on almost any Apple-provided class or method in Xcode brings up a nice 

{{% prism swift %}}/**
Sends an API request to 4sq for venues around a given location with an optional text search

:param: location    A CLLocation for the user's current location
:param: query       An optional search query
:param: completion A closure which is called with venues, an array of FoursquareVenue objects

:returns: Void
*/
func requestVenues(location: CLLocation, query: String?, completion: (venues: [FoursquareVenue]?) -> Void) { … }
{{% /prism %}}