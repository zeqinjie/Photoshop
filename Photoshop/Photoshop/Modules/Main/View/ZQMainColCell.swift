//
//  ZQMainColCell.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/12/9.
//  Copyright © 2018 zhengzeqin. All rights reserved.
//

import UIKit

class ZQMainColCell: BaseCollectionViewCell {
    
    fileprivate lazy var imgView: UIImageView = {
        let v = UIImageView()
        return v
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let l = self.common_creatLabel(ZQSYSFontSize(15), text: "", color: ZQColor_ffffff, lineNumber: 1, textAlignment: .center)
        l?.backgroundColor = ZQColor_clear
        return l!
    }()
    
    var model:ZQMainModel?{
        didSet{
            guard let model = model else {
                return
            }
            dealModel(model)
        }
    }
    
    // MARK: - override
    override func creatUI() {
        super.creatUI()
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.contentView).offset(-5)
            make.height.width.equalTo(50)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.imgView.snp.bottom).offset(8)
            make.height.equalTo(15)
        }
        
    }
    

    
    // MARK: - Private Method
    func dealModel(_ model:ZQMainModel) {
        titleLabel.text = model.title
        imgView.image = UIImage(named: model.photo)
    }
    

    // MARK: - Public Method
    func didSelectColor(_ didSelect:Bool)  {
        if didSelect {
            contentView.backgroundColor = ZQColor_121212
            imgView.image = UIImage(named: model?.selPhoto ?? "")
        }else {
            contentView.backgroundColor = ZQColor_1e1e1e
            imgView.image = UIImage(named: model?.photo ?? "")
        }
    }
    
    func didSelectColorChange() {
        self.didSelectColor(true)
        ZQTool.dispatch(afterTime: 0.5) { [weak self] in
            self?.didSelectColor(false)
        }
    }
}
