//
//  OneViewController.swift
//  bbm
//
//  Created by ericsong on 15/9/28.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class OneViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ApnsDelegate {

    var datas:Int = 10

    @IBOutlet weak var _tableView: UITableView!
    var items:[itemMess]=[]
    var db: SQLiteDB!
    
    
    func NewMessage(string:String){
        //qzLabel!.text = string
        //println("qzLabel.text == \(string)")
    
        
        SaveRemoteData()
        
        querydata()//查询数据
        _tableView.reloadData()
        _tableView.doneRefresh()

    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title="动态"
        self.navigationItem.title="table"
        
        weak var weakSelf = self as OneViewController
        (UIApplication.sharedApplication().delegate as! AppDelegate).apnsdelegate = self

        _tableView!.delegate=self
        _tableView!.dataSource=self
        
        // 及时下拉刷新
        _tableView.nowRefresh({ () -> Void in
            weakSelf?.delay(2.0, closure: { () -> () in})
            weakSelf?.delay(2.0, closure: { () -> () in
                print("nowRefresh success")
                weakSelf?.datas += 10
                weakSelf?.SaveRemoteData();
                weakSelf?.querydata()//查询数据
                weakSelf?._tableView.reloadData()
                weakSelf?._tableView.doneRefresh()
            })
        })
        
        // 上啦加载更多
        _tableView.toLoadMoreAction({ () -> Void in
            print("toLoadMoreAction success")
            if (weakSelf?.datas < 1000){
                weakSelf?.datas += 10
                weakSelf?.SaveRemoteData();
                weakSelf?.querydata()//查询数据
                weakSelf?._tableView.reloadData()
                weakSelf?._tableView.doneRefresh()
            }else{
                weakSelf?._tableView.endLoadMoreData()
            }
        })
        
        db = SQLiteDB.sharedInstance()
        let dbHelp = DbHelp()
        dbHelp.initdb()//生成表
        
        //db.query("delete from message")
        
        
        querydata()//查询数据

    }
    
    
