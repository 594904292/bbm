//
//  itemDaymic.swift
//  bbm
//
//  Created by ericsong on 15/12/10.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class itempl: NSObject {
    var id: String = ""
    var userid: String = ""
    var username: String = ""
    var headface: String = ""
    var content: String = ""
    var actiontime: String = ""
    
    init(id:String,userid: String,username: String,headafce: String,actiontime: String,content:String) {
        self.id=id
        self.userid = userid
        self.username = username
        self.headface = headafce
        self.actiontime = actiontime
        self.content = content
    }
    
}
