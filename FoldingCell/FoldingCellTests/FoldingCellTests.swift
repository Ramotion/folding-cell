//
//  FoldingCellTests.swift
//  FoldingCellTests
//
//  Created by Alex K on 24/08/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import XCTest
import UIKit
@testable import FoldingCell_Demo
@testable import FoldingCell

class FoldingCellTests: XCTestCase {
    
    var foldingCell: FoldingCell!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TableViewController") as? MainTableViewController
        foldingCell = vc?.tableView.dequeueReusableCell(withIdentifier: "FoldingCell") as? FoldingCell
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCretaFoldingCell() {
        XCTAssertNotNil(foldingCell)
    }
}
