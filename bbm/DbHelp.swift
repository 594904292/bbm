//
//  DbHelp.swift
//  bbm
//
//  Created by ericsong on 15/10/10.
//  Copyright © 2015年 sprin. All rights reserved.
//

import Foundation

class DbHelp
{
    func initdb()
    {
        //获取数据库实例
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        
        let sql0:NSString = "create table IF NOT EXISTS interest(_id integer primary key autoincrement, interestname varchar(20), imageurl varchar(20), weather varchar(20), temp varchar(20))";
        db.execute(sql0  as String);
        
        
        let sql:NSString = "create table  IF NOT EXISTS [user] (id integer primary key autoincrement,userid varchar(20),nickname varchar(20),password varchar(20),telphone varchar(2),headface varchar(2),pass BOOLEAN  NULL,online BOOLEAN  NULL)";
        db.execute(sql  as String);
        
        
        let sql1:NSString  = "create table  IF NOT EXISTS [xiaoqu] (_id integer primary key autoincrement, xiaoquname varchar(20))";
        db.execute(sql1  as String);
        
        
        
        let sql2:NSString = "create table  IF NOT EXISTS [messagegz] (_id integer primary key autoincrement, infoid varchar(50), userid varchar(50))";
        db.execute(sql2  as String);
        
        
        
        let sql3:NSString = "create table  IF NOT EXISTS [messagebm] (_id integer primary key autoincrement, infoid varchar(50), userid varchar(50))";
        db.execute(sql3  as String);
        
        
        
        let sql4:NSString = "CREATE table IF NOT EXISTS [message] (_id INTEGER PRIMARY KEY AUTOINCREMENT, "
            
            + "senduserid varchar(20), "
            
            + "sendnickname varchar(50), "
            
            + "community varchar(200), "
            
            + "address varchar(200), "
            
            + "lng varchar(20), "
            
            + "lat varchar(20), "
            
            + "guid varchar(100), "
            
            + "infocatagroy varchar(20), "
            
            + "message varchar(200), "
            
            + "icon   varchar(200), "
            
            + "date varchar(20) , "
            
            + "is_coming integer ,"//判断是否自己
            
            + "readed integer)";
        
        db.execute(sql4 as String)
        
        
        
        
        
        let sql5:NSString = "CREATE table IF NOT EXISTS [chat] (_id INTEGER PRIMARY KEY AUTOINCREMENT, "
            
            + "guid varchar(100), " //GUID服务器上唯一标识
            
            + "senduserid varchar(20), " //发送人id
            
            + "sendnickname varchar(50), " //发送人
            
            + "sendusericon varchar(200), " //发送人头像
            
            + "touserid varchar(20), " //发送人id
            
            + "tonickname varchar(50), " //发送人
            
            + "tousericon varchar(200), " //发送人头像
            
            + "message varchar(200), " //正文
            
            + "date varchar(20) , "//日期
            
            + "readed integer)";
        
        db.execute(sql5 as String);
        
        
        
        
        
        let sql6 = "CREATE table IF NOT EXISTS [notice] (_id INTEGER PRIMARY KEY AUTOINCREMENT, "
            
            + "date varchar(100), " //提醒时间
            
            + "catagory varchar(20), " //提醒类别
            
            + "relativeid varchar(50), " //关联id
            
            + "content varchar(20), " //内容
            
            + "readed integer)";
        
        db.execute(sql6 as String);//
        
        
        
        let sql7 = "CREATE table IF NOT EXISTS [notice] (_id INTEGER PRIMARY KEY AUTOINCREMENT, "
            
            + "userid varchar(100), "
            
            + "nickname varchar(100), "
            
            + "usericon varchar(100), "
            
            + "lastuserid varchar(100), "
            
            + "lastnickname varchar(100), "
            
            + "lastusericon varchar(100), "
            
            + "lastinfo varchar(100), "
            
            + "lastime varchar(100), "
            
            + "messnum integer)";
        
        db.execute(sql7 as String);//
        
    
        
    }

}