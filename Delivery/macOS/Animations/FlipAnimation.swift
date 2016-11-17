//
//  Flip.swift
//  Jirassic
//
//  Created by Baluta Cristian on 24/05/15.
//  Copyright (c) 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class FlipAnimation: NSObject {

	var animationReachedMiddle: (() -> ())?
	var animationFinished: (() -> ())?
	var layer: CALayer?
	
	func startWithLayer (_ layer: CALayer) {
		
		// Create CAAnimation
		let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
		rotationAnimation.fromValue = 0.0
		rotationAnimation.toValue = 3.14/2
		rotationAnimation.duration = 0.2
		rotationAnimation.repeatCount = 1.0
		rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
		rotationAnimation.fillMode = kCAFillModeForwards
		rotationAnimation.isRemovedOnCompletion = false
		rotationAnimation.setValue("flipAnimationInwards", forKey: "flip")
		rotationAnimation.delegate = self
		
		// Add perspective
		var mt = CATransform3DIdentity
		mt.m34 = CGFloat(1.0 / 1000)
		layer.transform = mt
		layer.add(rotationAnimation, forKey:"flip")
		self.layer = layer
	}
	
	func animatePhase2 (_ anim: CAAnimation!) {
		
		let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
		rotationAnimation.fromValue = -3.14/2
		rotationAnimation.toValue = 0.0
		rotationAnimation.duration = 0.2
		rotationAnimation.repeatCount = 1.0
		rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
		rotationAnimation.fillMode = kCAFillModeForwards
		rotationAnimation.isRemovedOnCompletion = false
		rotationAnimation.setValue("flipAnimationOutwards", forKey: "flip")
		rotationAnimation.delegate = self
		
		// Add perspective
		var mt = CATransform3DIdentity
		mt.m34 = CGFloat(1.0 / 1000)
		self.layer?.transform = mt
		self.layer?.add(rotationAnimation, forKey:"flip")
	}
}

extension FlipAnimation: CAAnimationDelegate {
    
    func animationDidStop (_ anim: CAAnimation, finished flag: Bool) {
        
        if anim.value(forKey: "flip") as! String == "flipAnimationInwards" {
            
            self.animationReachedMiddle!()
            self.animatePhase2(anim)
        }
        else if anim.value(forKey: "flip") as! String == "flipAnimationOutwards" {
            self.animationFinished!()
        }
    }
}