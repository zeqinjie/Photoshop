//
//  ZQNinePalaceView.swift
//  Photoshop
//
//  Created by 郑泽钦 on 2018/10/28.
//  Copyright © 2018 zhengzeqin. All rights reserved.
//

import UIKit

class ZQPhotoDivideView: BaseView {

    override func defaultSet() {
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = false
    }
    

    private var lines = [UIView]()
    
    /// 动画划线
    var drawLines:UIImage.DividePolicy?{
        didSet {
            creatLines()
        }
    }
    
    // MARK: - UI
    func creatLines() {
        guard let drawLines = self.drawLines else {return}
        self.lines.forEachEnumerated { (i, view) in
            view.isHidden = true
        }
//        self.lines.removeAll()
        self.isHidden = false
        let totalSize = self.size
        var divideSize = totalSize
        switch drawLines {
        case .twice:
            divideSize = CGSize(width: totalSize.width / 2, height: totalSize.height / 2)
        case .thrice:
            divideSize = CGSize(width: totalSize.width / 3, height: totalSize.height / 3)
        case .four:
            divideSize = CGSize(width: totalSize.width / 4, height: totalSize.height / 4)
        case .none:
            self.isHidden = true
            return
        }
        var times: Int = 0
        //2X2
        if drawLines == .twice {
            times = 1
        }
        //3X3
        if drawLines == .thrice {
            times = 2
        }
        //4X4
        if drawLines == .four {
            times = 3
        }
        let w = divideSize.width
        let h = divideSize.height
        var index = 0
        for i in 0..<2 {
            for j in 0..<times {
                var r = CGRect.zero
                if i == 0 {
                    r = CGRect(x: CGFloat((j + 1)) * w, y: 0, w: 1, h: totalSize.height)
                }else {
                    r = CGRect(x: 0, y: CGFloat((j + 1)) * h, w: totalSize.width, h: 1)
                }
                var line:UIView?
                if lines.count > index {
                    line = lines[index]
                    line?.frame = r
                }else {
                    line = common_creatView(withFrame: r, backgroundColor:ZQColor_ffffff)                    
                }
                if let line = line{
                    line.isHidden = false
                    if lines.contains(line) == false {
                        lines.append(line)
                        addSubview(line)
                    }
                    line.tag = tag
                }
                index += 1;
            }
        }
        
    }
    

}
