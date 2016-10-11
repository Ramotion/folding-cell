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

/// UITableViewCell with folding animation
open class FoldingCell: UITableViewCell {
  
  /// UIView whitch display when cell open
  @IBOutlet weak open var containerView: UIView!
  @IBOutlet weak open var containerViewTop: NSLayoutConstraint!
  
  /// UIView whitch display when cell close
  @IBOutlet weak open var foregroundView: RotatedView!
  @IBOutlet weak open var foregroundViewTop: NSLayoutConstraint!
  var animationView: UIView?
  
  ///  the number of folding elements. Default 2
  @IBInspectable open var itemCount: NSInteger = 2
  
  /// The color of the back cell
  @IBInspectable open var backViewColor: UIColor = UIColor.brown
  
  var animationItemViews: [RotatedView]?
  
  /**
   Folding animation types
   
   - Open:  Open direction
   - Close: Close direction
   */
  public enum AnimationType {
    case open
    case close
  }
  
  // MARK:  life cicle
  
  override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override open func awakeFromNib() {
    super.awakeFromNib()
    
    commonInit()
  }
  
  /**
   Call this method in methods init(style: UITableViewCellStyle, reuseIdentifier: String?) after creating Views
   */
  open func commonInit() {
    configureDefaultState()
    
    self.selectionStyle = .none
    
    containerView.layer.cornerRadius = foregroundView.layer.cornerRadius
    containerView.layer.masksToBounds = true
  }

  
  // MARK: configure
  
  func configureDefaultState() {
    
    guard let foregroundViewTop = self.foregroundViewTop,
      let containerViewTop = self.containerViewTop else {
        fatalError("set constratins outlets")
    }
    
    containerViewTop.constant = foregroundViewTop.constant
    containerView.alpha = 0;
    
    if let height = (foregroundView.constraints.filter { $0.firstAttribute == .height && $0.secondItem == nil}).first?.constant {
      foregroundView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
      foregroundViewTop.constant += height / 2
    }
    foregroundView.layer.transform = foregroundView.transform3d()
    
    createAnimationView();
    self.contentView.bringSubview(toFront: foregroundView)
  }
  
  func createAnimationItemView()->[RotatedView] {
    guard let animationView = self.animationView else {
      fatalError()
    }
    
    var items = [RotatedView]()
    items.append(foregroundView)
    var rotatedViews = [RotatedView]()
    for case let itemView as RotatedView in animationView.subviews.filter({$0 is RotatedView}).sorted(by: {$0.tag < $1.tag}) {
      rotatedViews.append(itemView)
      if let backView = itemView.backView {
        rotatedViews.append(backView)
      }
    }
    items.append(contentsOf: rotatedViews)
    return items
  }
  
  func configureAnimationItems(_ animationType: AnimationType) {
    
    guard let animationViewSuperView = animationView?.subviews else {
      fatalError()
    }
    
    if animationType == .open {
      for view in animationViewSuperView.filter({$0 is RotatedView}) {
        view.alpha = 0;
      }
    } else { // close
      for case let view as RotatedView in animationViewSuperView.filter({$0 is RotatedView}) {
        if animationType == .open {
          view.alpha = 0
        } else {
          view.alpha = 1
          view.backView?.alpha = 0
        }
      }
    }
  }
  
