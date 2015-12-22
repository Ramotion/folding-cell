//
//  FoldingCell.swift
//  FoldingCell
//
//  Created by Alex K. on 21/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit

class FoldingCell: UITableViewCell {
    
    @IBOutlet weak var foregroundTop: NSLayoutConstraint!
    @IBOutlet weak var contanerTop: NSLayoutConstraint!
    
    @IBOutlet weak var contanerView: UIView!
    @IBOutlet weak var foregroundView: RotatedView!
    
    // PRAGMA:  life cicle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureDefaultState()
    }

    // PRAGMA: configure
    
    func configureDefaultState() {
        contanerTop.constant = foregroundTop.constant
        contanerView.alpha = 0;
      
        foregroundView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
        foregroundTop.constant += foregroundView.bounds.height / 2
        
        foregroundView.layer.transform = foregroundView.transform3d()
        
        // elements view
        
        for constraint in contanerView.constraints {
            if constraint.identifier == "custom" {
                constraint.constant -= constraint.firstItem.bounds.height / 2
                constraint.firstItem.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
                constraint.firstItem.layer.transform = constraint.firstItem.transform3d()
            }
        }
    }
    
    // PRAGMA: public
    
    func selectedAnimation(isSelected: Bool) {
        if isSelected {
            contanerView.alpha = 1;
            openAnimation()
        } else {
            closeAnimation()
        }
    }
    
    // PRAGMA: animations
    
    func openAnimation() {
        foregroundView.foldingAnimation(kCAMediaTimingFunctionEaseIn, from: 0, to: CGFloat(-M_PI / 2), duration: 0.5, delay:0, hidden: true)
      
        for itemView in contanerView.subviews {

            if itemView is RotatedView {
                let rotatedView: RotatedView = itemView as! RotatedView
                rotatedView.alpha = 0;
                rotatedView.foldingAnimation(kCAMediaTimingFunctionLinear, from: CGFloat(M_PI / 2), to: 0, duration: 0.5, delay:0.5, hidden:false)
            }

        }
    }
    
    func closeAnimation() {
        foregroundView.alpha = 0
        foregroundView.foldingAnimation(kCAMediaTimingFunctionEaseIn, from: CGFloat(-M_PI / 2), to: 0, duration: 0.5, delay:0.5, hidden:false)
        
        for itemView in contanerView.subviews {
            if itemView is RotatedView {
                let rotatedView: RotatedView = itemView as! RotatedView
                rotatedView.foldingAnimation(kCAMediaTimingFunctionLinear, from:0, to: CGFloat(M_PI / 2), duration: 0.5, delay:0, hidden:true)
            }
        }
    }
}

class RotatedView: UIView {
    var hiddenAfterAnimation = false
}


extension RotatedView {
    
    func rotatedX(angle : CGFloat) {
        var allTransofrom = CATransform3DIdentity;
        let rotateTransform = CATransform3DMakeRotation(angle, 1, 0, 0)
        allTransofrom = CATransform3DConcat(allTransofrom, rotateTransform)
        allTransofrom = CATransform3DConcat(allTransofrom, transform3d())
        self.layer.transform = allTransofrom
    }
    
    func transform3d()-> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = 2.5 / -2000;
        return transform
    }
    
    // PRAGMA: animations
    
    func foldingAnimation(timing: String, from: CGFloat, to: CGFloat, duration: NSTimeInterval, delay:NSTimeInterval, hidden:Bool) {
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: timing)
        rotateAnimation.fromValue = (from)
        rotateAnimation.toValue = (to)
        rotateAnimation.duration = duration
        rotateAnimation.delegate = self;
        rotateAnimation.fillMode = kCAFillModeForwards;
        rotateAnimation.removedOnCompletion = false;
        rotateAnimation.beginTime = CACurrentMediaTime() + delay
        
        self.hiddenAfterAnimation = hidden
        
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
    
    override func animationDidStart(anim: CAAnimation) {
        self.alpha = 1
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if hiddenAfterAnimation {
            self.alpha = 0
        }
        self.layer.removeAllAnimations()
        self.rotatedX(CGFloat(0))
    }
}
