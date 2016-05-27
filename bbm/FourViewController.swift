//
//  FourViewController.swift
//  bbm
//
//  Created by ericsong on 15/9/28.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class FourViewController: UIViewController,UINavigationControllerDelegate{

    
//    @IBOutlet weak var messopenswitch: UISwitch!
//    
//    @IBOutlet weak var messopenlabel: UILabel!
//    
//    @IBAction func messopenaction(sender: UISwitch) {
//        if self.messopenswitch.on == true
//        {
//            self.messopenlabel.text="接收消息"
//        }else
//        {
//            self.messopenlabel.text="关闭通知"
//        }
//        
//        //print(messopenswitch.on)
//        
//    }
    var isopenmess:Bool=true;
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title="我的"
        //self.view.backgroundColor=UIColor.grayColor()
        // Do any additional setup after loading the view.
            self.navigationItem.title="个人中心"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        
        
        
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

    
    @IBAction func myinfo(sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("myinfo") as! MyInfoViewController
       
        //创建导航控制器
        self.navigationController?.pushViewController(vc, animated: true)
        
         NSLog("one")

    }
    
    @IBAction func recent(sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("recentviewcontroller") as! RecentTableViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    @IBAction func friends(sender: UIButton) {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("friendsviewcontroller") as! FriendsTableViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func myinfos(sender: UIButton) {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("myinfosviewcontroller") as! MyinfosTableViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }

    
    @IBAction func gz(sender: UIButton) {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("gzinfosviewcontroller") as! GzInfosTableViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
   
    @IBAction func setting(sender: UIButton) {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("settingviewcontroller") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    @IBAction func offline(sender: UIButton) {
//        NSLog("offlineClick")
//        //exit(0)
//        let sb = UIStoryboard(name:"Main", bundle: nil)
//        let vc = sb.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
//        vc.reloadInputViews();
//        //创建导航控制器
//        //let nvc=UINavigationController(rootViewController:vc);
//        //设置根视图
//        //self.view.window!.rootViewController=nvc;
//        self.presentViewController(vc, animated: true, completion: nil)
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("systemsettingviewcontroller") as! SystemSettingViewController
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

}
