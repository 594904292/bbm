//
//  SubscribeCommunityViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/13.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class GzInfoViewController: UIViewController,UINavigationControllerDelegate,UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableview: UITableView!
     var items:[itemMess]=[]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="关注信息"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        // Do any additional setup after loading the view.
        self.tableview.delegate=self;
        self.tableview.dataSource=self;
        SaveRemoteData()

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
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int{
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
            headface?.image=UIImage(named: "add")
            
        }else
        {
            var head:String!
            var ppp:String = (items[indexPath.row] as itemMess).photo;
            if((ppp.rangeOfString(",") ) != nil)
            {
                var myArray = ppp.componentsSeparatedByString(",")
                var headname = myArray[0] as String
                head = "http://www.bbxiaoqu.com/uploads/"+headname
            }else
            {
                head = "http://www.bbxiaoqu.com/uploads/"+ppp
            }
            
            NSLog("\((items[indexPath.row] as itemMess).photo)")
            NSLog("\(head)")
            Alamofire.request(.GET, head!).response { (_, _, data, _) -> Void in
                if let d = data as? NSData!
                {
                    headface?.image=UIImage(data: d)
                }
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
    
    func SaveRemoteData()
    {
        var guid:String="";
        //Alamofire.request(.GET, "http://www.bbxiaoqu.com/getgzinfo.php?guid=", parameters: nil)
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
//                        var infoobj:itemMess=itemMess(userid:senduser,vname: "", vtime: sendtime, vaddress: address, vcontent: content, vcommunity: community, vlng: lng, vlat: lat, vguid: guid, vinfocatagory: infocatagroy, vphoto: photo, vis_coming: "1", vreaded: "0")
//                        self.items.append(infoobj)
                    }
                    self.tableview.reloadData();
            }
        }
    }
    

}
