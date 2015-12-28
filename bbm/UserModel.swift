//
//  UserModel.swift
//  bbm
//
//  Created by ericsong on 15/12/22.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class UserModel : NSObject {
    var userName: String     ///< store user's name, optional
    var phone: String?       ///< store user's telephone number
    
    // designated initializer
    init(userName: String, userID: Int, phone: String?, email: String?) {
        self.userName = userName
        
        self.phone = phone
         
        super.init()
    }
}