//
//  itemTop.swift
//  bbm
//
//  Created by songgc on 16/3/29.
//  Copyright © 2016年 sprin. All rights reserved.
//

import Foundation

class itemTop: NSObject {
    
    var order:String = ""
    var username:String = ""
    var score:String = ""
    var nums:String = ""
    
    init(order:String,username:String, score:String, nums:String)
    {
        self.order = order
        self.username = username
        self.score = score
        self.nums = nums
    }
    
}
