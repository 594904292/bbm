
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
    var sendView:UIView!;
    var txtMsg:UITextField!
    var db: SQLiteDB!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.title="私聊"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        
        //远程同步
        zdl().xxdl = self
        db = SQLiteDB.sharedInstance()
        zdl().connect()
        
        Chats = NSMutableArray()
        let defaults = NSUserDefaults.standardUserDefaults();
        myselfname = defaults.objectForKey("nickname") as! String;
        myselfheadface = defaults.objectForKey("headface") as! String;
       
        loaduserinfo(from)
        loaduserinfo(myself)

        setupChatTable()
        setupSendPanel()
        getData()
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
    
    
    
    func loaduserinfo(userid:String)
        
    {
        
        Alamofire.request(.GET, "http://www.bbxiaoqu.com/getuserinfo.php?userid="+userid, parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for data in jsonItem{
                            //print("data: \(data)")
                            if(userid==self.from)
                            {
                                self.fromname = data.objectForKey("username") as! String;
                                self.fromheadface = data.objectForKey("headface") as! String;
                            }
                            var name:String = data.objectForKey("username") as! String;
                            var headface:String = data.objectForKey("headface") as! String;

                            if(!sqlitehelp.shareInstance().isexituser(userid))
                            {//缓存用户数据
                                sqlitehelp.shareInstance().addusers(userid, nickname: name, usericon: headface)
                                //更新聊天记录
                            }
                        }
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
    }
    
    
    func getData() {
        let sql="select * from chat where (senduserid='\(from)' and  touserid='\(myself)') or (senduserid='\(myself)' and  touserid='\(from)') order by _id desc";
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
                let senduserid = item["senduserid"]!.asString()
                let touserid = item["touserid"]!.asString()
                 let sendnickname = sqlitehelp.shareInstance().loadusername(senduserid)
                 let sendusericon = sqlitehelp.shareInstance().loadheadface(senduserid)
                let tonickname = sqlitehelp.shareInstance().loadusername(touserid)
                let tousericon = sqlitehelp.shareInstance().loadheadface(touserid)
                
                var fmt:NSDateFormatter = NSDateFormatter();
                fmt.dateFormat="yyyy-MM-dd HH:mm:ss"
                var now=fmt.dateFromString(date)!;
                
                NSLog(senduserid)
                NSLog(self.myself)
                let defaults = NSUserDefaults.standardUserDefaults();
                let userid = defaults.objectForKey("userid") as! NSString;
                if(senduserid == userid)
                {
                    var me:UserInfo! = UserInfo(name:sendnickname ,logo:(sendusericon))
                    let   itemobj =  MessageItem(body:message, user:me,  date:now, mtype:ChatType.Mine)
                    Chats.insertObject(itemobj, atIndex: 0)
                    
                }else
                    
                {
                    var to:UserInfo! = UserInfo(name:sendnickname ,logo:(sendusericon))
                    let itemobj =  MessageItem(body:message, user:to,  date:now, mtype:ChatType.Someone)
                    Chats.insertObject(itemobj, atIndex: 0)
                }
            }
            

            self.tableView.reloadData();
//            if(self.Chats.count>0)
//            {
//                //NSLog(self.Chats.count);
//                print("Chats count: \(self.Chats.count)")
//
//                var indexPath =  NSIndexPath(forRow:self.Chats.count-1,inSection:0)
//                self.tableView.scrollToRowAtIndexPath(indexPath,atScrollPosition:UITableViewScrollPosition.Bottom,animated:true)
//            }
            
            tableViewScrollToBottom(true)
            
        }
        
    }
    
    
    
    
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRowsInSection(numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
        })
    }
    
    
    func setupSendPanel()
    {
        sendView = UIView(frame:CGRectMake(0,self.view.frame.size.height-56,self.view.frame.size.width,56))
        sendView.backgroundColor=UIColor.grayColor()
        sendView.alpha=0.9
        txtMsg = UITextField(frame:CGRectMake(7,10,225,36))
        txtMsg.backgroundColor = UIColor.whiteColor()
        txtMsg.textColor=UIColor.blackColor()
        txtMsg.font=UIFont.boldSystemFontOfSize(12)
        txtMsg.layer.cornerRadius = 10.0
         //Set the delegate so you can respond to user input
        txtMsg.delegate=self
        txtMsg.placeholder = "输入消息内容"
        txtMsg.returnKeyType = UIReturnKeyType.Send
        txtMsg.enablesReturnKeyAutomatically  = true
       sendView.addSubview(txtMsg)
        let sendButton = UIButton(frame:CGRectMake(235,10,77,36))
        sendButton.backgroundColor=UIColor.lightGrayColor()
        sendButton.addTarget(self, action:Selector("sendMessage") ,forControlEvents:UIControlEvents.TouchUpInside)
        sendButton.layer.cornerRadius=6.0
        sendButton.setTitle("发送", forState:UIControlState.Normal)
        sendView.addSubview(sendButton)
        self.view.addSubview(sendView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:"handleTouches:")
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
    }
    
    
    
    func textFieldShouldReturn(textField:UITextField) -> Bool
    {
        sendMessage()
        return true
    }
    
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
        //添加到本地
        sqlitehelp.shareInstance().addchat(sendcontent, guid: guid, date: strNowTime, senduserid: myself, sendnickname: myselfname, sendusericon: myselfheadface, touserid: from, tousernickname: fromname, tousericon: fromheadface)
        //添加朋友
        //添加朋友联系人
        if(!sqlitehelp.shareInstance().isexitfriend(from))
        {
            sqlitehelp.shareInstance().addfriend(from, nickname: fromname, usericon: fromheadface, lastuserid: myself, lastnickname: myselfname, lastinfo: sendcontent, lasttime: strNowTime, messnum: 0)
            
        }
        sqlitehelp.shareInstance().updatefriendlastinfo(from, lastuserid: myself, lastinfo: sendcontent, lasttime: strNowTime)
        let  dic:Dictionary<String,String> = ["_catatory" : "chat","_senduserid" : myself,"_sendnickname" : myselfname,"_sednusericon" : myselfheadface,"_touserid" : from,"_tonickname" : fromname,"_tousericon" : fromheadface,"_gudi":guid,"_message":sendcontent,"_channelid":""]
        var url_str:String = "http://www.bbxiaoqu.com/chat.php";
        Alamofire.request(.POST,url_str, parameters:dic)
            .responseString{ response in
                if(response.result.isSuccess)
                {
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
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
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
    
    
    
    func keyBoardWillShow(note:NSNotification)
    {
         let userInfo  = note.userInfo as! NSDictionary
        var  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        var keyBoardBoundsRect = self.view.convertRect(keyBoardBounds, toView:nil)
        var keyBaoardViewFrame = sendView.frame
        var deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
             self.sendView.transform = CGAffineTransformMakeTranslation(0,-deltaY)
        }
         if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
        
        
    }
    
    func keyBoardWillHide(note:NSNotification)
    {
        let userInfo  = note.userInfo as! NSDictionary
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            self.sendView.transform = CGAffineTransformIdentity
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    func handleTouches(sender:UITapGestureRecognizer){
        if sender.locationInView(self.view).y < self.view.bounds.height - 250{
            txtMsg.resignFirstResponder()
         }
    }

    
}

