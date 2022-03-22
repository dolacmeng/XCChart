//
//  XCCharSetting.swift
//  XCCharts
//
//  Created by Jack on 2021/8/13.
//

import UIKit

public enum ValueType {
    case percent
    case value
}

public class XCCharSetting: NSObject {
    
    // xy轴相关
    public var axisLineColor = UIColor.lightGray
    public var axisLineWidth = CGFloat(0.5)
    public var axisSelectedLineColor = UIColor.lightGray
    
    // xy轴标签相关
    public var labelFont = UIFont.systemFont(ofSize: 10.0)
    public var labelTextColor = UIColor.gray
    public var labelSelectedTextColor = UIColor.black

    /// y轴标签宽度
    public var labelWidth = CGFloat(30)
    /// x轴标签高度
    public var labelHeight = CGFloat(20)
    
    // 值类型 (value暂时XCBarCharView下才有效)
    public var valueType:ValueType = .percent

    // 四个方向的内间距
    public var padddingTop = CGFloat(40)
    public var padddingLeft = CGFloat(16)
    public var padddingBottom = CGFloat(20)
    public var padddingRight = CGFloat(16)
    
    // 坐标内的内边距
    public var axisPadddingLeft = CGFloat(10)
    public var axisPadddingRight = CGFloat(10)

    // 柱状相关
    public var barWidth = CGFloat(8)
    public var barColor = UIColor(red: 109/255.0, green: 121/255.0, blue:254/255.0, alpha: 1.0)
    public var compareBarColor = UIColor(red: 237/255.0, green: 240/255.0, blue:250/255.0, alpha: 1.0)
    public var compareLineColor = UIColor(red: 237/255.0, green: 240/255.0, blue:250/255.0, alpha: 1.0)
    public var segmentColors = [UIColor(red: 109/255.0, green: 121/255.0, blue:254/255.0, alpha: 1.0),UIColor(red: 174/255.0, green: 180/255.0, blue:1.0, alpha: 1.0),UIColor(red: 1.0, green: 208/255.0, blue:111/255.0, alpha: 1.0),UIColor(red: 237/255.0, green: 240/255.0, blue:255.0/250.0, alpha: 1.0)]
    
    public var lineFillColor:UIColor = UIColor(red: 24/255.0, green: 24/255.0, blue:38/255.0, alpha: 1.0)

    // 动画
    public var animate = true
    
}
