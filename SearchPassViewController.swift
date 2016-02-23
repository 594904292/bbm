//
//  SearchPassViewController.swift
//  bbm
//
//  Created by ericsong on 16/2/22.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class SearchPassViewController: UIViewController {

    @IBOutlet weak var telphone: UITextField!
   
    @IBOutlet weak var authcode: UITextField!
    
    @IBOutlet weak var nextbtn: UIButton!
    var lastauthcode:String = "9811";
    
    
    @IBAction func controltouchdown(sender: AnyObject) {
        telphone.resignFirstResponder()
        authcode.resignFirstResponder()
    }
    
    @IBAction func telphone_exit(sender: UITextField) {
        self.resignFirstResponder()
        
    }
    
    @IBAction func authcode_exit(sender: UITextField) {
        
        self.resignFirstResponder()
    }
    
//    @IBAction func ControlTouchDown(sender: UIControl) {
//        
//         telphone.resignFirstResponder()
//        authcode.resignFirstResponder()
//    }
    
    
    @IBAction func GetAuthcode(sender: UIButton) {
        if(self.telphone.text!.characters.count==0)
        {
            self.alertView = UIAlertView()
            self.alertView!.title = "提示"
            self.alertView!.message = "电话不能为空"
            self.alertView!.addButtonWithTitle("关闭")
            NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
            self.alertView!.show()
            return;
        }

        let tel:String = self.telphone.text as String!
        let  dic:Dictionary<String,String> = ["_telphone" : tel]
        Alamofire.request(.POST, "http://www.bbxiaoqu.com/getauthcode.php?show=true", parameters: dic)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                print(response.result.value)
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    self.authcode.text=String(JSON as! NSNumber);
                    self.lastauthcode=String(JSON as! NSNumber);
                }
        }

    }
    
    @IBAction func authcodechange(sender: UITextField) {
        if(self.lastauthcode == sender.text)
        {
        
            self.nextbtn.enabled = true

        }else
        {
            self.nextbtn.enabled = false

        }
    
    }
    var alertView:UIAlertView?

    @IBAction func NextAction(sender: UIButton) {
        
        
        
        if(self.telphone.text!.characters.count==0)
        {
            self.alertView = UIAlertView()
            self.alertView!.title = "提示"
            self.alertView!.message = "电话不能为空"
            self.alertView!.addButtonWithTitle("关闭")
            NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
            self.alertView!.show()
            return;
        }
        if(self.authcode.text!.characters.count==0)
        {
            self.alertView = UIAlertView()
            self.alertView!.title = "提示"
            self.alertView!.message = "认证码不能为空"
            self.alertView!.addButtonWithTitle("关闭")
            NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
            self.alertView!.show()
            return;
        }
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("resetpassController") as! ResetPassViewController
        vc.telphone = telphone.text!
        //创建导航控制器
        let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        self.view.window!.rootViewController=nvc;

    }
    
    func dismiss(timer:NSTimer){
        alertView!.dismissWithClickedButtonIndex(0, animated:true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title="忘记密码"
        self.title="忘记密码"
        nextbtn.enabled=false
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        
        
        
        
    }
    
    func backClick()
    {
        NSLog("back");
        //self.navigationController?.popViewControllerAnimated(true)
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
        //创建导航控制器
        //let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        //self.view.window!.rootViewController=nvc;
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
