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
    
    func testRotateX() {
        let startX = (rotationView.value(forKeyPath: "layer.transform.rotation.x") as? NSNumber)?.floatValue
        XCTAssertEqual(startX, 0)

        let angel: CGFloat = 0.5
        rotationView.rotatedX(angel)
        let x = (rotationView.value(forKeyPath: "layer.transform.rotation.x") as? NSNumber)?.floatValue

        XCTAssertEqual(x, Float(angel))
    }
}
