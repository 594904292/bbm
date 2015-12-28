
import UIKit

import Alamofire



class ChatViewController: UIViewController, ChatDataSource,UITextFieldDelegate,UINavigationControllerDelegate,XxDL {
    
    
    
    var alertView:UIAlertView?
    var Chats:NSMutableArray!
    var tableView:TableView!
    var from:String = "";
    var fromname:String = ""
    var fromheadface:String = ""
    var myself:String = "";
    var myselfname:String = "";
    var myselfheadface:String = "";
    var txtMsg:UITextField!
    var db: SQLiteDB!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        super.viewDidLoad()
        
        self.navigationItem.title="查看"
        
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        
        //远程同步
        zdl().xxdl = self
        db = SQLiteDB.sharedInstance()
        zdl().connect()
        
        Chats = NSMutableArray()
        let defaults = NSUserDefaults.standardUserDefaults();
        myselfname = defaults.objectForKey("nickname") as! String;
        myselfheadface = defaults.objectForKey("headface") as! String;
        getData()
        
        loaduserinfo()
        
        setupChatTable()
        
        setupSendPanel()
        
        
        
    }
    
    //收到消息
    func newMsg(aMsg: WXMessage) {
        //对方正在输入
        if aMsg.isComposing {
            self.navigationItem.title = "对方正在输入。。。"
        }else if (aMsg.body != "") {
            //显示跟谁聊天
            //self.navigationItem.title = toBuddyName
            //加入到未读消息组
            //msgList.append(aMsg)
            
             let me:UserInfo! = UserInfo(name:fromname ,logo:(fromheadface))
            let thisChat =  MessageItem(body:aMsg.body, user:me, date:NSDate(), mtype:ChatType.Someone)
            
            Chats.addObject(thisChat)
             //通知表格刷新
            self.tableView.reloadData()
        }
    }

    
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    func loaduserinfo()
        
    {
        
        Alamofire.request(.GET, "http://www.bbxiaoqu.com/getuserinfo.php?userid="+from, parameters: nil)
            
            .responseJSON { response in
                
                if let jsonItem = response.result.value as? NSArray{
                    
                    for data in jsonItem{
                        print("data: \(data)")
                        self.fromname = data.objectForKey("username") as! String;
                        self.fromheadface = data.objectForKey("headface") as! String;
                    }
                    
                }
                
        }
        
    }
    
    
    
    func add(messae:String,guid:String,date:String,senduserid:String,sendnickname:String,sendusericon:String,touserid:String,tousernickname:String,tousericon:String)
    {
        let sql = "insert into chat(message,guid,date,senduserid,sendnickname,sendusericon,touserid,tonickname,tousericon) values('\(messae)','\(guid)','\(date)','\(senduserid)','\(sendnickname)','\(sendusericon)','\(touserid)','\(tousernickname)','\(tousericon)')";
        
        NSLog("sql: \(sql)")
         db.execute(sql)
     }
    
    
    
    func getData() {
        
        //items.removeAll()
        
        let sql="select * from chat where (senduserid='\(from)' and  touserid='\(myself)') or (senduserid='\(myself)' and  touserid='\(from)') ";        
        NSLog(sql)
        let mess = db.query(sql)
        if mess.count > 0 {
            //获取最后一行数据显示
             for i in 0...mess.count-1
            {
                let item = mess[i] as SQLRow
                 let message = item["message"]!.asString()
                //let guid = item["guid"]!.asString()
                let date = item["date"]!.asString()
                
                let sendnickname = item["sendnickname"]!.asString()
                
                let senduserid = item["senduserid"]!.asString()
                
                let sendusericon = item["sendusericon"]!.asString()
                
                let tonickname = item["tonickname"]!.asString()
                
                let tousericon = item["tousericon"]!.asString()
                
                //var now=NSDate();
                
                var fmt:NSDateFormatter = NSDateFormatter();
                
                fmt.dateFormat="yyyy-MM-dd HH:mm:ss"
                
                var now=fmt.dateFromString(date)!;
                
                if(senduserid == myself)
                    
                {
                    
                    var me:UserInfo! = UserInfo(name:sendnickname ,logo:(sendusericon))
                    
                    let   itemobj =  MessageItem(body:message, user:me,  date:now, mtype:ChatType.Mine)
                    
                    Chats.insertObject(itemobj, atIndex: 0)
                    
                }else
                    
                {
                    
                    var to:UserInfo! = UserInfo(name:tonickname ,logo:(tousericon))
                    
                    let itemobj =  MessageItem(body:message, user:to,  date:now, mtype:ChatType.Someone)
                    
                    Chats.insertObject(itemobj, atIndex: 0)
                    
                }
                
            }
            
            
            
            
            
        }
        
    }
    
    
    
    
    
    
    
    func setupSendPanel()
        
    {
        
        let sendView = UIView(frame:CGRectMake(0,self.view.frame.size.height-56,320,56))
        
        
        
        sendView.backgroundColor=UIColor.grayColor()
        
        
        
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
    
    
//       //取得当前程序的委托
//    func  appDelegate() -> AppDelegate{
//        
//        return UIApplication.sharedApplication().delegate as! AppDelegate
//        
//    }

    //获取总代理
    func zdl() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

    
    func sendMessage()
        
    {
        
        
        
        var sender = txtMsg
        var sendcontent:String=sender.text!
        var me:UserInfo! = UserInfo(name:myselfname ,logo:(myselfheadface))
        
        //通过通道发送XML文本
        zdl().connect()
            
        let thisChat =  MessageItem(body:sendcontent, user:me, date:NSDate(), mtype:ChatType.Mine)
        
        Chats.addObject(thisChat)
        
        self.tableView.chatDataSource = self
        
        self.tableView.reloadData()
        
        sender.resignFirstResponder()
        
        sender.text = ""
        
        
        
        
        
        var uuid:CFUUIDRef
        
        var guid:String
        
        uuid = CFUUIDCreate(nil)
        
        guid = CFUUIDCreateString(nil, uuid) as String;
        
        
        
        var date = NSDate()
        
        var timeFormatter = NSDateFormatter()
        
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        
        var strNowTime = timeFormatter.stringFromDate(date) as String
        
        
        
        let  dic:Dictionary<String,String> = ["_catatory" : "chat","_senduserid" : myself,"_sendnickname" : myselfname,"_sednusericon" : myselfname,"_touserid" : from,"_tonickname" : fromname,"_tousericon" : fromheadface,"_gudi":guid,"_message":sendcontent,"_channelid":""]
        
        var url_str:String = "http://www.bbxiaoqu.com/chat.php";
        
        Alamofire.request(.POST,url_str, parameters:dic)
            
            .responseString{ response in
                
                if let ret = response.result.value  {
                    
                    if String(ret)=="1"
                        
                    {
                        
                        self.alertView = UIAlertView()
                        
                        self.alertView!.title = "提示"
                        
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
        
        
        
        self.tableView.chatDataSource = self
        
        
        
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

