//
//  NSObject+Extension.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/10/31.
//  Copyright © 2018 zhengzeqin. All rights reserved.
//
import Foundation
extension NSObject {
    // create a static method to get a swift class for a string name
    func swiftClassFromString(_ className: String) -> AnyClass? {
        if  let appName = ez.appDisplayName {
            let classStringName = appName+"."+className
            return NSClassFromString(classStringName)
        }
        return nil;
    }
    
    func isKindClass(of aClass: AnyClass?) -> Bool {
        if let aClass = aClass {
            return self.isKind(of: aClass)
        }
        return false
    }
}
