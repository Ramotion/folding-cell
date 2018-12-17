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
    
    func testAddBackView() {
        XCTAssertNil(rotationView.backView)
        let color = UIColor.red
        rotationView.addBackView(100, color: color)
        
        XCTAssertNotNil(rotationView.backView)
        XCTAssertEqual(rotationView.backView?.backgroundColor, color)
    }
}
