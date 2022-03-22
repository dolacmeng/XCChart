//
//  XCSectionCharView.swift
//  XCCharts
//
//  Created by Jack on 2021/8/15.
//

import UIKit

public class XCSectionCharView: XCCharBaseView {

    public var values:[XCCharSection]?
    
    public override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        renderData(context: context!)
        
    }
    
    /// 绘制数据
    override func renderData(context:CGContext) {
        
        if !hadShow {return}
        
        // 只绘制一次
        if !isFirst {return}
        
        guard let values = values,maxValue > minValue else {
            return
        }
        
        // 遍历绘制单个数据
        let itemW = getItemW(total:values.count)
        for (index,value) in values.enumerated() {
            
            if value.min == value.max {
                continue
            }
                        
            let x = setting.padddingLeft + setting.axisPadddingLeft + setting.labelWidth + itemW * 0.5 + itemW * CGFloat(index)
            let total = getTotalAndItemHeigh(value: value.min).1
            let minY = total + setting.padddingTop - getTotalAndItemHeigh(value: value.min).0 - (setting.barWidth * 0.5)
            let maxY = total + setting.padddingTop - getTotalAndItemHeigh(value: value.max).0 + (setting.barWidth * 0.5)
            let minXY = CGPoint(x: x, y: minY)
            let maxXY = CGPoint(x: x, y: maxY)
            
            let path = UIBezierPath()
            path.move(to: minXY)
            path.addLine(to: maxXY)
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.strokeColor = setting.barColor.cgColor
            layer.lineWidth = setting.barWidth
            layer.lineCap = CAShapeLayerLineCap.round
            layer.strokeEnd = 0
            self.layer.addSublayer(layer)
            
            // 动画
            if setting.animate {
                let animation = CABasicAnimation.init(keyPath: "strokeEnd")
                animation.fromValue = 0
                animation.toValue = 1
                animation.duration = 0
                animation.beginTime = CACurrentMediaTime() + 0.8
                animation.isRemovedOnCompletion = false
                animation.fillMode = CAMediaTimingFillMode.forwards
                layer.add(animation, forKey: "strokeEnd")
            }else {
                layer.strokeEnd = 1
            }
            

        }
        isFirst = false
    }
    
}

/// 点击相关
extension XCSectionCharView {
    
    override func clickAt(point:CGPoint) {
        guard let values = values else {
            return
        }
        
        let react = CGRect(x: setting.padddingLeft + setting.labelWidth + setting.axisPadddingLeft, y: setting.padddingTop, width: self.frame.size.width-setting.padddingLeft-setting.padddingRight-setting.labelWidth-setting.axisPadddingLeft-setting.axisPadddingRight, height: self.frame.size.height-setting.padddingTop-setting.padddingBottom-setting.labelHeight)
        
        if react.contains(point) {
            let itemW = getItemW(total:values.count)
            let realX = point.x - setting.padddingLeft - setting.axisPadddingLeft - setting.labelWidth
            let index = Int(floor(realX / itemW))
            
            if selectedIndex == index {
                hideBubble()
            }else {
                selectedIndex = index
                super.clickAt(point: point)
            }
        }
        
    }
    
    override func allValues() -> [Any] {
        return values ?? Array()
    }
    
}
