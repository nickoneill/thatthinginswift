---
title: "Read & Share Buildlog #1"
date: 2019-07-21T08:18:43-07:00
description: "buildlog"
draft: true
---

I've been working on a project that I'm aiming to release with iOS 13 later this year, and I've decided to do some build logs with interesting features or new things I'm learning here. From twitter:

{{<tweet 725217977314992128>}}

The idea for Read & Share stems from a) my interest in using some new features from iOS 13 in production and b) my newfound reading time during my commute where I wanted to share what I was reading on Twitter et al but didn't have the tools to do so.

This series will be a mix of how I build features that I'm familiar with as well as experiments with the newer iOS 13 and Xcode 11 features that we're all unfamiliar with.

Even experienced iOS engineers are newbies again with SwiftUI and Combine, and the incredible field of posts about working with new features shows how fresh even the basics are for everyone.

Let's get right to the first buildlog.

---

The fundamental piece of UI here that everything else feeds in to and out of is the highlighting screen.

Text comes into the app in various ways - sharing existing highlights from e-readers, copy-pasting chunks of text and even taking camera shots from physical books - and it all hits the highlight screen where you can select the part you want to share. After that you can tweak the book source or play with the share style, but all of these other elements flow through this one interface that needs to be intuitively understandable through a range of use cases.

<Text flow graphic>

I started working on this in SwiftUI and realized that I didn't know anything about it, then restarted it in UIKit where I was much more familiar. Eventually I'd like to rebuild all of this in SwiftUI but I've settled for building the easy stuff (Drawers! Navigation! Tabs!) in SwiftUI and giving myself some breathing room on the custom UI in UIKit for now. Look for a post about embedding UIKit in SwiftUI soon.

## Making selections

The end goal here is making it easy to tap and drag to select text, which sounds easy but there are a number of steps to be able to do this:

1. Get bounds for each word
2. Get tap points
3. Manage word selections
4. Draw stylized highlight layers

Support for finding text bounds in `UITextView` is pretty good, so I've picked that for the base text display and I'm using `firstRect(forRange:)` to find rects for each word that can be selected. These rects will be used both as the basis of the highlight shapes and to determine if taps have hit a word.

scanner here?

-code for selecting words-

Once I have the word rects, taps are sent to the selection manager which applies any selection rules. If you tap on the first word and the last word, the app should highlight all the words in the middle for you - this logic and more is all handled in the selection manager.

Finally, the view controller takes the selections and, knowing a bit about the rules for how text can be selected, makes custom `CAShapeLayer`s displayed in the layer behind the `UITextView`.

<find word boxes> <find selections> <add extras>

The separation between what happens in the selection manager and the view controller is at the display level. The selection manager shouldn't need to know anything about the layout of the screen, just the basic rules for how to select text. The parent view controller can handle both a conversion from taps -> word rect hits as well as selected rects -> highlight layer locations.

---

One last note: I'm doing some character counting here which is not directly compatible with how `String` tries to simplify complex multi-character glyphs into `String.Index`. I'll continue to refine this component during this process, and one of those steps will include checking unicode support.