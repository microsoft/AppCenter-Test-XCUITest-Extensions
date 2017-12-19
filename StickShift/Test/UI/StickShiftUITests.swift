
import XCTest
import AppCenterXCUITestExtensions

class StickShiftUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    override func tearDown() {
        super.tearDown()
    }

    func testACTLaunchUsingSwift() {
        let app = ACTLaunch.launch()
        XCTAssertNotNil(app)
        ACTLabel.labelStep("Given the app launched using ACTLaunch.launch from Swift")
        app?.terminate()
    }

    func testACTLaunchApplicationUsingSwift() {
        let app = XCUIApplication()
        let launched = ACTLaunch.launch(app)
        XCTAssertEqual(app, launched,
                       "Expected .launch(app): to return the application it" +
            "was passed as an argument.")
        ACTLabel.labelStep("Given app launched using ACTLaunch.launch(app) from Swift")
        app.terminate()
    }

    func testACTLabelClassMethodWithSwift() {
        let app: XCUIApplication = ACTLaunch.launch()
        ACTLabel.labelStep("Given the app has launched")
        ACTLabel.labelStep("Then I %@ the %@ button %@ times",
                           args: getVaList(["touch", "red", "3"]))
        XCTAssert(true, "This test should always pass")
        app.terminate()
    }
}
