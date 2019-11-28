//
//  ZQCommonHeader.swift
//  house591
//
//  Created by xiwu on 2017/7/21.
//
//

import Foundation
import UIKit


// MARK: ----- 通用-----
// 设备信息
/// 当前app信息
let ZQAppInfo = Bundle.main.infoDictionary
///// 当前app版本号
let ZQCurrentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

///// 获取设备系统号
let ZQGetSystemVersion = UIDevice.current.systemVersion

////当前版本号
//let ZQVersionNum =  HouseTool.getTWConfigure(forKey: "version_num");
//
//let ZQCurrentVersionNum = ZQCurrentVersion + "." + ZQVersionNum!


//请求时长
let ZQRequestTimeCountOut : Int = 120

/******** 尺寸信息 ************/

/// 全屏
let ZQScreen = UIScreen.main.bounds
/// 全屏宽度
let ZQScreenWidth = UIScreen.main.bounds.width
/// 全屏高度，不含状态栏高度
let ZQScreenHeight = UIScreen.main.bounds.height

/// tabbar切换视图控制器高度
let ZQTabbarHeight : CGFloat = 49.0
/// 搜索视图高度
let ZQSearchBarHeight : CGFloat = 45.0

/// 状态栏高度
var ZQStatusBarHeight : CGFloat  {
    get {
        if ZQIsIhoneX() {
            return 44.0
        }else{
            return 20.0
        }
    }
}

//tabbar高度
var ZQTabBarHeight : CGFloat  {
    get {
        if ZQIsIhoneX() {
            return 83.0
        }else{
            return 49.0
        }
    }
}
/// 导航栏高度
let ZQNavigationHeigth : CGFloat = 44.0

/// 状态栏 + 导航栏高度
let ZQStatusAndNavigationHeigth = ZQNavigationHeigth + ZQStatusBarHeight

///IPhoneX 头部
var ZQIPhoneXTopHeigth : CGFloat  {
    get {
        if ZQIsIhoneX() {
            return 30.0
        }else{
            return 0.0
        }
    }
}

///IPhoneX 底部留白
var ZQIPhoneXBottomHeigth : CGFloat  {
    get {
        if ZQIsIhoneX() {
            return 34.0
        }else{
            return 0.0
        }
    }
}

public func ZQIsIhoneX() -> Bool {
    //896
    let height = UIScreen.main.bounds.height
    if height == 812 || height == 896 {
        return true
    }
    return false
    
    //    let isIPhoneX = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1125, height: 2436), (UIScreen.main.currentMode?.size)!) : false)
    //    return isIPhoneX
}

///文字提示
let ZQNoNetMsg  = "無網絡連接,請檢查網絡設置"


///house591AppDelegate
let ZQDelegateApp  = (UIApplication.shared.delegate )


/// 打印日志
///
/// - Parameter str: 内容
func DLog(_ str: String) {
    #if DEBUG
    //    print("file: \(#file), line:\(#line),\(str)")
    print("DLOG:\(str)")
    #endif
}

/// 设置字体大小
func ZQSYSFontSize(_ size: CGFloat)->UIFont{
    return UIFont.systemFont(ofSize: size)
}

/// 设置粗体大小
func ZQBoldFontSize(_ size: CGFloat)->UIFont{
    return UIFont.boldSystemFont(ofSize: size)
}


// MARK: ----- GuardValue-----
/*************数据处理*************/

/// 处理数据Number 或者 String统一返回String
///
/// - Parameter str: 接收string 或者 number类型
/// - Returns: 返回结果String
func ZQGuardValueString(_ str:Any?) -> String {
    var result = ""
    if str is String {
        result = str as! String
    }else if(str is NSNumber){
        let number:NSNumber = str as! NSNumber
        result = number.stringValue
    }
    return result
}

/// 处理数据Number 或者 String统一返回number
func ZQGuardValueNumber(_ number:Any?) -> NSNumber {
    var result:NSNumber = 0
    if number is NSNumber {
        result = number as! NSNumber
    }else if(number is String){
        let str:String = number as! String
        guard let re = NumberFormatter().number(from: str) else  { return result }
        result = re
    }
    return result
}

///  字符串 1 或者 number 1时候转bool true
///
/// - Parameter str: 接收string 或者 number类型
/// - Returns: 返回结果bool
func ZQStringToBool(_ str:Any?) -> Bool{
    var result = false
    let string = ZQGuardValueString(str)
    if string == "1" {
        result = true
    }
    return result
}


/// 保证字符串类型，非字符串类型则返回空字符串
func ZQGuardNullString(_ str:Any?) -> String{
    let result = ""
    guard let string = str as? String else {return result}
    return string
}


/// 保证数组类型，非数组类型则返回nil
func ZQGuardNullArray(_ arr:Any?) -> Array<Any>?{
    guard let array = arr as? Array<Any> else {return nil}
    return array
}

/// 保证字典类型，非数组类型则返回nil
func ZQGuardNullDictionary(_ dic:Any?) -> Dictionary<AnyHashable, Any>?{
    guard let dictionary = dic as? Dictionary<AnyHashable, Any> else {return nil}
    return dictionary
}

