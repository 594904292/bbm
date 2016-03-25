//
//  TwoViewController.swift
//  bbm
//
//  Created by ericsong on 15/9/28.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class TwoViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var btn_1: UIButton!
    @IBOutlet weak var btn_2: UIButton!
    @IBOutlet weak var btn_3: UIButton!
    @IBOutlet weak var btn_4: UIButton!
    
    @IBAction func btn_1_click(sender: UIButton) {
        //let sb = UIStoryboard(name:"Main", bundle: nil)
        //let vc = sb.instantiateViewControllerWithIdentifier("publishController") as! PublishViewController
        //vc.cat=1;
        //self.presentViewController(vc, animated: true, completion: nil)
        //self.view.window.
        //self.addChildViewController(vc)
        
        
        //定义一个视图控制器
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("publishController") as! PublishViewController
        vc.cat=1
        //创建导航控制器
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;
        
        
        
        
    }
    @IBAction func btn_2_click(sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("publishController") as! PublishViewController
        vc.cat=2;
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func btn_3_click(sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("publishController") as! PublishViewController
        vc.cat=3;
        self.presentViewController(vc, animated: true, completion: nil)
    }
    @IBAction func btn_4_click(sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("publishController") as! PublishViewController
        vc.cat=4;
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    //定位管理器
    let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title="发布"
        //self.view.backgroundColor=UIColor.yellowColor()
        // Do any additional setup after loading the view.
        
        
        //设置定位服务管理器代理
        locationManager.delegate = self
       //设备使用电池供电时最高的精度  
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //精确到1000米,距离过滤器，定义了设备移动后获得位置信息的最小距离
        locationManager.distanceFilter = 100
        ////发送授权申请
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
