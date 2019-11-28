//
//  ZQDrawingTool.swift
//  Photoshop
//
//  Created by zhengzeqin on 2018/12/17.
//  Copyright © 2018年 zhengzeqin. All rights reserved.
//



import UIKit
import QuartzCore
import CoreText
protocol ZQDrawingToolDelegate: NSObjectProtocol {
    
    var lineColor: UIColor {get set}
    var lineWidth: CGFloat {get set}
    var lineAlpha: CGFloat {get set}
    
    func setInitialPoint(_ firstPoint: CGPoint)
    func movePoint(from fromPoint: CGPoint, to toPoint: CGPoint)
    func draw()
}

extension ZQDrawingToolDelegate {
    func midPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: 0.5 * (p1.x + p2.x), y: 0.5 * (p1.y + p2.y))
    }
    
    func getCurrentContext() -> CGContext {
        let context = UIGraphicsGetCurrentContext()
        return context!
    }
    
    func setDrawCofigure(context:CGContext) {
        context.setLineCap(CGLineCap.round)
        context.setStrokeColor(lineColor.cgColor)
        context.setLineWidth(lineWidth)
        context.setAlpha(lineAlpha)
    }
}


// MARK: - ZQDrawingTool
class ZQDrawingTool: NSObject, ZQDrawingToolDelegate {
    var lineColor: UIColor = UIColor.white
    var lineAlpha: CGFloat = 1.0
    var lineWidth: CGFloat = 1.0
    var firstPoint = CGPoint.zero
    var lastPoint = CGPoint.zero

    func setInitialPoint(_ firstPoint: CGPoint) {
        self.firstPoint = firstPoint
    }
    
    func movePoint(from fromPoint: CGPoint, to toPoint: CGPoint) {
        lastPoint = toPoint
    }
    
    func draw(){
        
    }
}

// MARK: - Pen
class ZQDrawingToolPen: UIBezierPath, ZQDrawingToolDelegate {
    var lineColor: UIColor = UIColor.white
    var lineAlpha: CGFloat = 1.0
//    var lineWidth: CGFloat = 0.0
    var path =  CGMutablePath()
    func setInitialPoint(_ firstPoint: CGPoint) {
        
    }
    
    func movePoint(from fromPoint: CGPoint, to toPoint: CGPoint) {
        
    }
    
    func draw() {
        let context = getCurrentContext()
         // 添加path到context上
        context.addPath(path)
        // 设置线段属性
        setDrawCofigure(context:context)
        // 将path渲染到context上
        context.strokePath()
    }
    
    func addPath(fromPPreviousPoint p1Point: CGPoint, andPreviousPoint p2Point: CGPoint, andCurrentPoint cPoint: CGPoint) -> CGRect {
        let mid1: CGPoint = midPoint(p1: p1Point, p2: p2Point)
        let mid2: CGPoint = midPoint(p1: cPoint, p2: p2Point)
        let subpath = CGMutablePath()
        subpath.move(to: CGPoint(x: mid1.x, y: mid1.y), transform: .identity)
        subpath.addQuadCurve(to: CGPoint(x: mid2.x, y: mid2.y), control: CGPoint(x: p1Point.x, y: p1Point.y), transform: .identity)
        let bounds: CGRect = subpath.boundingBox
        path.addPath(subpath, transform: .identity)
        return bounds
    }
}

// MARK: - Line
class ZQDrawingToolLine: ZQDrawingTool {
    
    override func draw() {
        let context = getCurrentContext()
        
        // 设置线段属性
        setDrawCofigure(context:context)

        // 绘制线段
        context.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
        context.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        context.strokePath()
    }
}

// MARK: - Eraser
class ZQDrawingToolEraser: ZQDrawingToolPen {
    override func draw() {
        let context = getCurrentContext()
        context.saveGState()
        context.addPath(path)
        context.setLineCap(CGLineCap.round)
        context.setLineWidth(lineWidth)
        context.setBlendMode(CGBlendMode.clear)
        context.strokePath()
        context.restoreGState()
    }
}

// MARK: - Rectangle
//不填充
class ZQDrawingToolRectangle: ZQDrawingTool {
    var isFill = false
    
    override func draw() {
        let context = getCurrentContext()
        
        context.setAlpha(lineAlpha)
        
        // 计算矩形
        let rectangle = CGRect(x: firstPoint.x, y: firstPoint.y, width: lastPoint.x - firstPoint.x, height: lastPoint.y - firstPoint.y)

        if isFill {
            context.setFillColor(lineColor.cgColor)
            context.fill(rectangle)
        } else {
            context.setStrokeColor(lineColor.cgColor)
            context.setLineWidth(lineWidth)
            context.stroke(rectangle)
        }
    }

}

