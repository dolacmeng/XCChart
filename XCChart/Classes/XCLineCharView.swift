//
//  XCLineCharView.swift
//  XCCharts
//
//  Created by Jack on 2021/8/18.
//

import UIKit

public class XCLineCharView: XCCharBaseView {
    
    var itemLayer:XCLineLayer?
    var itemLayer2:XCLineLayer?

    // 取值数组
    public var values:[[CGFloat]]?
    
    override func renderData(context:CGContext) {
        
        if !hadShow {return}
        
        // 只绘制一次
        if !isFirst {return}
        
        guard let values = values,maxValue > minValue else {
            return
        }

        let x = setting.padddingLeft + setting.axisPadddingLeft + setting.labelWidth
        let y = setting.padddingTop
        let width = frame.size.width - setting.padddingLeft - setting.labelWidth - setting.padddingRight - setting.axisPadddingLeft - setting.axisPadddingRight
        let height = bounds.size.height - setting.padddingTop - setting.padddingBottom - setting.labelHeight

        if values.count > 1 {
            itemLayer2 =  XCLineLayer(setting: setting, values:values[1] ,axisHeight:frame.size.height,color: setting.compareLineColor)
            itemLayer2!.frame = CGRect(x: x, y: y-4, width: width, height: height+4)
            layer.addSublayer(itemLayer2!)
            itemLayer2!.setNeedsDisplay()
        }
        if values.count > 0 {
            itemLayer =  XCLineLayer(setting: setting, values:values[0] ,axisHeight:frame.size.height,color: setting.barColor)
            itemLayer!.frame = CGRect(x: x, y: y-4, width: width, height: height+4)
            layer.addSublayer(itemLayer!)
            itemLayer!.setNeedsDisplay()
        }
        
        // 动画
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: height)).cgPath
        itemLayer?.mask = maskLayer
        
        let maskLayer2 = CAShapeLayer()
        maskLayer2.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: height)).cgPath
        itemLayer2?.mask = maskLayer2

        if setting.animate {
            let animation = CABasicAnimation.init(keyPath: "path")
            animation.fromValue = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 0, height: height)).cgPath
            animation.toValue = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: height)).cgPath
            animation.duration = 0
            animation.isRemovedOnCompletion = false
            animation.fillMode = CAMediaTimingFillMode.forwards
            itemLayer?.mask?.add(animation, forKey: "path")
            itemLayer2?.mask?.add(animation, forKey: "path")
        }
        

        isFirst = false
    }
}

/// 点击相关
extension XCLineCharView {
    
    override func clickAt(point:CGPoint) {
        guard let values = values?[0] else {
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
        return values?[0] ?? Array()
    }
    
}
