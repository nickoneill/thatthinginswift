---
title: "Automated Building with Fastlane and Match"
date: "2016-02-07"
htmltitle: "Automated Building and Codesigning with Fastlane and Match"
description: "Spend an hour saving yourself future hours"
draft: true
---
Setting up codesigning on your app is pretty straightforward when you've got a new app on a single computer. However, your project will inevitably get larger, pulling in dependencies through your favorite package management system, being shared with other developers and distributed via different beta and live distribution methods. It's critical to keep your build and codesign processes consistent to prevent having to spend time debugging this confusing and error-prone part of iOS development.

That's where [fastlane](https://fastlane.tools/) comes in. At the very least, it's an automated build tool for iOS/OSX that saves you time and ensures consistency. Of course it can do much more than that - screenshots, testing, distribution and provisioning - but one of the hardest parts about starting with fastlane is figuring out the smallest functional unit that will improve your build process. You can - and you will - find great new ways to automate the terrible parts of the build process but starting small will allow you to understand how fastlane can work for you.

Before we get started, follow the basic instructions for [installing fastlane](https://github.com/fastlane/fastlane) on their github page.

That'll start you off with an example `Fastfile` but it's got a lot of different pieces that you don't need to get started. Instead, here's a basic `Fastfile` that we can use to build our app:

*example file*

match:

*You must set up your profiles correctly in the project*

*Add devices and let match pull them into the profile*