//    data: {
//    
//    address = "\U5317\U4eac\U5e02\U6d77\U6dc0\U533a\U7f57\U5e84\U4e1c\U8def";
//    catagory = 1;
//    city = "\U5317\U4eac\U5e02";
//    citycode = 131;
//    community = "\U9526\U79cb\U77e5\U6625";
//    "community_id" = 830;
//    "community_lat" = "39.9805";
//    "community_lng" = "116.356";
//    content = "\U54c8\U54c8\U97a5";
//    country = "\U4e2d\U56fd";
//    direction = "-1.0";
//    district = "\U6d77\U6dc0\U533a";
//    floor = "";
//    guid = "bd7d6b39-2c4c-4dba-9d91-f7e3d13bbab1";
//    headface = "20150728114952.jpg";
//    id = 39;
//    infocatagroy = 0;
//    lat = "39.9745";
//    lng = "116.348";
//    networklocationtype = wf;
//    operators = 0;
//    photo = "Screenshot_2015-07-10-09-34-35.png";
//    province = "\U5317\U4eac\U5e02";
//    radius = "60.1011";
//    sendtime = "2015-07-10 05:29:58";
//    senduser = 369;
//    speed = "0.0";
//    street = "\U7f57\U5e84\U4e1c\U8def";
//    streetnumber = "";
//    title = "\U5e2e\U5e2e\U5fd9";
//    username = dzyang123;
//    village = "";
//    voice = "<null>";
//}
    
    func SaveRemoteData()
    {
    
        Alamofire.request(.GET, "http://www.bbxiaoqu.com/getlastinfo.php", parameters: nil)
            .responseJSON { response in
                //            if let JSON = response.result.value {
                //                print("JSON: \(JSON)")
                //            }
                //                let weatherinfo: AnyObject = json.objectForKey("weatherinfo")!
                //                city.text = weatherinfo.objectForKey("city") as String
                if let jsonItem = response.result.value as? NSArray{
                    for data in jsonItem{
                        print("data: \(data)")

                        let content:String = data.objectForKey("content") as! String;
                        let senduser:String = data.objectForKey("senduser") as! String;

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

                        self.saveItem(content, senduserid: senduser, sendnickname: sendnickname, guid: guid, date: sendtime, address: address, lng: lng, lat: lat, photo: photo, community: community, infocatagory: infocatagroy)
                    }
                    self._tableView.reloadData()
                }
               
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
            let cellId="mycell"
            var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as UITableViewCell?
            if(cell == nil)
            {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            }
            let lable1:UILabel? = (cell?.viewWithTag(1) as? UILabel)
            let lable2:UILabel? = (cell?.viewWithTag(2) as? UILabel)
            let lable3:UILabel? = (cell?.viewWithTag(3) as? UILabel)
            let lable4:UILabel? = (cell?.viewWithTag(4) as? UILabel)
            let lable5:UILabel? = (cell?.viewWithTag(5) as? UILabel)
            let lable6:UILabel? = (cell?.viewWithTag(6) as? UILabel)
            let lable7:UILabel? = (cell?.viewWithTag(7) as? UILabel)
            let lable8:UILabel? = (cell?.viewWithTag(8) as? UILabel)
            let headface:UIImageView? = (cell?.viewWithTag(9) as? UIImageView)
           
            
            
            lable1?.text=(items[indexPath.row] as itemMess).username
            lable2?.text=(items[indexPath.row] as itemMess).content
            lable3?.text=(items[indexPath.row] as itemMess).time
            lable4?.text=(items[indexPath.row] as itemMess).address

            lable5?.text="关注数:1"
            lable6?.text="评论数:1"
            lable7?.text="报名数:1"
            
            if ((items[indexPath.row] as itemMess).infocatagory == "0")
            {
                lable8?.text="求"
            }else if ((items[indexPath.row] as itemMess).infocatagory == "1")
            {
                lable8?.text="寻"
            }else if ((items[indexPath.row] as itemMess).infocatagory == "2")
            {
                lable8?.text="转"
            }else if ((items[indexPath.row] as itemMess).infocatagory == "3")
            {
                lable8?.text="帮"
            }
            
           if((items[indexPath.row] as itemMess).photo.isKindOfClass(NSNull))
            {
                headface?.image=UIImage(named: "icon")

            }else
            {
                var head:String!
                var ppp:String = (items[indexPath.row] as itemMess).photo;
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
                             headface?.image=UIImage(data: d)
                        }
                    }
                }else
                {
                    headface?.image=UIImage(named: "icon")
                }
            }
            
            
            
            
            if(indexPath.row%2 == 0)
            {
                return cell!;
            }else
            {
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
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;
    }

    
    
    
   
    
    func saveItem(content: String, senduserid: String, sendnickname: String, guid: String, date: String,address: String, lng: String, lat: String, photo: String, community: String, infocatagory: String)  {
        NSLog( "Hello again, " + content + "!")
        
        let sql = "insert into message(senduserid,sendnickname,community,address,lng,lat,guid,infocatagroy,message,icon,date,is_coming,readed) values('\(senduserid)','\(sendnickname)','\(community)','\(address)','\(lng)','\(lat)','\(guid)','\(infocatagory)','\(content)','\(photo)','\(date)','1','0')"
        NSLog("sql: \(sql)")
        //通过封装的方法执行sql
         db.execute(sql)
    }
    
    //从SQLite加载数据
    func querydata() {
        items.removeAll()
        let sql="select * from message limit 0,".stringByAppendingString(String(self.datas));
        NSLog(sql)
        let mess = db.query(sql)
        if mess.count > 0 {
            //获取最后一行数据显示
        for i in 0...mess.count-1
        {
           let item = mess[i] as SQLRow
            let senduserid = item["senduserid"]!.asString()
           let sendnickname = item["sendnickname"]!.asString()
            let datestr = item["date"]!.asString()
            let address = item["address"]!.asString()
            let message = item["message"]!.asString()
            
            let community = item["community"]!.asString()
            let lng = item["lng"]!.asString()
            let lat = item["lat"]!.asString()
            let guid = item["guid"]!.asString()
            let infocatagroy = item["infocatagroy"]!.asString()
            let photo = item["icon"]!.asString()
            
            
            let item_obj:itemMess = itemMess(userid:senduserid,vname: sendnickname, vtime: datestr, vaddress: address, vcontent: message, vcommunity: community, vlng: lng, vlat: lat, vguid: guid, vinfocatagory: infocatagroy, vphoto: photo, vis_coming: "1", vreaded: "0")
            
            items.append(item_obj)

            
          //  NSLog(aa)
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
