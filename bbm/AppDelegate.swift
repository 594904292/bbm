//
//  AppDelegate.swift
//  bbm
//
//  Created by ericsong on 15/9/24.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,XMPPStreamDelegate{

    var window: UIWindow?
    var mapManager: BMKMapManager?
    //var xmppStream:XMPPStream?
    //var password:String = ""
   // var isOpen:Bool = false
    //var chatDelegate:ChatDelegate?
    //var messageDelegate:MessageDelegate?
    
    
    //通道
    var xs: XMPPStream?
    //服务器是否开启
    var isOpen = false
    //密码
    var pwd = ""
    
    //状态代理
    var ztdl : ZtDL?
    
    //消息代理
    var xxdl : XxDL?
    
    
//    func loadusername(userid:String) -> String
//    {
//        var username="";
//        var url_str:String = "http://api.bbxiaoqu.com/getuserinfo.php?userid=".stringByAppendingString(userid)
//        Alamofire.request(.POST,url_str, parameters:nil)
//            .responseJSON { response in
//                print(response.result.value)
//                if let JSON = response.result.value {
//                    print("JSON1: \(JSON.count)")
//                       username = JSON[0].objectForKey("username") as! String;
//                    
//                }
//        }
//        var flag:Int = 0
//        while(username.characters.count==0 && flag<10){
//            sleep(200)
//            flag++
//        }
//        return username;
//    }
//    
//    func loadheadface(userid:String) -> String
//    {
//        var headfaceurl="";
//        var url_str:String = "http://api.bbxiaoqu.com/getuserinfo.php?userid=".stringByAppendingString(userid)
//        Alamofire.request(.POST,url_str, parameters:nil)
//            .responseJSON { response in
//                print(response.result.value)
//                if let JSON = response.result.value {
//                    print("JSON1: \(JSON.count)")
//                    headfaceurl = JSON[0].objectForKey("headface") as! String;
//                    
//                }
//        }
//        var flag:Int = 0
//        while(headfaceurl.characters.count==0 && flag<10){
//            sleep(200)
//            flag++
//        }
//        return headfaceurl;
//    }

    
    //收到消息
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        //如果消息是聊天消息
        if message.isChatMessage() {
            var msg = WXMessage()
            
            //对方正在输入
            if message.elementForName("composing") != nil {
                msg.isComposing = true
            }
            
            //离线
            if message.elementForName("delay") != nil {
                msg.isDelay = true
            }
            
            //消息正文
            if let body = message.elementForName("body") {
                msg.body = body.stringValue()
            }
            var from = message.from().user ;
            var to = message.to().user;
            var guid =  message.elementID()
            //完整用户名
            msg.from = message.from().user + "@" + message.from().domain
            
            var touserid:String=message.to().user;
            
            
            var date = NSDate()
            var timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss" //(格式可俺按自己需求修整)
            var strNowTime = timeFormatter.stringFromDate(date) as String
            //cleanchat()
            
            
            var sqlitehelpInstance1=sqlitehelp.shareInstance()
            
            //写一条信息到聊天记录表
            sqlitehelpInstance1.addchat(from, touserid: to, message: msg.body, guid: "", date: strNowTime, readed: "0")
            //修改通知记录
            if(sqlitehelpInstance1.unreadnoticenum(from, catagory: "私信")==0)
            {
               sqlitehelpInstance1.addnotice(strNowTime, catagory: "私信", relativeid: from, content: from.stringByAppendingString("发送了一条私信"), readed: "０")
            }else
            {
//                let unreadchatnum:String=self.unreadchatnum(from, to: to) as! String
//                self.updateusercontent(from,content: from.stringByAppendingString("发送了").stringByAppendingString(unreadchatnum).stringByAppendingString("条私信"))
            }
            
            //添加朋友联系人
            if(!sqlitehelpInstance1.isexitfriend(from))
            {
               sqlitehelpInstance1.addfriend(from, nickname: "", usericon: "", lastuserid: from, lastnickname: "", lastinfo: msg.body, lasttime: strNowTime, messnum: 0)
                //更新头像和用户名
            
            }
            sqlitehelpInstance1.updatefriendlastinfo(from, lastuserid: from, lastinfo: msg.body, lasttime: strNowTime)
            //添加到消息代理中
            xxdl?.newMsg(msg)
            

        }
    }
    
