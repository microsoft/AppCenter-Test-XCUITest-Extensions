
import Foundation
import XCTest

class ACTScreenshotter {
    class func screenshotWithTitle (title: String) {
        XCTContext.runActivity(named: title) { (activity) in
            let screenshot = XCUIScreen.main.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.lifetime = .keepAlways
            activity.add(attachment)
        }
    }
}
