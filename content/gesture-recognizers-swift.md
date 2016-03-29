---
date: 2015-07-05T17:56:14-07:00
title: "Gesture Recognizers"
htmltitle: "Gesture Recognizers in Swift"
description: "A place where Objective-C shines through the cracks"
previewCode: gesture-recognizers
---

{{% contrib twitter="klaaspieter" web="www.annema.me" %}}

Like many things, not a lot has changed when using `UIGestureRecognizer` in Swift. Let’s compare the two, first Objective-C:

{{< highlight objectivec >}}
- (void)viewDidLoad;
{
    [super viewDidLoad];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)handleTap:(UIGestureRecognizer *)recognizer;
{
    CGPoint location = [recognizer locationInView:self.view];

    NSString *message = [NSString stringWithFormat:@“You tapped at: %@“, NSStringFromCGPoint(location)];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@“You tapped” message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@“Dismiss” style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}
{{< /highlight >}}

And Swift:

{{< highlight swift >}}
override func viewDidLoad() {
    super.viewDidLoad()

    let gestureRecognizer = UITapGestureRecognizer(target: self, action: “handleTap:”)
    self.view.addGestureRecognizer(gestureRecognizer)
}

func handleTap(gestureRecognizer: UIGestureRecognizer) {
    let alertController = UIAlertController(title: nil, message: “You tapped at \(gestureRecognizer.locationInView(self.view))”, preferredStyle: .Alert)
    alertController.addAction(UIAlertAction(title: “Dismiss”, style: .Cancel, handler: { _ in }))
    self.presentViewController(alertController, animated: true, completion: nil)
}
{{< /highlight >}}

While similar, there are small differences that can potentially have a crashing impact.

Your natural tendency might be to make the action method private. There is no reason why anything outside the current file should have to call this method, it’s an implementation detail of how gesture recognizers work. Unfortunately this will produce the following crash at runtime:

    *** Terminating app due to uncaught exception ‘NSInvalidArgumentException’, reason: ‘-[GestureRecognizers.SwiftGestureRecognizerExampleViewController handleTap:]: unrecognized selector sent to instance 0x7fec3a7ac8b0’`

In Objective-C, which lacks method visibility as a language feature, the method can be considered private because it's not in the header file. Unfortunately meeting that requirement  in Swift will, by default, crash your program. The section about exposing Swift interfaces in the [Using Swift with Cocoa and Objective-C guide](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/BuildingCocoaApps/InteractingWithObjective-CAPIs.html#//apple_ref/doc/uid/TP40014216-CH4-ID55) explains why. First, it explains:

> If your class inherits from an Objective-C class, the compiler inserts the attribute [`@objc`] for you.

However, later the following is explained in a note:

> The compiler does not automatically insert the @objc attribute for declarations marked with the private access-level modifier.

Our class inherits from `UIViewController` which is an Objective-C object, but by default private methods do not get the `@objc` modifier added to them. You can add the modifier, but I've been told this can lead to naming collisions. Unfortunately I was unable to find a good source for this claim.

This behavior is surprising to me because it goes against Swift’s ‘Designed for Safety’ principle. There is no compiler warning, as a matter of fact there is no warning at all, just a crash at runtime (FYI: [rdar://21594714](rdar://21594714)).

Another interesting thing to note is that, judging by appearance, Swift has no notion of selectors. The action argument is just a string. Which actually is automatically converted into a Swift `Selector` because it adheres to the `StringLiteralConvertible` protocol. In case your interested, [NSHipster](http://nshipster.com/swift-literal-convertible/) has  written more about literal convertibles.

While it is trivial to convert gesture recognizer code from Objective-C to Swift, it's also one of those APIs where a little of the heritage from Objective-C shines through the cracks. Not a big deal, but definitely something to be aware of to prevent runtime crashers.
