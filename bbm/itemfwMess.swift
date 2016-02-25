//
//  itemfwMess.swift
//  bbm
//
//  Created by ericsong on 15/10/15.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class itemfwMess: NSObject {
    var userid: String = ""
    var username: String = ""
    var time: String = ""
    var address: String = ""
    var fwname: String = ""
    var content: String = ""
    var community: String = ""
    var lng: String = ""
    var lat: String = ""
    var guid: String = ""
    var infocatagory: String = ""
    var photo: String = ""
    var status: String = ""
    var visnum: String = ""
    var plnum: String = ""
    
    var headface: String = ""
    var telphone: String = ""
    var zannum: String = ""
    var tags: String = ""
    
    var name:String
        {
        get{
            return username;
        }
    }
    
    init(userid:String,vname: String,vtime: String,vaddress: String,fwname:String,vcontent: String,vcommunity:String,vlng:String,vlat:String,vguid:String,vinfocatagory:String,vphoto:String,status:String,visnum:String,plnum:String,headface:String,telphone:String,zannum:String,tags:String) {
        self.userid=userid
        self.username = vname
        self.time = vtime
        self.address = vaddress
         self.fwname = fwname
        self.content = vcontent
        self.community = vcommunity
        self.lng = vlng
        self.lat = vlat
        self.guid = vguid
        self.infocatagory = vinfocatagory
        self.photo = vphoto
        self.status=status
        self.visnum = visnum
        self.plnum = plnum
        
        self.headface = headface
        self.telphone = telphone
        self.zannum = zannum
        self.tags = tags
    }
    
}
