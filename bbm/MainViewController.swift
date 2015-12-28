//
//  MainViewController.swift
//  bbm
//
//  Created by ericsong on 15/12/10.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBAction func cansos(sender: UIButton) {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("tabone") as! OneViewController
       self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func sos(sender: UIButton) {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("publishController") as! PublishViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    var items:[itemDaymic]=[]
    var cities=["成都","北京","上海","深圳","天津","成都","北京","上海","深圳","天津"]
    var ggid:String = "";
    @IBOutlet weak var gonggao: UILabel!
    
    @IBOutlet weak var _tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title="帮帮小区"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "设置", style: UIBarButtonItemStyle.Done, target: self, action: "SetClick")
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "退出", style: UIBarButtonItemStyle.Done, target: self, action: "exitClick")
        
        
       
        
        showgg()
        gonggao.userInteractionEnabled = true
        //gonggao.addGestureRecognizer(UIGestureRecognizer(target: self, action: "showggpage"))
        gonggao.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("showpage")))
        //gonggao.addGestureRecognizer(UITapGestureRecognizer(target: <#T##AnyObject?#>, action: Selector))
        
        
        _tableview!.delegate=self
        _tableview!.dataSource=self
//        self._tableview.headerView = XWRefreshNormalHeader(target: self, action: "upPullLoadData")
//        
//        self._tableview.headerView?.beginRefreshing()
//        self._tableview.headerView?.endRefreshing()
//        
//        self._tableview.footerView = XWRefreshAutoNormalFooter(target: self, action: "downPlullLoadData")
        self.automaticallyAdjustsScrollViewInsets = false
        
        querydata()
        self.appDelegate().connect()
        
//        if (self.appDelegate().connect())
//        {
//            print("show buddy list")
//            
//        }
//        self.appDelegate().send("369", to: "18600888703", mess: "from main")
     }
    
    //取得当前程序的委托
    func  appDelegate() -> AppDelegate{
        
        return UIApplication.sharedApplication().delegate as! AppDelegate
        
    }
    

    
    
    //MARK: 加载数据
    func upPullLoadData(){
        
        //延迟执行 模拟网络延迟，实际开发中去掉
        xwDelay(1) { () -> Void in
            self.querydata()
            self._tableview.reloadData()
            self._tableview.headerView?.endRefreshing()
            
        }
        
    }
    
    func downPlullLoadData(){
        
        xwDelay(1) { () -> Void in
            
            
            self.querydata()
            self._tableview.reloadData()
            self._tableview.footerView?.endRefreshing()
        }
        
    }
    

    
    func querydata()
    {
        
        
        let url:String="http://www.bbxiaoqu.com/getdynamics.php?userid=369&rang=xiaoqu&start=0&limit=20";
        print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if let jsonItem = response.result.value as? NSArray{
                    for data in jsonItem{
                        print("data: \(data)")
                        
                        let id:String = data.objectForKey("id") as! String;
                        let userid:String = data.objectForKey("userid") as! String;
                        let username:String = data.objectForKey("username") as! String;
                        let actionname:String = data.objectForKey("actionname") as! String;
                        let actiontime:String = data.objectForKey("actiontime") as! String;
                        let guid:String = data.objectForKey("guid") as! String;
                        let messdesc:String = data.objectForKey("messdesc") as! String;
                       
                        let item_obj:itemDaymic = itemDaymic(id: id, userid: userid, username: username, actionname: actionname, actiontime: actiontime, guid: guid, messdesc: messdesc)
                        self.items.append(item_obj)
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self._tableview.reloadData();
                        self._tableview.doneRefresh();
                    })
                }
        }
        
    }

    
    func showpage()
    {
        print("showggpage")
        var urlstr:String="http://www.bbxiaoqu.com/wap/gonggao.php?id=".stringByAppendingString(ggid)
        var url=NSURL(string: urlstr)
        UIApplication.sharedApplication().openURL(url!)

    }
    
    func showgg()
    {
        
        
        var url:String="http://www.bbxiaoqu.com/gonggao.php"
        print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if let jsonItem = response.result.value as? NSArray{
                    for data in jsonItem{
                        //print("data: \(data)")
                        
                        let id:String = data.objectForKey("id") as! String;
                        let title:String = data.objectForKey("title") as! String;
                        self.gonggao.text=title
                        self.ggid=id;
                    }
                }
        }
    }
    
    func SetClick()
    {
        NSLog("SetClick")
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("tabfour") as! FourViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func exitClick()
    {
        NSLog("exitClick")
        exit(0)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        
    {
        
        
        
        let cellId = "daymiccell"
        
        //无需强制转换
        
        var cell:DynamicTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! DynamicTableViewCell
        
        if(cell == nil)
            
        {
            
            cell = DynamicTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            
        }
        
        
        cell?.name.text=(self.items[indexPath.row] as itemDaymic).username
        
        
        cell?.time.text=(self.items[indexPath.row] as itemDaymic).actiontime
        
      
        //lable3?.w
         //var label = UILabel(frame: CGRectMake(0,0,ScreenWidth,0))
        //var viewBounds:CGRect = UIScreen.mainScreen().applicationFrame
       // lable3?.frame = CGRectMake(0,0,viewBounds.width/2,0);
        cell?.info?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell?.info?.numberOfLines=0
        
        
        if((self.items[indexPath.row] as itemDaymic).actionname=="join")
        {
            
            cell?.tag1?.image = UIImage(named: "dynamic_info_left")
            cell?.tag2?.image = UIImage(named: "dynamic_info_icon")
            cell?.info?.text="加入了小区"

        }else if((self.items[indexPath.row] as itemDaymic).actionname=="publish")
        {
            cell?.tag1?.image = UIImage(named: "dynamic_join_left")
            cell?.tag2?.image = UIImage(named: "dynamic_join_icon")
           
            cell?.info?.text=(self.items[indexPath.row] as itemDaymic).messdesc

        }else if((self.items[indexPath.row] as itemDaymic).actionname=="solution")
        {
            
            cell?.tag1?.image = UIImage(named: "dynamic_name_left")
            cell?.tag2?.image = UIImage(named: "dynamic_name_icon")
            cell?.info?.text="获得一个雷锋称号"

        }
        
        return cell!
        
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        if((self.items[indexPath.row] as itemDaymic).actionname=="publish")
        {
            var guid:String = (self.items[indexPath.row] as itemDaymic).guid
            
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("contentviewController") as! ContentViewController
            //创建导航控制器
            //vc.message = aa.content;
            vc.guid=guid
            vc.infoid=guid
            // let nvc=UINavigationController(rootViewController:vc);
            //设置根视图
            //  self.view.window!.rootViewController=nvc;
            self.navigationController?.pushViewController(vc, animated: true)
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

}
