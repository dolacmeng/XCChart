//
//  XCCharSegmentLayer.swift
//  XCCharts
//
//  Created by Jack on 2021/8/16.
//

import UIKit

public class XCCharSegmentLayer: CALayer {

    let setting: XCCharSetting?
    let index:Int
    let value:[CGFloat]?
    var axisHeight = CGFloat(0)
    
    init(setting:XCCharSetting,index:Int,value:[CGFloat]) {
        self.setting = setting
        self.index = index
        self.value = value
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.setting = nil
        index = 0
        value = nil
        super.init(coder: coder)
    }
    
    public override func draw(in context: CGContext) {
        
        guard let setting = setting,let value = value else {
            return
        }
        
        context.setLineWidth(setting.barWidth)
        context.setLineDash(phase: 0, lengths: [])

        let x = frame.size.width * 0.5
        let total = frame.size.height
        var segmentTotalH = CGFloat(0)
        var currentPoint = CGPoint(x: x, y: total)
        context.move(to: currentPoint)

        for (segmentIndex,segmentValue) in value.enumerated() {
            let segmentH = getTotalAndItemHeigh(value: segmentValue).0
            segmentTotalH += segmentH
            let segmentPonit = CGPoint(x: currentPoint.x, y: currentPoint.y - segmentH)
            context.setStrokeColor(setting.segmentColors[segmentIndex].cgColor)
            context.strokeLineSegments(between: [currentPoint,segmentPonit])
            currentPoint = segmentPonit
        }
        
        // 圆角
        let maskLayer = CAShapeLayer()
        let rectPath = UIBezierPath(roundedRect: CGRect(x: (frame.width-setting.barWidth)*0.5, y: total-segmentTotalH, width: setting.barWidth, height: segmentTotalH), byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: setting.barWidth*0.5, height: setting.barWidth*0.5))
        maskLayer.path = rectPath.cgPath
        mask = maskLayer
    }
    
    func getTotalAndItemHeigh(value:CGFloat) -> (CGFloat,CGFloat) {
        guard let setting = setting else {
            return (CGFloat(0),CGFloat(0))
        }
        // 100%时的高度
        let totalH = axisHeight - setting.padddingTop - setting.padddingBottom - setting.labelHeight
        // 取值区间（0-100）
        // let valueDistance = maxValue - minValue
        // 实际高度
        let itemH =  totalH * (value / CGFloat(100));
        return (itemH,totalH)
    }
    
    

}
