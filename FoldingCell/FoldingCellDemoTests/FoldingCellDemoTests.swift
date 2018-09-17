//
//  FoldingCellDemoTests.swift
//  FoldingCellDemoTests
//
//  Created by Alex K on 06/09/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

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
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateFoldingCell() {
        XCTAssertNotNil(foldingCell)
    }
}
