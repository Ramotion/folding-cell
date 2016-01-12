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

public class FoldingCell: UITableViewCell {
    
    public typealias CompletionHandler = () -> Void

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var foregroundView: RotatedView!
    var animationView: UIView?
    
    let itemCount = 4
    
    @IBInspectable var backViewColor: UIColor = UIColor.brownColor()
    
    var animationItemViews: [RotatedView]?
    
    public enum AnimationType {
        case Open
        case Close
    }
   
    // MARK:  life cicle
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        configureDefaultState()
//        animationItemViews = createAnimationItemView()

        self.selectionStyle = .None
        containerView.backgroundColor = UIColor.clearColor()
        
    }

    // MARK: configure
    
    func configureDefaultState() {
        let foregroundTopConstraint = self.contentView.constraints.filter{ $0.identifier == "ForegroundViewTop"}.first
        let containerViewTopConstraint = self.contentView.constraints.filter{ $0.identifier == "ContainerViewTop"}.first
        
        assert(foregroundTopConstraint != nil, "set identifier")
        assert(containerViewTopConstraint != nil, "set identifier")
        
        containerViewTopConstraint!.constant = foregroundTopConstraint!.constant
        containerView.alpha = 0;
        
        let firstItemView = containerView.subviews.filter{$0.tag == 0}.first
        assert(firstItemView != nil, "contaner empty")
        firstItemView!.layer.cornerRadius = foregroundView.layer.cornerRadius
      
        foregroundView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
        foregroundTopConstraint!.constant += foregroundView.bounds.height / 2
        foregroundView.layer.transform = foregroundView.transform3d()
        
        createAnimationView();

        self.contentView.bringSubviewToFront(foregroundView)
    }
    
    func createAnimationItemView()->[RotatedView] {
        var items = [RotatedView]()
        items.append(foregroundView)
        var rotatedViews = [RotatedView]()
        for itemView in animationView!.subviews.filter({$0 is RotatedView}).sort({ $0.tag < $1.tag }) as! [RotatedView] {
            rotatedViews.append(itemView)
            if itemView.backView != nil {
                rotatedViews.append(itemView.backView!)
            }
        }
        items.appendContentsOf(rotatedViews)
        return items
    }
    
    func configureAnimationItems(animationType: AnimationType) {
        if animationType == .Open {
            for view in animationView!.subviews.filter({$0 is RotatedView}) {
                view.alpha = 0;
            }
        } else { // close
            for view: RotatedView in animationView!.subviews.filter({$0 is RotatedView}) as! [RotatedView] {
                if animationType == .Open {
                    view.alpha = 0
                } else {
                    view.alpha = 1
                    view.backView?.alpha = 0
                }
            }
        }
    }
    
    func createAnimationView() {
        
        let anAnimationView = UIView(frame: containerView.frame)
        anAnimationView.backgroundColor = UIColor.clearColor()
        anAnimationView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(anAnimationView)
        
        // copy constraints from containerView
        var newConstraints = [NSLayoutConstraint]()
        for constraint in self.contentView.constraints {
            if let item: UIView = constraint.firstItem as? UIView {
                if item == containerView {
                    let newConstraint = NSLayoutConstraint(
                        item: anAnimationView,
                        attribute: constraint.firstAttribute,
                        relatedBy: constraint.relation,
                        toItem: constraint.secondItem,
                        attribute: constraint.secondAttribute,
                        multiplier: constraint.multiplier,
                        constant: constraint.constant)
                    
                    newConstraints.append(newConstraint)
                } else if let item: UIView = constraint.secondItem as? UIView {
                    if item == containerView {
                        let newConstraint = NSLayoutConstraint(
                            item: constraint.firstItem,
                            attribute: constraint.firstAttribute,
                            relatedBy: constraint.relation,
                            toItem: anAnimationView,
                            attribute: constraint.secondAttribute,
                            multiplier: constraint.multiplier,
                            constant: constraint.constant)
                        
                        newConstraints.append(newConstraint)
                    }
                }
            }
        }
        self.contentView.addConstraints(newConstraints)
        
        for constraint in containerView.constraints { // added height constraint
            if constraint.firstAttribute == .Height {
                let newConstraint = NSLayoutConstraint(
                    item: anAnimationView,
                    attribute: constraint.firstAttribute,
                    relatedBy: constraint.relation,
                    toItem: nil,
                    attribute: constraint.secondAttribute,
                    multiplier: constraint.multiplier,
                    constant: constraint.constant)
               
                anAnimationView.addConstraint(newConstraint)
            }
        }
        
        animationView = anAnimationView
    }
    
    func addImageItemsToAnimationView() {
        containerView.alpha = 1;
        
        // added first item
        var image = containerView.pb_takeSnapshot(CGRect(x: 0, y: 0, width: containerView.bounds.size.width, height: foregroundView.bounds.size.height))
        var imageView = UIImageView(image: image)
        imageView.tag = 0
        animationView?.addSubview(imageView)
        
        // added secod item
        
        image = containerView.pb_takeSnapshot(
            CGRect(x: 0,
                y: foregroundView.bounds.size.height,
                width: containerView.bounds.size.width,
                height: foregroundView.bounds.size.height))
        
        imageView = UIImageView(image: image)
        let rotatedView = RotatedView(frame: imageView.frame)
        rotatedView.tag = 1
        rotatedView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        rotatedView.layer.transform = rotatedView.transform3d()
        
        rotatedView.addSubview(imageView)
        animationView?.addSubview(rotatedView)
        rotatedView.frame = CGRect(x: imageView.frame.origin.x,
            y: foregroundView.bounds.size.height,
            width: containerView.bounds.size.width,
            height: foregroundView.bounds.size.height)
        
        // added other views
        let itemHeight = (containerView.bounds.size.height - 2 * foregroundView.bounds.size.height) / CGFloat(itemCount - 2)
        var yPosition = 2 * foregroundView.bounds.size.height
        var tag = 2
        for var index = 2; index < itemCount; index++ {
            
            image = containerView.pb_takeSnapshot(CGRect(x: 0, y: yPosition, width: containerView.bounds.size.width, height: itemHeight))
            
            imageView = UIImageView(image: image)
            let rotatedView = RotatedView(frame: imageView.frame)
            
            rotatedView.addSubview(imageView)
            rotatedView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
            rotatedView.layer.transform = rotatedView.transform3d()
            animationView?.addSubview(rotatedView)
            rotatedView.frame = CGRect(x: 0, y: yPosition, width: rotatedView.bounds.size.width, height: itemHeight)
            rotatedView.tag = tag
            
            yPosition += itemHeight
            tag++;
        }
        
        containerView.alpha = 0;
        
        // added back view
        var previusView: RotatedView?
        for contener in animationView!.subviews.sort({ $0.tag < $1.tag }) {
            if contener is RotatedView && contener.tag > 0 && contener.tag < animationView!.subviews.count {
                let rotatedView = contener as! RotatedView
                previusView?.addBackView(rotatedView.bounds.size.height, color: backViewColor)
                previusView = rotatedView
            }
        }
        
        animationItemViews = createAnimationItemView()
    }
    
    // MARK: public
    
    public func selectedAnimation(isSelected: Bool, animated: Bool, completion: CompletionHandler?) {
        
        if isSelected {
            
            if animated {
                containerView.alpha = 0;
                openAnimation(completion: completion)
            } else  {
                foregroundView.alpha = 0
                containerView.alpha = 1;
            }
            
        } else {
            if animated {
                closeAnimation(completion: completion)
            } else {
                foregroundView.alpha = 1;
                containerView.alpha = 0;
            }
        }

//        if isSelected {
//            containerView.alpha = 0;
//            animationView?.alpha = 1;
//            for subview in animationView!.subviews {
//                subview.alpha = subview.tag > 0 ? 0 : 1;
//            }
//
//            if animated {
//                openAnimation(completion: completion)
//            } else {
//                foregroundView.alpha = 0
//                for subview in containerView.subviews {
//                    if subview is RotatedView {
//                        let rotateView = subview as! RotatedView
//                        rotateView.backView?.alpha = 0
//                    }
//                }
//            }
//        } else {
//            if animated {
//                closeAnimation(completion: completion)
//            } else {
//                foregroundView.alpha = 1;
//                containerView.alpha = 0;
//            }
//        }
    }
    
    public func isAnimating()->Bool {
        for item in animationItemViews! {
            if item.layer.animationKeys()?.count > 0 {
                return true
            }
        }
        return false
    }
    
    
    // MARK: animations
    
    public func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        assert(false, "added this method to cell")
        return 0
    }
    
    func durationSequence(type: AnimationType)-> [NSTimeInterval] {
        var durations = [NSTimeInterval]()
        for var index = 0; index < containerView.subviews.count - 1; index++ {
            let duration = animationDuration(index, type: .Open)
            durations.append(NSTimeInterval(duration / 2.0))
            durations.append(NSTimeInterval(duration / 2.0))
        }
        return durations
    }
    
    func openAnimation(completion completion: CompletionHandler?) {
        
        if animationView?.subviews.count == 0 { // added animation items if need
            addImageItemsToAnimationView()
        }
        
        animationView?.alpha = 1;
        containerView.alpha = 0;
        
        let durations = durationSequence(.Open)
        
        var delay: NSTimeInterval = 0
        var timing = kCAMediaTimingFunctionEaseIn
        var from: CGFloat = 0.0;
        var to: CGFloat = CGFloat(-M_PI / 2)
        var hidden = true
        configureAnimationItems(.Open)
        for var index = 0; index < animationItemViews?.count; index++ {
            let animatedView = animationItemViews![index]
            
            animatedView.foldingAnimation(timing, from: from, to: to, duration: durations[index], delay: delay, hidden: hidden)
            
            from = from == 0.0 ? CGFloat(M_PI / 2) : 0.0;
            to = to == 0.0 ? CGFloat(-M_PI / 2) : 0.0;
            timing = timing == kCAMediaTimingFunctionEaseIn ? kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn;
            hidden = !hidden
            delay += durations[index]
        }
        
        let firstItemView = containerView.subviews.filter{$0.tag == 0}.first
        firstItemView!.layer.masksToBounds = true
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(durations[0] * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            firstItemView!.layer.masksToBounds = false
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.animationView?.alpha = 0
            self.containerView.alpha = 1
            completion?()
        }
    }
    
    func closeAnimation(completion completion: CompletionHandler?) {
        
        if animationView?.subviews.count == 0 { // added animation items if need
            addImageItemsToAnimationView()
        }
        
        animationView?.alpha = 1;
        containerView.alpha = 0;
        
        var durations = durationSequence(.Close)
        durations = durations.reverse()
        
        var delay: NSTimeInterval = 0
        var timing = kCAMediaTimingFunctionEaseIn
        var from: CGFloat = 0.0;
        var to: CGFloat = CGFloat(M_PI / 2)
        var hidden = true
        configureAnimationItems(.Close)
        for var index = 0; index < animationItemViews?.count; index++ {
            let animatedView = animationItemViews?.reverse()[index]
            
            animatedView!.foldingAnimation(timing, from: from, to: to, duration: durations[index], delay: delay, hidden: hidden)
            
            to = to == 0.0 ? CGFloat(M_PI / 2) : 0.0;
            from = from == 0.0 ? CGFloat(-M_PI / 2) : 0.0;
            timing = timing == kCAMediaTimingFunctionEaseIn ? kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn;
            hidden = !hidden
            delay += durations[index]
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.animationView!.alpha = 0
            completion?()
        }
        
        let firstItemView = animationView!.subviews.filter{$0.tag == 0}.first
        firstItemView!.layer.masksToBounds = false
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((delay - durations.last! * 1.5) * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            firstItemView!.layer.masksToBounds = true
        }
    }
}


// MARK: RotatedView

public class RotatedView: UIView {
    var hiddenAfterAnimation = false
    var backView: RotatedView?
    
    func addBackView(height: CGFloat, color:UIColor) {
        let view = RotatedView(frame: CGRect.zero)
        view.backgroundColor = color
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
    
    // MARK: animations
    
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
        
        self.layer.addAnimation(rotateAnimation, forKey: "rotation.x")
    }
    
    override public func animationDidStart(anim: CAAnimation) {
        self.layer.shouldRasterize = true
        self.alpha = 1
    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if hiddenAfterAnimation {
            self.alpha = 0
        }
        self.layer.removeAllAnimations()
        self.layer.shouldRasterize = false
        self.rotatedX(CGFloat(0))
    }
}

extension UIView {
    func pb_takeSnapshot(frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, self.opaque, 0.0);
        
        let context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, frame.origin.x * -1, frame.origin.y * -1);
        
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return image
    }
}