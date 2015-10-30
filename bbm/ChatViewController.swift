
import UIKit
import Alamofire

class ChatViewController: UIViewController, ChatDataSource,UITextFieldDelegate {
    
     var alertView:UIAlertView?
    var Chats:NSMutableArray!
    var tableView:TableView!
    //var me:UserInfo!
    //var you:UserInfo!
    var to:String = "";
    var my:String = "";
    var txtMsg:UITextField!
    var db: SQLiteDB!

    var touserid:String = "";
    var touser:String = "";

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //远程同步
        
        db = SQLiteDB.sharedInstance()
       
        syncjson()

        Chats = NSMutableArray()
        querydata()
        setupChatTable()
        setupSendPanel()
        
       
    }
    func syncjson()
    {
        Alamofire.request(.GET, "http://www.bbxiaoqu.com/getchat.php?uid="+to, parameters: nil)
            .responseJSON { response in
                  if let jsonItem = response.result.value as? NSArray{
                    for data in jsonItem{
                        print("data: \(data)")
                        
                        let guid:String = data.objectForKey("guid") as! String;
                        let sendtime:String = data.objectForKey("sendtime") as! String;
                        
                        let senduser:String = data.objectForKey("senduser") as! String;
                        let senduserid:String = data.objectForKey("senduserid") as! String;
                        let touser:String = data.objectForKey("touser") as! String;
                        let touserid:String = data.objectForKey("touserid") as! String;
                        
                        let message:String = data.objectForKey("message") as! String;
                        
                        //对话框可以确实用户，就能提前得到用户的头像
                        self.add("message", guid: guid, date: sendtime, senduserid: senduserid, sendnickname: senduser, sendusericon: "", touserid: touser, tousernickname: touser, tousericon: "")
                    }
                   
                }
                
        }
    }
    
    
    func add(messae:String,guid:String,date:String,senduserid:String,sendnickname:String,sendusericon:String,touserid:String,tousernickname:String,tousericon:String)
    {
        //String sql=""
        
        let sql = "insert into chat(message,guid,date,senduserid,sendnickname,sendusericon,touserid,tonickname,tousericon) values('\(messae)','\(guid)','\(date)','\(senduserid)','\(sendnickname)','\(sendusericon)','\(touserid)','\(tousernickname)','\(tousericon)')";
        NSLog("sql: \(sql)")
        //通过封装的方法执行sql
        db.execute(sql)

    }
    func querydata() {
        //items.removeAll()
        let sql="select * from chat";
        NSLog(sql)
        let mess = db.query(sql)
        if mess.count > 0 {
            //获取最后一行数据显示
            for i in 0...mess.count-1
            {
                let item = mess[i] as SQLRow
                let message = item["message"]!.asString()
                 let guid = item["guid"]!.asString()
                let date = item["date"]!.asString()

                let sendnickname = item["sendnickname"]!.asString()
                let senduserid = item["senduserid"]!.asString()
                let sendusericon = item["sendusericon"]!.asString()
                
                let tonickname = item["tonickname"]!.asString()
                let touserid = item["touserid"]!.asString()
                let tousericon = item["tousericon"]!.asString()
                
                
                
                var me:UserInfo! = UserInfo(name:my ,logo:("xiaoming.png"))
                
                
                let defaults = NSUserDefaults.standardUserDefaults();
                var currentuserid = defaults.objectForKey("userid") as! String;
                var currentuser = defaults.objectForKey("nickname") as! String;
               // var itemobj:MessageItem ;
                
                var now=NSDate();
                var fmt:NSDateFormatter = NSDateFormatter();
                fmt.dateFormat="yyyy-MM-dd HH:mm:ss"
                //string转date
                now=fmt.dateFromString(date)!;
                
                //NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                //[formatter setDateFormat:@"yyyy年MM月dd日"];
                //NSDate *date=[formatter dateFromString:uiDate];
                
                if(senduserid == currentuserid)
                {
                 let   itemobj =  MessageItem(body:message, user:me,  date:now, mtype:ChatType.Mine)
                 Chats.insertObject(itemobj, atIndex: 0)
                }else
                {
                    let itemobj =  MessageItem(body:message, user:me,  date:now, mtype:ChatType.Someone)
                     Chats.insertObject(itemobj, atIndex: 0)
                }
               
                
                //  NSLog(aa)
            }
            //self.tableView.reloadData()

        }
    }
    

    
    func setupSendPanel()
    {
        let sendView = UIView(frame:CGRectMake(0,self.view.frame.size.height-56,320,56))
        
        sendView.backgroundColor=UIColor.blueColor()
        
        sendView.alpha=0.9
        
        txtMsg = UITextField(frame:CGRectMake(7,10,225,36))
        
        txtMsg.backgroundColor = UIColor.whiteColor()
        
        txtMsg.textColor=UIColor.blackColor()
        
        txtMsg.font=UIFont.boldSystemFontOfSize(12)
        
        
        txtMsg.layer.cornerRadius = 10.0
        txtMsg.returnKeyType = UIReturnKeyType.Send
        
        //Set the delegate so you can respond to user input
        txtMsg.delegate=self
        sendView.addSubview(txtMsg)
        
        self.view.addSubview(sendView)
        
        
        let sendButton = UIButton(frame:CGRectMake(235,10,77,36))
        
        sendButton.backgroundColor=UIColor.lightGrayColor()
        
        sendButton.addTarget(self, action:Selector("sendMessage") ,forControlEvents:UIControlEvents.TouchUpInside)
        
        sendButton.layer.cornerRadius=6.0
        sendButton.setTitle("发送", forState:UIControlState.Normal)
        
        sendView.addSubview(sendButton)
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool
    {
        sendMessage()
        return true
    }
    
    func sendMessage()
    {
        
        //composing=false
        var sender = txtMsg
        var me:UserInfo! = UserInfo(name:my ,logo:("xiaoming.png"))
        var you:UserInfo! = UserInfo(name:to ,logo:("xiaoming.png"))
        let thisChat =  MessageItem(body:sender.text!, user:me, date:NSDate(), mtype:ChatType.Mine)
        
        var thatChat =  MessageItem(body:"你说的是：\(sender.text)!", user:you, date:NSDate(), mtype:ChatType.Someone)
        
        Chats.addObject(thisChat)
        Chats.addObject(thatChat)
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        
        //self.showTableView()
        sender.resignFirstResponder()
        sender.text = ""
        
        
        var uuid:CFUUIDRef
        var guid:String
        uuid = CFUUIDCreate(nil)
        guid = CFUUIDCreateString(nil, uuid) as String;

        let defaults = NSUserDefaults.standardUserDefaults();
        
        
        my = defaults.objectForKey("userid") as! String;
        //my = defaults.objectForKey("nickname") as! String;
        
        //本地保存
        
        //sender.text = ""
        var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        var strNowTime = timeFormatter.stringFromDate(date) as String
        
        let  dic:Dictionary<String,String> = ["_catatory" : "chat","_senduserid" : my,"_sendnickname" : my,"_sednusericon" : my,"touserid" : to,"tonickname" : to,"tousericon" : to,"_gudi":guid,"_message":txtMsg.text!,"_channelid":""]
        var url_str:String = "http://www.bbxiaoqu.com/chat.php";
        Alamofire.request(.POST,url_str, parameters:dic)
            .responseString{ response in
                if let ret = response.result.value  {
                    if String(ret)=="1"
                    {
                        self.alertView = UIAlertView()
                        self.alertView!.title = "注册提示"
                        self.alertView!.message = "发送成功"
                        self.alertView!.addButtonWithTitle("关闭")
                        NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
                        self.alertView!.show()
                    }
                }
        }
        
    }
    
    func setupChatTable()
    {
        self.tableView = TableView(frame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 100))
        
        //创建一个重用的单元格
        self.tableView!.registerClass(TableViewCell.self, forCellReuseIdentifier: "ChatCell")
        
//        me = UserInfo(name:"Xiaoming" ,logo:("xiaoming.png"))
//        
//        you  = UserInfo(name:"Xiaohua", logo:("xiaohua.png"))
//        
//        
//        let first =  MessageItem(body:"嘿，这张照片咋样，我在泸沽湖拍的呢！", user:me,  date:NSDate(timeIntervalSinceNow:-600), mtype:ChatType.Mine)
//        
//        
//        let second =  MessageItem(image:UIImage(named:"luguhu.jpeg")!,user:me, date:NSDate(timeIntervalSinceNow:-290), mtype:ChatType.Mine)
//        
//        let third =  MessageItem(body:"太赞了，我也想去那看看呢！",user:you, date:NSDate(timeIntervalSinceNow:-60), mtype:ChatType.Someone)
//        
//        let fouth =  MessageItem(body:"嗯，下次我们一起去吧！",user:me, date:NSDate(timeIntervalSinceNow:-20), mtype:ChatType.Mine)
//        
//        let fifth =  MessageItem(body:"好的，一定！",user:you, date:NSDate(timeIntervalSinceNow:0), mtype:ChatType.Someone)
//        
//        let zero =  MessageItem(body:"最近去哪玩了？", user:you,  date:NSDate(timeIntervalSinceNow:-96400), mtype:ChatType.Someone)
//        
//        let zero1 =  MessageItem(body:"去了趟云南，明天发照片给你哈？", user:me,  date:NSDate(timeIntervalSinceNow:-86400), mtype:ChatType.Mine)
        
        
       
        //Chats.addObjectsFromArray([first,second, third, fouth, fifth, zero, zero1])
        //set the chatDataSource
        
        self.tableView.chatDataSource = self
        
        //call the reloadData, this is actually calling your override method
        self.tableView.reloadData()
        
        self.view.addSubview(self.tableView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func rowsForChatTable(tableView:TableView) -> Int
    {
        return self.Chats.count
    }
    
    func chatTableView(tableView:TableView, dataForRow row:Int) -> MessageItem
    {
        return Chats[row] as! MessageItem
    }
}

