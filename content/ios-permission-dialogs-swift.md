---
title: "Great iOS Permission Dialogs with PermissionScope"
htmltitle: "iOS Permission Dialogs with PermissionScope in Swift"
date: 2015-05-26T10:54:37Z
description: "Give clarity, get permissions"
---

*from [the original article](https://medium.com/ios-os-x-development/periscope-like-permissions-for-ios-apps-5b744b4bf5ed) I wrote on Medium*

[PermissionScope](https://github.com/nickoneill/PermissionScope) is an open-source permissions dialog inspired by [Periscope](https://www.periscope.tv/), the broadcasting app purchased by Twitter recently. My goal was to create a permissions dialog that was flexible and clear for users, increasing the number of users who approved requests for any given permission. It should be easy for developers to configure and use so you can have a great permissions experience in your app even if it’s your first version.

![Periscope vs. PermissionScope dialogs](https://d262ilb51hltx0.cloudfront.net/max/2000/1*NEQylpTpNKu4ApARfG50-A.jpeg)

The repo saw some good star-momentum last week but Github isn’t exactly the best place to go longform about the inspiration behind the code. We even saw a shoutout from Periscope founder [@kayvz](https://twitter.com/kayvz) and some insight into the original inspiration from [@mulligan](https://twitter.com/mulligan) at Cluster.

<blockquote class="twitter-tweet" data-cards="hidden" lang="en"><p lang="en" dir="ltr">Great to see folks thinking about permissions priming <a href="https://t.co/KFI5szA476">https://t.co/KFI5szA476</a> Shoutout to <a href="https://twitter.com/mulligan">@mulligan</a> for inspiring <a href="https://twitter.com/periscopeco">@periscopeco</a>&#39;s approach</p>&mdash; Kayvon Beykpour (@kayvz) <a href="https://twitter.com/kayvz/status/596437574601875457">May 7, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Every great product is born from some engineer frustration, right? Same with PermissionScope. I was struggling with how to present permissions when we were building treat. There are no existing projects that have kept up with the current state of iOS apps and provide a low-cost (a.k.a. low-time) way to ask for permissions. The super-slick contextual explanation flows are nice but do you want to spend time during your initial app release building one?

Practically every app gets iOS permissions wrong. The worst cases ask for every permission immediately on startup, barraging the user with a bunch of dialogs before they even know what your app does. I have seen this play out while watching people use apps over and over again and (unless your app is a personal recommendation), usually the answer is No, Reject, Disallow, etc.

This probably results in your app not working correctly. If you need Contacts permission to send invites and the user disallowed that permission, they’re probably not going to invite anyone to use your app.

Maybe this is “fine” because you’ve designed your invite screen to prompt them to reenable this in settings. But that’s not a good experience for anyone. And on the flip side, no one wants to waste their time implementing worst-case-scenario code in an MVP app.

## Enter PermissionScope

PermissionScope a take on the permissions overlay from Periscope which really stuck with me. I haven’t seen a post from Periscope explaining their reasoning for building the original version but I knew it was the future of permissions right when I saw it.

I have been an advocate for *responsible permissioning* for a while but it’s not easy to do right. I was using [ClusterPrePermissions](https://github.com/clusterinc/ClusterPrePermissions) which is a good way to alert your users that permissions are going to be asked for and give some explanation for why you need permissions. But users don’t read things, particularly things that look like default iOS dialogs.

![Cluster PrePermissions](https://d262ilb51hltx0.cloudfront.net/max/1600/1*qNOwyORKO5IM8o30i9WNZQ.jpeg)

They (Cluster Inc) have a [long post here](https://medium.com/launch-kit/the-right-way-to-ask-users-for-ios-permissions-96fa4eb54f2c) describing the right way to ask for permissions which I generally agree with. The problem here was that the only publicly available code is the sucky pre-permissions dialogs, not the nice contextual ones.

Contextual permission flows tend to be fairly customized and hard to share across apps which is one of the reasons I jumped when I saw the Periscope version. It’s easily usable for the common scenario where one or more permissions are required to use the next screen in your app. It gives a basic amount of description for why your app needs the permission and it doesn’t look like a generic iOS dialog.

## When to use PermissionScope

It makes the most sense to present PermissionScope when a user is tapping through to an action or flow that they cannot perform without providing permissions. This is what we mean by contextual permissions.

Plenty of apps have this sort of behavior somewhere in their apps:

* User invitations need Contacts access
* Camera apps need Camera and Microphone access
* Image filter apps need access to pull and save from the Photo album

Sometimes this means you need more than one permission for a particular flow, like in treat. We need both contacts and location access so you can send a *treat* to a *friend* at a *location*.

Moving through the main flow for your app should be enjoyable. Each step is a tiny bit of success for the user and interrupting each one with permissions dialogs ruins the experience.

That’s why we present all the permissions at once, letting the user deal with permissions at their own pace and without asking them to context-switch back into your app flow two or three times.

We’ve included almost all the permissions available in PermissionScope so whatever your permissions requirements are, PermissionScope should cover it now or soon.

## Optional permissions

If you’ve used the treat dialog, you might notice that Notifications permission is also optional. If you allow Contacts and Location, the “Let’s go” button is enabled and the user can move on without enabling Notifications. In addition, if the user opts to ignore Notifications on this first pass, we don’t ask them again until they hit a different required permission. Once all the required permissions are met, the prompt no longer appears on subsequent visits.

Why did we add notifications to this screen? It seems unrelated to the task at hand but we’re already asking you to approve stuff, why not take one more action? What were trying to avoid is random dialogs thrown in the users face while they’re still determining the value of your application.

I’m still not 100% on that behavior. I’d like to give the user another contextual way to turn on notifications when it really is relevant but I haven’t figured out how to re-prompt without feeling spammy. Still working on this.

**Periscope also has a smaller version for just notifications** that is a little more in-context for that permission. This feels nice and I’m considering extending PermissionScope to deal with these one-off cases more cleanly.

Do we still have normal permission actions? Sure, there’s a place for these. We still provide the basic location dialog for our geofencing setting. It works because it’s in direct response to a user action stating that they want some feature, unlike our initial permission dialog which usually occurs before the user knows how the app works.

Finally, if the user does reject the permissions for some reason, we make it clear what is preventing them from moving forward in the dialog and tapping presents a helpful link which sends them into Settings to reenable (I love this part but can’t take full credit, a [pseudo-anonymous helpful committer laid most of the groundwork](https://github.com/nickoneill/PermissionScope/pull/8)).

## tl;dr

PermissionScope is a new way to ask for iOS permissions in-context. It’s [on github](https://github.com/nickoneill/PermissionScope) with a nice example app. Also Github does not support emoji on headers in Readme files 🔒🔭

If you don’t want to build-and-run yourself, download [treat](https://gettre.at) and give it a shot. You’ll hit a permissions dialog when you send your first treat or if you redeem one you’ve been sent.