  func createAnimationView() {
    
    animationView = UIView(frame: containerView.frame)
    animationView?.layer.cornerRadius = foregroundView.layer.cornerRadius
    animationView?.backgroundColor = .clear
    animationView?.translatesAutoresizingMaskIntoConstraints = false
    animationView?.alpha = 0
    
    guard let animationView = self.animationView else { return }

    self.contentView.addSubview(animationView)
    
    // copy constraints from containerView
    var newConstraints = [NSLayoutConstraint]()
    for constraint in self.contentView.constraints {
      if let item = constraint.firstItem as? UIView , item == containerView {
        let newConstraint = NSLayoutConstraint( item: animationView, attribute: constraint.firstAttribute,
          relatedBy: constraint.relation, toItem: constraint.secondItem, attribute: constraint.secondAttribute,
          multiplier: constraint.multiplier, constant: constraint.constant)
        
        newConstraints.append(newConstraint)
      } else if let item: UIView = constraint.secondItem as? UIView , item == containerView {
        let newConstraint = NSLayoutConstraint(item: constraint.firstItem, attribute: constraint.firstAttribute,
          relatedBy: constraint.relation, toItem: animationView, attribute: constraint.secondAttribute,
          multiplier: constraint.multiplier, constant: constraint.constant)
        
        newConstraints.append(newConstraint)
      }
    }
    self.contentView.addConstraints(newConstraints)
    
    for constraint in containerView.constraints { // added height constraint
      if constraint.firstAttribute == .height {
        let newConstraint = NSLayoutConstraint(item: animationView, attribute: constraint.firstAttribute,
          relatedBy: constraint.relation, toItem: nil, attribute: constraint.secondAttribute,
          multiplier: constraint.multiplier, constant: constraint.constant)
        
        animationView.addConstraint(newConstraint)
      }
    }
  }

  
  func addImageItemsToAnimationView() {
    containerView.alpha = 1;
    let contSize        = containerView.bounds.size
    let forgSize        = foregroundView.bounds.size
    
    // added first item
    var image = containerView.pb_takeSnapshot(CGRect(x: 0, y: 0, width: contSize.width, height: forgSize.height))
    var imageView = UIImageView(image: image)
    imageView.tag = 0
    imageView.layer.cornerRadius = foregroundView.layer.cornerRadius
    animationView?.addSubview(imageView)
    
    // added secod item
    image = containerView.pb_takeSnapshot(CGRect(x: 0, y: forgSize.height, width: contSize.width, height: forgSize.height))
    
    imageView                     = UIImageView(image: image)
    let rotatedView               = RotatedView(frame: imageView.frame)
    rotatedView.tag               = 1
    rotatedView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
    rotatedView.layer.transform   = rotatedView.transform3d()
    
    rotatedView.addSubview(imageView)
    animationView?.addSubview(rotatedView)
    rotatedView.frame = CGRect(x: imageView.frame.origin.x, y: forgSize.height, width: contSize.width, height: forgSize.height)
    
    // added other views
    let itemHeight = (contSize.height - 2 * forgSize.height) / CGFloat(itemCount - 2)
    
    if itemCount == 2 {
      // decrease containerView height or increase itemCount
      assert(contSize.height - 2 * forgSize.height == 0, "contanerView.height too high")
    }
    // decrease containerView height or increase itemCount
    assert(contSize.height - 2 * forgSize.height >= itemHeight, "contanerView.height too high")
    
    var yPosition = 2 * forgSize.height
    var tag = 2
    for _ in 2..<itemCount {
      image = containerView.pb_takeSnapshot(CGRect(x: 0, y: yPosition, width: contSize.width, height: itemHeight))
      
      imageView = UIImageView(image: image)
      let rotatedView = RotatedView(frame: imageView.frame)
      
      rotatedView.addSubview(imageView)
      rotatedView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
      rotatedView.layer.transform = rotatedView.transform3d()
      animationView?.addSubview(rotatedView)
      rotatedView.frame = CGRect(x: 0, y: yPosition, width: rotatedView.bounds.size.width, height: itemHeight)
      rotatedView.tag = tag
      
      yPosition += itemHeight
      tag += 1;
    }
    
    containerView.alpha = 0;
    
    if let animationView = self.animationView {
      // added back view
      var previusView: RotatedView?
      for case let contener as RotatedView in animationView.subviews.sorted(by: { $0.tag < $1.tag })
        where contener.tag > 0 && contener.tag < animationView.subviews.count {
          previusView?.addBackView(contener.bounds.size.height, color: backViewColor)
          previusView = contener
      }
    }
    animationItemViews = createAnimationItemView()
  }
  
