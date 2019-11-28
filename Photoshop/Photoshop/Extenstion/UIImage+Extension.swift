//
//  UIImage+extension.swift
//  WXImageShareTool
//
//  Created by cocoawork on 2018/4/10.
//  Copyright © 2018年 cocoawork. All rights reserved.
//

import UIKit


extension UIImage {

    public enum DividePolicy: Int {
        case none
        case twice
        case thrice
        case four
    }

    /// 裁剪多少格
    public func divide(policy: UIImage.DividePolicy) -> [UIImage]? {
        let totalSize = CGSize(width: self.size.width * self.scale, height: self.size.height * self.scale)
        var divideSize = totalSize
        switch policy {
        case .twice:
            divideSize = CGSize(width: totalSize.width / 2, height: totalSize.height / 2)
        case .thrice:
            divideSize = CGSize(width: totalSize.width / 3, height: totalSize.height / 3)
        case .four:
            divideSize = CGSize(width: totalSize.width / 4, height: totalSize.height / 4)
        case .none:
            divideSize = CGSize(width: totalSize.width, height: totalSize.height)
        }
        
        var times: Double = 0
        var images: [UIImage] = []
        if policy == .none {
            times = 0
            images.append(self)
        }else if policy == .twice { // 2X2
            times = 4
        }else if policy == .thrice { //3X3
            times = 9
        }else if policy == .four {  //4X4
            times = 16
        }

       
        for i in 0..<Int(sqrt(times)) {
            for j in 0..<Int(sqrt(times)) {
                let rect = CGRect(x: CGFloat(j) * divideSize.width, y: CGFloat(i) * divideSize.height, width: divideSize.width, height: divideSize.height)
                if let divideImage = self.divide(rect: rect) {
                    images.append(divideImage)
                }
            }
        }

        return images.count == 0 ? nil : images
    }

    /// 分割区域图片
    private func divide(rect: CGRect) -> UIImage? {
        if let sourceImageRef: CGImage = self.cgImage {
            let newCGImage = sourceImageRef.cropping(to: rect)
            return UIImage(cgImage: newCGImage!)
        } else {
            return nil
        }
    }

    /// 压缩
    func zip() -> UIImage {
        let data = UIImageJPEGRepresentation(self, 0.5)
        return UIImage(data: data!)!
    }

    /// 获取大小
    func getDataSize() -> Int {
        let data = UIImageJPEGRepresentation(self, 1.0)
//        let data = UIImagePNGRepresentation(self)
        DLog("\((data?.count)! / 1024)KB")
        return (data?.count)! / 1024
    }

    /// 压缩图片限制多少k
    func resize(maxSize: Int) -> UIImage? {
        let size = self.getDataSize()
        let time = CGFloat(size) / CGFloat(maxSize)
        let zip = CGFloat(1) / time
        let data = UIImageJPEGRepresentation(self, zip)
        return UIImage(data: data!)
    }
    
    
//    /// 将多张图合成一张图，按照九宫格的方式
//    func mergedImgsToImg(imgs:[UIImage],gap:CGFloat) -> UIImage?{
//        var img:UIImage? = nil
//        
//        return img
//    }
    
    
    /// 保存图片
    func saveToPhoto() {
        UIImageWriteToSavedPhotosAlbum(self, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    /// 纠正图片方向
    func fixOrientation() -> UIImage? {
        if imageOrientation == .up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, _: false, _: scale)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let normalizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }

    func maskImage(maskColor: UIColor?) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, _: false, _: 0)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: rect.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        if let cgImagee = cgImage {
            context?.clip(to: rect, mask: cgImagee)
        }
        if let cgColorr = maskColor?.cgColor {
            context?.setFillColor(cgColorr)
        }
        context?.fill(rect)
        let smallImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return smallImage
    }
    
    // MARK: - Action
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil {
            
        }else{
            
        }
    }

}
