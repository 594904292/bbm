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
        
        
              // weak var weakSelf = self as OneViewController
       // (UIApplication.sharedApplication().delegate as! AppDelegate).apnsdelegate = self
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
        selectedSegmentval=segment1.selectedSegmentIndex;
         self.items.removeAll()
        self._tableView.reloadData()
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
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    func addClick()
    {
        NSLog("addClick");
        
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
            return self.items.count;
        }
    
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            var ppp:String = (items[indexPath.row] as itemMess).photo;
            if ppp.characters.count > 0
            {
                let cellId="mycell"
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
                            head = "http://www.bbxiaoqu.com/uploads/"+headname
                            
                             NSLog("-1--\(head)")
                        }else
                        {
                            head = "http://www.bbxiaoqu.com/uploads/"+ppp
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
                let cellId="mycell1"
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        //NSLog("select \(items[indexPath.row])")
        let aa:itemMess=items[indexPath.row] as itemMess;
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("contentviewController") as! ContentViewController
                //创建导航控制器
        //vc.message = aa.content;
        vc.guid=aa.guid
        vc.infoid=aa.guid
       // let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
      //  self.view.window!.rootViewController=nvc;
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    
    
    
    func querydata(Category:Int)
    {
        var url:String="";
        if(Category==0)
        {
            url="http://www.bbxiaoqu.com/getinfos.php?userid=369&rang=xiaoqu&status=0&start=".stringByAppendingString(String(self.start)).stringByAppendingString("&limit=").stringByAppendingString(String(self.limit));

        
        }else if(Category==1)
        {
            url="http://www.bbxiaoqu.com/getinfos.php?userid=369&rang=xiaoqu&status=1&start=".stringByAppendingString(String(self.start)).stringByAppendingString("&limit=").stringByAppendingString(String(self.limit));

        }else if(Category==2)
        {
            url="http://www.bbxiaoqu.com/getinfos.php?userid=369&rang=self&status=1&start=".stringByAppendingString(String(self.start)).stringByAppendingString("&limit=").stringByAppendingString(String(self.limit));

        }else if(Category==3)
        {
            url="http://www.bbxiaoqu.com/getinfos.php?userid=369&rang=xiaoqufw&status=1&start=".stringByAppendingString(String(self.start)).stringByAppendingString("&limit=").stringByAppendingString(String(self.limit));

        }
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
                
                
                
                //                    NSLog("\n name:%@\n  country:%@\n postalCode:%@\n ISOcountryCode:%@\n ocean:%@\n inlandWater:%@\n locality:%@\n subLocality:%@\n administrativeArea:%@\n subAdministrativeArea:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
                //                        p.name!,
                //                        p.country!,
                //                        p.postalCode!,
                //                        p.ISOcountryCode!,//国家代码
                //                        p.ocean!,//大洋
                //                        p.inlandWater!,//
                //                        p.administrativeArea!,
                //                        p.subAdministrativeArea!,
                //                        p.locality!,
                //                        p.subLocality!,
                //                        p.thoroughfare!,
                //                        p.subThoroughfare!)
                
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
                
                Alamofire.request(.POST, "http://www.bbxiaoqu.com/updatechannelid.php", parameters:["_userId" : _userid,"_channelId":_token])
                    .responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        print(response.result.value)
                        
                        
                }
                
                
                
                
                Alamofire.request(.POST, "http://www.bbxiaoqu.com/updatelocation.php", parameters:["_userId" : _userid,"_lat":String(currLocation.coordinate.latitude),"_lng":String(currLocation.coordinate.longitude),"_os":"ios"])
                    .responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        print(response.result.value)
                        
                        
                }
                
                
                //                    public var thoroughfare: String? { get } // street name, eg. Infinite Loop
                //                    public var subThoroughfare: String? { get } // eg. 1
                //                    public var locality: String? { get } // city, eg. Cupertino
                //                    public var subLocality: String? { get } // neighborhood, common name, eg. Mission District
                //                    public var administrativeArea: String? { get } // state, eg. CA
                //                    public var subAdministrativeArea: String? { get } // county, eg. Santa Clara
                //                    public var postalCode: String? { get } // zip code, eg. 95014
                //                    public var ISOcountryCode: String? { get } // eg. US
                //                    public var country: String? { get } // eg. United States
                //                    public var inlandWater: String? { get } // eg. Lake Tahoe
                //                    public var ocean: String? { get } // eg. Pacific Ocean
                //                    public var areasOfInterest: [String]? { get } // eg. Golden Gate Park
        })
        
        
        //        label1.text = "经度：\(currLocation.coordinate.longitude)"
        //        //获取纬度
        //        label2.text = "纬度：\(currLocation.coordinate.latitude)"
        //        //获取海拔
        //        label3.text = "海拔：\(currLocation.altitude)"
        //        //获取水平精度
        //        label4.text = "水平精度：\(currLocation.horizontalAccuracy)"
        //        //获取垂直精度
        //        label5.text = "垂直精度：\(currLocation.verticalAccuracy)"
        //        //获取方向
        //        label6.text = "方向：\(currLocation.course)"
        //        //获取速度
        //        label7.text = "速度：\(currLocation.speed)"
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print(error)
    }
    
}
