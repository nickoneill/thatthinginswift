---
date: 2015-04-15T10:56:14-07:00
title: "Writing files to the documents directory"
htmltitle: "Writing files to the documents directory in Swift"
description: "Where you should write files"
---
Just a quick one today: Pulling the proper documents directory on iOS has always been a pain and a bit of code that I always forget. Here's a reminder for you and I.

Remember on iOS that we can only write to our application's documents directory. We're sandboxed out of most of the system and other applications to save us from each other and we can't write into to the main bundle because that would defeat our code signature.

In Objective-C, something like this would get us the current documents directory:
{{% prism objectivec %}}
NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
NSString *filePath = [documents stringByAppendingPathComponent:@"file.plist"];
{{% /prism %}}

And you typically find this paired with simple serialization of `NSArray` or `NSDictionary` objects:

{{% prism objectivec %}}
// reading...
NSArray *objects = [NSArray arrayWithContentsOfFile:filePath];

// or writing
[objects writeToFile:filePath atomically:YES];
{{% /prism %}}

The Swift version is similar, but more compact with our more concise constants:
{{% prism swift %}}
let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
let writePath = documents.stringByAppendingPathComponent("file.plist")
{{% /prism %}}

Note our new downcast syntax (`as!`) for Swift 1.2!

Reading and writing `NSArray` and `NSDictionary` is almost exactly alike, aside from checking the optional returned by `contentsOfFile:`.
{{% prism swift %}}
let array = NSArray(contentsOfFile: filePath)
if let array = array {
    array.writeToFile(filePath, atomically: true)
}
{{% /prism %}}

This is nice if you're doing something simple but often we'd like to deal with Swift-native `Dictionary` and `Array`. Luckily, it's easy to convert between these older NS-types and our Swift natives. And the objects are much more powerful to deal with if you can cast them into their proper types:
{{% prism swift %}}
let swiftArray = NSArray(contentsOfFile: filePath) as? [String]
if let swiftArray = swiftArray {
    // now we can use Swift-native array methods
    find(swiftArray, "findable string")
    // cast back to NSArray to write
    (swiftArray as NSArray).writeToFile(filePath, atomically: true)
}
{{% /prism %}}

That's it. It truly is a wonder that I can't remember it.

Finally, one thing to avoid. You may run into some old Objective-C code that uses this example:
{{% prism objectivec %}}
// this returns an NSURL, *not* a NSString!
NSURL *documents = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
{{% /prism %}}

I've had various permissions issues between the simulator/devices with file urls so I tend to avoid them in favor of path strings. You can go back and forth easily if there's a particular API that demands one format or the other.