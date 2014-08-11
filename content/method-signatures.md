---
date: 2014-07-07T10:02:03-07:00
title: "Method Signatures"
description: "Really long method signatures live to see another day"
---
While writing up [remote notifications](/remote-notifications), I noticed that I hadn't covered a relatively simple but important difference between Objective-C and swift. Method signatures seem like the first thing you learn in any language and they're immediately useful knowing just the basics of writing signatures. However, the expectation that swift programmers know how to use slightly different Objective-C methods in our swift code adds some quirkiness to our understanding.

The case that brought this to my attention was translating the sentence-like structure of remote notifications delegate methods like this one:

{{% prism swift %}}func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!){{% /prism %}}

This is a case of direct translation from Objective-C methods that don't really look right in swift. The reason this works is swift's **external parameter names**, which I think of as one of those features that might only be handy when using both swift and Objective-C. In short, functions can have a name used to pass a parameter into a function and a name used for that parameter inside the function.

A method can be defined like this:

{{% prism swift %}}func repeatThis(name: String, andDoItThisManyTimes times: Int) {
	for i in 0..&lt;times {
		println(name)
	}
}{{% /prism %}}

So that when called it has that nice sentence structure, like Objective-C:

{{% prism swift %}}repeatThis("swift", andDoItThisManyTimes: 3){{% /prism %}}

But internally, the function references `times`, not `andDoItThisManyTimes`.
