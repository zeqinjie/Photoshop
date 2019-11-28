//
//  UserInfoModel.swift
//  ZQNews
//
//  Created by zhengzeqin on 2018/9/25.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit

class GlobalObject: BaseModel {
    static let _share = GlobalObject()
    let mobile_id = ZQTool.uniqueUUIDCode()
    
    
    class func share() -> GlobalObject{
        return _share
    }
}
