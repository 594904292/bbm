//
//  ItemBm.swift
//  bbm
//
//  Created by songgc on 16/3/30.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class ItemBm: NSObject {
    var id:String = ""
    var userid:String = ""
    var username:String = ""
    var headface:String = ""
    var telphone:String = ""
    var status:String = ""
    
    
    init(id:String,userid:String,username:String,telphone:String,headface:String,status:String)
    {
        self.id = id
        self.userid = userid
        self.username = username
        self.telphone = telphone
        self.headface = headface
        self.status = status
    }
    
}