// MARK: - Oval
//不填充
class ZQDrawingToolOval: ZQDrawingTool {
    var isFill = false
    
    override func draw() {
        let context = getCurrentContext()
        
        // 设置属性
        context.setAlpha(lineAlpha)
        
        let ovalRect = CGRect(x: firstPoint.x, y: firstPoint.y, width: lastPoint.x - firstPoint.x, height: lastPoint.y - firstPoint.y)
        
        if isFill {
            context.setFillColor(lineColor.cgColor)
            context.fillEllipse(in: ovalRect)
        } else {
            context.setStrokeColor(lineColor.cgColor)
            context.setLineWidth(lineWidth)
            context.strokeEllipse(in: ovalRect)
        }
    }
    
}


// MARK: - Oval
//箭头
class ZQDrawingToolArrow: ZQDrawingTool {
    var isFill = false
    
    override func draw() {
        let context = getCurrentContext()
        let capHeight: CGFloat = lineWidth * 4
        // 设置属性
        context.setStrokeColor(lineColor.cgColor)
        context.setLineWidth(lineWidth)
        context.setAlpha(lineAlpha)
        context.setLineCap(CGLineCap.square)
        // 设置箭头曲线
        context.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
        context.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        
        // 绘制箭头帽
        let angle: CGFloat = getAngle(withFirstPoint: firstPoint, andSecondPoint: lastPoint)
        var p1Point: CGPoint = getPoint(withAngle: angle + 7.0 * .pi / 8.0, andDistant: capHeight)
        var p2Point: CGPoint = getPoint(withAngle: angle - 7.0 * .pi / 8.0, andDistant: capHeight)
        let endPointOffset: CGPoint = getPoint(withAngle: angle, andDistant: lineWidth)
        
        p1Point = CGPoint(x: lastPoint.x + p1Point.x, y: lastPoint.y + p1Point.y)
        p2Point = CGPoint(x: lastPoint.x + p2Point.x, y: lastPoint.y + p2Point.y)
    
        context.move(to: CGPoint(x: p1Point.x, y: p1Point.y))
        context.addLine(to: CGPoint(x: endPointOffset.x + lastPoint.x, y: endPointOffset.y + lastPoint.y))
        context.addLine(to: CGPoint(x: p2Point.x, y: p2Point.y))
        context.strokePath()
        
    }
    
    func getAngle(withFirstPoint firstPoint: CGPoint, andSecondPoint secondPoint: CGPoint) -> CGFloat {
        let dx: CGFloat = secondPoint.x - firstPoint.x
        let dy: CGFloat = secondPoint.y - firstPoint.y
        let angle = atan2f(Float(dy), Float(dx))
        return CGFloat(angle)
    }
    
    func getPoint(withAngle angle: CGFloat, andDistant distant: CGFloat) -> CGPoint {
        let x: CGFloat = distant * cos(angle)
        let y: CGFloat = distant * sin(angle)
        return CGPoint(x: x, y: y)
    }
    
}

// MARK: - Text
//文本
class ZQDrawingToolText: ZQDrawingTool {
    var attributedText: NSAttributedString?
    var isMultiText = false
    
    override func draw() {
        var context = getCurrentContext()
        
        context.saveGState()
        context.setAlpha(lineAlpha)
        
        // draw the text
        var viewBounds = CGRect(x: min(firstPoint.x, lastPoint.x), y: min(firstPoint.y, lastPoint.y), width: CGFloat(fabs(firstPoint.x - lastPoint.x)), height: CGFloat(fabs(firstPoint.y - lastPoint.y)))
        
        // Flip the context coordinates, in iOS only.
        context.translateBy(x: 0, y: viewBounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        // Set the text matrix.
        context.textMatrix = .identity
        
        // Create a path which bounds the area where you will be ZQDrawing text.
        // The path need not be rectangular.
        let path = CGMutablePath()
        
        // In this simple example, initialize a rectangular path.
        let bounds = CGRect(x: viewBounds.origin.x, y: -viewBounds.origin.y, width: viewBounds.size.width, height: viewBounds.size.height)
        path.addRect(bounds, transform: .identity)
        
        // Create the framesetter with the attributed string.
        if let attributedText = attributedText{
            let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
            // Create a frame.
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)

            CTFrameDraw(frame, context)
        }

        context.restoreGState()
    }
}
