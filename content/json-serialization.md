---
title: "JSON Serialization"
htmltitle: "JSON Serialization in Swift"
date: 2014-06-28T10:54:37Z
description: "Ranked highly for methods likely to be updated for Swift"
previewCode: json-serialization
---

JSON serialization is essentially unchanged in Swift for one reason: it happens in foundation objects just as it did in Objective-C. Once we get the results back there are slightly different patterns for dealing with the data which we'll see shortly.

The basics, in Objective-C:

{{< highlight objectivec >}}
NSData *data = ...some data loaded...;
NSError *jsonError = nil;
NSDictionary *decodedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
if (!jsonError) {
  NSLog(decodedData[@"title"]);
}
{{< /highlight >}}

Lots of boilerplate, but still pretty simple. Now the same, in Swift:

{{< highlight swift >}}
let data: NSData = ...some data loaded...
let jsonError: NSError?
let decodedJson = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError!) as Dictionary<String, AnyObject>
if !jsonError {
  println(decodedJson["title"])
}
{{< /highlight >}}

Yes, just like before when we had to know we were going to get back an `NSDictionary` from `JSONObjectWithData:options:error:`, we still have to cast the return from `AnyObject` to a `Dictionary<String, AnyObject>` (or whatever type is appropriate). Such are the perils of working with JSON. We could inspect the return type before using it for a more generic case but you'll probably use the simpler example above when you already know the expected type.

But what! We still have to use `&` to pass a pointer to the serialization call! This is pretty un-Swifty and I suspect that a future where Apple is using Swift internally will deliver us more Swifty API calls. For now, at least understand that the `&` here doesn't actually mean a pointer (there are no pointers in swift), but rather an `inout` variable. `inouts` are just markers to let functions know they can modify the parameters being passed in. The style is pretty C-like so I'm curious why it was included in the language, especially since we have multiple return values in Swift (hit us up for [ideas on twitter](http://twitter.com/objctoswift)).
