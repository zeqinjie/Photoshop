//
//  ZQZQMappable.swift
//  ZQNews
//
//  Created by zhengzeqin on 2018/9/27.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import Foundation
//public typealias Codable = Decodable & Encodable
fileprivate enum ZQMapError: Error {
    case JsonToModelFail    //json转model失败
    case JsonToDataFail     //json转data失败
    case DictToJsonFail     //字典转json失败
    case JsonToArrFail      //json转数组失败
    case ModelToJsonFail    //model转json失败
}

protocol ZQMappable: Codable {
    func modelMapFinished()
    mutating func structMapFinished()
}

extension ZQMappable {
    
    func modelMapFinished() {}
    
    mutating func structMapFinished() {}
    
    //模型转字典
    func reflectToDict() -> [String:Any] {
        let mirro = Mirror(reflecting: self)
        var dict = [String:Any]()
        for case let (key?, value) in mirro.children {
            dict[key] = value
        }
        return dict
    }
    
    
    //字典转模型
    static func mapFromDict<T : ZQMappable>(_ dict : [String:Any], _ type:T.Type) throws -> T {
        guard let JSONString = dict.toJSONString() else {
            print(ZQMapError.DictToJsonFail)
            throw ZQMapError.DictToJsonFail
        }
        guard let jsonData = JSONString.data(using: .utf8) else {
            print(ZQMapError.JsonToDataFail)
            throw ZQMapError.JsonToDataFail
        }
        let decoder = JSONDecoder()
        
        if let obj = try? decoder.decode(type, from: jsonData) {
            var vobj = obj
            let mirro = Mirror(reflecting: vobj)
            if mirro.displayStyle == Mirror.DisplayStyle.struct {
                vobj.structMapFinished()
            }
            if mirro.displayStyle == Mirror.DisplayStyle.class {
                vobj.modelMapFinished()
            }
            return vobj
        }
        print(ZQMapError.JsonToModelFail)
        throw ZQMapError.JsonToModelFail
    }
    
    
    //JSON转模型
    static func mapFromJson<T : ZQMappable>(_ JSONString : String, _ type:T.Type) throws -> T {
        guard let jsonData = JSONString.data(using: .utf8) else {
            print(ZQMapError.JsonToDataFail)
            throw ZQMapError.JsonToDataFail
        }
        let decoder = JSONDecoder()
        if let obj = try? decoder.decode(type, from: jsonData) {
            return obj
        }
        print(ZQMapError.JsonToModelFail)
        throw ZQMapError.JsonToModelFail
    }
    
    
    //模型转json字符串
    func toJSONString() throws -> String {
        if let str = self.reflectToDict().toJSONString() {
            return str
        }
        print(ZQMapError.ModelToJsonFail)
        throw ZQMapError.ModelToJsonFail
    }
}


extension Array {
    
    func toJSONString() -> String? {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("dict转json失败")
            return nil
        }
        if let newData : Data = try? JSONSerialization.data(withJSONObject: self, options: []) {
            let JSONString = NSString(data:newData as Data,encoding: String.Encoding.utf8.rawValue)
            return JSONString as String? ?? nil
        }
        print("dict转json失败")
        return nil
    }
    
    func mapFromJson<T : Decodable>(_ type:[T].Type) throws -> Array<T> {
        guard let JSONString = self.toJSONString() else {
            print(ZQMapError.DictToJsonFail)
            throw ZQMapError.DictToJsonFail
        }
        guard let jsonData = JSONString.data(using: .utf8) else {
            print(ZQMapError.JsonToDataFail)
            throw ZQMapError.JsonToDataFail
        }
        let decoder = JSONDecoder()
        if let obj = try? decoder.decode(type, from: jsonData) {
            return obj
        }
        print(ZQMapError.JsonToArrFail)
        throw ZQMapError.JsonToArrFail
    }
}


extension Dictionary {
    func toJSONString() -> String? {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("dict转json失败")
            return nil
        }
        if let newData : Data = try? JSONSerialization.data(withJSONObject: self, options: []) {
            let JSONString = NSString(data:newData as Data,encoding: String.Encoding.utf8.rawValue)
            return JSONString as String? ?? nil
        }
        print("dict转json失败")
        return nil
    }
}


extension String {
    func toDict() -> [String:Any]? {
        guard let jsonData:Data = self.data(using: .utf8) else {
            print("json转dict失败")
            return nil
        }
        if let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
            return dict as? [String : Any] ?? ["":""]
        }
        print("json转dict失败")
        return nil
    }
}


