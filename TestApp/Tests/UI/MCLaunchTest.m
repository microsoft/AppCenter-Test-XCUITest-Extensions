
#import <XCTest/XCTest.h>
#import "MCLaunch.h"
#import "MCLabel.h"

@interface MCLaunch (TEST)

+ (XCUIApplicationState)stateForApplication:(XCUIApplication *)application;

@end

@interface MCLaunchTest : XCTestCase

@end

@implementation MCLaunchTest

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = YES;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testMCLaunchClassMethodUsingObjectiveC {
    XCUIApplication *application = [MCLaunch launch];
    label(@"Given the app launched using MCLabel.launch from ObjC");
    XCTAssertNotNil(application);
    XCUIApplicationState state = [MCLaunch stateForApplication:application];
    XCTAssertFalse(state == XCUIApplicationStateUnknown);
    [application terminate];
}

- (void)testMCLaunchApplicationClassMethodUsingObjectiveC {
    XCUIApplication *application = [[XCUIApplication alloc] init];
    XCTAssertNotNil(application);

    XCUIApplication *launched = [MCLaunch launchApplication:application];
    label(@"Given the app launched using MCLabel.launchApplication from ObjC");
    XCTAssertEqualObjects(application, launched,
                          @"Expected .launchApplication: to return the"
                          "application it was passed as an argument.");

    XCUIApplicationState state = [MCLaunch stateForApplication:application];
    XCTAssertFalse(state == XCUIApplicationStateUnknown);
    [application terminate];
}

- (void)testMCLaunchMacroUsingObjectiveC {
    XCUIApplication *application = mc_launch;
    XCTAssertNotNil(application);
    label(@"Given the app launched using mc_launch macro");
    XCUIApplicationState state = [MCLaunch stateForApplication:application];
    XCTAssertFalse(state == XCUIApplicationStateUnknown);
    [application terminate];
}

- (void)testMCLaunchAppMacroUsingObjectiveC {
    XCUIApplication *application = [[XCUIApplication alloc] init];
    XCTAssertNotNil(application);

    XCUIApplication *launched = mc_launch_app(application);
    label(@"Given the app launched using mc_launch_app macro");
    XCTAssertEqualObjects(application, launched,
                          @"Expected .launchApplication: to return the"
                          "application it was passed as an argument.");

    XCUIApplicationState state = [MCLaunch stateForApplication:application];
    XCTAssertFalse(state == XCUIApplicationStateUnknown);
    [application terminate];
}

@end
