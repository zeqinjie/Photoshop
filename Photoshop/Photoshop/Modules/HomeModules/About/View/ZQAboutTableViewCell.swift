//
//  AboutTableViewCell.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/12/22.
//  Copyright © 2018 zhengzeqin. All rights reserved.
//

import UIKit

class ZQAboutTableViewCell: BaseTableViewCell {

    @IBInspectable var selectedBackgroundColor = UIColor.gray {
        didSet{
            let v = UIView(frame: bounds)
            v.backgroundColor = selectedBackgroundColor
            selectedBackgroundView = v
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectedBackgroundColor = ZQColor_432572!
        
    }

    

}
