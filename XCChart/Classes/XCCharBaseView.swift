//
//  XCCharBaseView.swift
//  XCCharts
//
//  Created by Jack on 2021/8/13.
//

import UIKit

public protocol XCCharViewDatasource:NSObjectProtocol {
    
    /// 点击数据时的气泡信息
    func getSelectedBubbleView(index:Int) -> UIView?
    
}

public class XCCharBaseView: UIView {
    
    let setting: XCCharSetting
    public var xAxisTitles:[String]?
    public var yAxisTitles:[String]?
    
    public var maxValue = 100.0
    public var minValue = 0.0
    public var selectedIndex = -1
    public weak var charDatasource:XCCharViewDatasource?
    
    /// 视图是否已经在屏幕展示过
    public var hadShow = true
    
    /// 是否是第一次绘制.防止点击显示数据时重复绘制
    public var isFirst = true

    public var axisHeight:CGFloat {
        get {
            return frame.size.height - setting.padddingTop - setting.padddingBottom - setting.labelHeight
        }
    }
    
    public var axisWidth: CGFloat {
        frame.size.width - setting.padddingLeft - setting.labelWidth - setting.padddingRight - setting.axisPadddingLeft - setting.axisPadddingRight
    }
    
    weak var bubble:UIView?

    public init(frame:CGRect,setting:XCCharSetting) {
        self.setting = setting
        super.init(frame: frame)
        backgroundColor = .white
        
    }

    
    required init?(coder: NSCoder) {
        self.setting = XCCharSetting()
        super.init(coder: coder)
    }
    
    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

//        renderAxisLine(context: context!)
        renderXAxisLabels(context: context)
        renderYAxisLabels(context: context)
        renderGridAxisLine(context: context)
        renderData(context: context)
        renderBubbleLine(context: context)
    }
    
    /// 绘制xy轴
    func renderAxisLine(context:CGContext) {
        context.saveGState()
        context.setStrokeColor(setting.axisLineColor.cgColor)
        context.setLineWidth(setting.axisLineWidth)
        context.setLineDash(phase: 0.0, lengths: [])
        
        // x轴
        let xAxisStart = CGPoint(x: setting.padddingLeft+setting.labelWidth, y: frame.size.height-setting.padddingBottom-10)
        let xAxisEnd = CGPoint(x: frame.size.width-setting.padddingLeft, y: xAxisStart.y)
        context.strokeLineSegments(between: [xAxisStart,xAxisEnd])
        
        //y轴
        let yAxisStart = CGPoint(x: setting.padddingLeft+setting.labelWidth, y: setting.padddingTop)
        let yAxisEnd = CGPoint(x: yAxisStart.x, y: frame.size.height-setting.padddingBottom-10)
        context.strokeLineSegments(between: [yAxisStart,yAxisEnd])
        context.restoreGState()
    }
    
    /// 绘制x轴标题
    func renderXAxisLabels(context: CGContext) {
        
        guard let xAxisTitles = xAxisTitles else {
            return
        }
        
        let paraStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paraStyle.alignment = .center
        let labelAttrs: [NSAttributedString.Key : Any] = [.font: setting.labelFont,
                                                         .foregroundColor: setting.labelTextColor,
                                                         .paragraphStyle: paraStyle]
        let selectedAttrs: [NSAttributedString.Key : Any] = [.font: setting.labelFont,
                                                            .foregroundColor: setting.labelSelectedTextColor,
                                                            .paragraphStyle: paraStyle]
        
        let itemW = (axisWidth) / CGFloat(xAxisTitles.count)
        let y = frame.size.height - setting.padddingBottom - setting.labelHeight + 10
        // 如果超过10个,让label宽度大点,保证可以显示完整文字
        let addW = xAxisTitles.count > 10 ? CGFloat(10) : CGFloat(0)
        for (index,item) in xAxisTitles.enumerated() {
            let x = setting.padddingLeft + setting.axisPadddingLeft + setting.labelWidth + CGFloat(index) * itemW
            let textRect: CGRect = CGRect(x: x-addW*0.5, y: y, width: itemW+addW, height: setting.labelHeight)
            if item.count > 0 {
                item.draw(in: textRect, withAttributes: ((index == selectedIndex) ?  selectedAttrs : labelAttrs))
            }
        }
    }
    
    /// 绘制y轴标题
    func renderYAxisLabels(context: CGContext) {
        
        guard let yAxisTitles = yAxisTitles,yAxisTitles.count > 1 else {
            return
        }
        
        let labelAttrs: [NSAttributedString.Key : Any] = [.font: setting.labelFont,
                                                         .foregroundColor: setting.labelTextColor]
        let itemH = axisHeight / CGFloat(yAxisTitles.count-1)
        for (index,item) in yAxisTitles.enumerated() {
            let itemY =  (axisHeight + setting.padddingTop) - CGFloat(index) * itemH - 6;
            let textRect: CGRect = CGRect(x: setting.padddingLeft, y:itemY, width: setting.labelWidth, height: setting.labelHeight)
            item.draw(in: textRect, withAttributes: labelAttrs)
        }
    }

    
    /// 绘制水平网格线
    func renderGridAxisLine(context:CGContext) {
        guard let yAxisTitles = yAxisTitles,yAxisTitles.count > 1 else {
            return
        }
        
        context.saveGState()
        context.setStrokeColor(setting.axisLineColor.cgColor)
        context.setLineWidth(setting.axisLineWidth)
        context.setLineDash(phase: CGFloat(5), lengths: [CGFloat(5)])

        // x轴
        let itemH = (axisHeight) / CGFloat(yAxisTitles.count-1)
        for (index,_) in yAxisTitles.enumerated() {
            let itemY =  (axisHeight + setting.padddingTop) - CGFloat(index) * itemH;
            let xAxisStart = CGPoint(x: setting.padddingLeft+setting.labelWidth, y: itemY)
            let xAxisEnd = CGPoint(x: frame.size.width-setting.padddingLeft, y: itemY)
            context.strokeLineSegments(between: [xAxisStart,xAxisEnd])
        }
        context.restoreGState()
    }
    
    /// 绘制连接气泡的虚线
    func renderBubbleLine (context:CGContext) {
        context.saveGState()
        if selectedIndex >= 0 ,bubble != nil{
            context.setStrokeColor(setting.axisSelectedLineColor.cgColor)
            context.setLineWidth(1)
            context.setLineDash(phase: CGFloat(0), lengths: [])

            let itemW = axisWidth / CGFloat(allValues().count)
            let x =  setting.padddingLeft + setting.axisPadddingLeft + setting.labelWidth + (CGFloat(selectedIndex) + 0.5) * itemW
            let y = setting.padddingTop - 8
            
            let start = CGPoint(x: x, y: y)
            let end = CGPoint(x: x, y: axisHeight+setting.padddingTop)
            context.strokeLineSegments(between: [start,end])
        }
        context.restoreGState()
        
    }
    
    /// 绘制数据（子类实现）
    func renderData(context:CGContext) {
        
    }

    /// 动画(子类实现)
    func beginAnimate() {
        
    }

}


