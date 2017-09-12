## VSMobileCenterExtensions

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

An extension library for triggering screenshots and marking test steps when
running XCUITests in Mobile Center or Test Cloud. By default, test steps are
automatically marked and a screenshot taken at the conclusion of each test
method.  This library allows you to create labels and screenshots inside
your test methods.

- [Requirements](#requirements)
- [Installation](#installation)
  - [Cocoapods](#cocoapods)
  - [Carthage](#carthage)
  - [Building from source](#building-from-source)
- [Usage](#usage)
  - [Objective-C](#objective-c)
  - [Swift](#swift)
- [Preparing Your Application
  Bundles](#preparing-your-application-bundles)
- [Uploading Your Tests](#uploading-your-tests)
- [Known Issues](#known-issues)

### Requirements

* Xcode >= 8.3.3
* Sierra or High Sierra
* iOS >= 9.0

When using Xcode 9.0, you must launch your application using our
`MCLaunch` API.

```
### Objective-C

XCUIApplication *app = mc_launch
XCUIApplication *app = mc_launch_app([[XCUIApplication alloc] init]);

XCUIApplication *app = [MCLaunch launch];
XCUIApplication *app = [MCLaunch launchApplication:[[XCUIApplication alloc] init]];

### Swift

let app = MCLaunch.launch();
let app = MCLaunch.launch(XCUIApplication())
```

### Installation

The extension can be added to your Xcode project using Cocoapods, Carthage,
or by manually linking the framework to your XCUITest target.

### Cocoapods

If you are not already using CocoaPods, we recommend you use Carthage or
manually link the framework.

1) Ensure you have installed the `cocoapods` gem:

```shell
$ gem install cocoapods
```

2) Create a `Podfile` in your Xcode project folder with the following:

```ruby
use_frameworks! # required for projects with Swift sources

target 'MyUITestTarget' do pod 'VSMobileCenterExtensions' end
```

'MyUITestTarget' should be the name of the target for your XCUITests. If
you're unsure of what your test target is called, you can run

```shell
$ xcrun xcodebuild -list
```

to see a list of available targets for your project.

3) Once you have created the `Podfile`, run

```shell
$ pod install
```

4) You will probably see a notice from `cocoapods` about closing the
Xcode project (if currently open) and using `[YOUR_PROJECT_NAME].xcworkspace`
from now on. Please follow this instruction.

### Carthage

1) First ensure you have `carthage` available by running

```shell
$ brew install carthage
```

If you don't have homebrew, you can get it [here](http://brew.sh/).

2) Create a `Cartfile` with the following contents:

```
github "xamarinhq/test-cloud-xcuitest-extensions"
```

3) Follow the [Official Carthage Instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos)
for installing frameworks from a Cartfile.

### Building from source

The build scripts will use the `xcpretty` ruby gem if it is available.

1) Make the VSMobileCenterExtensions.framework

```shell
$ make
...
INFO: Installed Products/framework/VSMobileCenterExtensions.framework
INFO: Done!
```

2) Copy `VSMobileCenterExtensions.framework` into your application's project folder.

<img width="574" alt="filestructure"
src="https://cloud.githubusercontent.com/assets/3009852/22831228/7473bff4-ef5e-11e6-8fb5-7d9ae57e639b.png">

3) In Xcode, in the 'Build Phases' tab of your _UI Test target_ (not your main
application target), add the `VSMobileCenterExtensions.framework` in the 'Link
 Binary With Libraries' phase.

4) In the same tab, add the `VSMobileCenterExtensions.framework` to your
'Copy Files' phase.

You may need to create one if you don't already have one. To do so, click the
'+' sign on the top left of the pane:

=====

<img width="872" alt="addcopyfilesphase" src="https://cloud.githubusercontent.com/assets/3009852/22831259/8ffdf29e-ef5e-11e6-9e17-dfa874082ccf.png">

====

Once you have a 'Copy Files' phase, click the '+' button on the bottom left of
the phase's pane to add a new file.

====

<img width="663" alt="copyfilesphase" src="https://cloud.githubusercontent.com/assets/3009852/22832148/c8fcf010-ef61-11e6-9c8d-5750db12d78e.png">

====

Click 'Add Other...' and navigate to the framework:

====

<img width="873" alt="clickaddother" src="https://cloud.githubusercontent.com/assets/3009852/22831280/a2f484b2-ef5e-11e6-9610-8103c4f401ce.png">

====

