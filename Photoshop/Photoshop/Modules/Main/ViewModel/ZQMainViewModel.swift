//
//  ZQMainViewModel.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/12/10.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit

class ZQMainViewModel: ZQBasePhotoPickerViewModel {
    /// 加载数据
    func loadData(successBlock:ZQSuccessBlock) {
        let dic = ZQTool.getJsonDic(forResource: "main_func_data", ofType: "json")
        guard let data = dic?["data"] as? [String:Any] else {return}
        guard let arr = data["items"] as? [[String:Any]] else {
            return
        }
        let dataSource = [ZQMainModel].deserialize(from: arr)
        guard let dataSourceArr = dataSource as? [ZQMainModel] else {return}
        successBlock(dataSourceArr)
    }
}
