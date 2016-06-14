//
//  Evaluate.swift
//  bbm
//
//  Created by songgc on 16/3/31.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class ItemEvaluate: NSObject {
    var id:String = ""
    var guid:String = ""
    var infouser:String = ""
    var username:String = ""
    var userid:String = ""
    var score:String = ""
    var evalute:String = ""
    var addtime:String = ""
    
    init(id:String,guid:String,infouser:String,username:String,userid:String,score:String,evalute:String,addtime:String)
    {
        self.id = id
        self.guid = guid
        self.infouser = infouser
        self.username=username
        self.userid = userid
        self.score = score
        self.evalute = evalute
        self.addtime = addtime
    }
    
}
