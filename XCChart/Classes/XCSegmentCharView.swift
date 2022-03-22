//
//  XCSegmentCharView.swift
//  XCCharts
//
//  Created by Jack on 2021/8/15.
//

import UIKit

public class XCSegmentCharView: XCCharBaseView {

    public var values:[[CGFloat]]?

    
    public override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        renderData(context: context!)
        
    }
    
    /// 绘制数据
    override func renderData(context:CGContext) {
        
        if !hadShow {return}
        
        if !isFirst {return}

        guard let values = values,maxValue > minValue else {
            return
        }
        
        let itemW = getItemW(total:values.count)
        for (index,value) in values.enumerated() {
            let x = setting.padddingLeft + setting.axisPadddingLeft + setting.labelWidth + itemW * CGFloat(index)
            let total = getTotalAndItemHeigh(value: 0).1

            let itemLayer =  XCCharSegmentLayer(setting: self.setting, index: index, value: value)
            itemLayer.frame = CGRect(x: x, y: self.setting.padddingTop, width: itemW, height: total)
            itemLayer.axisHeight = self.frame.size.height
            self.layer.addSublayer(itemLayer)
            itemLayer.setNeedsDisplay()
            
            // 动画
            if self.setting.animate {
                let animation = CABasicAnimation.init(keyPath: "bounds.size.height")
                animation.fromValue = 0
                animation.toValue =  total
                animation.duration = 0
                animation.isRemovedOnCompletion = false
                animation.fillMode =  CAMediaTimingFillMode.forwards
                itemLayer.add(animation, forKey: "path")
                itemLayer.setNeedsDisplay()
            }else{
                
            }
            
        }
        isFirst = false
    }
    
}


/// 点击相关
extension XCSegmentCharView {
    
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
