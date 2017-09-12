
#import <XCTest/XCTest.h>
#import "VSMobileCenterExtensions.h"

@interface MCLabelTest : XCTestCase

@property (strong) XCUIApplication *app;

@end

@implementation MCLabelTest

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = YES;
    self.app = [MCLaunch launch];
}

- (void)tearDown {
    [super tearDown];
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2.0, false);
    [self.app terminate];
}

- (void)testMCLabelMacroUsingObjectiveC {
    label(@"label macro can be called without arguments");
    label(@"label macro can be called with arguments - %@, %@, %@",
          @"ARG0", @(1), @(2.3));
    XCTAssertTrue(YES, "This test should always pass");
}

- (void)testMCLabelClassMethodsUsingObjectiveC {
    [MCLabel label:@"label class method can be called without arguments"];
    [MCLabel label:@"label class method can be called with arguments - %@, %@, %@",
     @"ARG0", @(1), @(2.3)];
    XCTAssertTrue(YES, "This test should always pass");
}

- (void)testToggleScreenshots {
    [self.app.buttons[@"Circle"] tap];
    label(@"When I see the Circle tab");

    XCTAssertNotNil(self.app.images[@"flowers-in-circle"]);
    label(@"Then I see the flowers in a circle");

    [self.app.buttons[@"Square"] tap];
    label(@"When I touch the Square tab");

    XCTAssertNotNil(self.app.images[@"flowers-in-square"]);
    label(@"Then I see the flowers in a square");

    [self.app.buttons[@"Circle"] tap];
    label(@"When I see the Circle tab");

    XCTAssertNotNil(self.app.images[@"flowers-in-circle"]);
    label(@"Then I see the flowers in a circle");
}

@end
