//
//  XMPPManager.swift
//  bbm
//
//  Created by ericsong on 15/12/21.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class XMPPManager: NSObject ,XMPPStreamDelegate {
    //定义通讯通道
    var stream:XMPPStream = XMPPStream()
    //定义花名册
    var roster:XMPPRoster?
    var password:String?
    class func shareWithXMPPManager()->XMPPManager {
        struct StaticStruct{
            static var predicate:dispatch_once_t = 0;
            static var xmppManager:XMPPManager? = nil;
        }
        dispatch_once(&StaticStruct.predicate, { () -> Void in
            StaticStruct.xmppManager = XMPPManager();
            StaticStruct.xmppManager?.manageStreamAndRoster();
        });
        
        return StaticStruct.xmppManager!;
    }
    func manageStreamAndRoster(){
        self.stream.hostName = "101.200.194.1";
        self.stream.hostPort = UInt16(5222);
        self.stream.addDelegate(self, delegateQueue: dispatch_get_main_queue());
        
        var rosterStorage111:XMPPRosterCoreDataStorage = XMPPRosterCoreDataStorage.sharedInstance();
        self.roster = XMPPRoster(rosterStorage: rosterStorage111, dispatchQueue: dispatch_get_main_queue());
        self.roster!.addDelegate(self, delegateQueue: dispatch_get_main_queue());
    }
    //设置登录操作
    func loginWithUserNameAndPassword(userName:String,password:String){
        self.password = password;
       // var jid:XMPPJID = XMPPJID.jidWithUser(userName, domain: Domine, resource: Resource) as XMPPJID;
        var jid:XMPPJID = XMPPJID.jidWithUser(userName as String, domain: "bbxiaoqu", resource: "ios") as XMPPJID;
        self.stream.myJID = jid;
        self.connectToServer();
    }
    //设置与服务器的连接
    func connectToServer(){
        if self.stream.isConnecting() || self.stream.isConnected(){
            self.disconnectWithServer();
        }
        do {
            try self.stream.connectWithTimeout(5000)
        } catch {
            
        }
    }
    //断开与服务器的连接
    func disconnectWithServer(){
        var presence:XMPPPresence = XMPPPresence(type: "available");
        self.stream.sendElement(presence);
        self.stream.disconnect();
    }
    
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        var haveLogin:NSNumber = NSUserDefaults.standardUserDefaults().objectForKey("haveLogin") as! NSNumber;
        if !haveLogin.boolValue{
            return;
        }
        var presence:XMPPPresence = XMPPPresence(type: "available");
        self.stream.sendElement(presence);
    }
    func xmppStreamDidConnect(sender: XMPPStream!) {
        do {
            try self.stream.authenticateWithPassword(self.password)
        } catch {
           
        }
    }
    
    func xmppStream(sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        var alter:UIAlertView = UIAlertView(title: "提示", message: "密码验证失败!", delegate: nil, cancelButtonTitle: "取消");
        alter.show();
    }
    func xmppStreamConnectDidTimeout(sender: XMPPStream!) {
        var alter:UIAlertView = UIAlertView(title: "对不起", message: "连接超时!", delegate: nil, cancelButtonTitle: "取消");
        alter.show();
    }
    
    func unreadnum(userid:String,catagory:String)->Int
    {
         var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql="select * from notice where relativeid='"+userid+"' and readed=0 and catagory='"+catagory+"'";
        NSLog(sql)
        let mess = db.query(sql)
        return mess.count
     }
    
    func xmppStream(sender:XMPPStream ,didReceiveMessage message:XMPPMessage? ){
                if message != nil {
                    print(message)
                    
                    
                    let defaults = NSUserDefaults.standardUserDefaults();
                    let touserid = defaults.stringForKey("userid")
                    let tonickname = defaults.objectForKey("nickname") as! String;
                    let tousericon = defaults.objectForKey("headface") as! String;
                    
                    var cont:String = message!.elementForName("body").stringValue();
                    var from:String = message!.attributeForName("from").stringValue();
        
                    var date = NSDate()
                    var timeFormatter = NSDateFormatter()
                    timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss.SSS" //(格式可俺按自己需求修整)
                    var strNowTime = timeFormatter.stringFromDate(date) as String
        
                    var msg:Message = Message(content:cont,sender:from,ctime:strNowTime)
                    var db: SQLiteDB!
                    db = SQLiteDB.sharedInstance()
                    let sql = "insert into chat(message,guid,date,senduserid,sendnickname,sendusericon,touserid,tonickname,tousericon) values('\(cont)','','\(date)','\(from)','\(from)','\(from)','\(touserid)','\(tonickname)','\(tousericon)')";
                    //私信
                    
                    //通知
                    
                    //朋友
                    
        
                    //消息委托(这个后面讲)
                    //send("369",to: "18600888703",mess: "11111");
                }
    }
    
    
//    func send(send:String,to:String,mess:String)
//        {
//    
//                //XMPPFramework主要是通过KissXML来生成XML文件
//                //生成<body>文档
//                let body:DDXMLElement = DDXMLElement.elementWithName("body") as! DDXMLElement
//                body.setStringValue(mess)
//    
//                //生成XML消息文档
//                let mes:DDXMLElement = DDXMLElement.elementWithName("message") as! DDXMLElement
//                //消息类型
//                mes.addAttributeWithName("type",stringValue:"chat")
//                //发送给谁
//                mes.addAttributeWithName("to" ,stringValue:"369@bbxiaoqu")
//                //由谁发送
//                mes.addAttributeWithName("from" ,stringValue:"888@bbxiaoqu")
//                //组合
//                mes.addChild(body)
//    
//    
//                print(mes)
//                //发送消息
//                self.stream.sendElement(mes)
//            
//            
//        }


}
