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
        
        
        // added back view
        var previusView: RotatedView?
        for contener in contanerView.subviews.sort({ $0.tag < $1.tag }) {
            if contener is RotatedView && contener.tag > 0 && contener.tag < contanerView.subviews.count {
                let rotatedView = contener as! RotatedView
                previusView?.addBackView(rotatedView.bounds.size.height)
                previusView = rotatedView
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
        let duration = 0.5
        foregroundView.foldingAnimation(kCAMediaTimingFunctionEaseIn, from: 0, to: CGFloat(-M_PI / 2), duration: duration, delay:0, hidden: true)
        
        var index = 1.0
        for itemView in contanerView.subviews.sort({ $0.tag < $1.tag }) {

            if itemView is RotatedView {
                let rotatedView: RotatedView = itemView as! RotatedView
                rotatedView.alpha = 0;
                rotatedView.foldingAnimation(kCAMediaTimingFunctionLinear, from: CGFloat(M_PI / 2), to: 0, duration: duration, delay:duration * index, hidden:false)
                rotatedView.backView?.foldingAnimation(kCAMediaTimingFunctionLinear, from: 0, to: CGFloat(-M_PI / 2), duration: duration, delay:duration * (index + 1), hidden:true)
                index += 2
            }
        }
    }
    
    func closeAnimation() {
        let duration = 0.5
        
        var index = 0.0
        for itemView in contanerView.subviews.sort({ $0.tag > $1.tag }) {
            if itemView is RotatedView {
                let rotatedView: RotatedView = itemView as! RotatedView
                rotatedView.foldingAnimation(kCAMediaTimingFunctionLinear, from:0, to: CGFloat(M_PI / 2), duration: duration, delay:index * duration, hidden:true)
                rotatedView.backView?.foldingAnimation(kCAMediaTimingFunctionLinear, from: CGFloat(-M_PI / 2), to: 0, duration: duration, delay:duration * (index - 1), hidden:false)
                index += 2
            }
        }
        
        foregroundView.alpha = 0
        foregroundView.foldingAnimation(kCAMediaTimingFunctionEaseIn, from: CGFloat(-M_PI / 2), to: 0, duration: duration, delay:(index-1) * duration, hidden:false)
    }
}

class RotatedView: UIView {
    var hiddenAfterAnimation = false
    var backView: RotatedView?
    
    func addBackView(height: CGFloat) {
        let view = RotatedView(frame: CGRect.zero)
        view.backgroundColor = UIColor.brownColor()
        view.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
        view.layer.transform = view.transform3d()
        view.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(view)
        backView = view
        
        view.addConstraint(NSLayoutConstraint(item: view,
                                         attribute: .Height,
                                         relatedBy: .Equal,
                                            toItem: nil,
                                         attribute: .Height,
                                        multiplier: 1,
                                          constant: height))
        
        self.addConstraints([
             NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: self.bounds.size.height - height + height / 2),
             NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0),
             NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0)
        ])
    }
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
