//
//  ZQNetWorkTool.swift
//  ZQNews
//
//  Created by zhengzeqin on 2018/9/20.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import Foundation
/*
import Moya
import Result
import SwiftyJSON
import HandyJSON

///成功
typealias ZQSuccessStringBlock = (_ result: String) -> Void
typealias ZQSuccessModelBlock = (_ result: HandyJSON?) -> Void
typealias ZQSuccessArrModelBlock = (_ result:[HandyJSON]?) -> Void
typealias ZQSuccessJSONBlock = (_ result:JSON) -> Void
typealias ZQSuccessBlock = (_ result:Any?) -> Void
/// 失败
typealias ZQFailBlock = (_ errorMsg: String?) -> Void


class ZQNetWorkTool {
    static let shared = ZQNetWorkTool()
    private init(){}
    private let failInfo="数据解析失败"
    
    // MARK: - Public Method
    /// 请求JSON数据
    func requestDataWithTargetJSON<T:TargetType>(target:T,successClosure:@escaping ZQSuccessJSONBlock,failClosure: @escaping ZQFailBlock) {
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target))
        let _ = requestProvider.request(target) {[weak self] (result) -> () in
            switch result{
            case let .success(response):
                do {
                    let mapjson = try response.mapJSON()
                    let json=JSON(mapjson)
                    successClosure(json)
                } catch {
                    failClosure(self?.failInfo)
                }
            case let .failure(error):
                failClosure(error.errorDescription)
            }
        }
    }
    
    /// 请求对象JSON数据
    func requestDataWithTargetModelJSON<T:TargetType,M:HandyJSON>(target:T,model:M.Type,successClosure:@escaping ZQSuccessModelBlock,failClosure: @escaping ZQFailBlock) {
        self.requestDataWithTargetJSON(target: target, successClosure: { (json) in
            DLog("json = \(json)")
            guard let dic = json.dictionaryObject else { return }
            let model = M.deserialize(from: dic)
            successClosure(model)
        }, failClosure: failClosure)
    }
    
    /// 请求数组对象JSON数据
    func requestDataWithTargetArrModelJSON<T:TargetType,M:HandyJSON>(target:T,model:M.Type,successClosure:@escaping ZQSuccessArrModelBlock,failClosure: @escaping ZQFailBlock) {
        self.requestDataWithTargetJSON(target: target, successClosure: {[weak self] (json) in
            DLog("json = \(json)")
            guard let arr = json.arrayObject else { return }
            let models = [M].deserialize(from: arr)
            if let ms = models as? [HandyJSON] {
                successClosure(ms)
            }else{
                failClosure(self?.failInfo)
            }
        }, failClosure: failClosure)
    }
    
   
    
    ///请求String数据
    func requestDataWithTargetString<T:TargetType>(target:T,successClosure:@escaping ZQSuccessStringBlock,failClosure: @escaping ZQFailBlock) {
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target))
        let _=requestProvider.request(target) { (result) -> () in
            switch result{
            case let .success(response):
                do {
                    let str = try response.mapString()
                    successClosure(str)
                } catch {
                    failClosure(self.failInfo)
                }
            case let .failure(error):
                failClosure(error.errorDescription)
            }
            
        }
    }
    
    // MARK: - Private Method
    //设置一个公共请求超时时间
    private func requestTimeoutClosure<T:TargetType>(target:T) -> MoyaProvider<T>.RequestClosure{
        let requestTimeoutClosure = { (endpoint:Endpoint, done: @escaping MoyaProvider<T>.RequestResultClosure) in
            do{
                var request = try endpoint.urlRequest()
                request.timeoutInterval = 120 //设置请求超时时间
                done(.success(request))
            }catch{
                return
            }
        }
        return requestTimeoutClosure
    }
}


*/
