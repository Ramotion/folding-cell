//
//  MainNoNibTableViewController.swift
//  FoldingCell
//
//  Created by Kevin Malkic on 22/02/2016.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class MainNoNibTableViewController: UITableViewController {

	var kRowsCount: Int = 10
	
	var kOpenCellHeight: CGFloat = 0
	var kCloseCellHeight: CGFloat = 0
	
	var cellOpen = [Bool]()
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		initialize()
	}
	
	func initialize() {
		
		tableView.registerClass(DemoCell.self, forCellReuseIdentifier: "NoNibCell")
		tableView.separatorStyle = .None
		
		kOpenCellHeight = 0
		
		for i in 0..<4 {
		
			kOpenCellHeight += heightForFoldedItem(nil, index: i)
		}
		
		kCloseCellHeight = heightForForegroundView(nil)
		
		cellOpen = Array(count: kRowsCount, repeatedValue: false)
		
		tableView.reloadData()
	}
	
	// MARK: - Table view data source
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return kRowsCount
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("NoNibCell", forIndexPath: indexPath) as! DemoCell
		
		cell.dataSource = self
        
		return cell
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		return (cellOpen[indexPath.row]) ? kOpenCellHeight : kCloseCellHeight
	}
	
	// MARK: Table view delegate
	
	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		if let foldingCell = cell as? FoldingCell {
			
			foldingCell.backgroundColor = UIColor.clearColor()
			
			if !cellOpen[indexPath.row] {
				
				foldingCell.selectedAnimation(false, animated: false, completion:nil)
				
			} else {
				
				foldingCell.selectedAnimation(true, animated: false, completion: nil)
			}
		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		if let cell = tableView.cellForRowAtIndexPath(indexPath) as? FoldingCell {
			
			if cell.isAnimating() {
				
				return
			}
			
			var duration = 0.0
			
			if !cellOpen[indexPath.row] { // open cell
				
				cellOpen[indexPath.row] = true
				cell.selectedAnimation(true, animated: true, completion: nil)
				duration = 0.5
				
			} else { // close cell
				
				cellOpen[indexPath.row] = false
				cell.selectedAnimation(false, animated: true, completion: nil)
				duration = 0.8
			}
			
			UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
				tableView.beginUpdates()
				tableView.endUpdates()
				}, completion: nil)
		}
	}
}

extension MainNoNibTableViewController : FoldingCellDataSource {
	
	func numberOfFoldedItems(cell: FoldingCell) -> Int {
		
		return 4
	}
	
	func backViewBackgroundColor(cell: FoldingCell) -> UIColor {
	
		return .brownColor()
	}
	
	func heightForForegroundView(cell: FoldingCell?) -> CGFloat {
		
		return 100
	}
	
	func foregroundView(cell: FoldingCell) -> RotatedView {
	
		let view = RotatedView()
		view.backgroundColor = .redColor()
		
		return view
	}
	
	func foldedItem(cell: FoldingCell, index: Int) -> RotatedView {
	
		let view = RotatedView()
		view.backgroundColor = .random()
		
		return view
	}
	
	func heightForFoldedItem(cell: FoldingCell?, index: Int) -> CGFloat {
		
		return 100
	}
    
    func cornerRadius(cell: FoldingCell?) -> CGFloat {
        
        return 10
    }
}
