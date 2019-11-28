//
//  ZQDrawingView.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/12/17.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//

import UIKit
enum ZQDrawingToolType : Int {
    case pen
    case line
    case oval
    case rectangle
    case rectangleFill
    case ovalFill
    case text
    case multiText
    case arrow
    case eraser
}

protocol ZQDrawingViewDelegate: NSObjectProtocol {
    func zqDrawingViewDidFinishedDraw(_ drawingView: ZQDrawingView)
}

class ZQDrawingView: UIView {
    var delegate: ZQDrawingViewDelegate?
    var zqDrawingTool: ZQDrawingToolDelegate? = ZQDrawingToolPen()
    var drawToolType: ZQDrawingToolType = .pen
    var lineColor: UIColor = UIColor.white
    var lineWidth: CGFloat = 2.0
    var lineAlpha: CGFloat = 1.0
    
    var image: UIImage?
    var pathArray = [ZQDrawingToolDelegate]()
    var bufferArray = [ZQDrawingToolDelegate]()
    var textView: UITextView?
    
    var p1Point = CGPoint.zero
    var p2Point = CGPoint.zero
    var cPoint = CGPoint.zero
    var originRect = CGRect.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    override func draw(_ rect: CGRect) {
        image?.draw(at: CGPoint.zero)
        zqDrawingTool?.draw()
    }

    // MARK: - Private Method
    fileprivate func finishZQDrawing() {
        updateImage(withRedraw: false)
        delegate?.zqDrawingViewDidFinishedDraw(self)
    }
    
