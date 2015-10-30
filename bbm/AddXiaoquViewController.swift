//
//  AddXiaoquViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/19.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class AddXiaoquViewController: UIViewController {
    //体育　足球　运动　家教　房产　兼职　促销　培训
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title="增加小区"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")

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
    func backClick()
    {
        NSLog("back");
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("subscribeCommunityViewController") as! SubscribeCommunityViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }

}
