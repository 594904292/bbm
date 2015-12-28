//
//  itemRecent.swift
//  bbm
//
//  Created by ericsong on 15/12/28.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class itemRecent: NSObject {
   
    var userid: String = ""
    var username: String = ""
    var usericon: String = ""
    var lastinfo: String = ""
    var lastchattimer: String = ""
    var messnum: String = ""
    var lastnickname: String = ""

    
    init(userid: String,username: String,usericon: String,lastinfo: String,lastchattimer:String,messnum:String,lastnickname:String) {
        self.userid=userid
        self.username = username
        self.usericon = usericon
        self.lastinfo = lastinfo
        self.lastchattimer = lastchattimer
        self.messnum = messnum
        self.lastnickname = lastnickname
    }
    

}
