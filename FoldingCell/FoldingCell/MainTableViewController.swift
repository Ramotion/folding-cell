//
//  MainTableViewController.swift
//  FoldingCell
//
//  Created by Alex K. on 21/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let kCloseCellHeight: CGFloat = 134
    let kOpenCellHeight: CGFloat = 258

    let kRowsCount = 10
    
    var cellHeights: [CGFloat]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCellHeightsArray()
    }
    
    // PRAGMA: configure
    func createCellHeightsArray() {
        cellHeights = Array()
        for _ in 0...kRowsCount {
            cellHeights?.append(kCloseCellHeight)
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FoldingCell", forIndexPath: indexPath)

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights![indexPath.row]
    }
    
    // PRAGMA: Table vie delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FoldingCell
        if cellHeights![indexPath.row] == kCloseCellHeight { // open cell
            cellHeights![indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true)
        } else {// close cell
            cellHeights![indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false)
        }
        
        
        UIView.animateWithDuration(1) { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    
    
}
