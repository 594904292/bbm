//
//  UserInfo.swift
//  bbm
//
//  Created by ericsong on 15/10/16.
//  Copyright © 2015年 sprin. All rights reserved.
//



import Foundation

/*
用户信息类
*/
class UserInfo:NSObject
{
    var username:String = ""
    var avatar:String = ""
    
    init(name:String, logo:String)
    {
        self.username = name
        self.avatar = logo
    }
}