
import XCTest

class StickShiftUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = true
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPassing() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertNotNil(app)
        app.terminate()
        XCTAssert(true, "This tests passes")
    }

    func testFailure() {
        let app = XCUIApplication();
        app.launch()
        app.terminate()
        XCTAssert(false, "This test fails")
    }
}
