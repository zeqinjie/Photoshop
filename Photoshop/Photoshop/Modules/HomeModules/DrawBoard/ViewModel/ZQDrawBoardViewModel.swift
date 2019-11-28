//
//  ZQDrawBoardViewModel.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/12/18.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit

class ZQDrawBoardViewModel: ZQBasePhotoPickerViewModel {

    func loadData(successBlock:ZQSuccessBlock) {
        let dic = ZQTool.getJsonDic(forResource: "draw_data", ofType: "json")
        guard let data = dic?["data"] as? [String:Any] else {return}
        guard let arr = data["items"] as? [[String:Any]] else {
            return
        }
        let dataSource = [ZQDrawModel].deserialize(from: arr)
        guard let dataSourceArr = dataSource as? [ZQDrawModel] else {return}
        successBlock(dealData(dataSourceArr: dataSourceArr))
    }
    
    func dealData(dataSourceArr:[ZQDrawModel]) -> [String:Any] {
        var dic = [String:Any]()
        var photos = [UIImage]()
        var titles = [String]()
        for model in dataSourceArr {
            if let photo = UIImage(named: model.photo) {
                photos.append(photo)
                titles.append(model.title)
            }
        }
        dic["photos"] = photos
        dic["titles"] = titles
        dic["dataSource"] = dataSourceArr
        return dic
    }
}
