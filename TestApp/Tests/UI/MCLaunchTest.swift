
import XCTest


class MCLaunchTest: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = true;
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMCLaunchUsingSwift() {
        let app = MCLaunch.launch()
        XCTAssertNotNil(app)
        MCLabel.labelStep("Given the app launched using MCLaunch.launch from Swift")
        app?.terminate()
    }

    func testMCLaunchApplicationUsingSwift() {
        let app = XCUIApplication();
        let launched = MCLaunch.launch(app);
        XCTAssertEqual(app, launched,
                       "Expected .launch(app): to return the application it" +
                       "passed as an argument.");
        MCLabel.labelStep("Given app launched using MCLaunch.launch(app) from Swift");
        app.terminate();
    }
}
