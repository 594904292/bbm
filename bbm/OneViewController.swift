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
        querydata()//查询数据
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title="动态"
         //(UIApplication.sharedApplication().delegate as! AppDelegate).apnsdelegate = self
        //告诉apnsdelegate我在这个里面实现
        self.navigationItem.title="动态"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        
              // weak var weakSelf = self as OneViewController
       // (UIApplication.sharedApplication().delegate as! AppDelegate).apnsdelegate = self
        _tableView!.delegate=self
        _tableView!.dataSource=self
  
        self._tableView.headerView = XWRefreshNormalHeader(target: self, action: "upPullLoadData")
        
        self._tableView.headerView?.beginRefreshing()
        self._tableView.headerView?.endRefreshing()
        
        self._tableView.footerView = XWRefreshAutoNormalFooter(target: self, action: "downPlullLoadData")
        
        querydata()
        

    }
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    //MARK: 加载数据
    func upPullLoadData(){
        
        //延迟执行 模拟网络延迟，实际开发中去掉
        xwDelay(1) { () -> Void in
            self.start=0;
            self.querydata()
            self._tableView.reloadData()
            self._tableView.headerView?.endRefreshing()
            
        }
        
    }
    
    func downPlullLoadData(){
        
        xwDelay(1) { () -> Void in
            self.start=self.limit;
            
            
           self.querydata()
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
                cell?.sendaddress.text=(items[indexPath.row] as itemMess).time
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
                cell?.sendaddress.text=(items[indexPath.row] as itemMess).time
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
    
    
    
    
    
    func querydata()
    {
        
        
     var url:String="http://www.bbxiaoqu.com/getinfos.php?userid=369&rang=xiaoqu&start=".stringByAppendingString(String(self.start)).stringByAppendingString("&limit=").stringByAppendingString(String(self.limit));
       print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
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
    

}
