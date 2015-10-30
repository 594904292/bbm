//
//  itemMess.swift
//  bbm
//
//  Created by ericsong on 15/10/15.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class itemMess: NSObject {
    var userid: String = ""
    var username: String = ""
    var time: String = ""
    var address: String = ""
    var content: String = ""
    var community: String = ""
    var lng: String = ""
    var lat: String = ""
    var guid: String = ""
    var infocatagory: String = ""
    var photo: String = ""
    var is_coming: String = ""
    var readed: String = ""
    
    var name:String
    {
        get{
            return username;
        }
    }
    
    init(userid:String,vname: String,vtime: String,vaddress: String,vcontent: String,vcommunity:String,vlng:String,vlat:String,vguid:String,vinfocatagory:String,vphoto:String,vis_coming:String,vreaded:String) {
        self.userid=userid
        self.username = vname
        self.time = vtime
        self.address = vaddress
        self.content = vcontent
        self.community = vcommunity
        self.lng = vlng
        self.lat = vlat
        self.guid = vguid
        self.infocatagory = vinfocatagory
        self.photo = vphoto
        self.is_coming = vis_coming
        self.readed = vreaded
    }
    
}
