//
//  AttributedString+Extension.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/10/23.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString{
    /// 富文本0
    func attributeString(_ context: String?, text: String?, contextFont: UIFont?, contextColor: UIColor?, textFont: UIFont?, textColor: UIColor?) -> NSMutableAttributedString? {
        setAttributedString(NSAttributedString(string: ZQGuardNullString(context)))
        if let aFont = contextFont, let aColor = contextColor {
            addAttributes([NSAttributedString.Key.font: aFont, NSAttributedString.Key.foregroundColor: aColor], range: NSRange(location: 0, length: ZQGuardNullString(context).count))
        }
        let textRange: NSRange? = (context as NSString?)?.range(of: ZQGuardNullString(text))
        if let aFont = textFont, let aRange = textRange {
            addAttribute(.font, value: aFont, range: aRange)
        }
        if let aColor = textColor, let aRange = textRange {
            addAttribute(.foregroundColor, value: aColor, range: aRange)
        }
        return self
    }
    
    /// 富文本1
    func attributeString(_ context: String?, color: UIColor?, font: UIFont?) -> NSMutableAttributedString? {
        setAttributedString(NSAttributedString(string: ZQGuardNullString(context)))
        if let aFont = font, let aColor = color {
            addAttributes([NSAttributedString.Key.font: aFont, NSAttributedString.Key.foregroundColor: aColor], range: NSRange(location: 0, length: ZQGuardNullString(context).count))
        }
        return self
    }
    
    

    /// 富文本2
    func attributeString(_ context: String?, text: String?, contextFont: UIFont?, contextColor: UIColor?, textFont: UIFont?, textColor: UIColor?, lineSpace: CGFloat) -> NSMutableAttributedString? {
        let attributeString: NSMutableAttributedString? = self.attributeString(context, text: text, contextFont: contextFont, contextColor: contextColor, textFont: textFont, textColor: textColor)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace //调整行间距
        attributeString?.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: ZQGuardNullString(context).count))
        return attributeString
    }
    
    /// 富文本字间距
    func attributeString(_ context: String?, lineSpace: CGFloat) -> NSMutableAttributedString? {
        setAttributedString(NSAttributedString(string: ZQGuardNullString(context)))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace //调整行间距
        addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: ZQGuardNullString(context).count))
        return self
    }
    
    /// 下划线属性
    func underLineAttributeString(_ text: String?, color: UIColor?, fontSize size: Int) -> NSMutableAttributedString? {
        setAttributedString(NSAttributedString(string: ZQGuardNullString(text)))
        let contentRange = NSRange(location: 0, length: ZQGuardNullString(text).count)
        addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: contentRange)
        if let aColor = color {
            addAttribute(.foregroundColor, value: aColor, range: contentRange)
        }
        addAttribute(.font, value: UIFont.systemFont(ofSize: CGFloat(size)), range: contentRange)
        return self
    }
    
    /// html的富文本的高度
    func heightHtml(forLabelWidth width: Float, fontSize: Float) -> CGFloat {
        return boundingRect(with: CGSize(width: CGFloat(width), height: CGFloat(MAXFLOAT)), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size.height
    }


}
