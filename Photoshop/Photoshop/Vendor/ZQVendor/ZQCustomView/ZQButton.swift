//
//  ZQButton.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/12/13.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit

public enum ZQButtonType:Int{
    case `default`
    case back
    case crame
    case save
    case resetAll
    case share
}
class ZQButton: UIButton {
    var btnType:ZQButtonType = .default
}
