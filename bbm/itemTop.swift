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
    var userid:String = ""
    var username:String = ""
     var headface:String = ""
    var score:String = ""
    var nums:String = ""
    
    init(order:String,userid:String,username:String,headface:String, score:String, nums:String)
    {
        self.order = order
        self.userid = userid
        self.username = username
        self.headface = headface
        self.score = score
        self.nums = nums
    }
    
}
