//
//  ZQBasePicViewController.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/12/12.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit
enum PhotoPickerVCType:Int {
    case `default`
    case edit
    case draw
    case compress
}
class ZQBasePhotoPickerViewController: BaseViewController {
    
    
    var photoPickerViewModel = ZQBasePhotoPickerViewModel()
    // 视图内容
    lazy var contentView:UIView = {
        var view = UIView()
        return view
    }()
    
    // 图片内容视图
    lazy var photoView: ZQPhotoView  = {
        let photoView = ZQPhotoView(frame: CGRect.zero, type: self.getPhotoViewType())
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return photoView
    }()
    
    // 照片选择器
    lazy var photoPickerTool:ZQPhotoTool = {
        let tool = ZQPhotoTool()
        tool.photoPickerToolBlock = {
            [unowned self] (img) in
            self.photoPickerChoice(img: img)
        }
        return tool
    }()
    
    // 按钮
    lazy var chooseBtn: UIButton = {
        var chooseBtn = self.common_creatBtnTitle("", color: nil, fontSize: 12, target: self, action: #selector(zqbtnAction(_:)))
        chooseBtn?.setImage(UIImage(named: "add"), for: .normal)
        chooseBtn?.frame = CGRect(x: 0, y: 0, w: 100, h: 100)
        chooseBtn?.layer.borderColor = ZQColor_563885?.cgColor
        chooseBtn?.backgroundColor = ZQColor_563885
        chooseBtn?.layer.cornerRadius = CGFloat(chooseBtn?.frame.width ?? 0) / 2.0
        chooseBtn?.layer.borderWidth = 8
        chooseBtn?.btnType = .crame
        return chooseBtn!
    }()
    
    // MARK: - CycleLife
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    // MARK: - Override
    override func transitionEnable(isEnabled:Bool){
        super.transitionEnable(isEnabled:true)
        self.navigationController?.hero.navigationAnimationType = .zoomOut
    }

    override func defaultSet() {
        super.defaultSet()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK: - UI
    override func creatUI() {
        super.creatUI()
        creatLeftBarBtn()
        creatRightBarBtn()
        creatContentView()
        layoutFrame()
    }
    
    func creatContentView(){
        view.addSubview(contentView)
//        contentView.backgroundColor = ZQColor_0044dd
        view.addSubview(chooseBtn)
    }
    
    func creatLeftBarBtn() {
        let backBtn = common_barBtnItem(btnType: .back,imgStr: "back", self, #selector(zqbtnAction(_:)))
        let photoBtn = common_barBtnItem(btnType: .crame,imgStr: "camera", self, #selector(zqbtnAction(_:)))
        navigationItem.leftBarButtonItems = [backBtn,photoBtn]
    }
    
    func creatRightBarBtn(){
        let shareBtn = common_barBtnItem(btnType: .share,imgStr: "share", self, #selector(zqbtnAction(_:)))
        let downloadBtn = common_barBtnItem(btnType: .save,imgStr: "download", self, #selector(zqbtnAction(_:)))
        let resetBtn = common_barBtnItem(btnType: .resetAll,imgStr: "reset_all", self, #selector(zqbtnAction(_:)))
        if getPhotoPickerType() == .compress {
            navigationItem.rightBarButtonItems = [shareBtn,downloadBtn]
        }else{
            navigationItem.rightBarButtonItems = [shareBtn,downloadBtn,resetBtn]
        }
        
    }
    
    // 布局
    func layoutFrame(){
        contentView.snp.makeConstraints { (make) in
            make.width.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(ZQStatusAndNavigationHeigth)
            make.height.equalTo(ZQScreenHeight - ZQStatusAndNavigationHeigth - ZQIPhoneXBottomHeigth)
        }
        chooseBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Public Method
    func getDrawBoardView() -> ZQDrawingView{
         return photoView.getDrawBoardView()
    }
    
    // 控制器类型
    func getPhotoPickerType()->PhotoPickerVCType {
        return .default
    }
    
    // Photo的类型
    func getPhotoViewType() -> ZQPhotoViewType {
        return .default
    }
    
    // 照片选择
    func photoPickerChoice(img:UIImage?) {
        self.chooseBtn.isHidden = true
    }
    
    // 保存照片
    func savePhoto() {
        photoPickerViewModel.savePhoto(photoView: photoView, successBlock: {[unowned self] (json) in
            guard let str = json as? String else{return}
            self.hideHudHint(str)
        }) {[unowned self](error) in
            guard let str = error else{return}
            self.hideHudHint(str)
        }
    }
    
    // 重置
    func resetAll() {
        
    }
    
    //分享
    func share() {
        if checkSeletedImg() {
            let vc = UIActivityViewController(activityItems: [photoView.getContentImg()], applicationActivities: [])
            present(vc, animated: true)
        }
    }
    
    //判断是否有选择照片
    func checkSeletedImg() -> Bool{
        if photoView.img == nil {
            hideHudHint("请选择照片...")
            return false
        }else{
            return true
        }
    }
    
    // MARK: - Action
    @objc func zqbtnAction(_ btn:ZQButton) {
        switch btn.btnType {
        case ZQButtonType.back:
            navigationController?.popViewController(animated: true)
        case ZQButtonType.crame:
            self.photoPickerTool.showPickerPhoto(photoView:self.photoView, delegate: self)
        case ZQButtonType.save:
            savePhoto()
        case ZQButtonType.resetAll:
            resetAll()
        case ZQButtonType.share:
            share()
        default:
            navigationController?.popViewController(animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
