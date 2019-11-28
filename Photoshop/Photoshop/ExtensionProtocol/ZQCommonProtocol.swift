//
//  File.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/10/23.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import Foundation
import UIKit
protocol ZQCommonProtocol {
    func common_collectionViewFrame(_ frame: CGRect, minLineSpacing minimumLineSpacing: CGFloat, interitemSpacing minimumInteritemSpacing: CGFloat, scrollDirection: UICollectionView.ScrollDirection) -> UICollectionView?
}

extension ZQCommonProtocol {
    // MARK: - CollectionView
    func common_collectionViewFrame(_ frame: CGRect, minLineSpacing minimumLineSpacing: CGFloat, interitemSpacing minimumInteritemSpacing: CGFloat, scrollDirection: UICollectionView.ScrollDirection) -> UICollectionView? {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = minimumLineSpacing
        flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
        flowLayout.scrollDirection = scrollDirection
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }
    
    func common_collectionViewFrame(_ frame: CGRect, flowLayout: UICollectionViewFlowLayout?) -> UICollectionView? {
        var collectionView: UICollectionView? = nil
        if let aLayout = flowLayout {
            collectionView = UICollectionView(frame: frame, collectionViewLayout: aLayout)
        }
        collectionView?.showsHorizontalScrollIndicator = false
//        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = UIColor.white
        return collectionView
    }
    
    // MARK: - Button
    func common_btn(_ btn: ZQButton?, normalImgStr nor: String?, seletedImgStr sel: String?) {
        btn?.setImage(UIImage(named: nor ?? ""), for: .normal)
        if let sel = sel {
            btn?.setImage(UIImage(named: sel), for: .selected)
        }
    }
    
    func common_btn(_ btn: ZQButton?, normalImgStr nor: String?, highlightImgStr: String?) {
        btn?.setImage(UIImage(named: nor ?? ""), for: .normal)
        if let highlightImgStr = highlightImgStr {
            btn?.setImage(UIImage(named: highlightImgStr), for: .highlighted)
        }
    }
    
    func common_btn(_ btn: ZQButton?, normalBackImgStr nor: String?, seletedBackImgStr sel: String?) {
        btn?.setBackgroundImage(UIImage(named: nor ?? ""), for: .normal)
        if let sel = sel {
            btn?.setBackgroundImage(UIImage(named: sel ), for: .selected)
        }
    }
    
    func common_btn(_ btn: ZQButton?, normalTitleStr nor: String?, seletedTitleStr sel: String?) {
        btn?.setTitle(nor, for: .normal)
        if let sel = sel {
            btn?.setTitle(sel, for: .selected)
        }
    }
    
    func common_creatBtnTitle(_ title: String?, target: Any?, action: Selector) -> ZQButton? {
        let btn = ZQButton(type: .custom)
        if let title = title {
            btn.setTitle(title, for: .normal)
        }
        btn.addTarget(target, action: action, for: .touchUpInside)
        return btn
    }
    
    func common_creatBtnTitle(_ title: String?, color: UIColor?, fontSize size: CGFloat, target: Any?, action: Selector) -> ZQButton? {
        let btn: ZQButton? = common_creatBtnTitle(title, target: target, action: action)
        btn?.titleLabel?.font = ZQSYSFontSize(size)
        if let color = color {
            btn?.setTitleColor(color, for: .normal)
        }
        return btn
    }
    
    // MARK: - Label
    func common_creatLabel(_ font: UIFont?, text: String?, color: UIColor?) -> UILabel? {
        let l = UILabel()
        l.numberOfLines = 0
        if let aFont = font {
            l.font = aFont
        }
        l.text = text
        if let aColor = color {
            l.textColor = aColor
        }
        return l
    }
    
    func common_creatLabel(_ font: UIFont?, text: String?, color: UIColor?, lineNumber: Int, textAlignment: NSTextAlignment) -> UILabel? {
        let l: UILabel? = common_creatLabel(font, text: text, color: color)
        l?.textAlignment = textAlignment
        l?.numberOfLines = lineNumber
        return l
    }
    
