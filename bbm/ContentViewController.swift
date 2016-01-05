//
//  ContentViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/10.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class ContentViewController: UIViewController,UINavigationControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegate{
    
    // var Chats:NSMutableArray!
    //var tableView:SimTableView!
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
    
    @IBOutlet weak var sendaddr: UILabel!
   
   
    var timer:NSTimer!
    var picnum:Int = 0
    var photoArr:[String] = []
    var items:[itempl]=[]
    var pics:[String]=[]


    @IBOutlet weak var collectionView: UICollectionView!
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pics.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        //cell.backgroundColor = UIColor.blackColor()
       
        var myhead:String=self.pics[indexPath.row]
        Alamofire.request(.GET, myhead).response { (_, _, data, _) -> Void in
            if let d = data as? NSData!
            {
                cell.images.image=UIImage(data: d)
                
            }
        }

        return cell
    }
    
    //实现UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        //某个Cell被选择的事件处理
        //NSLog("cell #%d was selected",indexPath.row)
        
        let url:String=self.pics[indexPath.row]
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("picviewController") as! PicViewController
        //创建导航控制器
        //vc.message = aa.content;
        vc.url=url
        self.navigationController?.pushViewController(vc, animated: true)
        
        return
    }

    @IBOutlet weak var _tableview: UITableView!
    @IBAction func runchat(sender: UIButton) {
        let defaults = NSUserDefaults.standardUserDefaults();
        senduserid = defaults.objectForKey("userid") as! String;
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("chatviewController") as! ChatViewController
        //创建导航控制器
        vc.from=puserid
        vc.myself=senduserid;
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    override func viewDidLoad() {
   
        super.viewDidLoad()
        self.navigationItem.title="查看"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        // Do any additional setup after loading the view.
        _tableview!.delegate=self
        _tableview!.dataSource=self
        collectionView!.dataSource=self
        collectionView!.delegate=self
        collectionView.backgroundColor = UIColor.whiteColor()
        loadinfo(guid);
        
        setupSendPanel1()

        // querydata()
        
    }
    
    
    
    func loadinfo(guid:String)
    {
        var url_str:String = "http://www.bbxiaoqu.com/getinfo.php?guid=".stringByAppendingString(guid)
        Alamofire.request(.GET,url_str, parameters:nil)
            .responseJSON {response in
                if(response.result.isSuccess)
                {
                print(response.result.value)
                var photo:String=""
                if let JSON = response.result.value {
                    print("JSON1: \(JSON.count)")
                    if(JSON.count==0)
                    {
                        
                    }else
                    {
                        self.infoid = JSON[0].objectForKey("id") as! String;
                        let title:String = JSON[0].objectForKey("title") as! String;
                        let contentstr:String = JSON[0].objectForKey("content") as! String;
                        photo = JSON[0].objectForKey("photo") as! String;
                        let sendtimestr:String = JSON[0].objectForKey("sendtime") as! String;
                        let sendaddress = JSON[0].objectForKey("address") as! String

                        let infocatagroy:String = JSON[0].objectForKey("infocatagroy") as! String;
                        self.headface = JSON[0].objectForKey("headface") as! String
                        self.puserid = JSON[0].objectForKey("senduser") as! String;
                        self.puser = JSON[0].objectForKey("username") as! String;
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.contentLab.text = contentstr;
                            self.sendtime.text = sendtimestr;
                            self.sendaddr.text = sendaddress;
                        })
                    }
  
                    self.photoArr = photo.characters.split{$0 == ","}.map{String($0)}
                    self.picnum=self.photoArr.count
                    if(self.photoArr.count>0)
                    {
                         for i in 1...self.photoArr.count{ //loading the images
                            let picname:String = self.photoArr[i-1]
                             var imgurl = "http://www.bbxiaoqu.com/uploads/".stringByAppendingString(picname)
                            self.pics.append(imgurl)
                            
                        }
                     }
                    //

                    
                    self.collectionView.reloadData()
                    self.loadheadface(self.puserid,headname:self.headface)
                    self.loaddiscuzzBody(self.infoid)
                }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }        
    }
  
