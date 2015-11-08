---
date: 2014-07-01T10:02:03-07:00
title: "Remote Notifications"
htmltitle: "iOS Remote Notifications in Swift"
description: "Seriously, don't ask for notifications on start up"
---
Remote notifications is an interesting case in swift because we've run into our first deprecated method. While we could technically use the old iOS 7 remote notification methods through the Objective-C bridge, Apple has decided that swift developers are all forward thinking and may not use deprecated methods. Hey, it makes some sense: deprecation is like a warning for existing production code. *You should update this because it'll probably break in the future!* There's no swift production code yet, so no need for the gentle treatment when it comes to old APIs.

Previously, with Objective-C:

{{< highlight objectivec >}}
[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
{{< /highlight >}}

Then you implemented the delegate callbacks:

{{< highlight objectivec >}}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	NSLog("Got a %@",deviceToken);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog("Couldn't register: %@",error);
}
{{< /highlight >}}

Now, in swift code intended for iOS 8, things are a similar:

{{< highlight swift >}}
// somewhere when your app starts up
UIApplication.sharedApplication().registerForRemoteNotifications()

// implemented in your application delegate
func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!) {
	println("Got token data! \(deviceToken)")
}

func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError!) {
	println("Couldn't register: \(error)")
}
{{< /highlight >}}

**But one more thing!** Your application needs to separately register the types of notifications it can receive and this is the action that prompts the user for permission to show notifications.

{{< highlight swift >}}
let settings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
UIApplication.sharedApplication().registerUserNotificationSettings(settings)
{{< /highlight >}}

Remember when these were joined at the hip in iOS 7? Apple is obviously encouraging developers to get the device token on startup, as is natural, and then prompting the user for permission later when you're in the context of something that you want to be notified about. *Seriously kids, don't ask for permission immediately after your app starts up.*

As extra encouragement, Apple has given us a few bonus methods to know more about the state of remote notifications. First, a delegate method that returns when you register your settings:

{{< highlight swift >}}
func application(application: UIApplication!, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings!) {
	// inspect notificationSettings to see what the user said!
}
{{< /highlight >}}

And secondly, for when you're just curious about the current state of notification permissions:

{{< highlight swift >}}
let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
{{< /highlight >}}

Since we can request specific permissions (`.Alert`, `.Badge`, `.Sound`) and then inspect the settings immediately after, **we can know what settings the user has allowed and denied on a per-type basis**. This is huge for app developers trying to figure out if a user is getting notifications.

*Note the interesting method signatures for the new delegate methods!* This is a case of external parameter names which you can learn more about in the [method signatures](/method-signatures) post.
