//
//  BaseCollectionViewCell.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/10/17.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell,ZQCommonProtocol {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        defaultSet()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaultSet()
    }
    
    
    func defaultSet(){
        creatUI()
    }
    
    func creatUI(){
        
    }
}
