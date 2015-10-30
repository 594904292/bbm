//
//  displayViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/19.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class addcommuityViewController: UIViewController,UINavigationControllerDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate{
    
    /// 百度地图视图
    var mapView: BMKMapView!
    /// 地理位置编码
    var geocodeSearch: BMKGeoCodeSearch!
    var locService: BMKLocationService!
    var isGeoSearch: Bool!
    var first: Bool = true
    var currLocation:BMKUserLocation?;
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var xiaoquname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="增加小区"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        mapView = BMKMapView(frame:CGRectMake(0,0,320,self.view.frame.size.height/2))
        mapView.showsUserLocation = false
        
        //设置位置跟踪态
        
        mapView.userTrackingMode = BMKUserTrackingModeNone
        
        //显示定位图层
        
        mapView.showsUserLocation = true
        

        //mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(mapView)
         geocodeSearch = BMKGeoCodeSearch()
        
        
        
        // 设置定位精确度，默认：kCLLocationAccuracyBest
        BMKLocationService.setLocationDesiredAccuracy(kCLLocationAccuracyBest)
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        BMKLocationService.setLocationDistanceFilter(10)
        
        //初始化BMKLocationService
        locService = BMKLocationService()
        //启动LocationService
        locService.startUserLocationService()
        mapView.showsUserLocation = false
        //设置位置跟踪态
        mapView.userTrackingMode = BMKUserTrackingModeNone
        //显示定位图层
        mapView.showsUserLocation = true
        
        
        
        
        
    }
    
    //处理位置坐标更新
    
    //处理方向变更信息
    
    func didUpdateUserHeading(userLocation: BMKUserLocation!) {
        
        mapView.updateLocationData(userLocation)
        
    }
    
    
    
    //处理位置坐标更新
    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        if first
        {
            currLocation = userLocation
            //print("经度：\(currLocation.location.coordinate.latitude)")
            //print("纬度：\(currLocation.location.coordinate.longitude)")
        mapView.updateLocationData(userLocation)
        let url:String = "http://api.map.baidu.com/geocoder/v2/?ak=ROBALpv3vQpKoGOY18hze4kG&callback=renderReverse&location=".stringByAppendingString(String(currLocation!.location.coordinate.latitude)).stringByAppendingString(",").stringByAppendingString(String(currLocation!.location.coordinate.longitude)).stringByAppendingString("&output=json&pois=1")
            //print("url：\(url)")
            Alamofire.request(.GET, url, parameters: nil).responseString
                {response in
                    //print(response.result.value)
                    var json:String = response.result.value!
                    json=json.stringByReplacingOccurrencesOfString("renderReverse&&renderReverse(", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    json=json.stringByReplacingOccurrencesOfString(")", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)

                     //print("json：\(json)")
                    let jsonstring: NSString = json
                    let dd = jsonstring.dataUsingEncoding(NSUTF8StringEncoding)
                    let data: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(dd!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    var status:NSNumber = data["status"] as! NSNumber
                    var result:NSDictionary = data["result"] as! NSDictionary
                    
                    
                    var formatted_address:NSString = result["formatted_address"]  as! NSString
                    var addressComponent:NSDictionary = result["addressComponent"] as! NSDictionary
                    
                    
                    var country:NSString = addressComponent["country"]  as! NSString
                    var province:NSString = addressComponent["province"]  as! NSString
                    var city:NSString = addressComponent["city"]  as! NSString
                    var district:NSString = addressComponent["district"]  as! NSString
                    var street:NSString = addressComponent["street"]  as! NSString
                    
                    
                    self.address.text = "地址:".stringByAppendingString(formatted_address as String)
                    

            }
            
            
          
       }
        
        first = false
        
    }
    


    
    // MARK: - 覆盖物协议设置
    @IBAction func geocode(sender: UIButton) {
        isGeoSearch = true
        let geocodeSearchOption = BMKGeoCodeSearchOption()
        geocodeSearchOption.city = "北京"
        geocodeSearchOption.address = "北京大学"
        let flag = geocodeSearch.geoCode(geocodeSearchOption)
        if flag {
            print("geo 检索发送成功！")
        }else {
            print("geo 检索发送失败！")
        }
    }
    
    @IBAction func ungeocode(sender: UIButton) {
        isGeoSearch = false
        let aa:CLLocationDegrees = 116.403981
        let bb:CLLocationDegrees  = 39.915101
        var point = CLLocationCoordinate2DMake(0, 0)
            point = CLLocationCoordinate2DMake(bb, aa)
        var unGeocodeSearchOption = BMKReverseGeoCodeOption()
        unGeocodeSearchOption.reverseGeoPoint = point
        var flag = geocodeSearch.reverseGeoCode(unGeocodeSearchOption)
        if flag {
            print("反 geo 检索发送成功")
        }else {
            print("反 geo 检索发送失败")
        }
    }

    
    func backClick()
    {
        NSLog("back");
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("subscribeCommunityViewController") as! SubscribeCommunityViewController
        //self.presentViewController(vc, animated: true, completion: nil)
        
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;

        
    }

    func onGetGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!,  error: BMKSearchErrorCode) {
        var array = mapView.annotations
        mapView.removeAnnotations(array)
        array = mapView.overlays
        mapView.removeOverlays(array)
        if error.rawValue == 0 {
            var item = BMKPointAnnotation()
            item.coordinate = result.location
            item.title = result.address
            mapView.addAnnotation(item)
            mapView.centerCoordinate = result.location
            var title = "正向地理编码"
            var showMessage = "经度:\(item.coordinate.latitude)，纬度:\(item.coordinate.longitude)"
            
            var alertView = UIAlertController(title: title, message: showMessage, preferredStyle: .Alert)
            var okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!,error: BMKSearchErrorCode) {
        var array = mapView.annotations
        mapView.removeAnnotations(array)
        array = mapView.overlays
        mapView.removeOverlays(array)
        if error.rawValue == 0 {
            var item = BMKPointAnnotation()
            item.coordinate = result.location
            item.title = result.address
            mapView.addAnnotation(item)
            mapView.centerCoordinate = result.location
            
            var title = "反向地理编码"
            var showMessage = "\(item.title)"
            
            var alertView = UIAlertController(title: title, message: showMessage, preferredStyle: .Alert)
            var okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    // MARK: - 协议代理设置
    
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
        locService.delegate = self
        geocodeSearch.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
        locService.delegate = nil
        geocodeSearch.delegate = nil
    }
    
    // MARK: - 内存管理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