  fileprivate func removeImageItemsFromAnimationView() {
    
    guard let animationView = self.animationView else {
      return
    }

    animationView.subviews.forEach({ $0.removeFromSuperview() })
  }

  
  // MARK: public
  
  /**
   Open or close cell
   
   - parameter isSelected: Specify true if you want to open cell or false if you close cell.
   - parameter animated:   Specify true if you want to animate the change in visibility or false if you want immediately.
   - parameter completion: A block object to be executed when the animation sequence ends.
   */
  open func selectedAnimation(_ isSelected: Bool, animated: Bool, completion: ((Void) -> Void)?) {
    
    if isSelected {
      
      if animated {
        containerView.alpha = 0;
        openAnimation(completion)
      } else  {
        foregroundView.alpha = 0
        containerView.alpha = 1;
      }
      
    } else {
      if animated {
        closeAnimation(completion)
      } else {
        foregroundView.alpha = 1;
        containerView.alpha = 0;
      }
    }
  }
  
  open func isAnimating()->Bool {
    return animationView?.alpha == 1 ? true : false
  }
  
  // MARK: animations
  open func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
    assert(false, "added this method to cell")
    return 0
  }
  
  func durationSequence(_ type: AnimationType)-> [TimeInterval] {
    var durations  = [TimeInterval]()
    for index in 0..<itemCount-1 {
      let duration = animationDuration(index, type: .open)
      durations.append(TimeInterval(duration / 2.0))
      durations.append(TimeInterval(duration / 2.0))
    }
    return durations
  }
  
  func openAnimation(_ completion: ((Void) -> Void)?) {
    
    removeImageItemsFromAnimationView()
    addImageItemsToAnimationView()
    
    guard let animationView = self.animationView else {
      return
    }
    
    animationView.alpha = 1;
    containerView.alpha = 0;
    
    let durations = durationSequence(.open)
    
    var delay: TimeInterval = 0
    var timing                = kCAMediaTimingFunctionEaseIn
    var from: CGFloat         = 0.0;
    var to: CGFloat           = CGFloat(-M_PI / 2)
    var hidden                = true
    configureAnimationItems(.open)
    
    guard let animationItemViews = self.animationItemViews else {
      return
    }
    
    for index in 0..<animationItemViews.count {
      let animatedView = animationItemViews[index]
      
      animatedView.foldingAnimation(timing, from: from, to: to, duration: durations[index], delay: delay, hidden: hidden)
      
      from   = from == 0.0 ? CGFloat(M_PI / 2) : 0.0;
      to     = to == 0.0 ? CGFloat(-M_PI / 2) : 0.0;
      timing = timing == kCAMediaTimingFunctionEaseIn ? kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn;
      hidden = !hidden
      delay += durations[index]
    }
    
    let firstItemView = animationView.subviews.filter{$0.tag == 0}.first
    
    firstItemView?.layer.masksToBounds = true
    DispatchQueue.main.asyncAfter(deadline: .now() + durations[0], execute: {
      firstItemView?.layer.cornerRadius = 0
    })
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
      self.animationView?.alpha = 0
      self.containerView.alpha  = 1
      completion?()
    })
  }
  
  func closeAnimation(_ completion: ((Void) -> Void)?) {
    
    removeImageItemsFromAnimationView()
    addImageItemsToAnimationView()
    
    guard let animationItemViews = self.animationItemViews else {
      fatalError()
    }
    
    animationView?.alpha = 1;
    containerView.alpha  = 0;
    
    var durations: [TimeInterval] = durationSequence(.close).reversed()
    
    var delay: TimeInterval = 0
    var timing                = kCAMediaTimingFunctionEaseIn
    var from: CGFloat         = 0.0;
    var to: CGFloat           = CGFloat(M_PI / 2)
    var hidden                = true
    configureAnimationItems(.close)
    
    if durations.count < animationItemViews.count {
      fatalError("wrong override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval")
    }
    for index in 0..<animationItemViews.count {
      let animatedView = animationItemViews.reversed()[index]
      
      animatedView.foldingAnimation(timing, from: from, to: to, duration: durations[index], delay: delay, hidden: hidden)
      
      to     = to == 0.0 ? CGFloat(M_PI / 2) : 0.0;
      from   = from == 0.0 ? CGFloat(-M_PI / 2) : 0.0;
      timing = timing == kCAMediaTimingFunctionEaseIn ? kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn;
      hidden = !hidden
      delay += durations[index]
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
      self.animationView?.alpha = 0
      completion?()
    })
    
    let firstItemView = animationView?.subviews.filter{$0.tag == 0}.first
    firstItemView?.layer.cornerRadius = 0
    firstItemView?.layer.masksToBounds = true
    if let durationFirst = durations.first {
      DispatchQueue.main.asyncAfter(deadline: .now() + delay - durationFirst * 2, execute: {
        firstItemView?.layer.cornerRadius = self.foregroundView.layer.cornerRadius
        firstItemView?.setNeedsDisplay()
        firstItemView?.setNeedsLayout()
      })
    }
  }
}


