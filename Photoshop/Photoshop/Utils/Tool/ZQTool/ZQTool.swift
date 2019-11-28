//
//  ZQTool.swift
//  ZQNews
//
//  Created by zhengzeqin on 2018/9/20.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit
import KeychainAccess
import SwiftyJSON
//import AssetsLibrary
import AVFoundation
import Photos
class ZQTool: NSObject {
    
    
    // MARK: - Device
    /// 用户唯一uuid
    class func uniqueUUIDCode() -> String {
        let key = "uniqueUUIDCode"
        var uniqueUUIDCode = ""
        let keychain = Keychain(accessGroup: "com.ZQNews")
        let uuid = keychain[string: key]
        if let uuid = uuid {
            uniqueUUIDCode = uuid
        }else {
            keychain[string: key] = uuidDevice()
            uniqueUUIDCode = uuidDevice()
        }
        return uniqueUUIDCode
    }
    
    
    /// 设备uuid
    class func uuidDevice() -> String {
        var uuidString = UIDevice.current.identifierForVendor?.uuidString
        uuidString = uuidString?.replacingOccurrences(of: "-", with: "")
        guard let uuid = uuidString else { return "" }
        return uuid
    }
    
    
    // MARK: - instantiateVC
    /// 通過storyboardName 獲取 vc
    class func instantiateVC<T>(_ storyboardName:String,_ identifier: T.Type) -> T? {
        let storyboardID = String(describing: identifier)
        let storyBoard = UIStoryboard(name: storyboardName, bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: storyboardID) as? T {
            return vc
        } else {
            return nil
        }
        
    }
    
    // MARK: - json
    /// 通过json文件目录得到 字典
    class func getJsonDic(forResource:String,ofType:String) -> [String:Any]? {
        let dic:[String:Any]? = nil
        let jsonPath = Bundle.main.url(forResource: forResource, withExtension: ofType)
        guard let jsonPathUrl = jsonPath else {return dic}
        do {
            let data = try Data(contentsOf: jsonPathUrl)
            return getJsonDicFromData(data: data)
        }catch{
            DLog("getJsonDic fail")
            return dic
        }
    }
    
    /// JsonStr ==> Dictionary
    class func getJsonDicFromJsonStr(jsonString:String) -> [String:Any]? {
        guard let jsonData:Data = jsonString.data(using: .utf8) else {
            return nil
        }
        return getJsonDicFromData(data: jsonData)
    }
    
    /// Dictionary ==> JsonStr
    class func getJsonStrFromJsonDic(jsonDic:[String:Any]) -> String?{
        if (!JSONSerialization.isValidJSONObject(jsonDic)) {return nil}
        let data = getJsonDataFromJsonDic(jsonDic: jsonDic)
        guard let jsonData = data else {return nil}
        return String(data:jsonData,encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
    }
    
    /// Dictionary ==> Data
    class func getJsonDataFromJsonDic(jsonDic:[String:Any]) -> Data? {
        if (!JSONSerialization.isValidJSONObject(jsonDic)) {
            return nil
        }
        let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
        let str = String(data:data!, encoding: String.Encoding.utf8)
        DLog("JsonStr = \(String(describing: str))")
        return data
    }
    
    /// Data ==> Dictionary
    class func getJsonDicFromData(data:Data) ->[String:Any]?{
        let dic:[String:Any]? = nil
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            guard let result = json as? [String:Any] else {
                DLog("dictionaryObject fail")
                return dic
            }
            return result
        }catch {
            DLog("getJsonDicFromData 失败")
            return dic
        }
    }
    
    // MARK: - Color
    class func colorToHexStr(by color: UIColor) -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a);
        let rgb = Int(r * 255.0) << 16 | Int(g * 255.0) << 8 | Int(b * 255.0) << 0
        return String(format: "%06x", rgb)
    }
    
    
    // MARK: - swizzledMethod
    /// 方法交换
    public class func swizzledMethod(cls:AnyClass,originalSelector:Selector,swizzledSelector:Selector){
        
        let originalMethod = class_getInstanceMethod(cls, originalSelector)
        let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
        
        //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
        let didAddMethod: Bool = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        
        if didAddMethod {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
        
    }
    
    // MARK: - openURLStr
    /// 跳转
    class func openURLStr(_ urlStr: String?) {
        if let aStr = URL(string: urlStr ?? "") {
            UIApplication.shared.openURL(aStr)
        }
    }

    class func openSetUrl(){
        openURLStr(UIApplicationOpenSettingsURLString)
    }
    
    
    // MARK: - Camera
    class func isAuthorizeCamera() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return authStatus != .restricted && authStatus != .denied
    }
    
    class func isAuthorizePhoto() -> Bool {
        var authStatus: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
//        let authStatus = ALAssetsLibrary.authorizationStatus()
        return authStatus != .restricted && authStatus != .denied
    }
    
    // MARK: - dispatch
    class func dispatch(afterTime second: TimeInterval, block: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(second * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: block)
    }
    
    class func asyncMainQueueBlock(_ block: @escaping () -> ()) {
        DispatchQueue.main.async(execute: block)
    }
    
    class func asyncGlobalQueueBlock(_ block: @escaping () -> ()) {
        DispatchQueue.global(qos: .default).async(execute: block)
    }
    
    
    // MARK: - compressImage
    class func compressImageQuality(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = UIImageJPEGRepresentation(image, compression),
            data.count > maxLength else { return image }
        print("Before compressing quality, image size =", data.count / 1024, "KB")
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = UIImageJPEGRepresentation(image, compression)!
            print("Compression =", compression)
            print("In compressing quality loop, image size =", data.count / 1024, "KB")
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        print("After compressing quality, image size =", data.count / 1024, "KB")
        return UIImage(data: data)!
    }
    
    class func compressImageSize(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        guard var data = UIImageJPEGRepresentation(image, 1) else { return image }
        print("Before compressing size, image size =", data.count / 1024, "KB")
        
        var resultImage: UIImage = image
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            print("Ratio =", ratio)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = UIImageJPEGRepresentation(resultImage, 1)!
            print("In compressing size loop, image size =", data.count / 1024, "KB")
        }
        print("After compressing size loop, image size =", data.count / 1024, "KB")
        return resultImage
    }
    
    class func compressImage(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = UIImageJPEGRepresentation(image, compression),
            data.count > maxLength else { return image }
        print("Before compressing quality, image size =", data.count / 1024, "KB")
        
        // Compress by size
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = UIImageJPEGRepresentation(image, compression)!
            print("Compression =", compression)
            print("In compressing quality loop, image size =", data.count / 1024, "KB")
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        print("After compressing quality, image size =", data.count / 1024, "KB")
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < maxLength { return resultImage }
        
        // Compress by size
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            print("Ratio =", ratio)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = UIImageJPEGRepresentation(resultImage, compression)!
            print("In compressing size loop, image size =", data.count / 1024, "KB")
        }
        print("After compressing size loop, image size =", data.count / 1024, "KB")
        return resultImage
    }
}
