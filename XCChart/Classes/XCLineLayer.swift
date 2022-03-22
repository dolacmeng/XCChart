//
//  XCLineLayer.swift
//  XCCharts
//
//  Created by Jack on 2021/8/18.
//

import UIKit

public class XCLineLayer: CALayer {
    
    let setting: XCCharSetting?
    let values:[CGFloat]?
    var axisHeight = CGFloat(0)
    var color = UIColor.lightGray
    var paddingTop = CGFloat(4)
    
    init(setting: XCCharSetting, values:[CGFloat],axisHeight:CGFloat,color:UIColor) {
        self.setting = setting
        self.values = values
        self.axisHeight = axisHeight
        self.color = color
        
        super.init()
        // 设置放大倍数(不设置视网膜屏会模糊)
        contentsScale = UIScreen.main.scale
    }
    
    required init?(coder: NSCoder) {
        self.setting = nil
        values = nil
        super.init(coder: coder)
    }
    
    public override func draw(in context: CGContext) {
        guard let values = values else {
            return
        }

        context.setStrokeColor(color.cgColor)
        context.setLineWidth(1.5)
        context.setLineCap(CGLineCap.round)
        context.setFillColor(setting!.lineFillColor.cgColor)
        
        let itemW = bounds.size.width / CGFloat(values.count)
        let radius = CGFloat(3)
        var lastPoint:CGPoint = CGPoint(x: -1, y: -1)
        /// 上一个数据是否是0
        var lastIsZero = false
        for (index,value) in values.enumerated() {

            if value == 0 {
                lastIsZero = true
                continue
            }
            if lastIsZero {
                context.setLineDash(phase: CGFloat(3), lengths: [CGFloat(3)])
            }

            let itemH = bounds.size.height * value / 100.0
            let x = CGFloat(index) * itemW + (itemW)*0.5
            let y = bounds.size.height + paddingTop - itemH

            // 画线
            if index != 0 {
                context.move(to: lastPoint)
                if lastPoint.x != -1 {
                    context.addLine(to: CGPoint(x: x, y: y))
                }
            }
            context.strokePath()
            context.setLineDash(phase: 0, lengths: [])
            
            // 画圆(上一个数据)
            if index != 0 {
                context.addArc(center: lastPoint, radius: radius, startAngle: 2*CGFloat(Float.pi), endAngle: 0, clockwise: true)
                context.drawPath(using: .eoFillStroke)
            }
            
            lastIsZero = false
            lastPoint = CGPoint(x: x, y: y)
        }
        
        // 画圆(最后一个数据)
        context.addArc(center: lastPoint, radius: radius, startAngle: 2*CGFloat(Float.pi), endAngle: 0, clockwise: true)
        context.drawPath(using: .eoFillStroke)
        
        
    }
}
