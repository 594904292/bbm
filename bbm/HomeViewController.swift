//
//  HomeViewController.swift
//  bbm
//
//  Created by ericsong on 15/9/24.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UITabBarController,UINavigationControllerDelegate,ApnsDelegate {
    @IBOutlet weak var order: UILabel!
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var content: UIView!
    //创建四个
    var one:UIViewController!
    var two:UIViewController!
    var three:UIViewController!
    var four:UIViewController!
    
    func NewMessage(string:String){
        //qzLabel!.text = string
        //println("qzLabel.text == \(string)")
        print("\(string)")
    }
    
    var db: SQLiteDB!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        self.navigationItem.title="帮帮忙"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        one=storyboard?.instantiateViewControllerWithIdentifier("tabone") as UIViewController!
        two=storyboard?.instantiateViewControllerWithIdentifier("tabtwo") as UIViewController!
        three=storyboard?.instantiateViewControllerWithIdentifier("tabthree") as UIViewController!
        four=storyboard?.instantiateViewControllerWithIdentifier("tabfour") as UIViewController!
 
        var images=["movie_home","icon_cinema","start_top250","msg_new"]
        var titles=["动态","发布","订阅","我的"]
        for  index in 0...3{
            let item1 :UITabBarItem! = self.tabBar.items?[index] as UITabBarItem!;
            item1.title = titles[index] as String
            if(index == 0)
            {
               // item1.badgeValue=String(1)
            }
            item1.image=UIImage(named:images[index])
        }
        self.selectedIndex = 0
//        if (self.appDelegate().connect())
//        {
//            print("show buddy list")
//            
//        }
       // send()
        //if (self.appDelegate().connect()) {
          //  print("show buddy list")
            
       // }
    }
    
    func send()
    {
        //XMPPFramework主要是通过KissXML来生成XML文件
        //生成<body>文档
        let body:DDXMLElement = DDXMLElement.elementWithName("body") as! DDXMLElement
        body.setStringValue("我来自apple")
        
        //生成XML消息文档
        let mes:DDXMLElement = DDXMLElement.elementWithName("message") as! DDXMLElement
        //消息类型
        mes.addAttributeWithName("type",stringValue:"chat")
        //发送给谁
        mes.addAttributeWithName("to" ,stringValue:"888@bbxiaoqu")
         //由谁发送
        mes.addAttributeWithName("from" ,stringValue:"369@bbxiaoqu")
        //组合
        mes.addChild(body)
        
        //发送消息
        //self.appDelegate().xmppStream!.sendElement(mes)
    
    }
    
    
    //取得当前程序的委托
    func  appDelegate() -> AppDelegate{
        
        return UIApplication.sharedApplication().delegate as! AppDelegate
        
    }
    
    func backClick()
    {
        NSLog("back");
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    
    
    
    
  
}
