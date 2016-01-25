//
//  FoldingCellTests.swift
//  FoldingCellTests
//
//  Created by Alex K. on 25/01/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import XCTest

class FoldingCellTests: XCTestCase {
    
    var viewController : UITableViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewControllerWithIdentifier("MainTableViewController") as! UITableViewController
        viewController.beginAppearanceTransition(true, animated: false)
    }
    
    override func tearDown() {
         viewController.endAppearanceTransition()
        super.tearDown()
    }
    
    func testExample() {
        let tableView = viewController.tableView
        
        for case let cell as FoldingCell in tableView.visibleCells {
            XCTAssertTrue(cell.itemCount >= 2)
        }
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
