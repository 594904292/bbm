//
//  XiaoquTableViewController.swift
//  bbm
//
//  Created by ericsong on 16/1/4.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire

protocol ChangeWordDelegate:NSObjectProtocol{
    //回调方法
    func changeWord(controller:XiaoquTableViewController,xqname:String,xqid:String,xqlat:String,xqlng:String)
}

class XiaoquTableViewController: UITableViewController ,UINavigationControllerDelegate{

    @IBOutlet weak var tableview: UITableView!
    var items:[xiaoquItem]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title="选择小区"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")

        querydata()
    }
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    
    func querydata()
        
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
                        var pic:String="";
                        
                        

                        if(!data.objectForKey("pic")!.isKindOfClass(NSNull))
                        {
                            pic = data.objectForKey("pic") as! String;
                        }
                        
                        var business:String = ""
                        
                        
                        
                        
                        var develop:String = "";
                        if(!data.objectForKey("develop")!.isKindOfClass(NSNull))
                        {
                            develop = data.objectForKey("develop") as! String;
                        }
                        
                        var propertymanagement:String = ""
                    
                        if(!data.objectForKey("propertymanagement")!.isKindOfClass(NSNull))
                        {
                            propertymanagement = data.objectForKey("propertymanagement") as! String;
                        }
                        
                        
                        var propertytype:String = "";
                        if(!data.objectForKey("propertytype")!.isKindOfClass(NSNull))
                        {
                            propertytype = data.objectForKey("propertytype") as! String;
                        }
                        
                        var homenumber:String = ""
                        if(!data.objectForKey("homenumber")!.isKindOfClass(NSNull))
                        {
                            homenumber = data.objectForKey("homenumber") as! String;
                        }
                        var buildyear:String = ""
                        if(!data.objectForKey("buildyear")!.isKindOfClass(NSNull))
                        {
                            buildyear = data.objectForKey("buildyear") as! String;
                        }
                        
                        let item_obj:xiaoquItem = xiaoquItem(id: id, name: name, address: address, lat: lat, lng: lng, pic: pic, business: business, develop: develop, propertymanagement: propertymanagement, propertytype: propertytype, homenumber: homenumber, buildyear: buildyear)
                        
                        
                        
                        self.items.append(item_obj)
                        
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData();
                        
                    })

                }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
             let cellId="myxqcell"
                   //无需强制转换
        var cell:XiaoquTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? XiaoquTableViewCell!
        if(cell == nil)
        {
            cell = XiaoquTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            
        }
            var aaa:xiaoquItem = items[indexPath.row] as xiaoquItem
            cell?.name.text = aaa.name
            cell?.address.text = aaa.address
            cell?.imageView?.image=UIImage(named: "icon")
                    if(aaa.pic.isKindOfClass(NSNull))
                    {
                        cell?.imageView?.image=UIImage(named: "icon")
            
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
                                       cell?.imageView?.image = UIImage(data: d)
                                    })
                                }
                            }
                        }else
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                               cell?.imageView?.image=UIImage(named: "icon")
                            })
                       
                        }
                    }
            return cell!        
        }

    
   var delegate:ChangeWordDelegate?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        
        
        var aaa:xiaoquItem = items[indexPath.row] as xiaoquItem
        var xiaoquname=aaa.name
        var xiaoquid=aaa.id
        var xiaoqulat=aaa.lat
        var xiaoqulng=aaa.lng
        
        //if((delegate) != nil){
            delegate?.changeWord(self, xqname: xiaoquname, xqid: xiaoquid, xqlat: xiaoqulat, xqlng: xiaoqulng)        //}
        self.navigationController?.popViewControllerAnimated(true)

    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
