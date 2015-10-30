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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    
    
    
    
    
  
}
