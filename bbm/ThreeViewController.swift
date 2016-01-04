//
//  ThreeViewController.swift
//  bbm
//
//  Created by ericsong on 15/9/28.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class ThreeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         self.title="订阅"
        //self.view.backgroundColor=UIColor.greenColor()
        // Do any additional setup after loading the view.
    }

    @IBAction func SubscribeCommunity_Click(sender: UIButton) {
//        let sb = UIStoryboard(name:"Main", bundle: nil)
//        let vc = sb.instantiateViewControllerWithIdentifier("subscribeCommunityViewController") as! SubscribeCommunityViewController
//        //创建导航控制器
//        let nvc=UINavigationController(rootViewController:vc);
//        //设置根视图
//        self.view.window!.rootViewController=nvc;
        NSLog("one")
    }
    
    @IBAction func SubscribeInterest_Click(sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("subscribeInterestViewController") as! SubscribeInterestViewController
                //创建导航控制器
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;
        NSLog("two")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
