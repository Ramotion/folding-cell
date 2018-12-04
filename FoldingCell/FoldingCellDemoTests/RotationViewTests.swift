import XCTest
import UIKit
@testable import FoldingCell

class RotationViewTests: XCTestCase {

    var rotationView: RotatedView!
    override func setUp() {
        
        rotationView = RotatedView()
    }

    override func tearDown() {
        
    }
    
    func testCreateRotationView() {
        XCTAssertNotNil(rotationView)
    }
}
