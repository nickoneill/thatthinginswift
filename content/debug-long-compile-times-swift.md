---
title: "Speeding Up Slow Swift Build Times"
date: "2016-04-26"
description: "Find problem areas in Xcode and specify type information"
previewCode: type-inference
---
A quick note today: People seemed interested at the ease in which we can currently make the Swift 2.2 compiler take 12+ hours to compile some basic code because of type inference. From [this post by Matt Nedrich](https://spin.atomicobject.com/2016/04/26/swift-long-compile-time/), we can see a simple example of code taking way too long to figure out what types should be used.

{{<highlight swift>}}
let myCompany = [
   "employees": [
        "employee 1": ["attribute": "value"],
        "employee 2": ["attribute": "value"],
        "employee 3": ["attribute": "value"],
        "employee 4": ["attribute": "value"],
        "employee 5": ["attribute": "value"],
        "employee 6": ["attribute": "value"],
        "employee 7": ["attribute": "value"],
        "employee 8": ["attribute": "value"],
        "employee 9": ["attribute": "value"],
        "employee 10": ["attribute": "value"],
        "employee 11": ["attribute": "value"],
        "employee 12": ["attribute": "value"],
        "employee 13": ["attribute": "value"],
        "employee 14": ["attribute": "value"],
        "employee 15": ["attribute": "value"],
        "employee 16": ["attribute": "value"],
        "employee 17": ["attribute": "value"],
        "employee 18": ["attribute": "value"],
        "employee 19": ["attribute": "value"],
        "employee 20": ["attribute": "value"],
    ]
]
{{</highlight>}}

Build and run any files with this and Swift will get stuck on compilation for *at least* 12 hours (from Matt's experiments). He notes that less employees take significantly less time to compile (though still way more than you'd expect). Seven employees takes my Mid-2011 iMac (3.4Ghz i7) about 630ms to compile. That might not sound like a lot by itself but it's a lot more realistic: the danger is spreading little increases in compile time all over your Swift code, leading to overall wait times for each build measured in tens of minutes.

This is a type inference problem. The Swift compiler doesn't know what type is coming next so it has to investigate and find out before it can continue compilation. This case is a particular "quirk" where adding more data increases compile time exponentially but fundamentally Swift is doing __The Right Thing__: checking which type it thinks you mean.

One of my favorite features of Swift is type inference so I'm not going to just stop using it because it can cause build time increases. Instead, we should focus on identifying problem areas (sometimes in unexpected places!) and helping the Swift compiler determine the correct type in the short term. The long term solution rests on the Swift compiler team 😅

If you suspect that something is taking too long to compile in your Swift project, you should turn on the `debug-time-function-bodies` option for the compiler. In your project in Xcode, go to __Build Settings__ and set __Other Swift Flags__ to `-Xfrontend -debug-time-function-bodies`.

{{<figure src="http://nickoneill-blog.s3.amazonaws.com/images/swift-debug-time.png" title="Set debug-time-function-bodies for the Swift compiler">}}

Now that Swift is recording the time taken to compile *each function*, build your project again with ⌘-B and jump over to the __Build Report__ navigator with ⌘-8 where you'll see the most recent build (and possibly some others).

{{<figure src="http://nickoneill-blog.s3.amazonaws.com/images/swift-build-report.png" title="Navigate to the build report with ⌘-8">}}

Next, right-click on the build log for the target you built and select __Expand All Transcripts__ to show the detailed build log.

{{<figure src="http://nickoneill-blog.s3.amazonaws.com/images/swift-expand-all-transcripts.png" title="Expand All Transcripts to see the detailed build log">}}

Finally, you should see a series of green boxes, each representing a file or step in the compilation process. The text inside these boxes may take a moment (or a click) to load properly. If you correctly set up the build flags to show function compilation times, you should see a line of build times along the left. Scan these lines for anything that looks suspect! Anything longer than a hundred milliseconds should be investigated.

{{<figure src="http://nickoneill-blog.s3.amazonaws.com/images/swift-long-compile-function.png" title="Spot long compile times along the left side of the build log">}}

We can see our __630ms+__ compile time in `viewDidLoad` where we were testing the type inference earlier. 630ms for just a few lines of code!

Now that we know type inference can be a problem here, we can investigate the problem areas, specify type information and try building again. In this case, simply defining the structure to be a `Dictionary<String, AnyObject>` brings our compile time for that function down to __21.6ms__. Even adding the rest of the employee objects back in doesn't meaningfully change the compile time. Problem solved! Hit the rest of the potential problem areas in your code and try adding type information to speed up the compile times for the rest of your project.

{{<highlight swift>}}
let myCompany: Dictionary<String, AnyObject> = [
    "employees": [
        "employee 1": ["attribute": "value"],
        "employee 2": ["attribute": "value"],
        "employee 3": ["attribute": "value"],
        "employee 4": ["attribute": "value"],
        "employee 5": ["attribute": "value"],
        "employee 6": ["attribute": "value"],
        "employee 7": ["attribute": "value"]
    ]
]
{{</highlight>}}

---

Two updates since just __yesterday__: the bug in question has been [fixed for the next swift release](https://github.com/apple/swift/commit/2cdd7d64e1e2add7bcfd5452d36e7f5fc6c86a03) (3?). This shouldn't be read as "all type inference issues have been fixed", but the problem that was causing this one to grow exponentially was fixed. I should also suggest that if you run into something similar (find them with the method mentioned above!), file a bug at [bugs.swift.org](https://bugs.swift.org) and it *will* get fixed!

Secondly, [Erik Aderstedt](https://twitter.com/erikaderstedt) mentioned a great way to automatically sort your function timing results so you can find the biggest slowdowns:

{{<tweet 725217977314992128>}}
