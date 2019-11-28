//
//  BaseView.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/10/18.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit
import SnapKit
//import Spring
//import Kingfisher
//@_exported import RxSwift
class BaseView: UIView ,ZQCommonProtocol{
    
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
    
    func mengShapeLayer(_ pathFrame: CGRect, cornerRadius: CGFloat) -> CAShapeLayer? {
        let path = UIBezierPath(rect: frame)
        path.append(UIBezierPath(roundedRect: pathFrame, cornerRadius: cornerRadius).reversing())
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        return shapeLayer
    }

}
