//
//  XCCharSection.swift
//  XCCharts
//
//  Created by Jack on 2021/8/15.
//

import UIKit

public class XCCharSection: NSObject {
    var min:CGFloat = 0
    var max:CGFloat = 0
    
    public init(min:CGFloat,max:CGFloat) {
        super.init()
        self.min = min
        self.max = max
    }
    
    public init(min:Int,max:Int) {
        super.init()
        self.min = CGFloat(min)
        self.max = CGFloat(max)
    }
    
}
