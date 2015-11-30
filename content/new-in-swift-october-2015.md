---
title: New in Swift, October 2015
date: "2015-10-05"
htmltitle: "New in Swift, October 2015"
description: "Coach marks, JSON decoding and stack views"
---
Something new! I'm going to try branching out from our traditional Objective-C -> Swift format. To start, there are a lot of interesting Swift libraries popping up which I try to feature periodically [on Twitter](https://twitter.com/objctoswift) but you might miss them there, dear reader. I'll summarize the best every month with a post here.

[**Instructions**](https://github.com/ephread/Instructions)

![Instructions](https://camo.githubusercontent.com/9d7ebd2fb87dccc3c87dc12a0491caad73e03aeb/687474703a2f2f692e696d6775722e636f6d2f39323763726c442e706e67)

Coach marks are a little contentious in the app design world. The suggestion is that your app design should be clear enough that users know what everything does without having to be "coached" through it. I don't have a clear YES/NO opinion on using them personally... I've used apps that explain *every* part of their UI with coach marks which is excessive. I bet minimal use of these could contribute nicely to your app.

My primary reason for including this is how damn beautiful it is. One could easily see an app that adds this component and makes these marks the *nicest* designed part of the app.

- - -

[**Unbox**](https://github.com/JohnSundell/Unbox)

Unbox is a JSON decoder that requires minimal boilerplate setup and has recently been updated to Swift 2. It really doesn't get any simpler than this:

{{<highlight swift>}}
struct User: Unboxable {
    let name: String
    let age: Int

    init(unboxer: Unboxer) {
        self.name = unboxer.unbox("name")
        self.age = unboxer.unbox("age")
    }
}
{{</highlight>}}

- - -

[**UIStackViewPlayground**](https://github.com/dasdom/UIStackViewPlayground)

I knew stack views (new in the iOS 9 SDK) were supposed to be powerful but this collection of playgrounds really nails the point home. It shows off how to layout the iOS calculator view, a more detailed scientific calculator view, a pretty standard profile view, tweet view, mailbox view and iOS homescreen view.

I'm convinced that stack views can create anything. Now I just have to convince all my users to upgrade to iOS 9 so I can use them 😕

- - -

[**RateLimit**](https://github.com/soffes/RateLimit) & [**AwesomeCache**](https://github.com/aschuch/AwesomeCache)

Here's a related pair. *AwesomeCache* is a simple Swift cache that lets you put stuff away for later but with a really nice expiration mechanism:

{{<highlight swift>}}
cache.setObject("Alex", forKey: "name", expires: .Seconds(60 * 60 * 24)) // expire in a day
{{</highlight>}}

I use this all the time to cache API calls to data that rarely changes. It could use some update to be more Swifty and less `NSKeyedArchiver`-y but it'll do for now.

For more short term and ephemeral "caching" you can try *RateLimit* which will only run a block as frequently as you specify. The given example is a perfect one: say you refresh a page in `viewDidAppear:` and you don't want to overdo it when users are constantly navigating back and forth from a list to a detail screen. Wrap that refresh in a block set to 60 seconds and that screen will only grab new data every minute.

{{<highlight swift>}}
RateLimit.execute(name: "RefreshTimeline", limit: 60) {
    // Do some work that runs a maximum of once per minute
}
{{</highlight>}}

- - -

That's all for this episode. Keep tabs through the month on Twitter or follow up every month here for a quick summary.
