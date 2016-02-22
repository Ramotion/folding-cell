//
//  RotatedView.swift
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

public class RotatedView: UIView {
	
	var hiddenAfterAnimation = false
	var backView: RotatedView?
	
	func addBackView(height: CGFloat, color:UIColor) {
		
		let view                                       = RotatedView(frame: CGRect.zero)
		view.backgroundColor                           = color
		view.layer.anchorPoint                         = CGPoint.init(x: 0.5, y: 1)
		view.layer.transform                           = view.transform3d()
		view.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(view)
		backView = view
		
		view.addConstraint(NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil,attribute: .Height,
			multiplier: 1, constant: height))
		
		self.addConstraints([
			NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1,
				constant: self.bounds.size.height - height + height / 2),
			NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading,
				multiplier: 1, constant: 0),
			NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing,
				multiplier: 1, constant: 0)
			])
	}
	
	func rotatedX(angle : CGFloat) {
		
		var allTransofrom    = CATransform3DIdentity;
		let rotateTransform  = CATransform3DMakeRotation(angle, 1, 0, 0)
		allTransofrom        = CATransform3DConcat(allTransofrom, rotateTransform)
		allTransofrom        = CATransform3DConcat(allTransofrom, transform3d())
		layer.transform = allTransofrom
	}
	
	func transform3d() -> CATransform3D {
		
		var transform = CATransform3DIdentity
		transform.m34 = 2.5 / -2000
		
		return transform
	}
	
	// MARK: animations
	
	func foldingAnimation(timing: String, from: CGFloat, to: CGFloat, duration: NSTimeInterval, delay:NSTimeInterval, hidden:Bool) {
		
		let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
		rotateAnimation.timingFunction      = CAMediaTimingFunction(name: timing)
		rotateAnimation.fromValue           = (from)
		rotateAnimation.toValue             = (to)
		rotateAnimation.duration            = duration
		rotateAnimation.delegate            = self;
		rotateAnimation.fillMode            = kCAFillModeForwards
		rotateAnimation.removedOnCompletion = false;
		rotateAnimation.beginTime           = CACurrentMediaTime() + delay
		
		self.hiddenAfterAnimation = hidden
		
		self.layer.addAnimation(rotateAnimation, forKey: "rotation.x")
	}
	
	override public func animationDidStart(anim: CAAnimation) {
		
		layer.shouldRasterize = true
		alpha = 1
	}
	
	override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		
		if hiddenAfterAnimation {
			
			alpha = 0
		}
		
		layer.removeAllAnimations()
		layer.shouldRasterize = false
		rotatedX(CGFloat(0))
	}
}
