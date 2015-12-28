//
//  FriendsTableViewController.swift
//  bbm
//
//  Created by ericsong on 15/12/22.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class FriendsTableViewController: UITableViewController {

    var dataSource = NSMutableArray()
    var currentIndexPath: NSIndexPath?
    var items:[Friends]=[]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title="朋友列表"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        querydata()
    }
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func querydata()
    {
        
        
        let url:String="http://www.bbxiaoqu.com/getfriends.php?mid1=369";
        print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if let jsonItem = response.result.value as? NSArray{
                    for data in jsonItem{
                        print("data: \(data)")
                        
                       
                        let userid:String = data.objectForKey("userid") as! String;
                        let username:String = data.objectForKey("username") as! String;
                        let headface:String = data.objectForKey("headface") as! String;
                        
                        let item_obj:Friends = Friends(userid: userid, name: username, logo: headface)
                        self.items.append(item_obj)
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData();
                        
                    })
                }
        }
        
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellId = "friendscell"
        //无需强制转换
         var cell:FriendsTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? FriendsTableViewCell!
         if(cell == nil)
        {
            cell = FriendsTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)

        }
        cell?.names.text=(self.items[indexPath.row] as Friends).username
        cell?.leftimg.image = UIImage(named: "dynamic_join_left")
        
        var avatar:String = (self.items[indexPath.row] as Friends).avatar;
        
        var head = "http://www.bbxiaoqu.com/uploads/".stringByAppendingString(avatar)
     
        Alamofire.request(.GET, head).response { (_, _, data, _) -> Void in
            if let d = data as? NSData!
            {
                cell?.headface.image=UIImage(data: d)
            }
        }

         return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        
        let defaults = NSUserDefaults.standardUserDefaults();
        var senduserid = defaults.objectForKey("userid") as! String;
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("chatviewController") as! ChatViewController
        //创建导航控制器
        vc.from=(self.items[indexPath.row] as Friends).userid
        vc.myself=senduserid;
        self.navigationController?.pushViewController(vc, animated: true)

        
    }
    
    
    
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

