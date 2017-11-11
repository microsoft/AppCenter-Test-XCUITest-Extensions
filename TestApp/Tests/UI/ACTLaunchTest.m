
#import <XCTest/XCTest.h>
#import "ACTLaunch.h"
#import "ACTLabel.h"

@interface ACTLaunch (TEST)

+ (XCUIApplicationState)stateForApplication:(XCUIApplication *)application;

@end

@interface ACTLaunchTest : XCTestCase

@end

@implementation ACTLaunchTest

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = YES;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testACTLaunchClassMethodUsingObjectiveC {
    XCUIApplication *application = [ACTLaunch launch];
    act_label(@"Given the app launched using ACTLabel.launch from ObjC");
    XCTAssertNotNil(application);
    XCUIApplicationState state = [ACTLaunch stateForApplication:application];
    XCTAssertFalse(state == XCUIApplicationStateUnknown);
    [application terminate];
}

- (void)testACTLaunchApplicationClassMethodUsingObjectiveC {
    XCUIApplication *application = [[XCUIApplication alloc] init];
    XCTAssertNotNil(application);

    XCUIApplication *launched = [ACTLaunch launchApplication:application];
    act_label(@"Given the app launched using ACTLabel.launchApplication from ObjC");
    XCTAssertEqualObjects(application, launched,
                          @"Expected .launchApplication: to return the"
                          "application it was passed as an argument.");

    XCUIApplicationState state = [ACTLaunch stateForApplication:application];
    XCTAssertFalse(state == XCUIApplicationStateUnknown);
    [application terminate];
}

- (void)testACTLaunchMacroUsingObjectiveC {
    XCUIApplication *application = act_launch;
    XCTAssertNotNil(application);
    act_label(@"Given the app launched using act_launch macro");
    XCUIApplicationState state = [ACTLaunch stateForApplication:application];
    XCTAssertFalse(state == XCUIApplicationStateUnknown);
    [application terminate];
}

- (void)testACTLaunchAppMacroUsingObjectiveC {
    XCUIApplication *application = [[XCUIApplication alloc] init];
    XCTAssertNotNil(application);

    XCUIApplication *launched = act_launch_app(application);
    act_label(@"Given the app launched using act_launch_app macro");
    XCTAssertEqualObjects(application, launched,
                          @"Expected .launchApplication: to return the"
                          "application it was passed as an argument.");

    XCUIApplicationState state = [ACTLaunch stateForApplication:application];
    XCTAssertFalse(state == XCUIApplicationStateUnknown);
    [application terminate];
}

@end
