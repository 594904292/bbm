//
//  SettingViewController.swift
//  bbm
//
//  Created by ericsong on 15/12/22.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class SettingViewController: UIViewController,UINavigationControllerDelegate {
    var alertView:UIAlertView?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        self.navigationItem.title="关于建议"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        
        
        
        var contentlayer:CALayer = content.layer
        contentlayer.borderColor=UIColor.lightGrayColor().CGColor
        contentlayer.opacity=0.3
        contentlayer.borderWidth = 1.0;
        
        let infoDictionary = NSBundle .mainBundle ().infoDictionary
        
        let appDisplayName: AnyObject? = infoDictionary![ "CFBundleDisplayName"]
        
        let majorVersion : String = infoDictionary! [ "CFBundleShortVersionString"] as! String
        
        let minorVersion : String = infoDictionary! [ "CFBundleVersion"] as! String
        
        desc.text="帮帮忙(".stringByAppendingString(majorVersion).stringByAppendingString("_").stringByAppendingString(minorVersion).stringByAppendingString(")平台，是基于位置的传播正能量的互联网互助平台。让附近的人互相帮忙，我们希望把大众的力量组织起来，有一技之长的人可以通过“帮帮忙”为附近的人提供帮助；普通大众可以通过“帮帮忙” 快速寻求帮助。 “涓滴之水成海洋，颗颗爱心变希望”。")
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

    
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var desc: UILabel!
    @IBAction func submit(sender: UIButton) {
        if(content.text?.characters.count==0)
        {
            self.alertView = UIAlertView()
            self.alertView!.title = "提示"
            self.alertView!.message = "建议为空"
            self.alertView!.addButtonWithTitle("关闭")
            NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
            self.alertView!.show()
            return;
        }
        var alertView = UIAlertView()
        alertView.title = "系统提示"
        alertView.message = "您确定提交建议吗？"
        alertView.addButtonWithTitle("取消")
        alertView.addButtonWithTitle("确定")
        alertView.cancelButtonIndex=0
        alertView.delegate=self;
        alertView.show()
        
        
       
    }
    func dismiss(timer:NSTimer){
        alertView!.dismissWithClickedButtonIndex(0, animated:true)
    }
    
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
            print("点击了取消")
        }
        else
        {
            NSLog("add")
            let defaults = NSUserDefaults.standardUserDefaults();
            let userid = defaults.objectForKey("userid") as! String;
            var date = NSDate()
            var timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
            var strNowTime = timeFormatter.stringFromDate(date) as String
            let mess:String = content.text!
            var  dic:Dictionary<String,String> = ["content" : mess, "userid": userid, "addtime": strNowTime]
            Alamofire.request(.POST, "http://api.bbxiaoqu.com/savesuggest.php", parameters: dic)
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    print(response.result.value)
                    //                if let JSON = response.result.value {
                    //                    print("JSON: \(JSON)")
                    //                }
                    self.content.text = "";
            }

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
