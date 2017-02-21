# VSMobileCenterExtensions

An extension library for triggering screenshots/marking test steps when running XCUITests in Visual Studio Mobile Center / Xamarin 
Test Cloud. By default, test steps are automatically marked at the conclusion of each test method (which also triggers a screenshot); 
this library allows you to explicitly declare where you want to mark your test steps / trigger screenshots. 

- [Requirements](#requirements)
  - [Using](#using)
  - [Building](#building)
- [Installation](#installation)
  - [Cocoapods](#cocoapods)
  - [Carthage](#carthage)
  - [Building from source](#building-from-source)
- [Usage](#usage)
  - [Objective-C](#objective-c)
  - [Swift](#swift)
- [Preparing Your Application Bundles](#preparing-your-application-bundles)

# Requirements

### Using
`VSMobileCenterExtensions.framework` is built for iOS 9.0 or later. 

### Building
VSMobileCenterExtensions has been tested on OSX El Capitan (10.11.5) and Xcode 8.2. However, it should work on newer 
versions of Xcode/OSX. Feel free to file an [issue](https://github.com/xamarinhq/test-cloud-xcuitest-extensions/issues/new) if you have trouble with a newer OS / Xcode configuration. 

In order to run the unit tests, you will also need to change the project's codesign info locally to point to a certificate 
installed on your own machine. 

<img width="876" alt="screen shot 2017-02-13 at 2 24 51 am" src="https://cloud.githubusercontent.com/assets/3009852/22879607/b34c6eec-f193-11e6-9c33-32bed8e07e5f.png">

If you want to install the `xcpretty` gem (see [building from source](#building-from-source) below), you will also need a valid ruby installation. Ruby 2.2.1 or higher is recommended. 

# Installation

### Cocoapods

1) Ensure you have installed the `cocoapods` gem:
```shell
$ gem install cocoapods
```

2) Create a `Podfile` in your Xcode project folder with the following:

```ruby
target 'MyUITestTarget' do
  pod 'VSMobileCenterExtensions'
end
```

'MyUITestTarget' should be the name of the target for your XCUITests. If you're unsure of what your test target is called, 
you can run 
```shell
$ xcodebuild -list
```
to see a list of available targets for your project. 

3) Once you have created the `Podfile`, run
```shell
$ pod install
```

4) You will probably see a notice from `cocoapods` about closing the Xcode project (if currently open) and
using `[YOUR_PROJECT_NAME].xcworkspace` from now own. Please follow this instruction. 

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

_Optional_: It is recommended that you install the `xcpretty` gem for nicer output:
```shell
$ gem install xcpretty
```

1) Run:
```shell
$ make
```
This will build `VSMobileCenterExtensions.framework` inside of the `build/Release-iphoneos`
folder. 

2) Copy `VSMobileCenterExtensions.framework` into your application's project folder.

<img width="574" alt="filestructure" src="https://cloud.githubusercontent.com/assets/3009852/22831228/7473bff4-ef5e-11e6-8fb5-7d9ae57e639b.png">

3) In Xcode, in the 'Build Phases' tab of your _UI Test target_ (not your main application target), 
add the `VSMobileCenterExtensions.framework` in the 'Link Binary With Libraries' phase.

4) In the same tab, add the `VSMobileCenterExtensions.framework` to your 'Copy Files' phase. 

You may need to create one if you don't already have one. To do so, click the '+' sign on the top left of the pane:

<img width="872" alt="addcopyfilesphase" src="https://cloud.githubusercontent.com/assets/3009852/22831259/8ffdf29e-ef5e-11e6-9e17-dfa874082ccf.png">

Once you have a 'Copy Files' phase, click the '+' button on the bottom left of the phase's pane to add a new file.
<img width="663" alt="copyfilesphase" src="https://cloud.githubusercontent.com/assets/3009852/22832148/c8fcf010-ef61-11e6-9c8d-5750db12d78e.png">

Click 'Add Other...' and navigate to the framework:

<img width="873" alt="clickaddother" src="https://cloud.githubusercontent.com/assets/3009852/22831280/a2f484b2-ef5e-11e6-9610-8103c4f401ce.png">

**Make sure that the 'Copy Files' phase's destination
is set to 'Frameworks'.**
 
When you're all done, your Build Phases pane should resemble the following:

<img width="874" alt="buildsettings" src="https://cloud.githubusercontent.com/assets/3009852/22831239/82f297bc-ef5e-11e6-96aa-46b00b2bbd8e.png">

# Usage

The `VSMobileCenterExtensions` framework exposes a `label` functionality that you can use to 
trigger a screenshot and mark a particular point in your UI Test with a label of your choosing. 

### Objective-C

In Objective-C, the method is called `+[MCLabel label:]` or `label()` for short. 
It accepts a format string and arguments just like `NSLog()`:

```objective-c
#import <VSMobileCenterExtensions/VSMobileCenterExtensions.h>

- (void)myTest {
    //Some test logic....
  
    [MCLabel label:fmt, ... ];
    // or
    label(fmt, ...);

    //More test logic...
}
```

### Swift
In Swift the function is called `MCLabel.labelStep()` and it accepts a string, and an optional
`vaList` if you want to use an Objective-C `NSLog()`-style format string:

```swift
import VSMobileCenterExtensions

class MyTestCase: XCTestCase {
    func myTestCase() {
        //Some test logic...

        MCLabel.labelStep(label)
        //or
        MCLabel.labelStep(fmt, args: getVaList([ ... ]))

        //More test logic...
    }
}
```

# Preparing Your Application Bundles

In order to run a test in Xamarin Test Cloud or Mobile Center, you will need to build your application and XCUITest runner bundles. To do this, run the following command from the root of your application project directory:

```shell
$ xcrun xcodebuild build-for-testing -workspace YOUR_WORKSPACE -sdk iphoneos -scheme YOUR_APPLICATION_SCHEME -derivedDataPath .
```
This will build your Application and your XCUITest-Runner into a local directory called `Build` (specifically, the bundles are in
`Build/Products/Debug-iphoneos/`).

`YOUR_WORKSPACE` should point to a `.xcworkspace` file, likely titled `PROJECT_NAME.xcworkspace`. `YOUR_APPLICAITON_SCHEME` should be 
the scheme you use to build your application. By default it is usually the name of your application. If you are unsure, you can run
```
$ xcrun xcodebuild -list
```
to see a list of valid schemes. For more information about Xcode schemes, see the [Apple Developer Documentation](https://developer.apple.com/library/content/featuredarticles/XcodeConcepts/Concept-Schemes.html).  
