
import XCTest

class MCLabelTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = true
        MCLaunch.launch();
    }
    
    override func tearDown() {
        super.tearDown()
        XCUIApplication().terminate()
    }

    func testMCLabelClassMethodWithSwift() {
        MCLabel.labelStep("Given the app has launched")
        MCLabel.labelStep("Then I %@ the %@ button %@ times",
                          args: getVaList(["touch", "red", "3"]))
        XCTAssert(true, "This test should always pass");
    }
}
