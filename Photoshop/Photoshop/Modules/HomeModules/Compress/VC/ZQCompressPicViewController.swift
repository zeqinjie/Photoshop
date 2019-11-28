//
//  CompressPicViewController.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/12/10.
//  Copyright © 2018 zhengzeqin. All rights reserved.
//

import UIKit

class ZQCompressPicViewController: ZQBasePhotoPickerViewController {

    @IBOutlet weak var inputCompressView: UIView!
    @IBOutlet weak var textField: UITextField!
    fileprivate var image:UIImage?
    fileprivate var index:Int?
    var menuView: BTNavigationDropdownMenu!
    let viewModel = ZQCompressPicViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerAutoKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterAutoKeyboard()
    }
    
    // MARK: - override
    override func defaultSet() {
        super.defaultSet()
        self.contentView.addTapGesture { [weak self](make) in
            self?.view.endEditing(true)
        }
    }
    
    override func layoutFrame(){
        super.layoutFrame()
        contentView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(ZQStatusAndNavigationHeigth)
            make.width.centerX.equalToSuperview()
            make.bottom.equalTo(self.inputCompressView.snp.top) //.offset(2)
        }
    }
    
    override func photoPickerChoice(img:UIImage?) {
        super.photoPickerChoice(img: img)
        image = img
    }
    
    override func getPhotoPickerType()->PhotoPickerVCType {
        return .compress
    }
    // MARK: - UI
    override func creatUI() {
        super.creatUI()
        creatDropdowns()
        view.bringSubview(toFront: inputCompressView)
    }
    
    
    func creatDropdowns() {
        let items = ["压缩质量", "压缩尺寸 ", "质量及尺寸"]
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.view, title: "选择压缩", items: items)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = ZQColor_563885
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
        menuView.cellBackgroundColor = ZQColor_181818
        menuView.arrowPadding = 15
        menuView.menuTitleColor = UIColor.white
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {[weak self](indexPath: Int) -> Void in
            self?.index = indexPath
        }
        self.navigationItem.titleView = menuView
    }

    // MARK: - Action
    @IBAction func ensureAction(_ sender: UIButton) {
        textField.resignFirstResponder()
        dealCompressPic()
    }
    
    // MARK: - Private Method
    func dealCompressPic() {
        guard let index = index else{
            hideHudHint("请选择压缩方式...")
            return
        }
        
        guard let image = image else {
            hideHudHint("请选择照片...")
            return
        }
        
        guard let text = textField.text,let textIntValue = Int(text) else {
            hideHudHint("输入限制图片最大多少K...")
            return
        }
        let imageByte: Int = textIntValue * 1024
        var compressImg:UIImage?
        switch index {
        case 0:
            compressImg = ZQTool.compressImageQuality(image, toByte: imageByte)
        case 1:
            compressImg = ZQTool.compressImageSize(image, toByte: imageByte)
        default:
            compressImg = ZQTool.compressImage(image, toByte: imageByte)
        }
        if let compressImg = compressImg {
            hideHudHint("压缩完毕...")
            self.photoPickerTool.updateChoiceImage(image: compressImg)
        }
    }
}


extension ZQCompressPicViewController:UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        DLog("textFieldShouldReturn")
        dealCompressPic()
        return true
    }
    
    
}
