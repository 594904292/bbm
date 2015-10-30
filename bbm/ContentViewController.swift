//
//  ContentViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/10.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class ContentViewController: UIViewController,UINavigationControllerDelegate,SimChatDataSource,UITextFieldDelegate {
    
     var Chats:NSMutableArray!
    var tableView:SimTableView!
    var alertView:UIAlertView?
    @IBOutlet weak var contentLab: UILabel!
    @IBOutlet weak var lvsv: UIScrollView!
    var txtMsg:UITextField!
    
    @IBOutlet weak var headimgview: UIImageView!
    var infoid:String = "";
    var guid:String = "";
    var puserid:String=""
    var puser:String=""
    
    var senduserid:String=""
    var senduser:String=""
    var headface:String=""
    
    @IBOutlet weak var sendtime: UILabel!
    @IBOutlet weak var sendaddress: UIImageView!
   
    @IBAction func wxshare(sender: UIButton) {
    }
    
    @IBAction func wxspaceshare(sender: UIButton) {
    }
    
    @IBAction func runchat(sender: UIButton) {
        
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("chatviewController") as! ChatViewController
        //创建导航控制器
        //vc.message = aa.content;
        vc.to=puserid
        vc.my="";
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;
    }
    
    
    @IBAction func gz(sender: UIButton) {
    }
    
    
    @IBAction func bm(sender: UIButton) {
        
    }
    
    
   
    
    override func viewDidLoad() {
   
        super.viewDidLoad()
        self.navigationItem.title="查看"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        // Do any additional setup after loading the view.
        //
        loadinfo(guid);
        
        setupChatTable1()
        setupSendPanel1()
    }
    
    
    
    func loadinfo(guid:String)
    {
        var url_str:String = "http://www.bbxiaoqu.com/getinfo.php?guid=".stringByAppendingString(guid)
        Alamofire.request(.GET,url_str, parameters:nil)
            .responseJSON {response in
                print(response.result.value)
                if let JSON = response.result.value {
                    print("JSON1: \(JSON.count)")
                    if(JSON.count==0)
                    {
                        
                    }else
                    {
                        
                        self.infoid = JSON[0].objectForKey("id") as! String;
                        let title:String = JSON[0].objectForKey("title") as! String;
                        let contentstr:String = JSON[0].objectForKey("content") as! String;
                         let sendtimestr:String = JSON[0].objectForKey("sendtime") as! String;
                        let infocatagroy:String = JSON[0].objectForKey("infocatagroy") as! String;

                        self.headface = JSON[0].objectForKey("headface") as! String
                    
                        self.puserid = JSON[0].objectForKey("senduser") as! String;
                        self.puser = JSON[0].objectForKey("username") as! String;
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.contentLab.text = contentstr;
                            self.sendtime.text = sendtimestr;
                        })
                        
                    }
                    self.loadheadface(self.puserid,headname:self.headface)

                    self.loaddiscuzzBody(self.infoid)
                }
        }        
    }
    
    func loadheadface(userid:String,headname:String)
    {
        var head:String="http://www.bbxiaoqu.com/uploads/".stringByAppendingString(headface)
        Alamofire.request(.GET, head).response { (_, _, data, _) -> Void in
            if let d = data as? NSData!
            {
                self.headimgview?.image=UIImage(data: d)
            }
        }
        
    }
    

    
        func loaddiscuzzBody(infoid:String)
        {
    
            let url_str:String = "http://www.bbxiaoqu.com/getdiscuzz.php?infoid=".stringByAppendingString(infoid)
            Alamofire.request(.GET,url_str, parameters:nil)
    
                .responseJSON { response in
    
                    if let JSON = response.result.value as? NSArray {
    
                        print("JSON1: \(JSON.count)")
    
                        if(JSON.count==0)
    
                        {
    
                        }else
                        {
                            for data in JSON{
                                let headface:String = data.objectForKey("headface") as! String;
                                let sendtime:String = data.objectForKey("sendtime") as! String;
                                let message:String = data.objectForKey("message") as! String;
                                let puid:String = data.objectForKey("touserid") as! String;
                                let pname:String = data.objectForKey("touser") as! String;
                                let uid:String = data.objectForKey("senduserid") as! String;
                                let username:String = data.objectForKey("senduser") as! String;
                                let me = "xiaoming.png"
                                let you = "xiaohua.png"
                                let item =  SimMessageItem(body:message, logo:me,
                                    date:NSDate(timeIntervalSinceNow:-600), mtype:SimChatType.Mine)
                                self.Chats.insertObject(item, atIndex: 0)
                            }
                            
    
                        }
    
                        
                        NSLog("\(self.Chats.count)")
                         self.tableView.reloadData()
    
                    }
    
            }
    
        }
    

    
    
    func backClick()
    {
        NSLog("back");
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("homeController") as! HomeViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }

    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupSendPanel1()
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
        var sender = txtMsg
        let me = "xiaoming.png"
        let you = "xiaohua.png"
        let thisChat =   SimMessageItem(body:sender.text!,logo:me,
            date:NSDate(timeIntervalSinceNow:-600), mtype:SimChatType.Mine)
        Chats.addObject(thisChat)
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        sender.resignFirstResponder()
        
        let defaults = NSUserDefaults.standardUserDefaults();
        
        
        
        
        senduserid = defaults.objectForKey("userid") as! String;
        senduser = defaults.objectForKey("nickname") as! String;
        
        
        
        //sender.text = ""
        var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        var strNowTime = timeFormatter.stringFromDate(date) as String

        let  dic:Dictionary<String,String> = ["_infoid" : infoid,"_sendtime" : strNowTime,"_puserid" : puserid,"_puser" : puser,"_touserid" : senduserid,"_touser" : senduser,"_message" : sender.text!]
        var url_str:String = "http://www.bbxiaoqu.com/discuzz.php";
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
    
        
        
        
    
    func dismiss(timer:NSTimer){
        alertView!.dismissWithClickedButtonIndex(0, animated:true)
    }
    
    /*创建表格及数据*/
    func setupChatTable1()
    {
        self.tableView = SimTableView(frame:CGRectMake(0, 250,
        self.view.frame.size.width, self.view.frame.size.height - 270))
        
        //创建一个重用的单元格
        self.tableView!.registerClass(SimTableViewCell.self, forCellReuseIdentifier: "MsgCell")
        
        
        Chats = NSMutableArray()
        //Chats.addObjectsFromArray([first,second, third, fouth, fifth, zero, zero1])
        
        
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        self.view.addSubview(self.tableView)
    }
    
  
    
    /*返回对话记录中的全部行数*/
    func rowsForChatTable(tableView:SimTableView) -> Int
    {
        return self.Chats.count
    }
    
    /*返回某一行的内容*/
    func chatTableView(tableView:SimTableView, dataForRow row:Int) -> SimMessageItem
    {
        return Chats[row] as! SimMessageItem
    }
}