//    func cleanchat()
//    {
//        var db: SQLiteDB! = SQLiteDB.sharedInstance()
//        let sql = "delete from chat";
//        db.execute(sql)
//        
//        let sql1 = "delete from users";
//        db.execute(sql1)
//
//        
//    }
    
    
    
    //收到状态
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        let myUser = sender.myJID.user
        //好友的用户名
        let user = presence.from().user
        //用户所在的域
        let domain = presence.from().domain
        //状态类型
        let pType = presence.type()
        //如果状态不是自己的
        if (user != myUser) {
            //状态保存的结构
            var zt = Zhuangtai()
            //保存了状态的完整用户名
            zt.name = user + "@" + domain
            //上线
            if pType == "available" {
                zt.isOnline = true
                ztdl?.isOn(zt)
            }else if pType == "unavailable"{
                ztdl?.isOff(zt)
            }
        }
    }
    
    //连接成功
    func xmppStreamDidConnect(sender: XMPPStream!) {
        isOpen = true
        // xs!.authenticateWithPassword(pwd, error: nil)
        do
        {
            try xs!.authenticateWithPassword(pwd)
        }catch
        {
            
        }
    }
    
    //验证成功
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        //上线
        goOnline()
    }
    
    //建立通道
    func buildStream(){
        xs = XMPPStream()
        xs?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
    }
    
    //发生上线状态
    func goOnline(){
        var p = XMPPPresence()
        xs!.sendElement(p)
    }
    //发生下线状态
    func goOffline(){
        var p = XMPPPresence(type: "unavailabe")
        xs!.sendElement(p)
    }
    
    //连接服务器（查看服务器是否可连接）
    func connect() -> Bool {
        buildStream()
        
        //通道已经连接
        if xs!.isConnected(){
            return true
        }
        // defaults.setObject(userid, forKey: "userid");
        //defaults.setObject(pass, forKey: "password");
        
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid:String = defaults.objectForKey("userid") as! String;
        let pass:String = defaults.objectForKey("password") as! String;
        
        //获取系统中保存的用户名、密码、服务器地址
        let user:String = userid.stringByAppendingString("@bbxiaoqu")
        let password:String = pass
        let server:String = "101.200.194.1"
        
        // (user!= nil && password != nil) {
            //通道的用户名
            xs!.myJID = XMPPJID.jidWithString(user)
            xs!.hostName = server
            //密码保存备用
            pwd = password
        do
               {
                    _  = try xs!.connectWithTimeout(5000)
               }catch let error as NSError {
                  print(error.localizedDescription)
                  print("cannot connect \(server)")
                  return false;
                }
                print("connect success!!!")
                return true;
        //}
        
       
    }
    //断开连接
    func disConnect(){
        if xs != nil {
            if xs!.isConnected() {
                
                goOffline()
                xs!.disconnect()
            }
        }
    }
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //质量跟踪平台
        Bugly.startWithAppId("900018226")
        
        mapManager = BMKMapManager() // 初始化 BMKMapManager
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = mapManager?.start("uaiX1ZQ8vdbRQp6tRUBgL5Me", generalDelegate: nil)  // 注意此时 ret 为 Bool? 类型
        if !ret! {  // 如果 ret 为 false，先在后面！强制拆包，再在前面！取反
            NSLog("manager start failed!") // 这里推荐使用 NSLog，当然你使用 println 也是可以的
        }
        
        print("\(NSHomeDirectory())")
        
        let str:NSString = UIDevice.currentDevice().systemVersion
        let version:Float = str.floatValue
        if version >= 8.0 {
            //UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound |..UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
            
            //public convenience init(forTypes types: UIUserNotificationType, categories: Set<UIUserNotificationCategory>?)
           
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil))

            
            
            UIApplication.sharedApplication().registerForRemoteNotifications()
        } else {
            //UIApplication.sharedApplication().registerForRemoteNotificationTypes( UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound |UIRemoteNotificationType.Alert)
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let token:String = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        print("token==\(token)")
        
        let defaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject(token, forKey: "token");
        defaults.synchronize();

        //将token发送到服务器
    }


    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        let alert:UIAlertView = UIAlertView(title: "", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    
    //代理成员变量
    var apnsdelegate:ApnsDelegate?
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("userInfo==\(userInfo)")
        //调用代理函数，改变Label值
        self.apnsdelegate?.NewMessage("newmess")
    }
    
//    //点击推送消息的按钮时
//    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
//        print("identifier=\(identifier)")  //这里的identifier是按钮的identifier
//        
//        completionHandler()  //最后一定要调用这上方法
//    }
    
