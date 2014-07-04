---
date: 2014-07-01T10:02:03-07:00
draft: true
title: remote notifications
---

Previously

	- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types

And

	- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken

or

	- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error

Now:

	application.registerForRemoteNotifications()
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!)
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError!)
