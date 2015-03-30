---
title: "IBAction and IBOutlet"
htmltitle: "Using IBAction and IBOutlet in Xcode for Swift"
date: 2014-06-25T10:54:37Z
description: "Hooking storyboards up to your custom code"
---

Gone are the days of switching back and forth between .h and .m files! And one of the tangible benefits of a single file per class is easy access to IBAction and IBOutlet declarations.

In Objective-C your .h would probably have a bit of this:

{{% prism objectivec %}}@interface MyViewController: UIViewController

@property (weak) IBOutlet UIButton *likeButton;
@property (weak) IBOutlet UILabel *instructions;
- (IBAction)likedThis:(id)sender;

@end
{{% /prism %}}

And then you constantly have to dig into your .h file when playing with storyboards to tweak names. Blah.

Simplicity rules in swift. If you have a property defined that you want to make accessible to your storyboards, just add the `@IBOutlet` attribute before your property. Similarly with `@IBAction` to connect storyboard actions back to code.

{{% prism swift %}}class MyViewController: UIViewController {
  @IBOutlet weak var likeButton: UIButton?
  @IBOutlet weak var instruction: UILabel?

  @IBAction func likedThis(sender: UIButton) {
    ...
  }
}
{{% /prism %}}

There are other interesting attributes that you can apply in swift but for now we'll just cover these two common interface builder ones. There are two *new* interface builder attributes `@IBDesignable` and `@IBInspectable` which we probably won't cover as their usage is very similar to this.
