//
//  itemMess.swift
//  bbm
//
//  Created by ericsong on 15/10/15.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class xiaoquItem: NSObject {
    var id: String = ""
    var name: String = ""
    var address: String = ""
    var lat: String = ""
    var lng: String = ""
    var pic: String = ""
    var business: String = ""
    var develop: String = ""
    var propertymanagement: String = ""
    var propertytype: String = ""
    var homenumber: String = ""
    var buildyear: String = ""
    
    
   
    
    init(id: String,name: String,address: String,lat: String,lng:String,pic:String,business:String,develop:String,propertymanagement:String,propertytype:String,homenumber:String,buildyear:String) {
        self.id = id
        self.name = name
        self.address = address
        self.lat = lat
        self.lng = lng
        self.pic = pic
        self.business = business
        self.develop = develop
        self.propertymanagement = propertymanagement
        self.propertytype = propertytype
        self.homenumber = homenumber
        self.buildyear = buildyear
    }
    
}
