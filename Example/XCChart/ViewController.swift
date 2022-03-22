//
//  ViewController.swift
//  XCChart
//
//  Created by JackXu on 03/15/2022.
//  Copyright (c) 2022 JackXu. All rights reserved.
//

import UIKit
import XCChart

class ViewController: UIViewController {
    let values = [CGFloat(15),CGFloat(40),CGFloat(60),CGFloat(100),CGFloat(120),CGFloat(60),CGFloat(70)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        scrollView.backgroundColor = .lightGray
        scrollView.contentSize = CGSize(width: view.bounds.size.width, height: 2000)
        view.addSubview(scrollView)
        
        let setting = XCCharSetting()
        setting.padddingTop = 60
        setting.valueType = .value
                
        // 标准的柱状图
        let barview = XCBarCharView(frame: CGRect(x: 16, y: 40, width: view.frame.size.width-32, height: 246), setting: setting)
        barview.charDatasource = self
        barview.layer.cornerRadius = 10
        barview.layer.masksToBounds  = true
        barview.xAxisTitles = ["一","二","三","四","五","六","日"]
        barview.yAxisTitles = ["10","20","30","60","100","120"]
        barview.values = values
        scrollView.addSubview(barview)

        // y开始不在0点的柱状图
        let sectionView = XCSectionCharView(frame: CGRect(x: 16, y: 300, width: view.frame.size.width-32, height: 246), setting: setting)
        sectionView.charDatasource = self
        sectionView.layer.cornerRadius = 10
        sectionView.layer.masksToBounds  = true
        sectionView.xAxisTitles = ["一","二","三","四","五","六","日"]
        sectionView.yAxisTitles = ["10:00","08:00","06:00","04:00","02:00","00:00","22:00"]
//        sectionView.yAxisTitles = ["0","20","40","60","80","100"]
        sectionView.values = [XCCharSection(min: 20, max: 60),XCCharSection(min: 40, max: 60),XCCharSection(min: 30, max: 80),XCCharSection(min: 20, max: 70),XCCharSection(min: 10, max: 40),XCCharSection(min: 50, max: 80),XCCharSection(min: 20, max: 60)]
        scrollView.addSubview(sectionView)
        
        // y开始不在0点,并且有多个数据的柱状图
        let sectionsView = XCSectionsBarCharView(frame: CGRect(x: 16, y: 570, width: view.frame.size.width-32, height: 246), setting: setting)
        sectionsView.charDatasource = self
        sectionsView.layer.cornerRadius = 10
        sectionsView.layer.masksToBounds  = true
        sectionsView.xAxisTitles = ["一","二","三","四","五","六","日"]
        sectionsView.yAxisTitles = ["00","20","40","60","80","100"]
        sectionsView.values = [[XCCharSection(min: 20, max: 30),XCCharSection(min: 50, max: 80)],
                               [XCCharSection(min: 40, max: 60)],
                               [XCCharSection(min: 10, max: 15),XCCharSection(min: 20, max: 21),XCCharSection(min: 80, max: 90)],
                               [XCCharSection(min: 20, max: 60)],
                               [XCCharSection(min: 20, max: 60),XCCharSection(min: 20, max: 60)],
                               [XCCharSection(min: 20, max: 30),XCCharSection(min: 60, max: 90)],
                               [XCCharSection(min: 50, max: 60),XCCharSection(min: 80, max: 100)]]
        scrollView.addSubview(sectionsView)
        
        // 多个累积数据的柱状图
        let segmentView = XCSegmentCharView(frame: CGRect(x: 16, y: 830, width: view.frame.size.width - 32, height: 246), setting: setting)
        segmentView.charDatasource = self
        segmentView.layer.cornerRadius = 10
        segmentView.layer.masksToBounds  = true
        segmentView.xAxisTitles = ["一","二","三","四","五","六","日"]
        segmentView.yAxisTitles = ["0H","3H","6H","9H"]
        //segmentView.values = [[50,0,0,0]]
        segmentView.values = [[8,16,32,10],[10,10,10,10],[60,10,10,0],[10,0,10,10],[20,20,20,6],[0,0,0,50],[50,0,0,0]]
        scrollView.addSubview(segmentView)
        
        
        // 多个对比柱状图
        let compareView = XCCompareBarCharView(frame: CGRect(x: 16, y: 1090, width: view.frame.size.width - 32, height: 246), setting: setting)
        compareView.charDatasource = self
        compareView.layer.cornerRadius = 10
        compareView.layer.masksToBounds  = true
        compareView.xAxisTitles = ["一","二","三","四","五","六","日"]
        compareView.yAxisTitles = ["0H","3H","6H","9H"]
        compareView.values = [[CGFloat(80),CGFloat(50)],[CGFloat(50),CGFloat(60)],[CGFloat(30),CGFloat(10)],[CGFloat(80),CGFloat(80)],[CGFloat(70),CGFloat(60)],[CGFloat(80),CGFloat(50)],[CGFloat(50),CGFloat(15)]]
        scrollView.addSubview(compareView)
        
        
        let lineView = XCLineCharView(frame: CGRect(x: 16, y: 1350, width: view.frame.size.width-32, height: 246), setting: setting)
        lineView.charDatasource = self
        lineView.layer.cornerRadius = 10
        lineView.layer.masksToBounds  = true
        lineView.xAxisTitles = ["01","","","","05","","","","","10","","","","","15","","","","","20","","","","","25","","","","","30"]
        lineView.yAxisTitles = ["0","20","40","60","80","100"]
        lineView.values = [[CGFloat(20),CGFloat(40),CGFloat(20),CGFloat(60),CGFloat(30),CGFloat(60),CGFloat(70),CGFloat(0),CGFloat(0),CGFloat(70),CGFloat(30),CGFloat(60),CGFloat(70),CGFloat(20),CGFloat(40),CGFloat(20),CGFloat(60),CGFloat(30),CGFloat(60),CGFloat(70),CGFloat(0),CGFloat(0),CGFloat(70),CGFloat(30),CGFloat(60),CGFloat(70),CGFloat(70),CGFloat(30),CGFloat(60),CGFloat(70)]]
        scrollView.addSubview(lineView)
        
    }


}

extension ViewController: XCCharViewDatasource {
    
    func getSelectedBubbleView(index: Int) -> UIView? {
        if index < 0 || index >= values.count {
            return UIView()
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 85, height: 38))
        view.backgroundColor = UIColor(red: 246.0/255.0, green: 247.0/255.0, blue: 252.0/255.0, alpha: 1.0)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        let dateLabel = UILabel(frame: CGRect(x: 8, y: 0, width: 77, height: 18))
        dateLabel.text = "2021年6月10日"
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textColor = UIColor.gray
        view.addSubview(dateLabel)
        
        let scoreLabel = UILabel(frame: CGRect(x: 8, y: 16, width: 77, height: 18))
        scoreLabel.text = "80分"
        scoreLabel.font = UIFont.systemFont(ofSize: 13)
        scoreLabel.textColor = UIColor(red: 0.09, green: 0.09, blue: 0.19, alpha: 1)
        view.addSubview(scoreLabel)
        
        scoreLabel.text = "\(values[index])"
        return view
    }
    
    
    
    
}


