//
//  ZQColorPickerTool.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/11/14.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit
import EFColorPicker
class ZQColorPickerTool: NSObject,ZQCommonProtocol,EFColorSelectionViewControllerDelegate {
    
    fileprivate weak var delegate:UIViewController?
    fileprivate var finishBlock:((_ btn:UIButton,_ color:String)->())?
    fileprivate var colorValue:String = "ffffff"
    
    
    lazy fileprivate var navCtrl:UINavigationController = {
        let colorSelectionController = EFColorSelectionViewController()
        colorSelectionController.delegate = self
        colorSelectionController.color = UIColor.white
        let navCtrl = UINavigationController(rootViewController: colorSelectionController)
        navCtrl.navigationBar.backgroundColor = UIColor.white
        navCtrl.navigationBar.isTranslucent = false
        navCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
        
        navCtrl.preferredContentSize = colorSelectionController.view.systemLayoutSizeFitting(
            UILayoutFittingCompressedSize
        )
        let finishBtn = self.common_creatBtnTitle("完成", color: ZQColor_000000, fontSize: 14, target: self, action: #selector(finishAction(_:)))
        finishBtn?.tag = 11
        let cancleBtn = self.common_creatBtnTitle("取消", color: ZQColor_000000, fontSize: 14, target: self, action: #selector(finishAction(_:)))
        cancleBtn?.tag = 10
        colorSelectionController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: finishBtn!)
        colorSelectionController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancleBtn!)
        return navCtrl
    }()

    static let share = ZQColorPickerTool()
    override init() {
    }
    
    func presentColorPicker(delegate:UIViewController,finishBlock:@escaping ((_ btn:UIButton,_ color:String)->())) {
        self.finishBlock = finishBlock
        self.delegate = delegate
        delegate.present(self.navCtrl, animated: true, completion: nil)
    }
    
    @objc func finishAction(_ btn:UIButton){
        delegate?.dismissVC(completion: nil)
        finishBlock?(btn,colorValue)
    }
    
    func colorViewController(colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor){
        guard let colorValue = ZQTool.colorToHexStr(by: color) else {
            return
        }
        self.colorValue = colorValue
    }

}




