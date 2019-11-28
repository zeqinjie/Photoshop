//
//  ZQCustomAnimation.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/11/3.
//  Copyright © 2018 zhengzeqin. All rights reserved.
//

import UIKit

class ZQCustomAnimation: NSObject {
    class func shakeAnimation()->CAKeyframeAnimation {
        let shakeAnimation = CAKeyframeAnimation()
        shakeAnimation.keyPath = "position.x"
        shakeAnimation.values = [0, 10, -10, 10, -10, 10, 0]
        shakeAnimation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        shakeAnimation.duration = 0.5
        shakeAnimation.isAdditive = true
        return shakeAnimation
    }
    
    class func shrinkView(_ view: UIView?, druation time: TimeInterval, scaleValue: CGFloat) {
        view?.transform = CGAffineTransform(scaleX: scaleValue, y: scaleValue)
        UIView.animate(withDuration: time, animations: {
            view?.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    class func opacityView(_ time: Float,_ repeatCount:Int)->CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0 //这是透明度。
        animation.autoreverses = true
        animation.duration = CFTimeInterval(time)
        animation.isRemovedOnCompletion = false
        animation.repeatCount = 1
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        return animation
    }

}
