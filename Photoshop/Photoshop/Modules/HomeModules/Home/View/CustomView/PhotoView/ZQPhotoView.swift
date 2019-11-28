//
//  ZQHomePhotoView.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/10/29.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit
import GPUImage

enum ZQPhotoViewType:Int {
    case `default` //默认
    case editPhoto //编辑
    case drawPhoto //绘画
}

class ZQPhotoView: BaseView {
    
    
    static let cut_remove = "cut_remove"
    fileprivate var filterTool = ZQFilterTool.share
    /// 是否画九宫格
    fileprivate var isDivideLine = false
    fileprivate var cutImgColor = "ffffff"
    fileprivate var cutImgStr:String?
    var type:ZQPhotoViewType = .default
    
    fileprivate lazy var gpuImageView:GPUImageView = {
        let v = GPUImageView()
        return v
    }()
    
    fileprivate lazy var drawBoardView:ZQDrawingView = {
        let v = ZQDrawingView(frame: CGRect.zero)
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    fileprivate lazy var divideLineView:ZQPhotoDivideView = {
        let v = ZQPhotoDivideView.init(frame: getContentFrame())
        v.isHidden = true
        addSubview(v)
        return v
    }()
    
    /// 裁剪视图
    fileprivate lazy var cutImgView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    /// 画线
    var drawLines:UIImage.DividePolicy = .none{
        didSet {
            drawLine()
        }
    }
    
    /// 内容图片视图
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    /// 内容是视图
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// 内容图片
    var img:UIImage?{
        didSet{
            guard let image = img else {return}
            self.imageView.image = image
            if self.type == .editPhoto {
                self.filterTool.setupFilters(image:image,gpuImageView:gpuImageView)
            }
        }
    }
    // MARK: - LifeCycle
    init(frame: CGRect,type:ZQPhotoViewType) {
        self.type = type
        super.init(frame: frame)
        if type == .editPhoto {
            creatEditPhotoUI()
        }else if type == .drawPhoto {
            creatDrawPhotoUI()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    override func creatUI() {
        addSubview(contentView)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // 编辑图片的视图
    func creatEditPhotoUI() {
        imageView.addSubview(gpuImageView)
        gpuImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(cutImgView)
        cutImgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func creatDrawPhotoUI() {
        contentView.addSubview(drawBoardView)
        drawBoardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

// MARK: - Public Method
extension ZQPhotoView {
    /// 获取画板
    func getDrawBoardView() -> ZQDrawingView {
        return drawBoardView
    }
    
    /// 获取内容图片
    func getContentImg() -> UIImage {
        return contentView.toImage()
    }
    
    /// 获取内容frame
    func getContentFrame() -> CGRect {
        return contentView.frame
    }
    
    /// 设置内容frame
    func setContentFrame(frame:CGRect) {
        contentView.frame = frame
        self.layoutIfNeeded()
        if isDivideLine == true {
            drawLine()
        }
    }
    
    /// 设置内容是否隐藏
    func setContentHide(isHide:Bool) {
        contentView.isHidden = isHide
    }
    
    /// 获取需要保存的图片集
    func getSaveImgs() -> [UIImage]? {
        guard img != nil else {return nil}
        var imgs:[UIImage]?
        let contentImg = getContentImg()
        if self.drawLines == .none {
            imgs = [contentImg]
        }else {
            imgs = contentImg.divide(policy: self.drawLines)
        }
        return imgs
    }
    
    /// 设置裁剪视图
    func setCutImgView(imgStr:String?){
        guard img != nil else {return}
        cutImgStr = imgStr
        if let cutImgStr = cutImgStr {
            if cutImgStr == ZQPhotoView.cut_remove{
                cutImgView.isHidden = true
                cutImgColor = "ffffff"
            }else{
                cutImgView.isHidden = false
                setCutImgMask(img: cutImgStr, color:cutImgColor)
            }
        }else{
            cutImgView.isHidden = true
            cutImgColor = "ffffff"
        }
    }
    
    /// 设置裁剪视图背景色
    func setCutImgView(color:String?){
        guard img != nil else {return}
        if let color = color {
            if let cutImgStr = cutImgStr{
                if cutImgStr != ZQPhotoView.cut_remove {
                    cutImgColor = color
                    setCutImgMask(img: cutImgStr, color:cutImgColor)
                }
            }
        }
    }
    
    /// 滤镜处理
    func dealImageFilter(item:ZQHomeBottomModel) {
        guard img != nil else {return}
        filterTool.filterPhoto(item: item)
    }
    
    /// 重置所有滤镜
    func resetFilter(){
        guard img != nil else {return}
        filterTool.resetFiler()
    }
    
    /// 重置所有特效
    func resetEfficiency(){
        guard img != nil else {return}
        filterTool.resetEfficiency()
    }
    
    /// 特效处理
    func dealEfficiency(item:ZQHomeBottomModel) {
        guard img != nil else {return}
        filterTool.addEfficiencyFilter(filterType: item.efficiencyType)
    }
    
    // MARK: - Private Method
    /// 画线
    fileprivate func drawLine() {
        guard img != nil else {return}
        if self.drawLines != .none {
            self.isDivideLine = true
        }else{
            self.isDivideLine = false
        }
        divideLineView.frame = getContentFrame()
        divideLineView.drawLines = drawLines
    }
    
    /// 设置遮罩颜色
    func setCutImgMask(img:String,color:String){
        var maskImg = UIImage(named: img)
        maskImg = maskImg?.maskImage(maskColor:UIColor(hexString:color))
        cutImgView.image = maskImg
    }
}

