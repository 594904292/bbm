//
//  MainViewController.swift
//  bbm
//
//  Created by ericsong on 15/12/10.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate {

    @IBAction func gonggaobtn(sender: UIButton) {
        
        var urlstr:String="http://www.bbxiaoqu.com/wap/gonggao.php?id=".stringByAppendingString(ggid)
        var url=NSURL(string: urlstr)
        UIApplication.sharedApplication().openURL(url!)
    }
    @IBAction func cansos(sender: UIButton) {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("tabone") as! OneViewController
       self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func sos(sender: UIButton) {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("publishController") as! PublishViewController
        vc.cat=0;
        self.navigationController?.pushViewController(vc, animated: true)

    }
    var items:[itemDaymic]=[]
     var ggid:String = "";
    
    
    @IBOutlet weak var ggview: UIView!
    
    @IBOutlet weak var _tableview: UITableView!
    //定位管理器
    //let locationManager:CLLocationManager = CLLocationManager()
    var locService:BMKLocationService!
    var marquee: CHWMarqueeView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title="帮帮小区"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "设置", style: UIBarButtonItemStyle.Done, target: self, action: "SetClick")
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "退出", style: UIBarButtonItemStyle.Done, target: self, action: "exitClick")
        
        
       self.view.userInteractionEnabled=true
        
        showgg()
        
        _tableview!.delegate=self
        _tableview!.dataSource=self

        self.automaticallyAdjustsScrollViewInsets = false
        
        querydata()
        self.appDelegate().connect()
        

        // 设置定位精确度，默认：kCLLocationAccuracyBest
        BMKLocationService.setLocationDesiredAccuracy(kCLLocationAccuracyBest)
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        BMKLocationService.setLocationDistanceFilter(10)
        
        //初始化BMKLocationService
        locService = BMKLocationService()
        locService.delegate = self
        //启动LocationService
        locService.startUserLocationService()
       
     }
    
    //处理方向变更信息
    func didUpdateUserHeading(userLocation: BMKUserLocation!) {
        if(userLocation.location != nil)
        {
            print("经度: \(userLocation.location.coordinate.latitude)")
            print("纬度: \(userLocation.location.coordinate.longitude)")
            let defaults = NSUserDefaults.standardUserDefaults();
            defaults.setObject(String(userLocation.location.coordinate.latitude), forKey: "lat");
            defaults.setObject(String(userLocation.location.coordinate.longitude), forKey: "lng");
            defaults.synchronize();
            locService.stopUserLocationService()
        }else{
            NSLog("userLocation.location is nil")
        }
    }
    
    //处理位置坐标更新
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
         if(userLocation.location != nil)
         {
            print("经度: \(userLocation.location.coordinate.latitude)")
            print("纬度: \(userLocation.location.coordinate.longitude)")
            let defaults = NSUserDefaults.standardUserDefaults();
            defaults.setObject(String(userLocation.location.coordinate.latitude), forKey: "lat");
            defaults.setObject(String(userLocation.location.coordinate.longitude), forKey: "lng");
            defaults.synchronize();
            locService.stopUserLocationService()
         }else{
            NSLog("userLocation.location is nil")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
            locService.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
            locService.delegate = nil
    }
    
    //取得当前程序的委托
    func  appDelegate() -> AppDelegate{
         return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    

    
    
    //MARK: 加载数据
    func upPullLoadData(){
        //延迟执行 模拟网络延迟，实际开发中去掉
        xwDelay(1) { () -> Void in
            self.querydata()
            self._tableview.reloadData()
            self._tableview.headerView?.endRefreshing()
        }
    }
    
    func downPlullLoadData(){
        xwDelay(1) { () -> Void in
            self.querydata()
            self._tableview.reloadData()
            self._tableview.footerView?.endRefreshing()
        }
     }
    

    
    func querydata()
    {
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! String;
        let url:String="http://www.bbxiaoqu.com/getdynamics.php?userid=".stringByAppendingString(userid).stringByAppendingString("&rang=xiaoqu&start=0&limit=20");
        print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                if let jsonItem = response.result.value as? NSArray{
                    for data in jsonItem{
                        print("data: \(data)")
                        let id:String = data.objectForKey("id") as! String;
                        let userid:String = data.objectForKey("userid") as! String;
                        let username:String = data.objectForKey("username") as! String;
                        let actionname:String = data.objectForKey("actionname") as! String;
                        let actiontime:String = data.objectForKey("actiontime") as! String;
                        let guid:String = data.objectForKey("guid") as! String;
                        let messdesc:String = data.objectForKey("messdesc") as! String;
                       
                        let item_obj:itemDaymic = itemDaymic(id: id, userid: userid, username: username, actionname: actionname, actiontime: actiontime, guid: guid, messdesc: messdesc)
                        self.items.append(item_obj)
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self._tableview.reloadData();
                        self._tableview.doneRefresh();
                    })
                }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
        
    }

    
    func showpage()
    {
        print("showggpage")
        var urlstr:String="http://www.bbxiaoqu.com/wap/gonggao.php?id=".stringByAppendingString(ggid)
        var url=NSURL(string: urlstr)
        UIApplication.sharedApplication().openURL(url!)

    }
    
    func showgg()
    {
        var url:String="http://www.bbxiaoqu.com/gonggao.php"
        print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if response.result.isSuccess
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for data in jsonItem{
                            //print("data: \(data)")
                              let id:String = data.objectForKey("id") as! String;
                            let title:String = data.objectForKey("title") as! String;
                           
                            self.ggid=id;
                            self.marquee = CHWMarqueeView(frame: CGRectMake(45, 250, self.view.bounds.size.width-45, 45), title: title)
                            self.marquee!.userInteractionEnabled = true
                            self.marquee!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("showpage")))
                            //fffbca
                            //self.marquee?.backgroundColor=UIColor(red: 0x100/0x100, green: 0xb4/0x100, blue: 0x9f/0x100, alpha: 1)
                            
                            self.marquee?.backgroundColor=UIColor(red: 255/255, green: 251/255, blue: 202/255, alpha: 1)


                            self.view.addSubview(self.marquee!)
                        }
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
    }
    
    func SetClick()
    {
        NSLog("SetClick")
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("tabfour") as! FourViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func exitClick()
    {
        NSLog("exitClick")
        //exit(0)
        var alertView = UIAlertView()
        alertView.title = "系统提示"
        alertView.message = "您确定要退出吗？"
        alertView.addButtonWithTitle("取消")
        alertView.addButtonWithTitle("确定")
        alertView.cancelButtonIndex=0
        alertView.delegate=self;
        alertView.show()
        
       
    }
    
    
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
            
        }
        else
        {
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
            //创建导航控制器
            let nvc=UINavigationController(rootViewController:vc);
            //设置根视图
            self.view.window!.rootViewController=nvc;

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
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        
    {
        
        
        
        let cellId = "daymiccell"
        
        //无需强制转换
        
        var cell:DynamicTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! DynamicTableViewCell
        
        if(cell == nil)
            
        {
            
            cell = DynamicTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            
        }
        
        
        cell?.name.text=(self.items[indexPath.row] as itemDaymic).username
        
        
        cell?.time.text=(self.items[indexPath.row] as itemDaymic).actiontime
        
      
        //lable3?.w
         //var label = UILabel(frame: CGRectMake(0,0,ScreenWidth,0))
        //var viewBounds:CGRect = UIScreen.mainScreen().applicationFrame
       // lable3?.frame = CGRectMake(0,0,viewBounds.width/2,0);
        cell?.info?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell?.info?.numberOfLines=0
        
        
        if((self.items[indexPath.row] as itemDaymic).actionname=="join")
        {
            
            cell?.tag1?.image = UIImage(named: "dynamic_info_left")
            cell?.tag2?.image = UIImage(named: "dynamic_info_icon")
            cell?.info?.text="加入了小区"

        }else if((self.items[indexPath.row] as itemDaymic).actionname=="publish")
        {
            cell?.tag1?.image = UIImage(named: "dynamic_join_left")
            cell?.tag2?.image = UIImage(named: "dynamic_join_icon")
           
            cell?.info?.text=(self.items[indexPath.row] as itemDaymic).messdesc

        }else if((self.items[indexPath.row] as itemDaymic).actionname=="solution")
        {
            
            cell?.tag1?.image = UIImage(named: "dynamic_name_left")
            cell?.tag2?.image = UIImage(named: "dynamic_name_icon")
            cell?.info?.text="获得一个雷锋称号"

        }
        
        return cell!
        
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        if((self.items[indexPath.row] as itemDaymic).actionname=="publish")
        {
            var guid:String = (self.items[indexPath.row] as itemDaymic).guid
            
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("contentviewController") as! ContentViewController
            //创建导航控制器
            //vc.message = aa.content;
            vc.guid=guid
            vc.infoid=guid
            // let nvc=UINavigationController(rootViewController:vc);
            //设置根视图
            //  self.view.window!.rootViewController=nvc;
            self.navigationController?.pushViewController(vc, animated: true)
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
    
    
    
//    
//    //定位改变执行，可以得到新位置、旧位置
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        //获取最新的坐标
//        
//        let currLocation:CLLocation = locations.last!
//        print("经度：\(currLocation.coordinate.longitude)")
//        print("纬度：\(currLocation.coordinate.latitude)")
//        
//        let defaults = NSUserDefaults.standardUserDefaults();
//        defaults.setObject(String(currLocation.coordinate.latitude), forKey: "lat");
//        defaults.setObject(String(currLocation.coordinate.longitude), forKey: "lng");
//        defaults.synchronize();
//        
//        
//        var geocoder:CLGeocoder=CLGeocoder();
//        geocoder.reverseGeocodeLocation(currLocation,
//            completionHandler: { (placemarks, error) -> Void in
//                if error != nil {
//                    return
//                }
//                let p:CLPlacemark = placemarks!.last!
//                //NSLog(p.description)
//                print("name：\(p.name)")
//                print("country：\(p.country)")
//                print("postalCode：\(p.postalCode)")
//                print("locality：\(p.locality)")
//                print("subLocality：\(p.subLocality)")
//                
//                print("thoroughfare：\(p.thoroughfare)")
//                
//                print("administrativeArea：\(p.administrativeArea)")
//                print("subAdministrativeArea：\(p.subAdministrativeArea)")
//                print("inlandWater：\(p.inlandWater)")
//                
//                print("areasOfInterest：\(p.areasOfInterest)")
//                
//                
//                
//                //                    NSLog("\n name:%@\n  country:%@\n postalCode:%@\n ISOcountryCode:%@\n ocean:%@\n inlandWater:%@\n locality:%@\n subLocality:%@\n administrativeArea:%@\n subAdministrativeArea:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
//                //                        p.name!,
//                //                        p.country!,
//                //                        p.postalCode!,
//                //                        p.ISOcountryCode!,//国家代码
//                //                        p.ocean!,//大洋
//                //                        p.inlandWater!,//
//                //                        p.administrativeArea!,
//                //                        p.subAdministrativeArea!,
//                //                        p.locality!,
//                //                        p.subLocality!,
//                //                        p.thoroughfare!,
//                //                        p.subThoroughfare!)
//                
//                let defaults = NSUserDefaults.standardUserDefaults();
//                defaults.setObject(p.country, forKey: "country");
//                defaults.setObject(p.locality, forKey: "province");//省直辖市
//                defaults.setObject(p.administrativeArea  , forKey: "city");//城市
//                defaults.setObject(p.subAdministrativeArea  , forKey: "subadministrativearea");//城市
//                defaults.setObject(p.subLocality  , forKey: "sublocality");//区县
//                defaults.setObject(p.thoroughfare  , forKey: "thoroughfare");//街道
//                defaults.setObject(p.name  , forKey: "address");
//                defaults.synchronize();
//                
//                
//                let _userid = defaults.objectForKey("userid") as! NSString;
//                let _token = defaults.objectForKey("token") as! NSString;
//                //更新下地理位置
//                
//                Alamofire.request(.POST, "http://www.bbxiaoqu.com/updatechannelid.php", parameters:["_userId" : _userid,"_channelId":_token])
//                    .responseJSON { response in
//                        print(response.request)  // original URL request
//                        print(response.response) // URL response
//                        print(response.data)     // server data
//                        print(response.result)   // result of response serialization
//                        print(response.result.value)
//                        
//                        
//                }
//                
//                
//                
//                
//                Alamofire.request(.POST, "http://www.bbxiaoqu.com/updatelocation.php", parameters:["_userId" : _userid,"_lat":String(currLocation.coordinate.latitude),"_lng":String(currLocation.coordinate.longitude),"_os":"ios"])
//                    .responseJSON { response in
//                        print(response.request)  // original URL request
//                        print(response.response) // URL response
//                        print(response.data)     // server data
//                        print(response.result)   // result of response serialization
//                        print(response.result.value)
//                        
//                        
//                }
//                
//                
//   
//        })
//        
//      
//    }
//    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
//        print(error)
//    }
    

}
