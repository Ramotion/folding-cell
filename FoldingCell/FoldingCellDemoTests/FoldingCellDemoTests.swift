import XCTest
import UIKit
@testable import FoldingCell
@testable import FoldingCell_Demo

class FoldingCellDemoTests: XCTestCase {
    
    var foldingCell: FoldingCell!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTableViewController") as! MainTableViewController
        _ = vc.view
        foldingCell = vc.tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: IndexPath(row: 0, section: 0)) as? FoldingCell
    }
    
    func testCreateFoldingCell() {
        XCTAssertNotNil(foldingCell)
    }
    
    func testUnfold() {
        XCTAssertEqual(foldingCell.isUnfolded, false)
        foldingCell.unfold(true)
        XCTAssertEqual(foldingCell.isUnfolded, true)
        foldingCell.unfold(false)
        XCTAssertEqual(foldingCell.isUnfolded, false)
    }
}
