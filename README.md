## AppCenter XCUITest Extensions

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

AppCenter XCUITest Extensions is an iOS Framework for taking screenshots
and labeling test steps when running XCUITest test in App Center or
Xamarin Test Cloud. At the conclusion of each test method, a label and
screenshot are automatically generated for the test report. You can
create additional labels and screenshots to track your app's progress
during a test method.

This framework is _required_ for running XCUITests in App Center and
Xamarin Test Cloud.

- [Requirements](#requirements)
- [Using Labels](#using-labels)
- [Installation](#installation)
  - [Carthage](#carthage)
  - [Building from source](#building-from-sources)
  - [Cocoapods](#cocoapods)
- [Build For Testing](#build-for-testing)
- [Run Tests in App Center or Xamarin Test Cloud](#run-tests-in-app-center-or-xamarin-test-cloud)
- [Known Issues](#known-issues)

### Requirements

* Xcode >= 9.0
* Sierra or High Sierra
* iOS >= 9.0

You must launch your application using the `ACTLaunch` API.

```
### Objective-C

XCUIApplication *app = act_launch
XCUIApplication *app = act_launch_app([[XCUIApplication alloc] init]);

XCUIApplication *app = [ACTLaunch launch];
XCUIApplication *app = [ACTLaunch launchApplication:[[XCUIApplication alloc] init]];

### Swift

let app = ACTLaunch.launch();
let app = ACTLaunch.launch(XCUIApplication())
```

### Using Labels

Be sure that you launch your app with the `ACTLaunch` API. See the
examples in the [Requirements](#requirements) section.

* Objective-C [TestApp/Tests/UI/ACTLabelTest.m](TestApp/Tests/UI/ACTLabelTest.m)
* Swift [TestApp/Tests/UI/ACTLabelTest.swift](TestApp/Tests/UI/ACTLabelTest.swift)

### Installation

The extension can be added to your Xcode project using Cocoapods,
Carthage, or by manually linking the framework to your XCUITest target.

#### Carthage

Install carthage with homebrew:

```shell
$ brew install carthage
```

Create a `Cartfile` with the following contents:

```
github "xamarinhq/appcenter-test-cloud-xcuitest-extensions"
```

Follow the [Carthage Instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos) for installing frameworks from a Cartfile.

#### Building From Sources

##### 1. Make the AppCenterXCUITestExtensions.framework

```shell
$ make
...
INFO: Installed Products/framework/AppCenterXCUITestExtensions.framework
INFO: Done!
```

##### 2. Copy `AppCenterXCUITestExtensions.framework` into your application's project folder.

Use the Finder to drag-and-drop or use `ditto` to perserve symbolic
links and file attributes.

```shell
$ ditto Products/framework/AppCenterXCUITestExtensions.framework \
  path/to/MyApp/AppCenterXCUITestExtensions.framework
```

<p align="center">
<img width="720" alt="view-in-finder"
src="https://user-images.githubusercontent.com/466104/32554526-6e0b800e-c49a-11e7-8b6b-16a36c687fba.png">
</p>

##### 3. Link AppCenterXCUITestExtensions.framework with your XCUITest target

In Xcode, in the 'Build Phases' tab of the _XCUITest target_ (not the
main application target), add the
`AppCenterXCUITestExtensions.framework` in the 'Link Binary With
Libraries' phase.

In the same tab, add a 'Copy Files' phase with Destination: Frameworks
and add the `AppCenterXCUITestExtensions.framework`.

Note that your project may already have a 'Copy Files' phase.

<p align="center">
<img width="720" alt="link-framework"
src="https://user-images.githubusercontent.com/466104/32555375-d611c918-c49c-11e7-8146-238fa34de4f9.gif">
</p>

When you are finished, your Build Phases pane should resemble the
following:

<p align="center">
<img width="720" alt="build-settings"
src="https://user-images.githubusercontent.com/466104/32555560-653e8b58-c49d-11e7-954f-b5dd62590211.png">
</p>

#### Cocoapods

If you are not already using CocoaPods, we recommend you use Carthage or
manually linking the framework.

Update your `Podfile` in your Xcode project folder with the following:

```ruby
use_frameworks! # required for projects with Swift sources

target 'MyAppUITests' do pod 'AppCenterXCUITestExtensions' end
```

'MyAppUITests' should be the name of the target for your XCUITests.

```shell
$ pod install
```

### Build For Testing

In order to run a test in App Center or Xamarin Test Cloud, you will
need to build your application and an XCUITest bundle. To do this, run
the following command from the root of your application project
directory:

```shell
$ rm -rf DerivedData
$ xcrun xcodebuild build-for-testing \
  -configuration Debug \
  -workspace YOUR_WORKSPACE \
  -sdk iphoneos \
  -scheme YOUR_APP_SCHEME \
  -derivedDataPath DerivedData
```

This will build your app and an XCUITest bundle into the
`DerivedData/Build` directory. Your app and XCUITest bundle will be
located in the `DerivedData/Build/Products/Debug-iphoneos/` directory.

`YOUR_WORKSPACE` should point to a `.xcworkspace` file, likely titled
`PROJECT_NAME.xcworkspace`. `YOUR_APP_SCHEME` should be the scheme you
use to build your application. By default it is usually the name of your
application. To see the list of schemes defined in your Xcode project,
run:

```shell
$ xcrun xcodebuild -list
```

For a concrete example of generating an app and an XCUITest bundle, see
[bin/make/build-for-testing.sh](bin/make/build-for-testing.sh).

### Run Tests in App Center or Xamarin Test Cloud

#### Run Tests in App Center

* [Prepare XCUITest Tests for App Center](https://docs.microsoft.com/en-us/mobile-center/test-cloud/preparing-for-upload/xcuitest)
* [Run XCUITests in App Center](https://docs.microsoft.com/en-us/mobile-center/test-cloud/starting-a-test-run)

For a concrete example of submitting an app to App Center, see
[bin/make/appcenter.sh](bin/make/appcenter.sh)

#### Run Tests in Xamarin Test Cloud

Install the `xtc` upload tool by following these [instructions](https://github.com/xamarinhq/test-cloud-appium-java-extensions/blob/master/UploaderInstall.md/#installation).

If you have not already created an application record in Xamarin Test
Cloud, create one now at http://testcloud.xamarin.com.

Collect your Xamarin Test Cloud API Token and generate a device by following
the links to create a new test run.

```
# Follow the instructions in the previous section to build your app
# and generate an XCUITest bundle.
$ xcrun xcodebuild build-for-testing [args]

$ /usr/local/bin/xtc xcuitest \
  XAMARIN_TEST_CLOUD_API_TOKEN \
  --devices YOUR_DEVICE_SET \
  --app-name YOUR_APP_NAME \
  --user YOUR_EMAIL_ADDRESS \
  --series "master" \
  --workspace "DerivedData/Build/Products/Debug-iphoneos"
```

For a concrete example of submitting an app to Xamarin Test Cloud, see
[bin/make/xtc.sh](bin/make/xtc.sh)

### Known Issues

### Swift + bitcode

If you are building Swift XCUITests, you may encounter a build error
related to bitcode.  As a workaround, you can disable bitcode in your
XCUITest target. To do this, go to Build Settings, search for
`ENABLE_BITCODE` and set the value to `NO` for the test target.  You
should not need to change the setting for the App target.

<p align="center">
<img width="720" alt="screen shot 2017-04-06 at 12 43 24 pm" src="https://cloud.githubusercontent.com/assets/3009852/24772614/de004eea-1ac6-11e7-975a-bcdfae01d068.png">
</p>