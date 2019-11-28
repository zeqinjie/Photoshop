//
//  ZQHomeColorItemColCell.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/11/3.
//  Copyright © 2018 zhengzeqin. All rights reserved.
//

import UIKit

class ZQHomeColorItemColCell: BaseCollectionViewCell {
    lazy var imgView:UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()

    var type:ZQHomeColorItemViewType = .rect
    var model:ZQHomeColorModel? {
        didSet{
            dealModel()
        }
    }
    
    // MARK: - override Method
    override func defaultSet() {
        super.defaultSet()
    }
    
    override func creatUI() {
        super.creatUI()
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Public Method
    private func dealModel(){
        guard let model = self.model else {return}
        if model.title == ZQHomeColorModel.MORE {
            imgView.image = UIImage(named: "more")
            imgView.backgroundColor = UIColor.clear
        }else{
            imgView.image = nil
            imgView.backgroundColor = UIColor(hexString: model.color)
        }
        
        if type == .circle {
            common_viewClips(toBounds: imgView, cornerRadius: frame.width/2)
        }else {
            common_viewClips(toBounds: imgView, cornerRadius: 0)
        }
    }
    

}
