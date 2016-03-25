//
//  OneViewController.swift
//  bbm
//
//  Created by ericsong on 15/9/28.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class OneViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ApnsDelegate ,UINavigationControllerDelegate{

    var start:Int = 0
    var limit:Int = 10
   
    var items:[itemMess]=[]
    var fwitems:[itemfwMess]=[]
     @IBOutlet weak var _tableView: UITableView!
    func NewMessage(string:String){
        if(selectedSegmentval==0)
        {
            
            querydata(0)
        }else if(selectedSegmentval==1)
        {
            
            querydata(1)
        }else if(selectedSegmentval==2)
        {
            
            querydata(2)
        }else if(selectedSegmentval==3)
        {
            
            querydata(3)
        }

        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title="动态"
         //(UIApplication.sharedApplication().delegate as! AppDelegate).apnsdelegate = self
        //告诉apnsdelegate我在这个里面实现
        self.navigationItem.title="我能帮"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        
        
      
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "添加", style: UIBarButtonItemStyle.Done, target: self, action: "addClick")
 
        _tableView!.delegate=self
        _tableView!.dataSource=self
  
        self._tableView.headerView = XWRefreshNormalHeader(target: self, action: "upPullLoadData")
        
        self._tableView.headerView?.beginRefreshing()
        self._tableView.headerView?.endRefreshing()
        
        self._tableView.footerView = XWRefreshAutoNormalFooter(target: self, action: "downPlullLoadData")
        
        if(selectedSegmentval==0)
        {
             querydata(0)
        }else if(selectedSegmentval==1)
        {
            querydata(1)
        }else if(selectedSegmentval==2)
        {
             querydata(2)
        }else if(selectedSegmentval==3)
        {
             querydata(3)
        }

        

    }
    @IBOutlet weak var segment1: UISegmentedControl!
    var selectedSegmentval:Int=0;
    @IBAction func segmentValueChange(sender: AnyObject) {
        NSLog("you Selected Index\(segment1.selectedSegmentIndex)")
        self.selectedSegmentval=segment1.selectedSegmentIndex;
        
        self.items.removeAll()
        self.fwitems.removeAll()
        
       
        if(self.selectedSegmentval==0)
        {
            self.items.removeAll()
            querydata(0)
        }else if(self.selectedSegmentval==1)
        {
            self.items.removeAll()
            querydata(1)
        }else if(self.selectedSegmentval==2)
        {
            self.items.removeAll()
            querydata(2)
        }else if(self.selectedSegmentval==3)
        {
            self.fwitems.removeAll()
            querydata(3)
        }
         self._tableView.reloadData()
    }
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    func addClick()
    {
        NSLog("addClick");
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("publishfwController") as! PublishfwViewController
        vc.cat=3
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    //MARK: 加载数据
    func upPullLoadData(){
        
        //延迟执行 模拟网络延迟，实际开发中去掉
        xwDelay(1) { () -> Void in
            self.start=0;
            if(self.selectedSegmentval==0)
            {
                self.querydata(0)
            }else if(self.selectedSegmentval==1)
            {
                self.querydata(1)
            }else if(self.selectedSegmentval==2)
            {
                self.querydata(2)
            }else if(self.selectedSegmentval==3)
            {
                self.querydata(3)
            }
            self._tableView.reloadData()
            self._tableView.headerView?.endRefreshing()
        }
    }
    
    func downPlullLoadData(){
        
        xwDelay(1) { () -> Void in
            self.start=self.limit;
            if(self.selectedSegmentval==0)
            {
                
                self.querydata(0)
            }else if(self.selectedSegmentval==1)
            {
                
                self.querydata(1)
            }else if(self.selectedSegmentval==2)
            {
                
                self.querydata(2)
            }else if(self.selectedSegmentval==3)
            {
                
                self.querydata(3)
            }

            self._tableView.reloadData()
            self._tableView.footerView?.endRefreshing()
        }
        
    }

    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            NSLog("indexPath is = %i",self.selectedSegmentval);

            
            if(self.selectedSegmentval==3)
            {
                return self.fwitems.count;
            }else
            {
                return self.items.count;
            }
        }
    
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                       if self.selectedSegmentval==3
            {
                let cellId="mycell3"
                var cell:fwTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! fwTableViewCell?
                if(cell == nil)
                {
                    cell = fwTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
                }
                //NSLog("fwitems count is = %i",fwitems.count);
                //NSLog("indexPath is = %i",indexPath.row);
                var ifm:itemfwMess = fwitems[indexPath.row] as itemfwMess;
                cell?.senduser.text=(fwitems[indexPath.row] as itemfwMess).username
                cell?.usertag.text=(fwitems[indexPath.row] as itemfwMess).tags
                if (fwitems[indexPath.row] as itemfwMess).fwname == "帮帮忙"
                {
                    cell?.title.text=(fwitems[indexPath.row] as itemfwMess).content
                }else
                {
                    cell?.title.text=(fwitems[indexPath.row] as itemfwMess).fwname
                }
                let defaults = NSUserDefaults.standardUserDefaults();
                var sqlitehelpInstance1=sqlitehelp.shareInstance()
                var userid = defaults.objectForKey("userid") as! String;
                var guid:String=(fwitems[indexPath.row] as itemfwMess).guid;
                
                var v:Bool=sqlitehelpInstance1.isexitzan(guid, userid: userid);
                if(v)
                {
                    cell?.zan.setBackgroundImage(UIImage(named: "tab_sub_sos_sel"), forState: UIControlState.Normal)
                }else
                {
                    cell?.zan.setBackgroundImage(UIImage(named: "tab_sub_sos"), forState: UIControlState.Normal)
                }
                cell?.zan.tag = indexPath.row
                //cell?.zan.setTitle(String(indexPath.row)+"__"+(fwitems[indexPath.row] as itemfwMess).zannum, forState: UIControlState.Normal)
                cell?.zan.setTitle((fwitems[indexPath.row] as itemfwMess).zannum, forState: UIControlState.Normal)
                cell?.zan.addTarget(self,action:Selector("zantapped:"),forControlEvents:.TouchUpInside)
                
                cell?.tel.tag = indexPath.row
                cell?.tel.addTarget(self,action:Selector("teltapped:"),forControlEvents:.TouchUpInside)
                var head:String = "http://api.bbxiaoqu.com/uploads/"+(fwitems[indexPath.row] as itemfwMess).headface
                Alamofire.request(.GET, head).response { (_, _, data, _) -> Void in
                    if let d = data as? NSData!
                    {
                        cell?.headface.image=UIImage(data: d)
                    }
                }
                NSLog("indexPath is = %i",indexPath.row);
                return cell!
                
            }else
            {
                var ppp:String = (items[indexPath.row] as itemMess).photo;
                if ppp.characters.count > 0
                {
                    let cellId="mycell1"
                    var cell:InfopicTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! InfopicTableViewCell?
                    if(cell == nil)
                    {
                        cell = InfopicTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
                    }
                    
                    cell?.senduser.text=(items[indexPath.row] as itemMess).username
                    cell?.message.text=(items[indexPath.row] as itemMess).content
                    cell?.sendtime.text=(items[indexPath.row] as itemMess).time
                    cell?.sendaddress.text=(items[indexPath.row] as itemMess).address
                    if ((items[indexPath.row] as itemMess).infocatagory == "0")
                    {
                        cell?.catagory.text="求"
                        
                    }else if ((items[indexPath.row] as itemMess).infocatagory == "1")
                    {
                        cell?.catagory.text="寻"
                    }else if ((items[indexPath.row] as itemMess).infocatagory == "2")
                    {
                        cell?.catagory.text="转"
                    }else if ((items[indexPath.row] as itemMess).infocatagory == "3")
                    {
                        cell?.catagory.text="帮"
                    }
                    if ((items[indexPath.row] as itemMess).status == "0")
                    {
                        cell?.status.text="求助中"
                        cell?.status.textColor = UIColor.redColor()
                        
                    }else if ((items[indexPath.row] as itemMess).status == "1")
                    {
                        cell?.status.text="解决中"
                        cell?.status.textColor = UIColor.redColor()
                        
                    }else if ((items[indexPath.row] as itemMess).status == "2")
                    {
                        cell?.status.text="已解决"
                        cell?.status.textColor = UIColor.greenColor()
                        
                    }

                    
                   if((items[indexPath.row] as itemMess).photo.isKindOfClass(NSNull))
                    {
                        cell?.icon.image=UIImage(named: "icon")

                    }else
                    {
                        var head:String!
                        
                        if ppp.characters.count > 0
                        {
                            if((ppp.rangeOfString(",") ) != nil)
                            {
                                var myArray = ppp.componentsSeparatedByString(",")
                                var headname = myArray[0] as String
                                head = "http://api.bbxiaoqu.com/uploads/"+headname
                                
                                 NSLog("-1--\(head)")
                            }else
                            {
                                head = "http://api.bbxiaoqu.com/uploads/"+ppp
                                 NSLog("-2--\(head)")
                            }
                            
                            NSLog("\((items[indexPath.row] as itemMess).photo)")
                           
                            Alamofire.request(.GET, head!).response { (_, _, data, _) -> Void in
                                if let d = data as? NSData!
                                {
                                     cell?.icon.image=UIImage(data: d)
                                }
                            }
                        }else
                        {
                            cell?.icon.image=UIImage(named: "icon")
                        }
                    }
                    cell?.gz.text="关:"+(items[indexPath.row] as itemMess).visnum;
                    cell?.pl.text="评:"+(items[indexPath.row] as itemMess).plnum;
                    return cell!
                }else
                {
                    let cellId="mycell2"
                    var cell:InfoTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! InfoTableViewCell?
                    if(cell == nil)
                    {
                        cell = InfoTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
                    }
                    cell?.senduser.text=(items[indexPath.row] as itemMess).username
                    cell?.Message.text=(items[indexPath.row] as itemMess).content
                    cell?.sendtime.text=(items[indexPath.row] as itemMess).time
                    cell?.sendaddress.text=(items[indexPath.row] as itemMess).address


                    if ((items[indexPath.row] as itemMess).infocatagory == "0")
                    {
                        cell?.catagory.text="求"
                        
                    }else if ((items[indexPath.row] as itemMess).infocatagory == "1")
                    {
                        cell?.catagory.text="寻"
                    }else if ((items[indexPath.row] as itemMess).infocatagory == "2")
                    {
                        cell?.catagory.text="转"
                    }else if ((items[indexPath.row] as itemMess).infocatagory == "3")
                    {
                        cell?.catagory.text="帮"
                    }
                    
                    if ((items[indexPath.row] as itemMess).status == "0")
                    {
                        cell?.status.text="求助中"
                        cell?.status.textColor = UIColor.redColor()
                        
                    }else if ((items[indexPath.row] as itemMess).status == "1")
                    {
                        cell?.status.text="解决中"
                        cell?.status.textColor = UIColor.redColor()
                        
                    }else if ((items[indexPath.row] as itemMess).status == "2")
                    {
                        cell?.status.text="已解决"
                        cell?.status.textColor = UIColor.greenColor()
                        
                    }
                    cell?.gz.text="关:"+(items[indexPath.row] as itemMess).visnum;
                    cell?.pl.text="评:"+(items[indexPath.row] as itemMess).plnum;
                    return cell!
                }
            }
        }
    
    var seltel:String = "";
    func teltapped(button:UIButton){
        //print(button.titleForState(.Normal))
        var pos:Int = button.tag
        seltel = (fwitems[pos] as itemfwMess).telphone;
        
        var alertView = UIAlertView()
        alertView.title = "系统提示"
        alertView.message = "您确定要呼叫吗？"
        alertView.addButtonWithTitle("取消")
        alertView.addButtonWithTitle("确定")
        alertView.cancelButtonIndex=0
        alertView.delegate=self;
        alertView.show()

    }
    func zantapped(button:UIButton){
        //判断
        var pos:Int = button.tag
        NSLog("indexPath is = %i",pos);
        var zan:String = (fwitems[pos] as itemfwMess).zannum;
        let defaults = NSUserDefaults.standardUserDefaults();
        

        var sqlitehelpInstance1=sqlitehelp.shareInstance()
        var userid = defaults.objectForKey("userid") as! String;
        var guid:String=(fwitems[pos] as itemfwMess).guid;
        
        var v:Bool=sqlitehelpInstance1.isexitzan(guid, userid: userid);
        if(v)
        {
            var zann:Int = Int(zan)!
            button.setTitle(String(zann-1), forState: UIControlState.Normal)
            sqlitehelpInstance1.removezan(guid, userid: userid)
            button.setBackgroundImage(UIImage(named: "tab_sub_sos"), forState: UIControlState.Normal)
        }else
        {
            var zann:Int = Int(zan)!
            button.setTitle(String(zann+1), forState: UIControlState.Normal)
            
            sqlitehelpInstance1.addzan(guid, userid: userid)
            button.setBackgroundImage(UIImage(named: "tab_sub_sos_sel"), forState: UIControlState.Normal)
        }
        
    }

    
    
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
            
        }
        else
        {
            var url1 = NSURL(string: "tel://"+seltel)
            UIApplication.sharedApplication().openURL(url1!)
        }
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        //NSLog("select \(items[indexPath.row])")
         if(self.selectedSegmentval==3)
         {
            let aa:itemfwMess=fwitems[indexPath.row] as itemfwMess;
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("contentfwviewController") as! ContentfwViewController
            //创建导航控制器
            //vc.message = aa.content;
            vc.guid=aa.guid
            vc.infoid=aa.guid
            //设置根视图
            self.navigationController?.pushViewController(vc, animated: true)
        }else
         {
            
            
            
            let aa:itemMess=items[indexPath.row] as itemMess;
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("contentviewController") as! ContentViewController
            //创建导航控制器
            //vc.message = aa.content;
            vc.guid=aa.guid
            vc.infoid=aa.guid
            //设置根视图
            self.navigationController?.pushViewController(vc, animated: true)

        
         }

    }
    
    
    
    
    
    func querydata(Category:Int)
    {
        var url:String="";
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! String;
        
        if(Category==0)
        {
            url="http://api.bbxiaoqu.com/getinfos.php?userid=".stringByAppendingString(userid).stringByAppendingString("&rang=xiaoqu&status=0&start=").stringByAppendingString(String(self.start)).stringByAppendingString("&limit=").stringByAppendingString(String(self.limit));

        
        }else if(Category==1)
        {
            url="http://api.bbxiaoqu.com/getinfos.php?userid=".stringByAppendingString(userid).stringByAppendingString("&rang=xiaoqu&status=1&start=").stringByAppendingString(String(self.start)).stringByAppendingString("&limit=").stringByAppendingString(String(self.limit));

        }else if(Category==2)
        {
            url="http://api.bbxiaoqu.com/getinfos.php?userid=".stringByAppendingString(userid).stringByAppendingString("&rang=self&status=1&start=").stringByAppendingString(String(self.start)).stringByAppendingString("&limit=").stringByAppendingString(String(self.limit));

        }else if(Category==3)
        {
            url="http://api.bbxiaoqu.com/getfwinfos.php?userid=".stringByAppendingString(userid).stringByAppendingString("&rang=xiaoqufw&status=1&start=").stringByAppendingString(String(self.start)).stringByAppendingString("&limit=").stringByAppendingString(String(self.limit));

        }
        if(Category==3)
        {
            print("url: \(url)")
            Alamofire.request(.GET, url, parameters: nil)
                .responseJSON { response in
                    if(response.result.isSuccess)
                    {
                        
                        
                        if let jsonItem = response.result.value as? NSArray{
                            if(jsonItem.count>0)
                            {
                                for data in jsonItem{
                                    print("data: \(data)")
                                    let title:String = data.objectForKey("title") as! String;

                                    let content:String = data.objectForKey("content") as! String;
                                    let senduserid:String = data.objectForKey("senduser") as! String;
                                    
                                    var sendnickname:String = "";
                                    if(data.objectForKey("username")!.isKindOfClass(NSNull))
                                    {
                                        sendnickname="";
                                    }else
                                    {
                                        sendnickname   = data.objectForKey("username") as! String;
                                        
                                    }
                                    let guid:String = data.objectForKey("guid") as! String;
                                    let sendtime:String = data.objectForKey("sendtime") as! String;
                                    let address:String = data.objectForKey("address") as! String;
                                    let lng:String = data.objectForKey("lng") as! String;
                                    let lat:String = data.objectForKey("lat") as! String;
                                    let photo:String = data.objectForKey("photo") as! String;
                                    var community:String = ""
                                    if(data.objectForKey("community")!.isKindOfClass(NSNull))
                                    {
                                        community = "";
                                    }else
                                    {
                                        community = data.objectForKey("community") as! String;
                                        
                                    }
                                    let infocatagroy:String = data.objectForKey("infocatagroy") as! String;
                                    let status:String = data.objectForKey("status") as! String;
                                    let visit:String = data.objectForKey("visit") as! String;
                                    let plnum:String = data.objectForKey("plnum") as! String;
                                    
                                    let headface:String = data.objectForKey("headface") as! String;
                                    let telphone:String = data.objectForKey("telphone") as! String;
                                    let zannum:String = data.objectForKey("zannum") as! String;
                                    let tags:String = data.objectForKey("tags") as! String;
                                    
                                    let item_obj:itemfwMess = itemfwMess(userid: senduserid, vname: sendnickname, vtime: sendtime, vaddress: address,fwname:title,vcontent:content, vcommunity: community, vlng: lng, vlat: lat, vguid: guid, vinfocatagory: infocatagroy, vphoto: photo, status: status, visnum: visit, plnum: plnum,headface:headface,telphone:telphone,zannum:zannum,tags:tags)
                                    self.fwitems.append(item_obj)
                                    
                                }
                            }else
                            {
                                
                            }
                            self._tableView.reloadData()
                            self._tableView.doneRefresh()
                            
                        }
                    }else
                    {
                        self.successNotice("网络请求错误")
                        print("网络请求错误")
                    }
                    
                    
            }
        
        }else
        {
            print("url: \(url)")
            Alamofire.request(.GET, url, parameters: nil)
                .responseJSON { response in
                    if(response.result.isSuccess)
                    {
                        
                        
                        if let jsonItem = response.result.value as? NSArray{
                            for data in jsonItem{
                                //print("data: \(data)")
                            
                            let content:String = data.objectForKey("content") as! String;
                            let senduserid:String = data.objectForKey("senduser") as! String;
                            
                            var sendnickname:String = "";
                            if(data.objectForKey("username")!.isKindOfClass(NSNull))
                            {
                                sendnickname="";
                            }else
                            {
                                sendnickname   = data.objectForKey("username") as! String;
                                
                            }
                            let guid:String = data.objectForKey("guid") as! String;
                            let sendtime:String = data.objectForKey("sendtime") as! String;
                            let address:String = data.objectForKey("address") as! String;
                            let lng:String = data.objectForKey("lng") as! String;
                            let lat:String = data.objectForKey("lat") as! String;
                            let photo:String = data.objectForKey("photo") as! String;
                            var community:String = ""
                             if(data.objectForKey("community")!.isKindOfClass(NSNull))
                            {
                                community = "";
                            }else
                            {
                                community = data.objectForKey("community") as! String;
                                
                            }
                             let infocatagroy:String = data.objectForKey("infocatagroy") as! String;
                            let status:String = data.objectForKey("status") as! String;
                            let visit:String = data.objectForKey("visit") as! String;
                            let plnum:String = data.objectForKey("plnum") as! String;
                            let item_obj:itemMess = itemMess(userid: senduserid, vname: sendnickname, vtime: sendtime, vaddress: address, vcontent: content, vcommunity: community, vlng: lng, vlat: lat, vguid: guid, vinfocatagory: infocatagroy, vphoto: photo, status: status, visnum: visit, plnum: plnum)
                             self.items.append(item_obj)

                        }
                        self._tableView.reloadData()
                        self._tableView.doneRefresh()

                    }
                    }else
                    {
                        self.successNotice("网络请求错误")
                        print("网络请求错误")
                    }

             }
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    //定位改变执行，可以得到新位置、旧位置
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        
        let currLocation:CLLocation = locations.last!
        print("经度：\(currLocation.coordinate.longitude)")
        print("纬度：\(currLocation.coordinate.latitude)")
        
        let defaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject(String(currLocation.coordinate.latitude), forKey: "lat");
        defaults.setObject(String(currLocation.coordinate.longitude), forKey: "lng");
        defaults.synchronize();
        
        
        var geocoder:CLGeocoder=CLGeocoder();
        geocoder.reverseGeocodeLocation(currLocation,
            completionHandler: { (placemarks, error) -> Void in
                if error != nil {
                    return
                }
                let p:CLPlacemark = placemarks!.last!
                //NSLog(p.description)
                print("name：\(p.name)")
                print("country：\(p.country)")
                print("postalCode：\(p.postalCode)")
                print("locality：\(p.locality)")
                print("subLocality：\(p.subLocality)")
                
                print("thoroughfare：\(p.thoroughfare)")
                
                print("administrativeArea：\(p.administrativeArea)")
                print("subAdministrativeArea：\(p.subAdministrativeArea)")
                print("inlandWater：\(p.inlandWater)")
                
                print("areasOfInterest：\(p.areasOfInterest)")
                
                
                
                let defaults = NSUserDefaults.standardUserDefaults();
                defaults.setObject(p.country, forKey: "country");
                defaults.setObject(p.locality, forKey: "province");//省直辖市
                defaults.setObject(p.administrativeArea  , forKey: "city");//城市
                defaults.setObject(p.subAdministrativeArea  , forKey: "subadministrativearea");//城市
                defaults.setObject(p.subLocality  , forKey: "sublocality");//区县
                defaults.setObject(p.thoroughfare  , forKey: "thoroughfare");//街道
                defaults.setObject(p.name  , forKey: "address");
                defaults.synchronize();
                
                
                let _userid = defaults.objectForKey("userid") as! NSString;
                let _token = defaults.objectForKey("token") as! NSString;
                //更新下地理位置
                
                Alamofire.request(.POST, "http://api.bbxiaoqu.com/updatechannelid.php", parameters:["_userId" : _userid,"_channelId":_token])
                    .responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        print(response.result.value)
                        
                        
                }
                
                
                
                
                Alamofire.request(.POST, "http://api.bbxiaoqu.com/updatelocation.php", parameters:["_userId" : _userid,"_lat":String(currLocation.coordinate.latitude),"_lng":String(currLocation.coordinate.longitude),"_os":"ios"])
                    .responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        print(response.result.value)
                        
                        
                }
                
         })
        
        
      }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print(error)
    }
    
}
