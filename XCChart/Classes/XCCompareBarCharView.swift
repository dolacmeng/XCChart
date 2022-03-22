//
//  XCCompareBarCharView.swift
//  XCCharts
//
//  Created by Jack on 2021/8/17.
//

import UIKit


//class XCCharCompare: NSObject {
//    var first:CGFloat = 0
//    var second:CGFloat = 0
//
//    init(first:CGFloat,second:CGFloat) {
//        super.init()
//        self.first = first
//        self.second = second
//    }
//
//    init(first:Int,second:Int) {
//        super.init()
//        self.first = CGFloat(first)
//        self.second = CGFloat(second)
//    }
//
//}

public class XCCompareBarCharView: XCCharBaseView {
    
    public var values:[[CGFloat]]?

    override func renderData(context:CGContext) {
        
        if hadShow == false {
            return
        }
        
        guard let values = values,maxValue > minValue else {
            return
        }
        
        // 绘制柱状
        let itemW = getItemW(total:values.count)
        for (index,value) in values.enumerated() {
            let totalCount = value.count
            for (itemIndex,itemValue) in value.enumerated() {
                
                if itemValue == 0 {
                    continue
                }
                
                let (itemH,totalH) = getTotalAndItemHeigh(value: itemValue)
                
                let x = setting.padddingLeft + setting.axisPadddingLeft + setting.labelWidth + CGFloat(index) * itemW + (itemW-setting.barWidth)*0.5 - (setting.barWidth * CGFloat(totalCount) * CGFloat(0.25)) + (setting.barWidth * CGFloat(itemIndex))
                let rect0 = CGRect(x: x , y: setting.padddingTop + totalH, width: setting.barWidth, height: 0)
                let rect = CGRect(x:  x, y: setting.padddingTop + totalH-itemH, width: setting.barWidth, height: itemH)
                
                let path0 = UIBezierPath.init(roundedRect: rect0, byRoundingCorners: [.topRight , .topLeft] ,cornerRadii: CGSize.init(width: setting.barWidth*0.5, height: setting.barWidth*0.5));
                let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: [.topRight , .topLeft] ,cornerRadii: CGSize.init(width: setting.barWidth*0.5, height: setting.barWidth*0.5));
                let layer = CAShapeLayer()
                layer.path = path0.cgPath
                layer.fillColor = itemIndex == 0 ? setting.compareBarColor.cgColor : setting.barColor.cgColor
                self.layer.addSublayer(layer)
                
                // 动画
                if setting.animate {
                    let animation = CABasicAnimation.init(keyPath: "path")
                    animation.fromValue = path0.cgPath
                    animation.toValue = path.cgPath
                    animation.duration = 0
                    animation.beginTime = CACurrentMediaTime() + 0.8
                    animation.isRemovedOnCompletion = false
                    animation.fillMode = CAMediaTimingFillMode.forwards
                    layer.add(animation, forKey: "path")
                }else{
                    layer.path = path.cgPath
                }
            }
        }
        isFirst = false

    }
}


/// 点击相关
extension XCCompareBarCharView {
    
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