// MARK: RotatedView
open class RotatedView: UIView {
  var hiddenAfterAnimation = false
  var backView: RotatedView?
  
  func addBackView(_ height: CGFloat, color:UIColor) {
    let view                                       = RotatedView(frame: CGRect.zero)
    view.backgroundColor                           = color
    view.layer.anchorPoint                         = CGPoint.init(x: 0.5, y: 1)
    view.layer.transform                           = view.transform3d()
    view.translatesAutoresizingMaskIntoConstraints = false;
    self.addSubview(view)
    backView = view
    
    view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil,attribute: .height,
      multiplier: 1, constant: height))
    
    self.addConstraints([
      NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1,
        constant: self.bounds.size.height - height + height / 2),
      NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading,
        multiplier: 1, constant: 0),
      NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing,
        multiplier: 1, constant: 0)
      ])
  }
}


extension RotatedView: CAAnimationDelegate {
  
  func rotatedX(_ angle : CGFloat) {
    var allTransofrom    = CATransform3DIdentity;
    let rotateTransform  = CATransform3DMakeRotation(angle, 1, 0, 0)
    allTransofrom        = CATransform3DConcat(allTransofrom, rotateTransform)
    allTransofrom        = CATransform3DConcat(allTransofrom, transform3d())
    self.layer.transform = allTransofrom
  }
  
  func transform3d() -> CATransform3D {
    var transform = CATransform3DIdentity
    transform.m34 = 2.5 / -2000;
    return transform
  }
  
  // MARK: animations
  func foldingAnimation(_ timing: String, from: CGFloat, to: CGFloat, duration: TimeInterval, delay:TimeInterval, hidden:Bool) {
    
    let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
    rotateAnimation.timingFunction      = CAMediaTimingFunction(name: timing)
    rotateAnimation.fromValue           = (from)
    rotateAnimation.toValue             = (to)
    rotateAnimation.duration            = duration
    rotateAnimation.delegate            = self;
    rotateAnimation.fillMode            = kCAFillModeForwards
    rotateAnimation.isRemovedOnCompletion = false;
    rotateAnimation.beginTime           = CACurrentMediaTime() + delay
    
    self.hiddenAfterAnimation = hidden
    
    self.layer.add(rotateAnimation, forKey: "rotation.x")
  }
  
  public func animationDidStart(_ anim: CAAnimation) {
    self.layer.shouldRasterize = true
    self.alpha = 1
  }
  
  public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if hiddenAfterAnimation {
      self.alpha = 0
    }
    self.layer.removeAllAnimations()
    self.layer.shouldRasterize = false
    self.rotatedX(CGFloat(0))
  }
}

extension UIView {
  func pb_takeSnapshot(_ frame: CGRect) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
    
    let context = UIGraphicsGetCurrentContext();
    context!.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)
    
    guard let currentContext = UIGraphicsGetCurrentContext() else {
      return nil
    }
    
    self.layer.render(in: currentContext)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }
}
