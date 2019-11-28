//
//  UIViewControllerShowHudEx.swift
//  ZQNews
//
//  Created by zhengzeqin on 2018/9/27.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    private struct Hud {
        static var tKey = "Hud"
    }
    /// 是否隐藏导航栏
    @objc public var hud: UIWindow?{
        get { return objc_getAssociatedObject(self, &Hud.tKey) as? UIWindow }
        set { objc_setAssociatedObject(self, &Hud.tKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    
    func showHud() {
        self.hideHud()
        self.hud = SwiftNotice.wait()
    }
    
    func hideHud()  {
        if let hud = self.hud {
            SwiftNotice.hideNotice(hud)
        }
    }
    
    func showHudHint(_ hint:String) {
        self.hideHud()
        self.hud = SwiftNotice.showText(hint)
    }
    
    func hideHudHint(_ hint:String) {
        self.hideHud()
        SwiftNotice.showText(hint, autoClear: true, autoClearTime: 1)
    }
    
    
}

