//
//  BaseViewModel.swift
//  ZQNews
//
//  Created by zhengzeqin on 2018/9/25.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit
import HandyJSON
class BaseViewModel: NSObject {
//    let netWorkTool = ZQNetWorkTool.shared
    typealias ZQSuccessBlock = (_ result:Any?) -> Void
    typealias ZQFailBlock = (_ errorMsg: String?) -> Void
    typealias UpDataBlock = () ->Void
    var updataBlock:UpDataBlock?
}
