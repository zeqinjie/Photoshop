//
//  ZQHomeBottomSectionColCell.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/10/24.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit

class ZQHomeBottomSectionColCell: BaseCollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var model:ZQHomeBottomModel? {
        didSet{
            dealModel()
        }
    }

    
    // MARK: - Private Method
    private func dealModel(){
        guard let model = self.model else {return}
        self.titleLabel.text = model.title
        self.titleLabel.textColor = model.isSel == true ? ZQColor_ffffff : ZQColor_868686
        self.imgView.image = UIImage(named: (model.isSel == true ? model.selPhoto : model.photo ))
        guard let backColor = model.backColor else {return}
        self.contentView.backgroundColor = UIColor(hexString: backColor)
    }

}
