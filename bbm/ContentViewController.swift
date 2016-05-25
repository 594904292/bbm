//
//  ContentViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/10.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class ContentViewController: UIViewController,UINavigationControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate{
    var alertView:UIAlertView?
    @IBOutlet weak var contentLab: UILabel!
    @IBOutlet weak var lvsv: UIScrollView!
    @IBOutlet var scrollview: UIScrollView!
    var txtMsg:UITextField!
    var sendView:UIView!;

    @IBOutlet weak var headimgview: UIImageView!
    var infoid:String = "";
    var guid:String = "";
    var puserid:String=""
    var puser:String=""
    
    var senduserid:String=""
    var senduser:String=""
    var headface:String=""
    var isjb:Bool = false;
    @IBOutlet weak var sendtime: UILabel!
    @IBOutlet weak var sendaddr: UILabel!
   
   
    var timer:NSTimer!
    var picnum:Int = 0
    var photoArr:[String] = []
    var items:[itempl]=[]
    var pics:[String]=[]
    
    var issolution:Bool=false;//是否解决
    var solutionid:String="0"//解决ID

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var locService:BMKLocationService!
    var _search:BMKGeoCodeSearch!

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
        cell.images.layer.cornerRadius = 3.0
        cell.images.layer.masksToBounds = true
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
        vc.url = url
        vc.pics = self.pics;
        self.navigationController?.pushViewController(vc, animated: true)
        
        return
    }

    @IBOutlet weak var gzbtn: UIButton!
    
    @IBAction func gzbtnaction(sender: UIButton) {
        print("gzbtnaction")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            if(self.gzbtn.titleLabel?.text == "收藏")
            {
                
                var sqlitehelpInstance1=sqlitehelp.shareInstance()
                
                let defaults = NSUserDefaults.standardUserDefaults();
                var userid = defaults.objectForKey("userid") as! String;
                sqlitehelpInstance1.addgz(self.guid, userid: userid)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.gzbtn.setTitle("取消", forState: UIControlState.Normal)
                    self.successNotice("收藏成功")
                })
            }else if(self.gzbtn.titleLabel?.text == "取消")
            {
                
                var sqlitehelpInstance1=sqlitehelp.shareInstance()
                
                let defaults = NSUserDefaults.standardUserDefaults();
                var userid = defaults.objectForKey("userid") as! String;
                sqlitehelpInstance1.removegz(self.guid, userid: userid)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.gzbtn.setTitle("收藏", forState: UIControlState.Normal)
                    self.successNotice("取消收藏成功")
                })
            }
        }
    }
    
    @IBOutlet weak var _tableview: UITableView!
    @IBAction func runchat(sender: UIButton) {
        let defaults = NSUserDefaults.standardUserDefaults();
        senduserid = defaults.objectForKey("userid") as! String;
        let sb = UIStoryboard(name:"Main", bundle: nil)
        if(puserid==senduserid)
        {
            let vc = sb.instantiateViewControllerWithIdentifier("bmuserviewcontroller") as! BmUserViewController
            //创建导航控制器
            vc.guid=self.guid;
            self.navigationController?.pushViewController(vc, animated: true)
        }else
        {
            
            //做了一次报名动作
            self.savebmThread();
            
            var sqlitehelpInstance1=sqlitehelp.shareInstance()
            
            let defaults = NSUserDefaults.standardUserDefaults();
            var myuserid = defaults.objectForKey("userid") as! String;
            
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("chatviewController") as! ChatViewController
            vc.from=puserid
            vc.myself=myuserid;
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
    }
    
    
    override func viewDidLoad() {
   
        super.viewDidLoad()
        self.navigationItem.title="查看"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "举报", style: UIBarButtonItemStyle.Done, target: self, action: "reportClick")
        
        self.reportbtn.hidden=true
        // Do any additional setup after loading the view.
        _tableview!.delegate=self
        _tableview!.dataSource=self
        collectionView!.dataSource=self
        collectionView!.delegate=self
        collectionView.backgroundColor = UIColor.whiteColor()
        loadinfo(guid);
        
        self.headimgview!.userInteractionEnabled = true
        self.headimgview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("showuser")))
        //self.marquee!.userInteractionEnabled = true
        //self.marquee!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("showpage")))
        
        setupSendPanel1()
        
        
        // 设置定位精确度，默认：kCLLocationAccuracyBest
        BMKLocationService.setLocationDesiredAccuracy(kCLLocationAccuracyBest)
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        BMKLocationService.setLocationDistanceFilter(10)
        
        //初始化BMKLocationService
        locService = BMKLocationService()
        locService.delegate = self
        //启动LocationService
        locService.startUserLocationService()
        
        _search=BMKGeoCodeSearch()
        _search.delegate=self

  }
    override func viewWillDisappear(animated: Bool) {
        
        _search.delegate=nil
        locService.delegate=self


    }
    //处理位置坐标更新
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        if(userLocation.location != nil)
        {
            print("经度: \(userLocation.location.coordinate.latitude)")
            print("纬度: \(userLocation.location.coordinate.longitude)")
            
            var defaults = NSUserDefaults.standardUserDefaults();
            defaults.setObject(String(userLocation.location.coordinate.latitude), forKey: "lat");
            defaults.setObject(String(userLocation.location.coordinate.longitude), forKey: "lng");
            
            //            defaults.setNilValueForKey("province");//省直辖市
            //            defaults.setNilValueForKey("city");//城市
            //            defaults.setNilValueForKey("sublocality");//区县
            //            defaults.setNilValueForKey("thoroughfare");//街道
            //            defaults.setNilValueForKey("address");
            
            
            defaults.synchronize();
            
            
            let pt:CLLocationCoordinate2D=CLLocationCoordinate2D(latitude: userLocation.location.coordinate.latitude, longitude: userLocation.location.coordinate.longitude)
            
            var option:BMKReverseGeoCodeOption=BMKReverseGeoCodeOption();
            option.reverseGeoPoint=pt;
            _search.reverseGeoCode(option)
           locService.stopUserLocationService()
            let _userid = defaults.objectForKey("userid") as! NSString;
            let _token = defaults.objectForKey("token") as! NSString;
            
            Alamofire.request(.POST, "http://api.bbxiaoqu.com/updatechannelid.php", parameters:["_userId" : _userid,"_channelId":_token])
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    print(response.result.value)
                    
                    
            }
            
            
            
            
            Alamofire.request(.POST, "http://api.bbxiaoqu.com/updatelocation.php", parameters:["_userId" : _userid,"_lat":String(userLocation.location.coordinate.latitude),"_lng":String(userLocation.location.coordinate.longitude),"_os":"ios"])
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    print(response.result.value)
                    
            }
        }else{
            NSLog("userLocation.location is nil")
        }
    }
    
    
    func onGetReverseGeoCodeResult(searcher:BMKGeoCodeSearch, result:BMKReverseGeoCodeResult,  errorCode:BMKSearchErrorCode)
    {
        if(errorCode.rawValue==0)
        {
            
            print("province: \(result.addressDetail.province)")
            print("city: \(result.addressDetail.city)")
            print("district: \(result.addressDetail.district)")
            print("streetName: \(result.addressDetail.streetName)")
            print("streetNumber: \(result.addressDetail.streetNumber)")
            
            
            
            print("address: \(result.address)")
            let defaults = NSUserDefaults.standardUserDefaults();
            defaults.setObject(result.addressDetail.province, forKey: "province");//省直辖市
            defaults.setObject(result.addressDetail.city , forKey: "city");//城市
            defaults.setObject(result.addressDetail.district , forKey: "sublocality");//区县
            defaults.setObject(result.addressDetail.streetName, forKey: "thoroughfare");//街道
            defaults.setObject(result.address  , forKey: "address");
            defaults.synchronize();
            
        }else
        {
            let defaults = NSUserDefaults.standardUserDefaults();
            let a:String = "";
            defaults.setObject("", forKey: "province");//省直辖市
            defaults.setObject(a, forKey: "city");//城市
            defaults.setObject(a, forKey: "sublocality");//区县
            defaults.setObject(a, forKey: "thoroughfare");//街道
            defaults.setObject(a, forKey: "address");
            defaults.synchronize();
            
        }
        //_search.delegate=nil
    }

    
    func showuser()
    {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("userinfoviewcontroller") as! UserInfoViewController
        //创建导航控制器
        vc.userid=self.puserid;
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func loadinfo(guid:String)
    {
        var url_str:String = "http://api.bbxiaoqu.com/getinfo.php?guid=".stringByAppendingString(guid)
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
                        
                        var report = JSON[0].objectForKey("report") as! String;
                        if(JSON[0].objectForKey("issolution") as! String == "1")
                        {
                            self.issolution=true
                        }else
                        {
                            self.issolution=false
                        }
                        self.solutionid = JSON[0].objectForKey("solutionid") as! String;
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.contentLab.text = contentstr;
                            self.sendtime.text = sendtimestr;
                            self.sendaddr.text = sendaddress;
                            if(report=="1")
                            {
                                self.isjb=true
                                self.reportbtn.hidden=false
                                self.reportbtn.setTitle("已举报", forState: UIControlState.Normal)
                                self.reportbtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                            }
                        })
                    }
  
                    self.photoArr = photo.characters.split{$0 == ","}.map{String($0)}
                    self.picnum=self.photoArr.count
                    if(self.photoArr.count>0)
                    {
                         for i in 1...self.photoArr.count{ //loading the images
                            let picname:String = self.photoArr[i-1]
                             var imgurl = "http://api.bbxiaoqu.com/uploads/".stringByAppendingString(picname)
                            self.pics.append(imgurl)
                            
                        }
                     }
                    //
                    var sqlitehelpInstance1=sqlitehelp.shareInstance()
                    let defaults = NSUserDefaults.standardUserDefaults();
                    var userid = defaults.objectForKey("userid") as! String;
                    if(sqlitehelpInstance1.isexitgz(self.guid, userid: userid))
                    {
                        self.gzbtn.titleLabel?.userInteractionEnabled = true
                        self.gzbtn.titleLabel?.text="取消"
                        //self.gzbtn.titleLabel?.frame.size.width = 80
                        //let sendButton = UIButton(frame:CGRectMake(235,10,77,36))
                    }else
                    {
                        self.gzbtn.titleLabel?.userInteractionEnabled = true

                        self.gzbtn.titleLabel?.text="收藏"
                        // self.gzbtn.titleLabel?.frame.size.width = 50
                    }
                    
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
  

    func loadheadface(userid:String,headname:String)
    {
        if(headname.characters.count>0)
        {
        var myhead:String="http://api.bbxiaoqu.com/uploads/".stringByAppendingString(headface)
        Alamofire.request(.GET, myhead).response { (_, _, data, _) -> Void in
            if let d = data as? NSData!
            {
                self.headimgview?.image=UIImage(data: d)
                self.headimgview.layer.cornerRadius = 5.0
                self.headimgview.layer.masksToBounds = true
            }
        }
        }else
        {
            self.headimgview?.image=UIImage(named: "logo")
            self.headimgview.layer.cornerRadius = 5.0
            self.headimgview.layer.masksToBounds = true
        }
        
    }
    

    
        func loaddiscuzzBody(infoid:String)
        {
            let url_str:String = "http://api.bbxiaoqu.com/getdiscuzz.php?infoid=".stringByAppendingString(infoid)
            Alamofire.request(.GET,url_str, parameters:nil)
                .responseJSON { response in
                     if(response.result.isSuccess)
                    {
                    if let JSON = response.result.value as? NSArray {
                        print("JSON1: \(JSON.count)")
                        if(JSON.count>0)
                        {
                            for data in JSON{
                                let id:String = data.objectForKey("id") as! String;
                                let headface:String = data.objectForKey("headface") as! String;
                                let sendtime:String = data.objectForKey("sendtime") as! String;
                                let message:String = data.objectForKey("message") as! String;
                                let uid:String = data.objectForKey("senduserid") as! String;
                                let username:String = data.objectForKey("senduser") as! String;
                                let item_obj:itempl = itempl(id: id, userid: uid, username: username, headafce: headface, actiontime: sendtime, content: message)
                                  self.items.append(item_obj)
                            }
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                if(self.items.count==0)
                                {
                                    self._tableview.hidden=true
                                }else
                                {
                                    self._tableview.hidden=false
                                self._tableview.reloadData();
                                self._tableview.doneRefresh();
                                }
                            })
    
                        }
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

    
    func reportClick()
    {
        if(self.isjb)
        {
            self.successNotice("他人已举报")
        }else
        {
            var alertView = UIAlertView()
            alertView.title = "系统提示"
            alertView.message = "您确定要举报吗？"
            alertView.addButtonWithTitle("取消")
            alertView.addButtonWithTitle("确定")
            alertView.cancelButtonIndex=0
            alertView.delegate=self;
            alertView.show()
        }
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
        sendView = UIView(frame:CGRectMake(0,self.view.frame.size.height-50,self.view.frame.size.width,50))
        sendView.backgroundColor=UIColor.grayColor()
        sendView.alpha=0.9
        //txtMsg = UITextField(frame:CGRectMake(7,10,self.view.frame.size.width-91,36))
        txtMsg = UITextField(frame:CGRectMake(7,10,self.view.frame.size.width-14,36))
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
        
       

//        let sendButton = UIButton(frame:CGRectMake(view.frame.size.width-77,10,77,36))
//        sendButton.backgroundColor=UIColor.lightGrayColor()
//        sendButton.addTarget(self, action:Selector("sendMessage") ,forControlEvents:UIControlEvents.TouchUpInside)
//        sendButton.layer.cornerRadius=6.0
//        sendButton.setTitle("发送", forState:UIControlState.Normal)
//        
//        sendView.addSubview(sendButton)
        
        self.view.addSubview(sendView)
       self.view.bringSubviewToFront(sendView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:"handleTouches:")
        tapGestureRecognizer.cancelsTouchesInView = false
        self.scrollview.addGestureRecognizer(tapGestureRecognizer)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool
    {
        sendMessage()
        return true
    }
    
   
    func sendMessage()        
    {
        var sender = txtMsg
        
        if(sender.text?.characters.count==0)
        {
            self.successNotice("评论不能为空")
            return;
        }
        var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        var strNowTime = timeFormatter.stringFromDate(date) as String

        let defaults = NSUserDefaults.standardUserDefaults();
        senduserid = defaults.objectForKey("userid") as! String;
        senduser = defaults.objectForKey("nickname") as! String;
        
        var myselfheadface:String = defaults.objectForKey("headface") as! String;
        
        let item_obj:itempl = itempl(id: "0", userid: senduserid, username: senduser, headafce: headface, actiontime: strNowTime, content: sender.text!)
        self.items.append(item_obj)
        
        self._tableview.reloadData()
        sender.resignFirstResponder()
      
        
        let  dic:Dictionary<String,String> = ["_infoid" : infoid,"_sendtime" : strNowTime,"_puserid" : puserid,"_puser" : puser,"_touserid" : senduserid,"_touser" : senduser,"_message" : sender.text!]
          sender.text="";
        var url_str:String = "http://api.bbxiaoqu.com/discuzz.php";
        Alamofire.request(.POST,url_str, parameters:dic)
            .responseString{ response in
                if(response.result.isSuccess)
                {
                if let ret = response.result.value  {
                    if String(ret)=="1"
                    {
                        //做了一次报名动作
                        self.savebmThread();
                        
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
    
    
    func savebmThread()
    {
        let defaults = NSUserDefaults.standardUserDefaults();
        var senduseridstr = defaults.objectForKey("userid") as! String;

        let  dics:Dictionary<String,String> = ["_infoid" : self.infoid,"_userid" : senduseridstr,"_guid" : self.guid,"_action" : "add"]
        
        var url_str:String = "http://api.bbxiaoqu.com/adduserbminfo.php";
        Alamofire.request(.POST,url_str, parameters:dics)
            .responseString{ response in
                if(response.result.isSuccess)
                {
                    print("报名成功")
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
    }
    @IBOutlet weak var reportbtn: UIButton!
        
    
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
            
            var  dic:Dictionary<String,String> = ["guid" : guid, "userid": userid, "addtime": strNowTime]
            Alamofire.request(.POST, "http://api.bbxiaoqu.com/savereport.php", parameters: dic)
                .responseJSON { response in
                    if(response.result.isSuccess)
                    {
                        self.isjb=true;
                         self.reportbtn.hidden=false
                        self.reportbtn.setTitle("已举报", forState: UIControlState.Normal)
                        self.reportbtn.enabled=false
                        
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

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellId = "daymiccell"
        var cell:PlTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! PlTableViewCell?
        if(cell == nil)
        {
            cell = PlTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
        }
        cell?.pluser?.text=(self.items[indexPath.row] as itempl).username
        cell?.pltime.text=(self.items[indexPath.row] as itempl).actiontime
        cell?.plcontent?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell?.plcontent?.numberOfLines=0
        cell?.plcontent?.text=(self.items[indexPath.row] as itempl).content
        var headface:String = (self.items[indexPath.row] as itempl).headface;
        if(headface.characters.count>0)
        {
            var myhead:String="http://api.bbxiaoqu.com/uploads/".stringByAppendingString(headface)
            Alamofire.request(.GET, myhead).response {
                (_, _, data, _) -> Void in
                if let d = data as? NSData!
                {
                    cell?.plheadface?.image=UIImage(data: d)
                }
            }
        }else
        {
            cell?.plheadface?.image=UIImage(named: "logo")
        }
        cell?.plheadface.layer.cornerRadius = 5.0
        cell?.plheadface.layer.masksToBounds = true

        tableView.userInteractionEnabled = true
        if(self.issolution)
        {
            if(self.solutionid==(self.items[indexPath.row] as itempl).id)
            {
                //cell?.plgoodbtn.titleLabel?.text="获最佳"
                cell?.plgoodbtn.setTitle("获最佳", forState: UIControlState.Normal)
                cell?.plgoodbtn.enabled=false;
                cell?.plgoodbtn.hidden=false

            
            }else
            {
                cell?.plgoodbtn.hidden=true

            }
        }else
        {
            let defaults = NSUserDefaults.standardUserDefaults();
            let userid = defaults.objectForKey("userid") as! String;
            if(self.puserid == userid)
            {
                cell?.plgoodbtn.titleLabel?.text="最佳"
                cell?.plgoodbtn.userInteractionEnabled = true
                cell?.plgoodbtn.tag = indexPath.row
                cell?.plgoodbtn.addTarget(self,action:Selector("tapped:"),forControlEvents:.TouchUpInside)

            }else
            {
                cell?.plgoodbtn.hidden=true
            }
        }
        
        
         return cell!
    }
    
    
    func tapped(button:UIButton){
        var pos:Int = button.tag
        var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        var strNowTime = timeFormatter.stringFromDate(date) as String
        
        var  dic:Dictionary<String,String> = ["_infoid" : infoid, "_guid": guid]
        
         dic["_solutiontype"] = "1"
         dic["_solutionpostion"] = (self.items[pos] as itempl).id
         dic["_solutionuserid"] = (self.items[pos] as itempl).userid
        dic["_solutiontime"] = strNowTime
        
        Alamofire.request(.POST, "http://api.bbxiaoqu.com/solution.php", parameters: dic)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    self.successNotice("已解决")
                    print("已解决")

                    
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
                
        }
        

        
        
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