    func common_label(_ l: UILabel?, font: UIFont?, back backColor: UIColor?, textColor color: UIColor?, lineNumber: Int, textAlignment: NSTextAlignment) {
        if let aFont = font {
            l?.font = aFont
        }
        if let aColor = color {
            l?.textColor = aColor
        }
        if let backColor = backColor {
            l?.backgroundColor = backColor
        }
        l?.numberOfLines = lineNumber
        l?.textAlignment = textAlignment
    }
    
    func common_label(_ l: UILabel?, back backColor: UIColor?, textColor color: UIColor?, bordColor: UIColor?) {
        if let aColor = color {
            l?.textColor = aColor
        }
        if let backColor = backColor {
            l?.backgroundColor = backColor
        }
        if let bordColor = bordColor {
            l?.layer.borderColor = bordColor.cgColor
        }
    }
    
    // MARK: - UITabelView
    func common_tableViewFrame(_ frame: CGRect, style: UITableView.Style, delegate: Any?) -> UITableView? {
        let tableView = UITableView(frame: frame, style: style)
        tableView.delegate = delegate as? UITableViewDelegate
        tableView.dataSource = delegate as? UITableViewDataSource
        tableView.tableFooterView = UIView()
        return tableView
    }
    
    
    // MARK: - AlertView
    func common_showAlertViewTitle(_ title: String?, message: String?, cancelTitle: String?) {
        let alertView = UIAlertView(title: title ?? "提示:", message: ZQGuardNullString(message), delegate: nil, cancelButtonTitle: (cancelTitle?.count ?? 0) != 0 ? cancelTitle : "确定", otherButtonTitles: "")
        alertView.show()
    }
    
    func common_showAlertViewTitle(_ title: String?, message: String?) {
        common_showAlertViewTitle("提示:", message: message, cancelTitle: "确定")
    }
    
    func common_creatAlertViewTitle(_ title: String?, message: String?) -> UIAlertView? {
        let alertView = UIAlertView(title: title ?? "提示:", message: ZQGuardNullString(message), delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.show()
        return alertView
    }

    // MARK: - AlertView
    func commom_numberTextFieldFontSize(_ fontSize: CGFloat, color: UIColor?, placeHolder: String?, placeHolderColor: UIColor?, delegate: Any?) -> UITextField? {
        let textField = UITextField()
        textField.font = ZQSYSFontSize(fontSize)
        textField.returnKeyType = .done
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        if color != nil {
            textField.textColor = color
        }
        textField.placeholder = placeHolder
        if placeHolder != nil {
            textField.attributedPlaceholder = NSMutableAttributedString().attributeString(ZQGuardNullString(placeHolder), color: placeHolderColor, font: ZQSYSFontSize(fontSize))
        }
        textField.delegate = delegate as? UITextFieldDelegate
        return textField
    }
    
    // MARK: - UIView
    func common_creatView(withFrame frame: CGRect, backgroundColor: UIColor?) -> UIView? {
        let v = UIView(frame: frame)
        v.backgroundColor = backgroundColor
        return v
        
    }

    func common_removeAllSubview(view:UIView){
        for v in view.subviews {
            v.removeFromSuperview()
        }
    }
    
    
    // MARK: - UIBarButtonItem
    func common_barBtnItem(imgStr:String,_ target: Any?,_ action:Selector) -> UIBarButtonItem {
        return common_barBtnItem(btnType: nil, imgStr: imgStr, target, action)
    }
    
    func common_barBtnItem(btnType:ZQButtonType?,imgStr:String,_ target: Any?,_ action:Selector) -> UIBarButtonItem {
        let btn = ZQButton(frame: CGRect(x: 0, y: 0, w: 40, h: 40))
        if let type = btnType{
            btn.btnType = type
        }
        btn.setImage(UIImage(named: imgStr), for: .normal)
        btn.addTarget(target, action: action, for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btn)
        return barButton
    }
    
    // MARK: - Method
    func common_viewClips(toBounds view: UIView?, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor?) {
        common_viewClips(toBounds: view, cornerRadius: cornerRadius)
        view?.layer.borderWidth = borderWidth
        view?.layer.borderColor = borderColor?.cgColor
    }
    
    func common_viewClips(toBounds view: UIView?, cornerRadius: CGFloat) {
        view?.clipsToBounds = true
        view?.layer.cornerRadius = cornerRadius
    }

}

