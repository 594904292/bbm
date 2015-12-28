//
//  itemDaymic.swift
//  bbm
//
//  Created by ericsong on 15/12/10.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class itemDaymic: NSObject {
    var id: String = ""
    var userid: String = ""
    var username: String = ""
    var actionname: String = ""
    var actiontime: String = ""
    var guid: String = ""
    var messdesc: String = ""
    
    init(id:String,userid: String,username: String,actionname: String,actiontime: String,guid:String,messdesc:String) {
        self.id=id
        self.userid = userid
        self.username = username
        self.actionname = actionname
        self.actiontime = actiontime
        self.guid = guid
        self.messdesc = messdesc
          }
    
}
