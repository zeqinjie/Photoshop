//
//  UIView+Extension.swift
//  WXImageShareTool
//
//  Created by cocoawork on 2018/4/11.
//  Copyright © 2018年 cocoawork. All rights reserved.
//

import UIKit

extension UIView {
    
    private struct ZQAnimation {
        static var tKey = "zqAnimation"
    }
    /// 是否隐藏导航栏
    @objc public var zqAnimation: CABasicAnimation?{
        get { return objc_getAssociatedObject(self, &ZQAnimation.tKey) as? CABasicAnimation }
        set { objc_setAssociatedObject(self, &ZQAnimation.tKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public func snapShot(_ watermark: String) -> UIImage? {
        guard frame.size.height > 0 && frame.size.width > 0 else { return nil }
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        //绘制水印
        let text: NSString = NSString(string: watermark)
        let attr = [NSAttributedStringKey.foregroundColor: UIColor.init(white: 0.6, alpha: 0.6), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)]
        let size = text.size(withAttributes: attr)
        let rect = CGRect(x: self.frame.width - size.width - 5, y: self.frame.height - size.height - 5, width: size.width, height: size.height)
        text.draw(in: rect, withAttributes: attr)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    public func opacityAnimation(){
        if let zqAnimation = self.zqAnimation {
            self.layer.add(zqAnimation, forKey: "opacity")
        }else{
            self.zqAnimation = ZQCustomAnimation.opacityView(0.2,1)
            guard let zqAnimation = self.zqAnimation else {return}
            self.layer.add(zqAnimation, forKey: "opacity")
        }
    }

}
