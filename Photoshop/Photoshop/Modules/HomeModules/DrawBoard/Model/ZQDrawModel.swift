//
//  ZQDrawModel.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/12/18.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit

class ZQDrawModel: BaseModel {
    var photo:String = ""
    var title:String = ""
    var type:String = ""
}



class ZQDrawBoardModel: BaseModel {
    var type = 0
    var color = ZQColor_ffffff
    var size:CGFloat = 2
    var alpha:CGFloat = 1
    
}