    fileprivate func updateImage(withRedraw redraw: Bool) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0) // 开启一个图像上下文

        if redraw {
            image = nil
            // 重绘
            for tool in pathArray {
                tool.draw()
            }
            
        } else {
            image?.draw(at: CGPoint.zero)
            zqDrawingTool?.draw()
        }

        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        zqDrawingTool = nil
    }

    fileprivate func configure() {
        image = UIImage()
        zqDrawingTool?.lineWidth = lineWidth
        zqDrawingTool?.lineColor = lineColor
        zqDrawingTool?.lineAlpha = lineAlpha
    }
    
    fileprivate func setupDrawTool() {
        // 设置工具
        zqDrawingTool = setupCurrentDrawTool()
    }
    
    fileprivate func setupCurrentDrawTool() -> ZQDrawingToolDelegate? {
        switch drawToolType {
        case .pen:
            return ZQDrawingToolPen()
        case .line:
            return ZQDrawingToolLine()
        case .rectangle:
            let tool = ZQDrawingToolRectangle()
            tool.isFill = false
            return tool
        case .rectangleFill:
            let tool = ZQDrawingToolRectangle()
            tool.isFill = true
            return tool
        case .oval:
            let tool = ZQDrawingToolOval()
            tool.isFill = false
            return tool
        case .ovalFill:
            let tool = ZQDrawingToolOval()
            tool.isFill = true
            return tool
        case .text:
            let tool = ZQDrawingToolText()
            tool.isMultiText = false
            return tool
        case .multiText:
            let tool = ZQDrawingToolText()
            tool.isMultiText = true
            return tool
        case .arrow:
            return ZQDrawingToolArrow()
        case .eraser:
            return ZQDrawingToolEraser()
        }
    }

    fileprivate func initializeTextBox(with StartPoint: CGPoint, andMultiText isMultiText: Bool) {
        // 初始化textview和参数
        if textView == nil {
            textView = UITextView()
            textView?.delegate = self
            textView?.autocorrectionType = UITextAutocorrectionType.no
            textView?.backgroundColor = UIColor.clear
            textView?.layer.borderWidth = 1.0
            textView?.layer.borderColor = UIColor.gray.cgColor
            textView?.layer.cornerRadius = 8
            textView?.contentInset = .zero
            addSubview(textView!)
        }
        
        // 设置文本框的frame
        let fontSize = Int(lineWidth * 3)
        
        textView?.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        textView?.textColor = lineColor
        textView?.alpha = lineAlpha
        
        let defaultWidth: Int = 200
        let defaultHeight: Int = fontSize * 2
        let initialYPosition: Int = Int(StartPoint.y) - (defaultHeight / 2)
        var textFrame = CGRect(x: StartPoint.x, y: CGFloat(initialYPosition), width: CGFloat(defaultWidth), height: CGFloat(defaultHeight))
        textFrame = adjustTextViewFrame(withInitalFrame: textFrame)
        textView?.frame = textFrame
        textView?.text = ""
        textView?.isHidden = false
    }
    
    // 判断文本框是否在本视图之外
    fileprivate func adjustTextViewFrame(withInitalFrame frame: CGRect) -> CGRect {
        var frame = frame
        if (frame.origin.x + frame.size.width) > self.frame.size.width {
            frame.size.width = frame.size.width - frame.origin.x
        }
        if (frame.origin.y + frame.size.height) > self.frame.size.height {
            frame.size.height = frame.size.height - frame.origin.y
        }
        return frame
    }
    
    // 移动坐标调整文本框的大小
    fileprivate func resizeTextViewFrame(_ adjustedSize: CGPoint) {
        guard let textView = textView else {
            return
        }
        let minimumAllowedHeight = Int((textView.font?.pointSize ?? 0.0) * 2)
        let minimumAllowedWidth = Int((textView.font?.pointSize ?? 0.0) * 0.5)
        
        var frame: CGRect = textView.frame
        
        //adjust height
        let adjustedHeight = Int(adjustedSize.y - textView.frame.origin.y)
        if adjustedHeight > minimumAllowedHeight {
            frame.size.height = CGFloat(adjustedHeight)
        }
        
        //adjust width
        let adjustedWidth = Int(adjustedSize.x - textView.frame.origin.x)
        if adjustedWidth > minimumAllowedWidth {
            frame.size.width = CGFloat(adjustedWidth)
        }
        frame = adjustTextViewFrame(withInitalFrame: frame)
        
        textView.frame = frame
    }
    
    fileprivate func enterTextEdit() {
        guard let textView = textView else {return}
        if textView.isHidden {
            addNotificationToKeyboardAction()
            textView.becomeFirstResponder()
        }
    }

    fileprivate func adjustIfTextViewHide(byKeyboard notify: Notification?) {
        guard let textView = textView else {return}
        var textViewBottomPoint: CGPoint = convert(textView.frame.origin, to: nil)
        textViewBottomPoint.y += textView.frame.size.height
        let screenRect: CGRect = UIScreen.main.bounds
        if let value = notify?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            let keyboardSize:CGSize = value.cgRectValue.size
            let offset: CGFloat = (screenRect.size.height - (keyboardSize.height )) - textViewBottomPoint.y
            if offset < 0 {
                let newYPos: CGFloat = frame.origin.y + offset
                UIView.animate(withDuration: 0.25, animations: {
                    self.frame = CGRect(x: self.frame.origin.x, y: newYPos, width: self.frame.size.width, height: self.frame.size.height)
                })
            }
        }
    }
    
    fileprivate func textViewDidEndInput(){
        guard let textView = textView else {return}
        guard let zqDrawingTool = zqDrawingTool as? ZQDrawingToolText else {return}
        if textView.text?.length ?? 0 > 0 {
            let textInset: UIEdgeInsets = textView.textContainerInset
            let additionalXPadding: CGFloat = 5
            let start = CGPoint(x: textView.frame.origin.x + textInset.left + additionalXPadding, y: textView.frame.origin.y + textInset.top)
            let end = CGPoint(x: textView.frame.origin.x + textView.frame.size.width - additionalXPadding, y: textView.frame.origin.y + textView.frame.size.height)
            zqDrawingTool.attributedText = textView.attributedText
            pathArray.append(zqDrawingTool)
            zqDrawingTool.setInitialPoint(start) //change this for precision accuracy of text location
            zqDrawingTool.movePoint(from: start, to: end)
            setNeedsDisplay()
            finishZQDrawing()
        }
        self.textView?.isHidden = true
        self.textView?.removeFromSuperview()
        self.textView = nil
        self.zqDrawingTool = nil
    }
    
    // MARK: - Keyboard
    fileprivate func addNotificationToKeyboardAction() {
        print("给键盘添加监听")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: .UIKeyboardDidHide, object: nil)
    }


    // MARK: -- KeyboardAction
    @objc func keyboardDidShow(_ notify: Notification?) {
        adjustIfTextViewHide(byKeyboard: notify)
    }

    @objc func keyboardWillHide(_ notify: Notification?) {
        frame = originRect
    }
    
    @objc func keyboardDidHide(_ notify: Notification?) {
        // 移除监听
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Public Method
    func undoLastObject() {
        if canundo() {
            weak var tool = pathArray.last
            if let aTool = tool {
                bufferArray.append(aTool)
            }
            pathArray.removeLast()
            
            updateImage(withRedraw: true)
            
            setNeedsDisplay()
        }
    }
    
    func canundo() -> Bool {
        return pathArray.count > 0
    }
    
    func redoLastObject() {
        if canredo() {
            weak var tool = bufferArray.last
            if let aTool = tool {
                pathArray.append(aTool)
            }
            bufferArray.removeLast()
            
            updateImage(withRedraw: true)
            
            setNeedsDisplay()
        }

    }
    
    func canredo() -> Bool {
        return bufferArray.count > 0
    }
    
    func clearScreen() {
        if pathArray.count > 0 || bufferArray.count > 0 {
            pathArray.removeAll()
            bufferArray.removeAll()
            
            updateImage(withRedraw: true)
            zqDrawingTool = nil
            
            setNeedsDisplay()
        }
    }
    
}

