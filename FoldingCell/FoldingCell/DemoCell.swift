//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit

class DemoCell: FoldingCell {
    
    override func initialise() {
        
        if let foregroundView = foregroundView {
            
            foregroundView.layer.cornerRadius = 10
            foregroundView.layer.masksToBounds = true
        }
        
        super.initialise()
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType) -> NSTimeInterval {
     
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }

}
