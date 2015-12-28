//
//  Friends.swift
//  bbm
//
//  Created by ericsong on 15/12/23.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class Friends: NSObject {

    var userid:String = ""
    var username:String = ""
    var avatar:String = ""
    
    init(userid:String,name:String, logo:String)
    {
        self.userid = userid
        self.username = name
        self.avatar = logo
    }

}
