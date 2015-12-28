//
//  RecentTableViewController.swift
//  bbm
//
//  Created by ericsong on 15/12/22.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class RecentTableViewController: UITableViewController {

    var dataSource = NSMutableArray()
    var currentIndexPath: NSIndexPath?
    var items:[itemRecent]=[]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title="会话列表"
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
        var db: SQLiteDB!
        db = SQLiteDB.sharedInstance()
        let sql="select userid,nickname,usericon,lastinfo,lasttime,messnu,lastnickname　from friend";
        NSLog(sql)
        let mess = db.query(sql)
        if mess.count > 0 {
            //获取最后一行数据显示
            for i in 0...mess.count-1
            {
                let item = mess[i] as SQLRow
                let userid = item["userid"]!.asString()
                let nickname = item["nickname"]!.asString()
                let usericon = item["usericon"]!.asString()
                let lastinfo = item["lastinfo"]!.asString()
                let lasttime = item["messnu"]!.asString()
                let messnu = item["userid"]!.asString()
                let lastnickname = item["lastnickname"]!.asString()
                let item_obj:itemRecent=itemRecent(userid: userid, username: nickname, usericon: usericon, lastinfo: lastinfo, lastchattimer: lasttime, messnum: messnu, lastnickname: lastnickname)
                 self.items.append(item_obj)
            }
        }
        
        
    }
    

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        
    {
        
        
        
        let cellId = "recentcell"
        
        //无需强制转换
        
        var cell:RecentTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? RecentTableViewCell
        
        if(cell == nil)
            
        {
            
            cell = RecentTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            
        }
        cell?.name!.text = (self.items[indexPath.row] as itemRecent).username
        cell?.content!.text = (self.items[indexPath.row] as itemRecent).lastnickname.stringByAppendingString(":").stringByAppendingString((self.items[indexPath.row] as itemRecent).lastinfo)
        cell?.lasttime!.text = (self.items[indexPath.row] as itemRecent).lastchattimer


        var avatar:String = (self.items[indexPath.row] as itemRecent).usericon
        
        var head = "http://www.bbxiaoqu.com/uploads/".stringByAppendingString(avatar)
        
        Alamofire.request(.GET, head).response { (_, _, data, _) -> Void in
            if let d = data as? NSData!
            {
                cell?.lastuericon.image=UIImage(data: d)
            }
        }

        
        return cell!
        
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        
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
