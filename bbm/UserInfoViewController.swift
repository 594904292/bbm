//
//  UserInfoViewController.swift
//  bbm
//
//  Created by songgc on 16/4/1.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class UserInfoViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{

    
    @IBOutlet weak var headface: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var telphone: UILabel!
    
    @IBOutlet weak var gz_btn: UIButton!
    @IBOutlet weak var _tableview: UITableView!
    var userid:String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="好友信息"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        // Do any additional setup after loading the view.
        _tableview.delegate=self
        _tableview.dataSource=self
        loaduserinfo(userid);
        
        loadisfriend(userid);
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

    @IBAction func gz_btn_action(sender: UIButton) {
        var sqlitehelpInstance1=sqlitehelp.shareInstance()
        let defaults = NSUserDefaults.standardUserDefaults();
        var myuserid = defaults.objectForKey("userid") as! String;
        var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        var strNowTime = timeFormatter.stringFromDate(date) as String
        var  dic:Dictionary<String,String> =  ["mid1":myuserid,"mid2":userid]
        
        dic["addtime"] = strNowTime
        if(sender.tag==1)
        {
            dic["action"] = "del"
        }else
        {
            dic["action"] = "add"
        }
        
        Alamofire.request(.POST, "http://api.bbxiaoqu.com/addfriends.php", parameters: dic)
            
            .response { (request, response, data, error) in
                
                let tn:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                print(tn)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(sender.tag==1)
                    {
                        
                        self.successNotice("取消成功")
                        self.gz_btn.setTitle("关注", forState: UIControlState.Normal)
                        self.gz_btn.tag=0

                    }else
                    {
                         self.successNotice("关注成功")
                        self.gz_btn.setTitle("取消关注", forState: UIControlState.Normal)
                        self.gz_btn.tag=1

                    }
                   
                    
                });
        }

        
    }
    
    @IBAction func chat(sender: UIButton) {
        var sqlitehelpInstance1=sqlitehelp.shareInstance()
        
        let defaults = NSUserDefaults.standardUserDefaults();
        var myuserid = defaults.objectForKey("userid") as! String;
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("chatviewController") as! ChatViewController
        vc.from=userid
        vc.myself=myuserid;
        self.navigationController?.pushViewController(vc, animated: true)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func loaduserinfo(userid:String)
    {
        var url_str:String = "http://api.bbxiaoqu.com/getuserinfo.php?userid=".stringByAppendingString(userid)
        Alamofire.request(.POST,url_str, parameters:nil)
            .responseJSON { response in
                print(response.result.value)
                if let JSON = response.result.value {
                    print("JSON1: \(JSON.count)")
                    if(JSON.count>0)
                    {
                        let telphone:String = JSON[0].objectForKey("telphone") as! String;
                       
                        let username:String = JSON[0].objectForKey("username") as! String;
                        self.username.text=username;
                        self.telphone.text=telphone;
                        let headfaceurl:String = JSON[0].objectForKey("headface") as! String;
                        if(headfaceurl.characters.count>0)
                        {
                            let url="http://api.bbxiaoqu.com/uploads/"+headfaceurl;
                            Alamofire.request(.GET, url).response { (_, _, data, _) -> Void in
                                if let d = data as? NSData!
                                {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.headface?.image = UIImage(data: d)
                                    })
                                }
                            }
                        }else
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                //self.headface?.image = UIImage(named: "logo"))
                                
                                self.headface?.image = UIImage(named: "logo")
                            })
                        }
                    }
                    
                    
                }
        }
    }
    
    func loadisfriend(userid:String)
    {
        let defaults = NSUserDefaults.standardUserDefaults();
        var myuserid = defaults.objectForKey("userid") as! String;
        var url_str:String = "http://api.bbxiaoqu.com/getisfriends.php?mid1=".stringByAppendingString(myuserid).stringByAppendingString("&mid2=").stringByAppendingString(userid)
        Alamofire.request(.POST,url_str, parameters:nil)
            .responseJSON { response in
                print(response.result.value)
                if let JSON = response.result.value {
                    print("JSON1: \(JSON.count)")
                    if(JSON.count>0)
                    {
                        let isfriend:String = JSON.objectForKey("isfriend") as! String;
                        print("JSisfriendON1: \(isfriend)")

                        if(isfriend=="yes")
                        {
                            self.gz_btn.setTitle("取消关注", forState: UIControlState.Normal)
                            self.gz_btn.tag=1
                        }else
                        {
                            self.gz_btn.setTitle("关注", forState: UIControlState.Normal)
                            self.gz_btn.tag=0
                        }
                        
                    }
                    
                    
                }
        }
//        Alamofire.request(.POST, url_str, parameters: nil)
//            
//            .response { (request, response, data, error) in
//                
//                let tn:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
//                print(tn)
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    
//                    if(tn=="yes")
//                    {
//                       self.gz_btn.setTitle("关注", forState: UIControlState.Normal)
//                        self.gz_btn.tag=1
//                    }else
//                    {
//                        self.gz_btn.setTitle("取消关注", forState: UIControlState.Normal)
//                        self.gz_btn.tag=0
//                    }
//                    
//                });
//        }
        

        
    }


     var items:[ItemEvaluate]=[]
    func querydata()
    {
        var url:String="http://api.bbxiaoqu.com/getmemberevaluates.php?userid=".stringByAppendingString(userid);
        print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil).responseJSON
            { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for data in jsonItem{
                            print("data: \(data)")
                            let id:String = data.objectForKey("id") as! String;
                            let guid:String = data.objectForKey("guid") as! String;
                            let infouser:String = data.objectForKey("infouser") as! String;
                            let userid:String = data.objectForKey("userid") as! String;
                            let score:String = data.objectForKey("score") as! String;
                            let evaluate:String = data.objectForKey("evaluate") as! String;
                            let addtime:String = data.objectForKey("addtime") as! String;
                            
                            let item_obj:ItemEvaluate = ItemEvaluate(id: id, guid: guid, infouser: infouser, userid: userid, score: score, evalute: evaluate, addtime: addtime)
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
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var ppp:String = (items[indexPath.row] as itemMess).photo;
        let cellId="evaluatecell"
        var cell:EvaluateTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! EvaluateTableViewCell?
        if(cell == nil)
        {
            cell = EvaluateTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
        }
        cell?.infouser.text=(items[indexPath.row] as ItemEvaluate).infouser
        
        
        var f  =  CGFloat ( ( (items[indexPath.row] as ItemEvaluate).score as NSString).floatValue)
        
        cell?.ratingbar.rating = f

        cell?.eveluate.text=(items[indexPath.row] as ItemEvaluate).evalute
        cell?.addtime.text=(items[indexPath.row] as ItemEvaluate).addtime
        
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        //NSLog("select \(items[indexPath.row])")
        
    }


}