**Make sure that the 'Copy Files' phase's destination is set to 'Frameworks'.**

When you are finished, your Build Phases pane should resemble the following:

<img width="874" alt="buildsettings" src="https://cloud.githubusercontent.com/assets/3009852/22831239/82f297bc-ef5e-11e6-96aa-46b00b2bbd8e.png">

### Usage

* Objective-C [TestApp/Tests/MCLabelTest.m](TestApp/UI/Tests/MCLabelTest.m)
* Swift [TestApp/Tests/MCLabelTest.swift](TestApp/UI/Tests/MCLabelTest.swift)

### Preparing Your Application Bundles

In order to run a test in Xamarin Test Cloud or Mobile Center, you will
need to build your application and XCUITest runner bundles. To do this,
run the following command from the root of your application project
directory:

```shell
$ rm -rf ddp #remove the derivedDataPath if it exists
$ xcrun xcodebuild build-for-testing -configuration Debug -workspace YOUR_WORKSPACE -sdk iphoneos -scheme YOUR_APPLICATION_SCHEME -derivedDataPath ddp
```

This will build your Application and your XCUITest-Runner into a directory called
`ddp/Build` (specifically, the bundles are in `ddp/Build/Products/Debug-iphoneos/`).

`YOUR_WORKSPACE` should point to a `.xcworkspace` file, likely titled
`PROJECT_NAME.xcworkspace`. `YOUR_APPLICAITON_SCHEME` should be the
scheme you use to build your application. By default it is usually the
name of your application. If you are unsure, you can run

```shell
$ xcrun xcodebuild -list
```

to see a list of valid schemes. For more information about Xcode schemes, see
the [Apple Developer Documentation](https://developer.apple.com/library/content/featuredarticles/XcodeConcepts/Concept-Schemes.html).

#### Uploading Your Tests

First make sure you have the `xtc` uploader tool by following the
[installation instructions](https://github.com/xamarinhq/test-cloud-appium-java-extensions/blob/master/UploaderInstall.md/#installation).

If you do not have an existing device key ready, you can generate one by
following the new test run dialog in [Test Cloud](https://testcloud.xamarin.com).
 On the final screen, extract only the device key from the generated command.

To upload your tests, run the following command:

```shell
$ xtc xcuitest <api-key> --devices <selection> --user <email> --workspace ddp/Build/Products/Debug-iphoneos
```

### Known Issues

#### UI Testing Failure

When performing gestures in XTC/Mobile Center Test, you may see an error
message like the following:

```
UI Testing Failure - Failed to scroll to visible (by AX action)
Button ...  Error -25204 performing AXAction 2003
```

Presently, the issue not fully understood and believed to originate in
`XCTest.framework`. However, evidence suggests that one possible cause
is related to XCUITest not being able to 'see' the element in the
hierarchy when the gesture is invoked.

While not foolproof, as a potential workaround and general improvement
to test stability, we recommend adapting the following scaffolding code
to your gestures invocation (example is for a `tap` gesture):

#### Objective-C

```objc
- (void)waitAndTap:(XCUIElement *)button {
   NSPredicate *pred = [NSPredicate predicateWithFormat:@"exists == 1 && hittable == 1"];
   [self expectationForPredicate:pred evaluatedWithObject:button handler:nil];
   [self waitForExpectationsWithTimeout:5 /*or a larger value if necessary*/
                                handler:nil];
   [button tap];
}
```

#### Swift

```swift
func waitAndTap(element: XCUIElement) {
    let predicate = NSPredicate(format: "exists == 1 && hittable == 1")
    expectation(for: predicate, evaluatedWith: element)
    waitForExpectations(timeout: 5 // Or a larger value if necessary)
    element.tap()
 }
```

You would then invoke `waitAndTap` instead of `tap` to ensure that the
element in question is in a hittable state.

Note that in XTC/Mobile Center Test, this issue appears to only be
prevelant on iPhone 7 devices.

### Xcode 8.3 and Swift

If you are building Swift XCUITests using Xcode >= 8.3, you may
encounter a build error related to bitcode.  As a workaround, you can
disable bitcode in your XCUITest target. To do this, go to Build
Settings, search for `ENABLE_BITCODE` and set the value to `NO` for the
test target.  You should not need to change the setting for the App
target.

<img width="1076" alt="screen shot 2017-04-06 at 12 43 24 pm" src="https://cloud.githubusercontent.com/assets/3009852/24772614/de004eea-1ac6-11e7-975a-bcdfae01d068.png">
