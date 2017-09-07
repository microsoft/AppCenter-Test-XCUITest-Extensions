
#import <XCTest/XCTest.h>
#import "VSMobileCenterExtensions.h"

@interface MCLabelTest : XCTestCase

@end

@implementation MCLabelTest

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = YES;
    [[[XCUIApplication alloc] init] launch];
}

- (void)tearDown {
    [super tearDown];
    [[[XCUIApplication alloc] init] terminate];
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

@end
