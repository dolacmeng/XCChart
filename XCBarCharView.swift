//
//  XCBarCharView.swift
//  XCCharts
//
//  Created by Jack on 2021/8/13.
//

import UIKit

public class XCBarCharView: XCCharBaseView {

    // 取值数组（百分比0-100）或与y对应的实际值,取值类型在setting中修改valueType
    public var values:[CGFloat]?
    override func renderData(context:CGContext) {
        
        if !hadShow {return}
        
        // 只绘制一次
        if !isFirst {return}
        
        guard let values = values,maxValue > minValue else {
            return
        }
        
        // 绘制柱状
        let itemW = getItemW(total:values.count)
        for (index,value) in values.enumerated() {
            let (itemH,totalH) =  setting.valueType == .percent ? getTotalAndItemHeigh(value: value) : getRealHeigh(value: value);
            
            let x = setting.padddingLeft + setting.axisPadddingLeft + setting.labelWidth + CGFloat(index) * itemW + (itemW-setting.barWidth)*0.5
            let rect0 = CGRect(x: x , y: setting.padddingTop + totalH, width: setting.barWidth, height: 0)
            let rect = CGRect(x:  x, y: setting.padddingTop + totalH-itemH, width: setting.barWidth, height: itemH)
            
            let path0 = UIBezierPath.init(roundedRect: rect0, byRoundingCorners: [.topRight , .topLeft] ,cornerRadii: CGSize.init(width: setting.barWidth*0.5, height: setting.barWidth*0.5));
            let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: [.topRight , .topLeft] ,cornerRadii: CGSize.init(width: setting.barWidth*0.5, height: setting.barWidth*0.5));
            let layer = CAShapeLayer()
            layer.path = path0.cgPath
            layer.fillColor = setting.barColor.cgColor
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
            }else {
                layer.path = path.cgPath
            }

        }
        isFirst = false
    }

    
    /// 获取实际高度
    func getRealHeigh(value:CGFloat) -> (CGFloat,CGFloat)  {
        guard let yAxisTitles = yAxisTitles,yAxisTitles.count > 0 else {
            return (0,0)
        }
        
        var realH  = CGFloat(0)
        // 100%时的高度
        let totalH = frame.size.height - setting.padddingTop - setting.padddingBottom - 20
        let sectionH = CGFloat(totalH) / CGFloat(yAxisTitles.count-1)
        
        // 取值区间
        let maxValue = CGFloat(Double(yAxisTitles.last ?? "0") ?? 0)
        let minValue = CGFloat(Double(yAxisTitles.first ?? "0") ?? 0)
        if value < minValue || value > maxValue {
            return (realH,totalH)
        }
        
        // 计算实际高度
        for (index,yValue) in yAxisTitles.enumerated() {
            if value == (CGFloat(Double(yValue) ?? 0)) {
                realH = sectionH * CGFloat(index)
                break
            }else if value > (CGFloat(Double(yValue) ?? 0)) {
                continue
            }
            
            // 只要value没超过上下界限,都能来到这
            let topLimit = CGFloat(Double(yValue) ?? 100)
            let lowerLimit = CGFloat(Double(yAxisTitles[index-1]) ?? 0)
            
            //小区间
            let section = topLimit - lowerLimit
            let littleH = (value - lowerLimit) / section * sectionH
            realH = sectionH * CGFloat((index-1)) + littleH
            break
        }
        
        return (realH,totalH)
    }

}


/// 点击相关
extension XCBarCharView {
    
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


extension UIView {
    
}
