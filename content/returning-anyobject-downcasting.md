---
title: "The Return of AnyObject"
date: "2014-08-15"
draft: true
description: ""
---

// from the table view post
First, the potentially dequeued cell might be `nil` so we're already dealing with an optional. Moreover, the dequeued cell might be some `UITableViewCell` subclass so it's actually returned as `AnyObject?` and we downcast it to the class we know it is. The incantation for downcasting an optional is that `as?` we used, a combination of new concepts if you're coming straight from Objective-C and potentially the source of confusion here.
