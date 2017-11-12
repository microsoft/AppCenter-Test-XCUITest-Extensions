## Visual Studio App Center XCUITest Extensions

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`AppCenterXCUITestExtensions` is an iOS Framework for taking screenshots
and labeling test steps when running XCUITest test in Visual Studio App Center or
Xamarin Test Cloud. At the conclusion of each test method, a label and
screenshot are automatically generated for the test report. You can
create additional labels and screenshots to track your app's progress
during a test method.

This framework is _required_ for running XCUITests in Visual Studio App Center and Xamarin Test Cloud.

# Documentation

Please refer to the official [App Center documentation site](https://docs.microsoft.com/appcenter/test-cloud/preparing-for-upload/xcuitest) for installation and usage for both Visual Studio App Center and Xamarin Test Cloud. 

For instructions on how to run tests in Xamarin Test Cloud see below. 

# How To Run Tests in Xamarin Test Cloud

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

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

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
