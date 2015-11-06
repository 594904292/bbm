//
//  SubscribeCommunityViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/13.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class SubscribeCommunityViewController: UIViewController ,UINavigationControllerDelegate,UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableview: UITableView!
    var items:[xiaoquItem]=[]
    var db: SQLiteDB!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate=self;
        self.tableview.dataSource=self;
        
        self.navigationItem.title="小区"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        self.navigationItem.title="小区"
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "增加", style: UIBarButtonItemStyle.Done, target: self, action: "addClick")

        // Do any additional setup after loading the view.
        loadRemoteData()
        
        //querydata()//查询数据
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func backClick()
    {
        NSLog("back");
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("homeController") as! HomeViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
        
        
        
    }
    
    func addClick()
    {
        NSLog("add");
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("addcommController") as! addcommuityViewController
        //self.presentViewController(vc, animated: true, completion: nil)
        
        
        //let vc = sb.instantiateViewControllerWithIdentifier("subscribeCommunityViewController") as! SubscribeCommunityViewController
        //创建导航控制器
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;

        
    }

    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    func tableView(tableView:UITableView!, numberOfRowsInSection section: Int) -> Int{
        
        return items.count;
        
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath:NSIndexPath!) -> UITableViewCell!{
      
        let cellId="mycell"
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell?
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
        }
         let headface:UIImageView? = (cell?.viewWithTag(5) as? UIImageView)
        let lable1:UILabel? = (cell?.viewWithTag(1) as? UILabel)
        let lable2:UILabel? = (cell?.viewWithTag(2) as? UILabel)
  
        var aaa:xiaoquItem = items[indexPath.row] as xiaoquItem
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            headface?.image=UIImage(named: "icon")
        })
        
        if(aaa.pic.isKindOfClass(NSNull))
        {
            headface?.image=UIImage(named: "icon")
            
        }else
        {
            var headurl:String = aaa.pic
            if(headurl.characters.count>0)
            {
                print("pic: \(aaa.pic)")
                print("name: \(aaa.name)")
                print("address: \(aaa.address)")
                Alamofire.request(.GET, headurl).response { (_, _, data, _) -> Void in
                   if let d = data as? NSData!
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                           headface?.image = UIImage(data: d)
                        })
                    }
                }
            }else
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                   headface?.image=UIImage(named: "icon")
                })
           
            }
        }

        dispatch_async(dispatch_get_main_queue(), { () -> Void in

            lable1?.text = aaa.name
            lable2?.text = aaa.address
         })
            
        return cell        
    }
    
    
    
    
    func loadRemoteData()
        
    {
        
        let defaults = NSUserDefaults.standardUserDefaults();
        let lat = defaults.objectForKey("lat") as! String;
        let lng = defaults.objectForKey("lng") as! String;
        
        
        var url_str:String = "http://www.bbxiaoqu.com/getxiaoqu.php?latitude=".stringByAppendingString(lat).stringByAppendingString("&longitude=").stringByAppendingString(lng)
            Alamofire.request(.GET, url_str, parameters: nil)
            
            .responseJSON { response in
                
                if let jsonItem = response.result.value as? NSArray{
                    
                    for data in jsonItem{
                        
                        print("data: \(data)")
                        
                        
                        
                        let id:String = data.objectForKey("id") as! String;
                        
                        let name:String = data.objectForKey("name") as! String;
                        let address:String = data.objectForKey("address") as! String;
                        let lng:String = data.objectForKey("lng") as! String;
                        
                        let lat:String = data.objectForKey("lat") as! String;
                        let pic:String = data.objectForKey("pic") as! String;
                        
                        var business:String = ""
                        

                        
                        
                        let develop:String = data.objectForKey("develop") as! String;
                        let propertymanagement:String = data.objectForKey("propertymanagement") as! String;
                        
                        let propertytype:String = data.objectForKey("propertytype") as! String;
                        let homenumber:String = data.objectForKey("homenumber") as! String;
                        let buildyear:String = data.objectForKey("buildyear") as! String;
                        
                        let item_obj:xiaoquItem = xiaoquItem(id: id, name: name, address: address, lat: lat, lng: lng, pic: pic, business: business, develop: develop, propertymanagement: propertymanagement, propertytype: propertytype, homenumber: homenumber, buildyear: buildyear)
                        
                        
                        
                        self.items.append(item_obj)
                        
               
                    }
                    self.tableview.reloadData()
                }
        }
    }
    
    
    
    
    
    
     

}
