## Visual Studio App Center XCUITest Extensions

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`AppCenterXCUITestExtensions` is an iOS Framework for taking screenshots
and labeling test steps when running XCUITest test in Visual Studio App Center
or Xamarin Test Cloud. At the conclusion of each test method, a label and
screenshot are automatically generated for the test report. You can create
additional labels and screenshots to track your app's progress during a test
method.

## Update

This framework has been _deprecated_. 

This framework is _not_ compatibible with Xcode >= 10.2.

This framework is _no longer required_ for running XCUITests in Visual Studio
App Center.

Users need to migrate their tests to use Apple's
`XCTContext runActivityNamed:block` API.

```
- (void)testFavoriteSongs {
  [XCTContext runActivityNamed:@"Then I touch the Library tab" block:^(id<XCTActivity>
                                                                      _Nonnull activity) {
    // Gestures always generate a screenshot which will appear in your test report.
    [self.app.buttons[@"Library"] tap];
  }];

  [XCTContext runActivityNamed:@"Then I see a list of my favorite songs" block:^(id<XCTActivity>
                                                                                 _Nonnull activity) {
    // Queries do not generate screenshots.
    // Take a screenshot before assertions to make your test report more readable.
    XCUIScreenshot *screenshot = [[XCUIScreen mainScreen] screenshot];
    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:screenshot];
    [attachment setLifetime:XCTAttachmentLifetimeKeepAlways];
    [activity addAttachment:attachment];
    XCTAssertNotNil(self.app.tables[@"favorite Songs"]);
  }];
}
```

To make test source code readable, we recommend this method to take screenshots:

```
- (void) addScreenshot:(id<XCTActivity>  _Nonnull ) activity {
  XCUIScreenshot *screenshot = [[XCUIScreen mainScreen] screenshot];
  XCTAttachment *attachment;
  attachment = [XCTAttachment attachmentWithScreenshot:screenshot];
  [attachment setLifetime:XCTAttachmentLifetimeKeepAlways];
  [activity addAttachment:attachment];
}
```

We recommend inserting screenshots during your tests to make the test report
easier to interrept.

# Documentation

Please refer to the official [App Center documentation site](https://docs.microsoft.com/appcenter/test-cloud/preparing-for-upload/xcuitest)
for installation and usage for both Visual Studio App Center and Xamarin Test
Cloud.

This repository contains four demonstration apps:

* Flowers: demonstrates the API.
* Dido: demonstrates how to the link the framework using Carthage.
* BeetIt: demonstrates how to link the framework using CocoaPods.
* StickShift: demonstrates how to manually link the framework.


For a concrete example of submitting an app to App Center see
[bin/make/appcenter.sh](bin/make/appcenter.sh)

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
