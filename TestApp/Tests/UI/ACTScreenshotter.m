
#import <XCTest/XCTest.h>
#import "ACTScreenshotter.h"

@implementation ACTScreenshotter

+ (void)screenshotWithTitle:(NSString *)title {
    [XCTContext
     runActivityNamed:title
     block:^(id<XCTActivity>  _Nonnull activity) {
         XCUIScreenshot *screenshot = [[XCUIScreen mainScreen] screenshot];
         XCTAttachment *attachment;
         attachment = [XCTAttachment attachmentWithScreenshot:screenshot];
         [attachment setLifetime:XCTAttachmentLifetimeKeepAlways];
         [activity addAttachment:attachment];
     }];
}

@end
