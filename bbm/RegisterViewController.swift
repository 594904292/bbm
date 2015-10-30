//
//  RegisterViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/23.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class RegisterViewController: UIViewController {

    var alertView:UIAlertView?
    
    @IBOutlet weak var telphone_edit: UITextField!
    
    @IBOutlet weak var password_edit: UITextField!
    
    @IBOutlet weak var authoncode: UITextField!
    
    @IBOutlet weak var authonbtn: UIButton!
    
    @IBAction func getauthoncode(sender: UIButton) {
        let tel:String = self.telphone_edit.text as String!
        let  dic:Dictionary<String,String> = ["_telphone" : tel]
        Alamofire.request(.POST, "http://www.bbxiaoqu.com/getauthcode.php", parameters: dic)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                print(response.result.value)
                                if let JSON = response.result.value {
                                    print("JSON: \(JSON)")
                                    self.authoncode.text=String(JSON as! NSNumber);
                                }
        }
    }
    
    @IBAction func regmember(sender: UIButton) {
        let tel:String = self.telphone_edit.text as String!
        let password:String = self.password_edit.text as String!
        let authcode:String = self.authoncode.text as String!
        let  dic:Dictionary<String,String> = ["_userid" : tel,"_telphone" : tel,"_password" : password,"_authoncode" : authcode]
        Alamofire.request(.POST, "http://www.bbxiaoqu.com/save.php", parameters: dic)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                print(response.result.value)
                if let ret = response.result.value  {
                    // print("JSON: \(JSON)")
                   if String(ret)=="1"
                   {
                    
                    self.alertView = UIAlertView()
                    self.alertView!.title = "注册提示"
                    self.alertView!.message = "保存成功"
                    self.alertView!.addButtonWithTitle("关闭")
                    NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
                    self.alertView!.show()
                    
                    } else if String(ret)=="2"
                   {
                    self.alertView = UIAlertView()
                    self.alertView!.title = "注册提示"
                    self.alertView!.message = "用户ID已注册"
                    self.alertView!.addButtonWithTitle("关闭")
                    NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
                    self.alertView!.show()
                    }else if String(ret)=="3"
                   {
                    self.alertView = UIAlertView()
                    self.alertView!.title = "注册提示"
                    self.alertView!.message = "手机号已注册"
                    self.alertView!.addButtonWithTitle("关闭")
                    NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
                    self.alertView!.show()
                    }else if String(ret)=="4"
                   {
                    self.alertView = UIAlertView()
                    self.alertView!.title = "注册提示"
                    self.alertView!.message = "保存失败"
                    self.alertView!.addButtonWithTitle("关闭")
                    NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
                    self.alertView!.show()
                    
                    }
                }
        }

    }
    @IBAction func goback(sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func dismiss(timer:NSTimer){
        alertView!.dismissWithClickedButtonIndex(0, animated:true)
    }

}
