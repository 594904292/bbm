//
//  sqlitehelp.swift
//  bbm
//
//  Created by ericsong on 16/1/6.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class sqlitehelp: NSObject {

    class func shareInstance()->sqlitehelp{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:sqlitehelp? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=sqlitehelp()
            }
        )
        return YRSingleton.instance!
    }
    
    /*朋友*/
    
    func isexitfriend(userid:String)->Bool
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql="select * from friend where userid='"+userid+"'";
        NSLog(sql)
        let mess = db.query(sql)
        if( mess.count>0)
        {
            return true
        }
        else
        {
            return false
        }
    }

    
    func addfriend(userid:String,nickname:String,usericon:String,lastuserid:String,lastnickname:String,lastinfo:String,lasttime:String,messnum:Int)
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql = "insert into friend(userid,nickname,usericon,lastuserid,lastnickanme,lastinfo,lasttime,messnum) values('\(userid )','\(nickname)','\(usericon)','\(lastuserid)','\(lastnickname)','\(lastinfo)','\(lasttime)','\(messnum)')";
        db.execute(sql)
        
    }

    
    
    func updatefriendlastinfo(userid:String, lastuserid:String, lastinfo:String, lasttime:String)
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql = "update friend set lastuserid='\(lastuserid)',lastinfo='\(lastinfo)',lasttime='\(lasttime)' ,messnum=messnum+1 where userid='\(userid)'";
        db.execute(sql)
        
    }
    /*通知*/
       
    func addnotice(date:String, catagory:String, relativeid:String, content:String, readed:String)
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql = "insert into notice(date,catagory,relativeid,content,readed) values('\(date)','\(catagory)','\(relativeid)','\(content)','\(readed)')";
        db.execute(sql)
        
        
    }
    
    func updatenoticebyuserid( userid:String,  content:String)
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql = "update notice  set content='\(content)' where relativeid='\(userid)'";
        db.execute(sql)
        
        
    }
    
    
    
    func unreadnoticenum(userid:String,catagory:String)->Int
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql="select * from notice where relativeid='\(userid)' and readed=0 and catagory='\(catagory)'";
        NSLog(sql)
        let mess = db.query(sql)
        return mess.count
        
    }

    
    /*聊天*/

    func addchat(senduserid:String,touserid:String,message:String,guid:String,date:String,readed:String)
    {
        var sendnickname:String=loadusername(senduserid)
        var sendusericon:String=loadheadface(senduserid)
        
        var tonickname:String=loadusername(touserid)
        var tousericon:String=loadheadface(touserid)
        
        
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql = "insert into chat(senduserid,sendnickname,sendusericon,touserid,tonickname,tousericon,message,guid,date,readed) values('\(senduserid)','\(sendnickname)','\(sendnickname)','\(touserid)','\(tonickname)','\(tousericon)','\(message)','','\(date)','0')";
        db.execute(sql)
    }

    
    func addchat(messae:String,guid:String,date:String,senduserid:String,sendnickname:String,sendusericon:String,touserid:String,tousernickname:String,tousericon:String)
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql = "insert into chat(message,guid,date,senduserid,sendnickname,sendusericon,touserid,tonickname,tousericon) values('\(messae)','\(guid)','\(date)','\(senduserid)','\(sendnickname)','\(sendusericon)','\(touserid)','\(tousernickname)','\(tousericon)')";
        
        NSLog("sql: \(sql)")
        db.execute(sql)
    }

    
    func unreadchatnum(from:String,to:String)->Int
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql="select * from chat where senduserid='\(from)' and touserid='\(to)' and readed=0";
        NSLog(sql)
        let mess = db.query(sql)
        return mess.count
        
    }
    
    
    
    func unreadnumchat(from:String,to:String)->Int
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql="select count(*) as num1 from chat where senduserid='\(from)' and readed=0 and touserid='\(to)'";
        //NSLog(sql)
        let mess = db.query(sql)
        let item = mess[0] as SQLRow
        let num1 = item["num1"]!.asInt()
        return num1;
    }
    
    /*用户*/

     func loadusername(userid:String)->String
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql="select * from users where userid='"+userid+"'";
        //NSLog(sql)
        let mess = db.query(sql)
        if( mess.count>0)
        {
            let item = mess[0] as SQLRow
            return item["nickname"]!.asString()
        }
        else
        {
            return ""
        }
    }
    
    func loadheadface(userid:String)->String
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql="select * from users where userid='"+userid+"'";
        //NSLog(sql)
        let mess = db.query(sql)
        if( mess.count>0)
        {
            let item = mess[0] as SQLRow
            return item["usericon"]!.asString()
        }
        else
        {
            return ""
        }
    }
    
    func isexituser(userid:String)->Bool
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql="select * from users where userid='"+userid+"'";
        //NSLog(sql)
        let mess = db.query(sql)
        if( mess.count>0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    
    func addusers(userid:String,nickname:String,usericon:String)
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql = "insert into users(userid,nickname,usericon) values('\(userid )','\(nickname)','\(usericon)')"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql)
        
        print(result)
        NSLog(sql)
        
    }

    /*关注*/
    func removeallgz()->Bool
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql="delete from messagegz ";
        let result = db.execute(sql)
        return true
    }

    func getguids(userid:String)->String
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql="select * from messagegz where userid='"+userid+"'";
        //NSLog(sql)
        let mess = db.query(sql)
        
        var guids:String="";
        if(mess.count>0)
        {
            for i in 0...mess.count-1
            {
                let item = mess[i] as SQLRow
                let infoid = item["infoid"]!.asString()
                guids += "'".stringByAppendingString(infoid).stringByAppendingString("'")
                if(i<mess.count-1)
                {
                   guids += ","
                }
                
            }
        }
        return guids;
    }
    
    
    func addgz(infoid:String,userid:String)
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql = "insert into messagegz(infoid,userid) values('\(infoid )','\(userid)')"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql)
        
        print(result)
        NSLog(sql)
        
    }
    
    func removegz(infoid:String,userid:String)->Bool
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql="delete from messagegz where infoid='"+infoid+"' and userid='"+userid+"'";
        let result = db.execute(sql)
        return true
   }

    func isexitgz(infoid:String,userid:String)->Bool
    {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql="select * from messagegz where infoid='"+infoid+"' and userid='"+userid+"'";
        //NSLog(sql)
        let mess = db.query(sql)
        if( mess.count>0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    

    
}
