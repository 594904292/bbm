//
//  TopViewController.swift
//  bbm
//
//  Created by songgc on 16/3/29.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class TopViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var _tableview: UITableView!
    var items:[itemTop]=[]

    
    @IBOutlet weak var topnum: UILabel!
    @IBOutlet weak var topnumdesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title="排行榜"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        
        _tableview.delegate=self
        _tableview.dataSource=self
        loadrate();
        querydata();
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
    func loadrate()
    {
        var url:String="http://api.bbxiaoqu.com/myrank.php?userid=888";
        print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil)
            .response { (request, response, data, error) in
//            print(request)
//            print(response)
//            print(data)
//            print(error)
                let tn:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                print(tn)
                 dispatch_async(dispatch_get_main_queue(), { () -> Void in
               
                    
                self.topnum.text=tn as String

                self.topnumdesc.text="你排名是第".stringByAppendingString(tn as String).stringByAppendingString("位")
                 });
        }
        
        
    }
    
    
    func querydata()
    {
            var url:String="http://api.bbxiaoqu.com/rank.php";
        print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for data in jsonItem{
                            print("data: \(data)")
                            let order:String = data.objectForKey("order") as! String;
                            let username:String = data.objectForKey("username") as! String;
                            let score:String = "1";//data.objectForKey("score") as! String;
                            let nums:String = data.objectForKey("nums") as! String;
                            
                            let item_obj:itemTop = itemTop(order: order, username: username, score: score, nums: nums)
                            self.items.append(item_obj)
                            
                        }
                        self._tableview.reloadData()
                        self._tableview.doneRefresh()
                        
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
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
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        
                  return self.items.count;
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            //var ppp:String = (items[indexPath.row] as itemMess).photo;
        
            let cellId="topcell"
            var cell:TopTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! TopTableViewCell?
            if(cell == nil)
            {
                cell = TopTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            }
            
            cell?.order.text=(items[indexPath.row] as itemTop).order
            cell?.username.text=(items[indexPath.row] as itemTop).username
            cell?.score.text=(items[indexPath.row] as itemTop).score
            cell?.nums.text=(items[indexPath.row] as itemTop).nums
        
            return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        //NSLog("select \(items[indexPath.row])")
        
        
        
        
        
        
    }

    

}
