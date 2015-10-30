//
//  FourViewController.swift
//  bbm
//
//  Created by ericsong on 15/9/28.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class FourViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         self.title="我的"
        //self.view.backgroundColor=UIColor.grayColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func myinfo(sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("myinfo") as! MyInfoViewController
       
        //创建导航控制器
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;
         NSLog("one")

    }

    @IBAction func gzxiaoqu(sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("gzcommunity") as! GzCommunityViewController
      
        //创建导航控制器
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;
         NSLog("two")

    }
    
    @IBAction func myinterest(sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("myinterest") as! MyInterestViewController
        //创建导航控制器
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;
         NSLog("three")

    }
    
    @IBAction func gzinfo(sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("gzinfo") as! GzInfoViewController
       
        //创建导航控制器
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;
        NSLog("four")
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
