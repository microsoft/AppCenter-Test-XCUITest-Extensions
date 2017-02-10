# test-cloud-xcuitest-extensions
An extension library for to provided added value when running XCUITest tests in Visual Studio Mobile Center and Xamarin Test Cloud

# Installation

## Cocoapods

1. Ensure you have installed the `cocoapods` gem:
```shell
$ gem install cocoapods
```

2. Create a `Podfile` in your Xcode project folder with the following:

```
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

## Carthage 

1. First ensure you have `carthage` available by running
```shell
$ brew install carthage
```
(If you don't have homebrew, you can get it [here](http://brew.sh/))

2. Create a `Cartfile` with the following contents:

```
github "xamarinhq/test-cloud-xcuitest-extensions"
```

3. Run
```shell
$ carthage bootstrap
```

This will build the framework and install it into `Carthage/Build/iOS/VSMobileCenterExtensions.framework`

4. In Xcode, in the 'Build Phases' tab of your _UI Test target_ (not your main application target), 
add the `VSMobileCenterExtensions.framework` that you just built in the 'Link Binary With Libraries' phase.

5. In the same tab, also add the `VSMobileCenterExtensions.framework` to your 'Copy Files' phase. 
You may need to create one if you don't already have one. Make sure that the 'Copy Files' phase's destination 
is set to 'Frameworks'.  

## Building from source

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

3. In Xcode, in the 'Build Phases' tab of your _UI Test target_ (not your main application target), 
add the `VSMobileCenterExtensions.framework` in the 'Link Binary With Libraries' phase.

4. In the same tab, add the `VSMobileCenterExtensions.framework` to your 'Copy Files' phase. You may
need to create one if you don't already have one. Make sure that the 'Copy Files' phase's destination
is set to 'Frameworks'. 
 

# Usage

The `VSMobileCenterExtensions` framework exposes a `label()` function that you can use to 
trigger a screenshot and mark a particular point in your UI Test with a label of your choosing. 

In Objective-C:
```objective-c
#import <VSMobileCenterExtensions/VSMobileCenterExtensions.h>

- (void)myTest {
    //...
  
    [MCLabel label:fmt, args ... ];
    // or
    label(fmt, ...);

    //...
}
```

Swift:
```swift
import VSMobileCenterExtensions


class MyTestCase: XCTestCase {
    func myTestCase() {
        //...

        MCLabel.labelStep(message)
        MCLabel.labelStep(fmt, args: getVaList([ args, ... ]))

        //...
    }
}
```