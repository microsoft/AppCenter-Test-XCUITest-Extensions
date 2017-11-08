
import XCTest


class ACTLaunchTest: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = true;
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMCLaunchUsingSwift() {
        let app = ACTLaunch.launch()
        XCTAssertNotNil(app)
        ACTLabel.labelStep("Given the app launched using ACTLaunch.launch from Swift")
        app?.terminate()
    }

    func testMCLaunchApplicationUsingSwift() {
        let app = XCUIApplication();
        let launched = ACTLaunch.launch(app);
        XCTAssertEqual(app, launched,
                       "Expected .launch(app): to return the application it" +
                       "passed as an argument.");
        ACTLabel.labelStep("Given app launched using ACTLaunch.launch(app) from Swift");
        app.terminate();
    }
}
