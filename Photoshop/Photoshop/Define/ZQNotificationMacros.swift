//
//  ZQNotificationMacros.swift
//  house591
//
//  Created by zhengzeqin on 2018/8/2.
//

import Foundation
import UIKit

// MARK:Method

/// 通知初始化
func ZQNoticeCenter(_ observer: Any, method: Selector, noticeName: String, obj: Any?)  {
    NotificationCenter.default.addObserver(observer, selector: method, name: NSNotification.Name(rawValue:noticeName), object: obj)
}

/// 删除通知
func ZQClearNoticeCenter(_ observer: Any,noticeName: String,obj: Any?) {
    NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue:noticeName), object: obj)
}

/// 发送通知  dic 默认 nil
func ZQPostNoticeCenter(_ name: String, obj: Any?, dic: [AnyHashable : Any]? = nil) {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue:name), object: obj, userInfo: dic)
}

/// 移除通知
func ZQNotificationCenterRemove(_ observer: Any){
    NotificationCenter.default.removeObserver(observer)
}

/// 取消滤镜选择
let ZQFilterUnSelectNotification = "ZQResetFilterUnSelectNotification"

/// 清空滤镜值
let ZQResetFiterValueNotification = "ZQResetFiterValueNotification"
