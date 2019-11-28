//
//  ZQHomeBottomItemModel.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/10/18.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit


class ZQHomeBottomModel: BaseModel {
    
    // section 值
    var section:Int = 0
    var index:Int = 0
    var value:CGFloat = 0.0
    var photo:String = ""
    var selPhoto:String = ""
    var title:String = ""
    var backColor:String?
    var titleColor:String?
    var filterColor:String? // 滤镜颜色
    var efficiencyType:String = "original" //类型
    var efficiencyImage:UIImage?
    weak var originEfficiencyImage:UIImage?
    weak var cell:ZQHomeItemColCell?
    var indexPath:IndexPath?
    var isSel = false
    var items = [ZQHomeBottomModel]()
    
    // bug
    func modifyEfficiency(image:UIImage){
        ZQFilterTool.deleteFilterCache()
        ZQFilterTool.share.filterImage(image, filterType: self.efficiencyType) { [weak self] (pic,origin) in
            self?.efficiencyImage = pic
            self?.originEfficiencyImage = origin
        }
    }

}
