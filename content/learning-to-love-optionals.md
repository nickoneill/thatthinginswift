---
title: "Learning to Love Optionals"
date: "2014-08-10"
draft: true
description: ""
---
Yes, this isn't a direct comparison between Objective-C and Swift but it's a sounding board for Swifty things so we're gonna run with it.

// optionals hate

After experiencing optionals for the last few months I've come to terms with a slightly different approach to optionals.

At first, I approached optionals as a pain to deal with because everything had to be unwrapped, implicitly or otherwise, but eventually I came to terms with the information optionals was providing and took issue with the way I was dealing with optionals.

Optionals are actually a very useful tool, particularly when we're talking about communication from some API that may provide the information you're looking for or nothing. We don't have the luxury of looking at every piece of code we're asked to interact with and even if we did, it's nearly impossible (and definitely a waste of time) to attempt to map every failure mode for every API we want to interact with.

Instead, optionals give us a simple way to know if we have real data or some failure mode. I initially dismissed them as a stepping stone, a thing to be used when transitioning from nil-based Objective-C code to Swift but discarded in the future. I no longer think that's the case - the concept of the lack of anything is too powerful to give up on - and now I'm simply trying to embrace optionals and find ways to use them seamlessly within my code.

?? love

right side is lazily evaluated