//    func  imageViewTouch(sender:UITapGestureRecognizer){
//        //print("2")
//        var index:Int = (sender.view?.tag)!
//        var imgurl:String=self.pics[index]
//        var url=NSURL(string: imgurl)
//        UIApplication.sharedApplication().openURL(url!)
//        
//    }

    func loadheadface(userid:String,headname:String)
    {
        var myhead:String="http://www.bbxiaoqu.com/uploads/".stringByAppendingString(headface)
        Alamofire.request(.GET, myhead).response { (_, _, data, _) -> Void in
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
                    
                    if(response.result.isSuccess)
                    {
                    if let JSON = response.result.value as? NSArray {
    
                        print("JSON1: \(JSON.count)")
    
                        if(JSON.count==0)
    
                        {
    
                        }else
                        {
                            for data in JSON{
                                let id:String = data.objectForKey("id") as! String;
                                let headface:String = data.objectForKey("headface") as! String;
                                let sendtime:String = data.objectForKey("sendtime") as! String;
                                let message:String = data.objectForKey("message") as! String;
                                //let puid:String = data.objectForKey("touserid") as! String;
                                //let pname:String = data.objectForKey("touser") as! String;
                                let uid:String = data.objectForKey("senduserid") as! String;
                                let username:String = data.objectForKey("senduser") as! String;
                                let item_obj:itempl = itempl(id: id, userid: uid, username: username, headafce: headface, actiontime: sendtime, content: message)
                                  self.items.append(item_obj)
                            }
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                if(self.items.count==0)
                                {
                                    self._tableview.hidden=true
                                    //self._tableview.vi
                                }else
                                {
                                    self._tableview.hidden=false
                                self._tableview.reloadData();
                                self._tableview.doneRefresh();
                                }
                            })

                            
                            
    
                        }
                        
                        
                        //NSLog("\(self.Chats.count)")
                        self._tableview.reloadData();
    
                    }
            }else
            {
                self.successNotice("网络请求错误")
                print("网络请求错误")
            }
            }
    
        }
    

    
    
    func backClick()
    {
        NSLog("back");
         self.navigationController?.popViewControllerAnimated(true)
        
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
        let sendView = UIView(frame:CGRectMake(0,self.view.frame.size.height-50,self.view.frame.size.width,50))
        
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
    
   
    func sendMessage()        
    {
        var sender = txtMsg
        
        var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        var strNowTime = timeFormatter.stringFromDate(date) as String
        
//        let thisChat =   SimMessageItem(body:sender.text!,logo:self.headface,
//            date:strNowTime, mtype:SimChatType.Mine)
//        Chats.addObject(thisChat)
        //self.tableView.chatDataSource = self
        //self.tableView.reloadData()
        
        let defaults = NSUserDefaults.standardUserDefaults();
        senduserid = defaults.objectForKey("userid") as! String;
        senduser = defaults.objectForKey("nickname") as! String;
        
        var myselfheadface:String = defaults.objectForKey("headface") as! String;
        
        let item_obj:itempl = itempl(id: "0", userid: senduserid, username: senduser, headafce: headface, actiontime: strNowTime, content: sender.text!)
        self.items.append(item_obj)
        
        self._tableview.reloadData()
        sender.resignFirstResponder()
        
        
        let  dic:Dictionary<String,String> = ["_infoid" : infoid,"_sendtime" : strNowTime,"_puserid" : puserid,"_puser" : puser,"_touserid" : senduserid,"_touser" : senduser,"_message" : sender.text!]
        var url_str:String = "http://www.bbxiaoqu.com/discuzz.php";
        Alamofire.request(.POST,url_str, parameters:dic)
            .responseString{ response in
                if(response.result.isSuccess)
                {
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
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
    }
    
        
    @IBAction func report(sender: UIButton) {
        
        var alertView = UIAlertView()
        alertView.title = "系统提示"
        alertView.message = "您确定要举报吗？"
        alertView.addButtonWithTitle("取消")
        alertView.addButtonWithTitle("确定")
        alertView.cancelButtonIndex=0
        alertView.delegate=self;
        alertView.show()
    }
        
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
            print("点击了取消")
        }
        else
        {
            NSLog("add")
            let defaults = NSUserDefaults.standardUserDefaults();
            let userid = defaults.objectForKey("userid") as! String;
            var date = NSDate()
            var timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
            var strNowTime = timeFormatter.stringFromDate(date) as String
            
            var  dic:Dictionary<String,String> = ["content" : guid, "userid": userid, "addtime": strNowTime]
            Alamofire.request(.POST, "http://www.bbxiaoqu.com/savesuggest.php", parameters: dic)
                .responseJSON { response in
                    if(response.result.isSuccess)
                    {

                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        print(response.result.value)
                        //                if let JSON = response.result.value {
                        //                    print("JSON: \(JSON)")
                        //                }
                        
                    }else
                    {
                        self.successNotice("网络请求错误")
                        print("网络请求错误")
                    }
                    
            }
            
        }
    }
    
    func dismiss(timer:NSTimer){
        alertView!.dismissWithClickedButtonIndex(0, animated:true)
    }
//    
//    /*创建表格及数据*/
//    func setupChatTable1()
//    {
//        self.tableView = SimTableView(frame:CGRectMake(0, 250,
//        self.view.frame.size.width, self.view.frame.size.height - 250))
//        //tableView.backgroundColor = UIColor.greenColor()
//        //创建一个重用的单元格
//        self.tableView!.registerClass(SimTableViewCell.self, forCellReuseIdentifier: "MsgCell")
//        
//        
//        Chats = NSMutableArray()
//        //Chats.addObjectsFromArray([first,second, third, fouth, fifth, zero, zero1])
//        
//        
//        self.tableView.chatDataSource = self
//        self.tableView.reloadData()
//        self.view.addSubview(self.tableView)
//    }
//    
  
    
//    /*返回对话记录中的全部行数*/
//    func rowsForChatTable(tableView:SimTableView) -> Int
//    {
//        return self.Chats.count
//    }
//    
//    /*返回某一行的内容*/
//    func chatTableView(tableView:SimTableView, dataForRow row:Int) -> SimMessageItem
//    {
//        return Chats[row] as! SimMessageItem
//    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        
    {
        
        
        
        let cellId = "daymiccell"
        
        //无需强制转换
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell?
        
        if(cell == nil)
            
        {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            
        }
        
        let lable1:UILabel? = (cell?.viewWithTag(1) as? UILabel)
        
        lable1?.text=(self.items[indexPath.row] as itempl).username
        
        let lable2:UILabel? = (cell?.viewWithTag(2) as? UILabel)
        
        lable2?.text=(self.items[indexPath.row] as itempl).actiontime
        
        let lable3:UILabel? = (cell?.viewWithTag(3) as? UILabel)
        //lable3?.w
        //var label = UILabel(frame: CGRectMake(0,0,ScreenWidth,0))
        //var viewBounds:CGRect = UIScreen.mainScreen().applicationFrame
        // lable3?.frame = CGRectMake(0,0,viewBounds.width/2,0);
        lable3?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        lable3?.numberOfLines=0
        
        lable3?.text=(self.items[indexPath.row] as itempl).content
        let img5:UIImageView? = (cell?.viewWithTag(5) as? UIImageView)
        
        
        var picname:String = (self.items[indexPath.row] as itempl).headface;
        
        var myhead:String="http://www.bbxiaoqu.com/uploads/".stringByAppendingString(picname)
       NSLog("myhead \(myhead)")
        Alamofire.request(.GET, myhead).response {
            (_, _, data, _) -> Void in
            if let d = data as? NSData!
            {
                img5?.image=UIImage(data: d)

            }
        }
        
        return cell!
        
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
    }
    
    
}