/// 手势相关
extension XCCharBaseView {
    
    /// 点击
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.randomElement()
        if let point = touch?.location(in: self){
            clickAt(point: point)
        }
    }
    
    /// 点击事件(子类处理)
    @objc func clickAt(point:CGPoint) {
        showBubble()
        setNeedsDisplay()
    }
    
    /// 显示信息气泡
    public func showBubble () {
        self.bubble?.removeFromSuperview()
        self.bubble = nil
        if let bubble = self.charDatasource?.getSelectedBubbleView(index:selectedIndex) {
            let itemW = axisWidth / CGFloat(allValues().count)
            var x =  setting.padddingLeft + setting.axisPadddingLeft + setting.labelWidth + (CGFloat(selectedIndex) + 0.5) * itemW
            
            // 如果超出右边界,左移动
            let xMore = (x + bubble.frame.size.width*0.5) - self.frame.size.width
            if xMore > 0 {
                x = x - xMore - 4
            }
            
            let y = (bubble.frame.size.height+setting.padddingTop)*0.5
            bubble.center = CGPoint(x: x, y: y)
            addSubview(bubble)
            self.bubble = bubble
        }else{
            selectedIndex = -1
        }
    }
    
    // 隐藏信息气泡
    public func hideBubble() {
        self.bubble?.removeFromSuperview()
        self.bubble = nil
        selectedIndex = -1
        setNeedsDisplay()
    }
    
        
    @objc func allValues() -> [Any] {
        return Array()
    }
}


/// private method
extension XCCharBaseView {
    
    /// 获取总高度，和根据百分比获取单个高度
    func getTotalAndItemHeigh(value:CGFloat) -> (CGFloat,CGFloat) {
        // 100%时的高度
        let totalH = frame.size.height - setting.padddingTop - setting.padddingBottom - setting.labelHeight
        // 取值区间（0-100）
        let valueDistance = maxValue - minValue
        // 实际高度
        let itemH =  totalH * (value / CGFloat(valueDistance));
        return (itemH,totalH)
    }
    
    // 获取单个数据宽度
    func getItemW(total:Int) -> CGFloat{
        let itemW = (frame.size.width - setting.padddingLeft - setting.axisPadddingLeft  - setting.axisPadddingRight - setting.padddingRight - setting.labelWidth) / CGFloat(total)
        return itemW
    }

    
    
}

