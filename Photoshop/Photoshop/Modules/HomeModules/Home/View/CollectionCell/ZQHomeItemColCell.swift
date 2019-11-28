//
//  ZQHomeBottomItemColCell.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/10/19.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit
//432572  868686
class ZQHomeItemColCell: BaseCollectionViewCell {

    fileprivate lazy var imgView: UIImageView = {
        let v = UIImageView()
        return v
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let l = self.common_creatLabel(ZQSYSFontSize(13), text: "", color: ZQColor_000000, lineNumber: 1, textAlignment: .center)
        l?.backgroundColor = ZQColor_clear
        return l!
    }()
    
    fileprivate lazy var filterImgView: UIImageView = {
        let v = UIImageView()
        return v
    }()
    
    fileprivate lazy var filterTitleLabel: UILabel = {
        let l = self.common_creatLabel(ZQSYSFontSize(11), text: "", color: ZQColor_000000, lineNumber: 1, textAlignment: .center)
        l?.backgroundColor = ZQColor_clear
        return l!
    }()
    
//    var index:Int = 0
//    var efficiencyImg:UIImage?
    var model:ZQHomeBottomModel? {
        didSet{
            dealModel()
        }
    }
    
    deinit {
        ZQNotificationCenterRemove(self)
    }
    
    // MARK: - Override
    override func defaultSet() {
        super.defaultSet()
        ZQNoticeCenter(self, method: #selector(ZQHomeItemColCell.retSetFilterInfoNot(_:)), noticeName: ZQFilterUnSelectNotification, obj: nil)
    }
    
    override func creatUI() {
        super.creatUI()
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(60)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(15)
        }
        
        addSubview(filterImgView)
        filterImgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(30)
        }
        
        contentView.addSubview(filterTitleLabel)
        filterTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.filterImgView.snp.bottom)
            make.height.equalTo(15)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Private Method
    private func dealModel(){
        guard let model = self.model else {return}
        self.titleLabel.text = model.title
        if let titleColor = model.titleColor {
            self.titleLabel.textColor = UIColor(hexString: titleColor)
        }
        if model.title.count == 0 {
            self.titleLabel.isHidden = true
        }else {
            self.titleLabel.isHidden = false
        }
        
//        42494B
        self.titleLabel.backgroundColor = model.section == 0 ? ZQColor_42494b : UIColor.clear
        
        if model.section == 2 {// 滤镜
            filterImgView.isHidden = false
            filterTitleLabel.isHidden = false
            imgView.isHidden = true
            if model.index == 7 {
                filterTitleLabel.text = ""
            }else if model.index == 2 {
                filterTitleLabel.text = model.filterColor
            }else{
                filterTitleLabel.text = "\(model.value)"
            }
        }else{
            filterImgView.isHidden = true
            filterTitleLabel.isHidden = true
            imgView.isHidden = false
            if model.section == 3 { //特效
//                setEfficiencyPhoto()
                imgView.image = model.efficiencyImage
            }else{
                imgView.image = UIImage(named:model.photo)
            }
        }
        
        if model.section == 1 {
            imgView.backgroundColor = ZQColor_432572
        }
        
        setStyleColor()
        filterImgView.tintColor = ZQColor_0044dd
        guard let backColor = model.backColor else {return}
        contentView.backgroundColor = UIColor(hexString: backColor)
        
    }
    
    /// 设置y特效图片
    private func setEfficiencyPhoto(){
        guard let model = self.model else {return}
        if model.photo.count == 0 {return}
//        if efficiencyImg == nil {
//            let img = UIImage(named: model.photo)
//            guard let image = img else {return}
//            efficiencyImg = image
//            setEfficiency(image: image)
//        }else
        
        if model.efficiencyImage == nil{
            let img = UIImage(named: model.photo)
            guard let image = img else {return}
            setEfficiency(image: image)
        }else{
            imgView.image = model.efficiencyImage
        }
        
        
    }
    
    // MARK: - Public Method
    func setEfficiency(image:UIImage) {
        guard let model = self.model else {return}
        ZQFilterTool.share.filterImage(image, filterType: model.efficiencyType) { [weak self] (pic,origin) in
            model.efficiencyImage = pic
            model.originEfficiencyImage = origin
            self?.imgView.image = pic
        }
    }
    
    func setStyleColor() {
        guard let model = self.model else {return}
        if model.section == 2 {
            filterTitleLabel.textColor = model.isSel ? ZQColor_9013fe : ZQColor_ffffff
            titleLabel.textColor = model.isSel ? ZQColor_9013fe : ZQColor_ffffff
            filterImgView.image = UIImage(named:model.isSel ? model.selPhoto : model.photo)
        }else{
            filterTitleLabel.textColor = ZQColor_ffffff
            titleLabel.textColor = ZQColor_ffffff
        }
    }
    
    // MARK: - Notification
    /// 设置滤镜用户信息通知 取消选择
    @objc func retSetFilterInfoNot(_ not:Notification){
        guard let model = self.model else {return}
        model.isSel = false
        if model.section == 2 {
            filterTitleLabel.textColor =  ZQColor_ffffff
            titleLabel.textColor =  ZQColor_ffffff
            filterImgView.image = UIImage(named:model.photo)
        }
    }

}
