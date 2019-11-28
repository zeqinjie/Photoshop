//
//  ZQHomeViewModel.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/10/20.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit

class ZQHomeViewModel: ZQBasePhotoPickerViewModel {

    weak var photoView:ZQPhotoView?
    
    // MARK: - API
    /// 加载底部视图数据
    func loadBottomData(successBlock:ZQSuccessBlock) {
        let dic = ZQTool.getJsonDic(forResource: "home_bottom_data", ofType: "json")
        guard let data = dic?["data"] as? [String:Any] else {return}
        guard let arr = data["sections"] as? [[String:Any]] else {
            return
        }
        let dataSource = [ZQHomeBottomModel].deserialize(from: arr)
        getEfficiency(dataSource: dataSource as? [ZQHomeBottomModel])
        successBlock(dataSource)
    }
    
    func getEfficiency(dataSource:[ZQHomeBottomModel]?){
        guard let dataSource = dataSource else {return}
        let model = dataSource.last
        let dog = UIImage(named: "gougou")
        guard let items = model?.items else {return}
        guard let dogPic = dog else {return}
        for item in items {
            item.modifyEfficiency(image:dogPic)
        }
    }
    
    // MARK: - Public Method
    /// 处理底部视图操作 二级操作
    func dealImageIndexPath(item:ZQHomeBottomModel) {
//        guard let img = imageView.image else {return}
        guard let photoView = photoView else {return}
        let section = item.section
        let row = item.index
//        let size = img.size
        if section == 0 {  // 九宫格
            if row == 0 {  // 9
                photoView.drawLines = .thrice
            }else if row == 1{ // 4
                photoView.drawLines = .twice
            }else {
                photoView.drawLines = .none
            }

        }else if section == 1 { //cut
            photoView.setCutImgView(imgStr:item.photo)
        }else if section == 3 { //特效
            photoView.dealEfficiency(item: item)
        }
    }
    
    /// 处理图片颜色设置
    func dealCutImageColorIndexPath(item:ZQHomeColorModel){
        guard let photoView = photoView else {return}
        photoView.setCutImgView(color:item.color)
    }
    
    
    /// 处理滤镜
    func dealImageFilter(item:ZQHomeBottomModel) {
        guard let photoView = photoView else {return}
        photoView.dealImageFilter(item:item)
    }
    
    /// 重置fiter
    func resetFilter() {
        guard let photoView = photoView else {return}
        photoView.resetFilter()
        
    }
    
    /// 重置所有
    func resetAll(){
        guard let photoView = photoView else {return}
        photoView.drawLines = .none
        photoView.setCutImgView(imgStr: ZQPhotoView.cut_remove)
        photoView.resetEfficiency()
    }
    
    
    
    

}
