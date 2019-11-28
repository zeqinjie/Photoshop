//
//  ZQBasePhotoPickerViewModel.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/12/13.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit

class ZQBasePhotoPickerViewModel: BaseViewModel {
    /// 图片保存
    func savePhoto(photoView:ZQPhotoView,successBlock:ZQSuccessBlock,failBlock:ZQFailBlock) {
        let imgs = photoView.getSaveImgs()
        if let images = imgs {
            for img in images {
                img.saveToPhoto()
            }
            successBlock("保存图片到相册...")
        }else{
            failBlock("请选择照片...")
        }
        
    }

}
