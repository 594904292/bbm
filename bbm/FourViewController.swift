//
//  FourViewController.swift
//  bbm
//
//  Created by ericsong on 15/9/28.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class FourViewController: UIViewController,UINavigationControllerDelegate{

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
        var sb = UIStoryboard(name:"Main", bundle: nil)
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
        NSLog("offlineClick")
        exit(0)
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
