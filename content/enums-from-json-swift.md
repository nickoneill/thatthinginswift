---
date: 2015-04-09T17:56:14-07:00
title: "Writing API Clients in Swift: Enums from JSON"
htmltitle: "Writing API Clients in Swift: Enums from JSON"
draft: true
description: "dispatch_async plus a nice custom operator"
---
[Last time](/switch-unwrap-shortcut/) we talked about switches in the context of `UITableViewCell`s and asynchronous loading. It was a bit opaque at the time but this is kind of thing you might do a lot of if you were writing API clients in Swift. And I do.

Another case that I run into frequently is translating values from some JSON object into nice Swifty data structures. Here's an example of a JSON response from an API:

{{% prism swift %}}
{{% /prism %}}

Sometimes we know all the possible values that could exist in `status`, sometimes not. A spec is ideal but not always available. Regardless, if you've got a field that returns a reasonable number of possible values (say, less than 20) it's good to make a Swift `enum` to keep track of those values. Let's say we're making an API client and starting to test responses, this is a reasonable first crack at some code:

{{% prism swift %}}
{{% /prism %}}

Because we haven't tested every 