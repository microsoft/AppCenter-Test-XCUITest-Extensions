# VXMobileCenterExtensions
An extension library for to provided added value when running XCUITest tests in Visual Studio Mobile Center and Xamarin Test Cloud

- [Installation](#installation)
  - [Cocoapods](#cocoapods)
  - [Carthage](#carthage)
  - [Build from source](#building-from-source)
- [Usage](#usage)
  - [Objective-C](#objective-c)
  - [Swift](#swift)

# Installation

### Cocoapods

1. Ensure you have installed the `cocoapods` gem:
```shell
$ gem install cocoapods
```

2. Create a `Podfile` in your Xcode project folder with the following:

```ruby
target 'MyUITestTarget' do
  pod 'VSMobileCenterExtensions'
end
```

'MyUITestTarget' should be the name of the target for your XCUITests. If you're unsure, you can run 
```shell
$ xcodebuild -list
```
to see a list of available targets for your project. 

3. Once you have created the `Podfile`, run
```shell
$ pod install
```

4. You will probably see a notice from `cocoapods` about closing the Xcode project (if currently open) and
using `[YOUR_PROJECT_NAME].xcworkspace` from now own. Please follow this instruction. 

### Carthage 

1. First ensure you have `carthage` available by running
```shell
$ brew install carthage
```
(If you don't have homebrew, you can get it [here](http://brew.sh/))

2. Create a `Cartfile` with the following contents:

```
github "xamarinhq/test-cloud-xcuitest-extensions"
```

3. Follow the [Official Carthage Instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos)
for installing frameworks from a Cartfile.

### Building from source

_Optional_: It is recommended that you install the `xcpretty` gem for nicer output:
```shell
$ gem install xcpretty
```

1. Run:
```shell
$ make
```
this will build `VSMobileCenterExtensions.framework` inside of the `build/Release-iphoneos`
folder. 

2. Copy `VSMobileCenterExtensions.framework` into your application's project folder.

<img width="574" alt="filestructure" src="https://cloud.githubusercontent.com/assets/3009852/22831228/7473bff4-ef5e-11e6-8fb5-7d9ae57e639b.png">

3. In Xcode, in the 'Build Phases' tab of your _UI Test target_ (not your main application target), 
add the `VSMobileCenterExtensions.framework` in the 'Link Binary With Libraries' phase.

4. In the same tab, add the `VSMobileCenterExtensions.framework` to your 'Copy Files' phase. 

You may need to create one if you don't already have one. To do so, click the '+' sign on the top left of the pane:

<img width="872" alt="addcopyfilesphase" src="https://cloud.githubusercontent.com/assets/3009852/22831259/8ffdf29e-ef5e-11e6-9e17-dfa874082ccf.png">

Click on 'Add Other' and navigate to the framework:

<img width="873" alt="clickaddother" src="https://cloud.githubusercontent.com/assets/3009852/22831280/a2f484b2-ef5e-11e6-9610-8103c4f401ce.png">

**Make sure that the 'Copy Files' phase's destination
is set to 'Frameworks'.**
 
When you're all done, your build settings should resemble the following:

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
  
    [MCLabel label:fmt, args ... ];
    // or
    label(fmt, ...);

    //More test logic...
}
```

### Swift
In Swift the function is called `MCLabel.labelStep()` and it accepts a string, and an optional
`vaList` if you want to use an Objective-C `NSLog()` style format string:

```swift
import VSMobileCenterExtensions


class MyTestCase: XCTestCase {
    func myTestCase() {
        //Some test logic...

        MCLabel.labelStep(label)
        MCLabel.labelStep(fmt, args: getVaList([ args, ... ]))

        //More test logic...
    }
}
```
