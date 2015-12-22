//
//  MainTableViewController.swift
//  FoldingCell
//
//  Created by Alex K. on 21/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 400

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
        
        var duration = 0.0
        if cellHeights![indexPath.row] == kCloseCellHeight { // open cell
            cellHeights![indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true)
            duration = 1.5
        } else {// close cell
            cellHeights![indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false)
            duration = 4
        }
        
        
        UIView.animateWithDuration(duration) { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    
    
}
