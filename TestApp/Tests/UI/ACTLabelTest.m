
#import <XCTest/XCTest.h>
#import "AppCenterXCUITestExtensions.h"

@interface ACTLabelTest : XCTestCase

@property (strong) XCUIApplication *app;

@end

@implementation ACTLabelTest

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = YES;
    self.app = [ACTLaunch launch];
}

- (void)tearDown {
    [super tearDown];
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2.0, false);
    [self.app terminate];
}

- (void)testACTLabelMacroUsingObjectiveC {
    act_label(@"act_label macro can be called without arguments");
    act_label(@"act_label macro can be called with arguments - %@, %@, %@",
          @"ARG0", @(1), @(2.3));
    XCTAssertTrue(YES, "This test should always pass");
}

- (void)testACTLabelClassMethodsUsingObjectiveC {
    [ACTLabel label:@"label class method can be called without arguments"];
    [ACTLabel label:@"label class method can be called with arguments - %@, %@, %@",
     @"ARG0", @(1), @(2.3)];
    XCTAssertTrue(YES, "This test should always pass");
}

- (void)testToggleScreenshots {
    [self.app.buttons[@"Circle"] tap];
    act_label(@"When I see the Circle tab");

    XCTAssertNotNil(self.app.images[@"flowers-in-circle"]);
    act_label(@"Then I see the flowers in a circle");

    [self.app.buttons[@"Square"] tap];
    act_label(@"When I touch the Square tab");

    XCTAssertNotNil(self.app.images[@"flowers-in-square"]);
    act_label(@"Then I see the flowers in a square");

    [self.app.buttons[@"Circle"] tap];
    act_label(@"When I see the Circle tab");

    XCTAssertNotNil(self.app.images[@"flowers-in-circle"]);
    act_label(@"Then I see the flowers in a circle");
}

@end