// MARK: - UITextViewDelegate
extension ZQDrawingView:UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewDidEndInput()
    }

    func textViewDidBeginEditing(_ textView: UITextView){
        originRect = self.frame
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if (zqDrawingTool?.isKind(of: ZQDrawingToolText.self) ?? false) && (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView){
        var frame: CGRect = textView.frame
        if textView.contentSize.height > frame.size.height {
            frame.size.height = textView.contentSize.height
        }
        textView.frame = frame
    }
}

// MARK: - UIResponder
extension ZQDrawingView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let textView = textView  {
            if !textView.isHidden {
                textViewDidEndInput()
                return
            }
        }else {
            if let touch = touches.first {
                cPoint = touch.location(in: self)
                p2Point = touch.previousLocation(in: self)
                setupDrawTool()
                if let zqDrawingTool = zqDrawingTool {
                    // 设置属性
                    zqDrawingTool.lineWidth = lineWidth
                    zqDrawingTool.lineColor = lineColor
                    zqDrawingTool.lineAlpha = lineAlpha
                    if (zqDrawingTool is ZQDrawingToolText) {
                        initializeTextBox(with: cPoint, andMultiText: false)
                    } else {
                        zqDrawingTool.setInitialPoint(cPoint)
                        pathArray.append(zqDrawingTool)
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            p1Point = p2Point
            p2Point = touch.previousLocation(in: self)
            cPoint = touch.location(in: self)
            if let zqDrawingTool = zqDrawingTool {
                if (zqDrawingTool is ZQDrawingToolPen) {
                    let bounds: CGRect? = (zqDrawingTool as? ZQDrawingToolPen)?.addPath(fromPPreviousPoint: p1Point, andPreviousPoint: p2Point, andCurrentPoint: cPoint)
                    var drawBox: CGRect? = bounds
                    drawBox?.origin.x -= zqDrawingTool.lineWidth * 2
                    drawBox?.origin.y -= zqDrawingTool.lineWidth * 2
                    drawBox?.size.width += zqDrawingTool.lineWidth * 4
                    drawBox?.size.height += zqDrawingTool.lineWidth * 4
                    setNeedsDisplay(drawBox ?? CGRect.zero)
                } else if (zqDrawingTool is ZQDrawingToolText) {
                    resizeTextViewFrame(CGPoint(x: cPoint.x, y: cPoint.y))
                } else {
                    zqDrawingTool.movePoint(from: p2Point, to: cPoint)
                    setNeedsDisplay()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let zqDrawingTool = zqDrawingTool {
            if (zqDrawingTool is ZQDrawingToolText) {
                enterTextEdit()
            } else {
                touchesMoved(touches, with: event) // 保证一个点也能绘图
                finishZQDrawing()
            }
        }
    }
}
