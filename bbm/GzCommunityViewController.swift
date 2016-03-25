//
//  SubscribeCommunityViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/13.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class GzCommunityViewController: UIViewController ,UINavigationControllerDelegate,UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableview: UITableView!
    var items:[xiaoquItem]=[]
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableview.delegate=self;
        self.tableview.dataSource=self;
        
        self.navigationItem.title="关注小区"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        loadRemoteData()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        //let cell = UITableViewCell(style:.Subtitle, reuseIdentifier:"myCell")
        //var xq:xiqoquItem = self.items[indexPath.row] as! xiqoquItem;
        var aaa:xiaoquItem = items[indexPath.row] as xiaoquItem
        //var headurl:String = aaa.pic
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
        let userid = defaults.objectForKey("userid") as! String;
        var url_str:String = "http://api.bbxiaoqu.com/getgzxiaoqu.php?userid=".stringByAppendingString(userid)        //
        Alamofire.request(.GET, url_str, parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
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
                        
//                        if(data.objectForKey("business")!.isKindOfClass(NSNull))
//                        {
//                            business = "";
//                        }else
//                        {
//                            business = data.objectForKey("business") as! String;
//
//                        }
                        
                        let develop:String = data.objectForKey("develop") as! String;
                        let propertymanagement:String = data.objectForKey("propertymanagement") as! String;
                        
                        let propertytype:String = data.objectForKey("propertytype") as! String;
                        let homenumber:String = data.objectForKey("homenumber") as! String;
                        let buildyear:String = data.objectForKey("buildyear") as! String;
                        
                        if(!self.isexitxiaoqu(name))
                        {//添加小区
                            self.addxiaoqu(name)
                        }
                        let item_obj:xiaoquItem = xiaoquItem(id: id, name: name, address: address, lat: lat, lng: lng, pic: pic, business: business, develop: develop, propertymanagement: propertymanagement, propertytype: propertytype, homenumber: homenumber, buildyear: buildyear)
                        
                        
                        
                        self.items.append(item_obj)
                        
                        
                    }
                    self.tableview.reloadData()
                }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
                

        }
    }
    
    
    
    
    func addxiaoqu(xiaoquname: String)  {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql = "insert into xiaoqu(xiaoquname) values('\(xiaoquname)')"
        NSLog("sql: \(sql)")
        //通过封装的方法执行sql
        db.execute(sql)
        
    }

    
    func removexiaoqu(xiaoquname: String)  {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
       let sql = "delete from xiaoqu where xiaoquname ='\(xiaoquname)'"
        NSLog("sql: \(sql)")
        //通过封装的方法执行sql
        db.execute(sql)
    }

    
    func isexitxiaoqu(xiaoquname: String) ->Bool  {
        var db: SQLiteDB! = SQLiteDB.sharedInstance()
        let sql = "select * from xiaoqu where xiaoquname ='\(xiaoquname)'"
        NSLog("sql: \(sql)")
        //通过封装的方法执行sql
        let row = db.query(sql)
        if row.count > 0 {
            return true;
        }else
        {
            return false;
        }
    }

    
}
