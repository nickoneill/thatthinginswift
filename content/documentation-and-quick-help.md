---
title: "Third Party Documentation"
date: "2014-08-11"
tags: [""]
draft: true
description: ""
---
Everyone loves the fascinating topic of documentation!

Third party documentation has changed ever so slightly in Swift and I wanted to take the opportunity to highlight a feature that was introduced in Xcode 5 which I've come to appreciate while using Swift.

First, the feature: while documentation-browsing tools like Dash and even the integrated Xcode docs window are great, sometimes you want to have a peek at the documentation for this particular method, not the whole class. Enter Quick Help.

As shown above, option-clicking on almost any Apple-provided class or method in Xcode brings up a nice 

{{% prism 'swift' %}}
/**
Sends an API request to 4sq for venues around a given location with an optional text search

:param: location    A CLLocation for the user's current location
:param: query       An optional search query
:param: completion A closure which is called with venues, an array of FoursquareVenue objects

:returns: Void
*/
func requestVenues(location: CLLocation, query: String?, completion: (venues: [FoursquareVenue]?) -> Void) { … }
{{% /prism %}}