//
//  FoldingCell.swift
//
// Copyright (c) 21/12/15. Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class FoldingCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var foregroundView: RotatedView!
   
    // PRAGMA:  life cicle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureDefaultState()
    }

    // PRAGMA: configure
    
    func configureDefaultState() {
        let foregroundTopConstraint = self.contentView.constraints.filter{ $0.identifier == "ForegroundViewTop"}.first
        let containerViewTopConstraint = self.contentView.constraints.filter{ $0.identifier == "ContainerViewTop"}.first
        
        assert(foregroundTopConstraint != nil, "set identifier")
        assert(containerViewTopConstraint != nil, "set identifier")
        
        containerViewTopConstraint!.constant = foregroundTopConstraint!.constant
        containerView.alpha = 0;
        
        let firstItemView = containerView.subviews.filter{$0.tag == 0}.first
        assert(firstItemView != nil, "contaner empty")
        firstItemView!.layer.cornerRadius = 10
      
        foregroundView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
        foregroundTopConstraint!.constant += foregroundView.bounds.height / 2

        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        foregroundView.layer.transform = foregroundView.transform3d()
        
        // elements view
        
        for constraint in containerView.constraints {
            if constraint.identifier == "yPosition" {
                constraint.constant -= constraint.firstItem.bounds.height / 2
                constraint.firstItem.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
                constraint.firstItem.layer.transform = constraint.firstItem.transform3d()
            }
        }
        
        
        // added back view
        var previusView: RotatedView?
        for contener in containerView.subviews.sort({ $0.tag < $1.tag }) {
            if contener is RotatedView && contener.tag > 0 && contener.tag < containerView.subviews.count {
                let rotatedView = contener as! RotatedView
                previusView?.addBackView(rotatedView.bounds.size.height)
                previusView = rotatedView
            }
        }
    }
    
    // PRAGMA: public
    
    func selectedAnimation(isSelected: Bool, animated: Bool) {
        if isSelected {
            containerView.alpha = 1;
            for subview in containerView.subviews {
                subview.alpha = 1
            }

            if animated {
                openAnimation()
            } else {
                foregroundView.alpha = 0
                for subview in containerView.subviews {
                    if subview is RotatedView {
                        let rotateView = subview as! RotatedView
                        rotateView.backView?.alpha = 0
                    }
                }
            }
        } else {
            if animated {
                closeAnimation()
            } else {
                foregroundView.alpha = 1;
                containerView.alpha = 0;
            }
        }
    }
    
    // PRAGMA: animations
    
    func openAnimation() {
        
        let animationInfo:[(type: String, duration: NSTimeInterval)] = [
                                                                 (kCAMediaTimingFunctionEaseIn, 0.165), // folding open
                                                                 (kCAMediaTimingFunctionEaseOut, 0.165),
            
                                                                 (kCAMediaTimingFunctionEaseIn, 0.13),
                                                                 (kCAMediaTimingFunctionEaseOut, 0.13),
            
                                                                 (kCAMediaTimingFunctionEaseIn, 0.13),
                                                                 (kCAMediaTimingFunctionEaseOut, 0.13),
                                                                ]
        
        var delay: NSTimeInterval = 0
        foregroundView.foldingAnimation(animationInfo[0].type, from: 0, to: CGFloat(-M_PI / 2), duration: animationInfo[0].duration, delay:delay, hidden: true)
        
        let firstItemView = containerView.subviews.filter{$0.tag == 0}.first
        firstItemView!.layer.masksToBounds = true
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(animationInfo[0].duration * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            firstItemView!.layer.masksToBounds = false
        }
        
        var index = 1
        for itemView in containerView.subviews.sort({ $0.tag < $1.tag }) {

            if itemView is RotatedView {
                let rotatedView: RotatedView = itemView as! RotatedView
                rotatedView.alpha = 0;
                if index < animationInfo.count {
                    delay += animationInfo[index - 1].duration
                    rotatedView.foldingAnimation(animationInfo[index].type,
                                                from: CGFloat(M_PI / 2),
                                                to: 0,
                                                duration:
                                                animationInfo[index].duration,
                                                delay:delay,
                                                hidden:false)
                }
                if index+1 < animationInfo.count {
                    delay += animationInfo[index].duration
                    rotatedView.backView?.foldingAnimation(animationInfo[index + 1].type,
                                                from: 0,
                                                to: CGFloat(-M_PI / 2),
                                                duration: animationInfo[index+1].duration,
                                                delay: delay,
                                                hidden:true)
                }
                index += 2
            }
        }
    }
    
    func closeAnimation() {
        
        let animationInfo:[(type: String, duration: NSTimeInterval)] = [
            (kCAMediaTimingFunctionEaseIn, 0.13),
            (kCAMediaTimingFunctionEaseOut, 0.13),
            
            (kCAMediaTimingFunctionEaseIn, 0.13),
            (kCAMediaTimingFunctionEaseOut, 0.13),

            (kCAMediaTimingFunctionEaseIn, 0.165), // folding open
            (kCAMediaTimingFunctionEaseOut, 0.165),
            ]
    
        var index = 0
        var delay: NSTimeInterval = 0
        
        for itemView in containerView.subviews.sort({ $0.tag > $1.tag }) {
            if itemView is RotatedView {
                let rotatedView: RotatedView = itemView as! RotatedView
                
                if index - 1 > 0 {
                    rotatedView.backView?.foldingAnimation(animationInfo[index-1].type,
                        from: CGFloat(-M_PI / 2),
                        to: 0,
                        duration: animationInfo[index-1].duration,
                        delay: delay,
                        hidden: false)
                    delay += animationInfo[index-1].duration
                }

                
                if index < animationInfo.count {
                    rotatedView.foldingAnimation(animationInfo[index].type,
                                                        from:0,
                                                        to: CGFloat(M_PI / 2),
                                                        duration: animationInfo[index].duration,
                                                        delay:delay,
                                                        hidden:true)
                    delay += animationInfo[index].duration
                }
                
                index += 2
            }
        }
        
        foregroundView.alpha = 0
        foregroundView.foldingAnimation(animationInfo.last!.type,
                                        from: CGFloat(-M_PI / 2),
                                        to: 0,
                                        duration: animationInfo.last!.duration,
                                        delay:delay,
                                        hidden:false)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.containerView.alpha = 0
        }
      
        let firstItemView = containerView.subviews.filter{$0.tag == 0}.first
        firstItemView!.layer.masksToBounds = false
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((delay - 0.07) * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            firstItemView!.layer.masksToBounds = true
        }
    }
}

class RotatedView: UIView {
    var hiddenAfterAnimation = false
    var backView: RotatedView?
    
    func addBackView(height: CGFloat) {
        let view = RotatedView(frame: CGRect.zero)
        view.backgroundColor = UIColor(red:0.97, green:0.94, blue:0.98, alpha:1)
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
