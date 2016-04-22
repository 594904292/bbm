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
    
    @IBOutlet weak var topbgimg: UIImageView!
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
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! String;
        var url:String="http://api.bbxiaoqu.com/myrank.php?userid=".stringByAppendingString(userid);
        print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil)
            .response { (request, response, data, error) in
                let tn:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                print(tn)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //self.topnum.text=tn as String
                    self.topnumdesc.text="你排名是第".stringByAppendingString(tn as String).stringByAppendingString("位")
                    
                    var img:UIImageView!
                    img = UIImageView(frame: CGRectMake(self.view.frame.width/2-50, 60, 100, 100))
                    img.image=UIImage(named: "topbg")
                    self.view.addSubview(img)
                    
                    var label1: UILabel!
                    label1 = UILabel(frame: CGRectMake(self.view.frame.width/2-30, 80, 60, 60))
                    
                    // 设置文本内容
                    label1.text = tn as String
                   
                    
                    // 设置字体样式：粗体、大小等
                    label1.font = UIFont.boldSystemFontOfSize(30)
                    
                    // 设置文字颜色
                    label1.textColor = UIColor.purpleColor()
                    
                    // 设置文字对齐方式
                    label1.textAlignment = NSTextAlignment.Center
                    
                    // 设置文本背景色
                    label1.backgroundColor = UIColor.clearColor()
                    
                    // 设置 label 中的文字是否可变，默认值是 true
                    label1.enabled = false
                    
                    // 设置高亮
                    label1.highlighted = true
                    label1.highlightedTextColor = UIColor.blackColor()
                    
                    // 设置阴影
                    label1.shadowColor = UIColor.redColor()
                    label1.shadowOffset = CGSizeMake(1.0,1.0);
                    
                    // 设置是否能与用户进行交互
                    label1.userInteractionEnabled = true
                   
                    
                    self.view.addSubview(label1)  
                   
                    
                    //self.topnum.frame=CGRectMake((self.view.frame.size.width/2)-20, self.topbgimg.xw_centerY, 40, 30)
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
                            let userid:String = data.objectForKey("username") as! String;
                            let score:String = data.objectForKey("score") as! String;
                            let nums:String = data.objectForKey("nums") as! String;
                            self.loaduserinfo(userid);
                            let usericon = sqlitehelp.shareInstance().loadheadface(userid)
                            let nickname = sqlitehelp.shareInstance().loadusername(userid)
                            
                            //let item_obj:itemTop = itemTop(order: order, userid: userid, score: score, nums: nums)
                            let item_obj:itemTop = itemTop(order: order, userid: userid, username: nickname, headface: usericon, score: score, nums: nums)
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

    
    
    func loaduserinfo(userid:String)
        
    {
        
        Alamofire.request(.GET, "http://api.bbxiaoqu.com/getuserinfo.php?userid="+userid, parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for data in jsonItem{
                            //print("data: \(data)")
                            
                            var name:String = data.objectForKey("username") as! String;
                            var headface:String = data.objectForKey("headface") as! String;
                            
                            if(!sqlitehelp.shareInstance().isexituser(userid))
                            {//缓存用户数据
                                sqlitehelp.shareInstance().addusers(userid, nickname: name, usericon: headface)
                                //更新聊天记录
                            }
                        }
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
            //cell?.score.text=(items[indexPath.row] as itemTop).score
            cell?.nums.text=(items[indexPath.row] as itemTop).nums.stringByAppendingString("件")
        
        
        var f  =  CGFloat ( ( (items[indexPath.row] as itemTop).score as NSString).floatValue)
        
        cell?.score.rating = f
        
            var avatar:String = (self.items[indexPath.row] as itemTop).headface
            
            if(avatar.characters.count>0)
            {
                var head = "http://api.bbxiaoqu.com/uploads/".stringByAppendingString(avatar)
                
                Alamofire.request(.GET, head).response { (_, _, data, _) -> Void in
                    if let d = data as? NSData!
                    {
                        cell?.headface.image=UIImage(data: d)
                    }
                }
            }else
            {
                cell?.headface.image=UIImage(named: "logo")
                
            }

            return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        //NSLog("select \(items[indexPath.row])")
        let sb = UIStoryboard(name:"Main", bundle: nil)

        let vc = sb.instantiateViewControllerWithIdentifier("userinfoviewcontroller") as! UserInfoViewController
        //创建导航控制器
        vc.userid=(items[indexPath.row] as itemTop).userid
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
    }

    

}