//    // 设置XMPPStream
//    func setupStream(){
//        
//        //初始化XMPPStream
//        self.xmppStream = XMPPStream()
//        self.xmppStream!.addDelegate(self,delegateQueue:dispatch_get_main_queue());
//        
//    }
//    // 通知服务器器用户上线
//    func goOnline(){
//        
//        //发送在线状态
//        var presence:XMPPPresence = XMPPPresence(type:"available")
//        self.xmppStream!.sendElement(presence)
//        
//    }
//   // 通知服务器器用户下线
//    func goOffline(){
//        
//        //发送下线状态
//        var presence:XMPPPresence = XMPPPresence(type:"available");
//        self.xmppStream!.sendElement(presence)
//        
//    }
//    // 连接到服务器
//    func connect() -> Bool{
//        
//        setupStream()
//        
//        //从本地取得用户名，密码和服务器地址
//        var defaults:NSUserDefaults  = NSUserDefaults.standardUserDefaults()
//        
//        var userId:String  = "888@bbxiaoqu"
//        var pass:String = "888"
//        var server:String = "101.200.194.1"
//        var port:UInt16 = 5222
//        if (!xmppStream!.isDisconnected()) {
//            return true
//        }
//        
//        if (userId == "" || pass == "") {
//            return false;
//        }
//        
//        //设置用户
//        self.xmppStream!.myJID = XMPPJID.jidWithString(userId)        //设置服务器
//        self.xmppStream!.hostName = server;
//        //密码
//        password = pass;
//        
//        self.xmppStream!.hostPort = port;
//        
//        //连接服务器
//        do
//       {
//            _  = try self.xmppStream?.connectWithTimeout(XMPPStreamTimeoutNone)
//       }catch let error as NSError {
//          print(error.localizedDescription)
//          print("cannot connect \(server)")
//          return false;
//        }
//        print("connect success!!!")
//        return true;
//        
//    }
//    // 与服务器断开连接
//    func disconnect(){
//        
//        self.goOffline()
//        self.xmppStream!.disconnect()
//        
//    }
//    //XMPPStreamDelegate协议实现
//    //连接服务器
//    func xmppStreamDidConnect(sender:XMPPStream ){
//        print("xmppStreamDidConnect \(xmppStream!.isConnected())")
//        isOpen = true;
//        var error:NSError? ;
//        //验证密码
//        print(password)
//        
//         do
//        {
//            _  = try self.xmppStream?.authenticateWithPassword(password)
//
//        }catch let error as NSError {
//            print(error.localizedDescription)
//            
//        }
//        self.goOnline()
//    }
//    
//    //验证通过
//    func xmppStreamDidAuthenticate(sender:XMPPStream ){
//        print("xmppStreamDidAuthenticate")
//        self.goOnline()
//    }
//    
//    func xmppStream(sender:XMPPStream , didNotAuthenticate error:DDXMLElement ){
//        print(error)
//        var alter:UIAlertView = UIAlertView(title: "提示", message: "密码验证失败!", delegate: nil, cancelButtonTitle: "取消");
//        alter.show();
//    }
//    
//    //收到消息
//    func xmppStream(sender:XMPPStream ,didReceiveMessage message:XMPPMessage? ){
//        if message != nil {
//            print(message)
//            var cont:String = message!.elementForName("body").stringValue();
//            var from:String = message!.attributeForName("from").stringValue();
//            
//            var date = NSDate()
//            var timeFormatter = NSDateFormatter()
//            timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss.SSS" //(格式可俺按自己需求修整)
//            var strNowTime = timeFormatter.stringFromDate(date) as String
//            
//            var msg:Message = Message(content:cont,sender:from,ctime:strNowTime)
//            
//            
//            //消息委托(这个后面讲)
//            self.messageDelegate?.newMessageReceived(msg);
//            
//            send("369",to: "18600888703",mess: "888888888888888888");
//        }
//        
//    }
//    
//    
// 
//    func xmppStreamConnectDidTimeout(sender: XMPPStream!) {
//        var alter:UIAlertView = UIAlertView(title: "对不起", message: "连接超时!", delegate: nil, cancelButtonTitle: "取消");
//        alter.show();
//    }
//    
//
//    
//    
//    //收到好友状态
//    func xmppStream(sender:XMPPStream ,didReceivePresence presence:XMPPPresence ){
//        
//        print(presence)
//        
//        //取得好友状态
//        var presenceType:NSString = presence.type() //online/offline
//        //当前用户
//        var userId:NSString  = sender.myJID.user;
//        //在线用户
//        var presenceFromUser:NSString  = presence.from().user;
//        
//        if (!presenceFromUser.isEqualToString(userId as String)) {
//            
//            //在线状态
//            var srv:String = "bbxiaoqu"
//            if (presenceType.isEqualToString("available")) {
//                
//                //用户列表委托
//                chatDelegate?.newBuddyOnline("\(presenceFromUser)@\(srv)")
//                
//            }else if (presenceType.isEqualToString("unavailable")) {
//                //用户列表委托
//                chatDelegate?.buddyWentOffline("\(presenceFromUser)@\(srv)")
//            }
//            
//        }
//        
//    }
////    func sendElement(mes:DDXMLElement){
////        xmppStream!.sendElement(mes)
////    }
//    
//    
//    func send(send:String,to:String,mess:String)
//    {
//      
//            //XMPPFramework主要是通过KissXML来生成XML文件
//            //生成<body>文档
//            let body:DDXMLElement = DDXMLElement.elementWithName("body") as! DDXMLElement
//            body.setStringValue(mess)
//            
//            //生成XML消息文档
//            let mes:DDXMLElement = DDXMLElement.elementWithName("message") as! DDXMLElement
//            //消息类型
//            mes.addAttributeWithName("type",stringValue:"chat")
//            //发送给谁
//            mes.addAttributeWithName("to" ,stringValue:"369@bbxiaoqu")
//            //由谁发送
//            mes.addAttributeWithName("from" ,stringValue:"888@bbxiaoqu")
//            //组合
//            mes.addChild(body)
//        
//        
//            print(mes)
//            //发送消息
//            self.xmppStream!.sendElement(mes)
//        
//        
//    }
    


}



protocol ApnsDelegate:NSObjectProtocol{
    //回调方法
    func NewMessage(string:String)
}

