//
//  SystemSettingViewController.swift
//  bbm
//
//  Created by songgc on 16/5/23.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import AudioToolbox
import Alamofire

class SystemSettingViewController: UIViewController,XxDL {
    var openmessflag=false;
    var openvoiceflag=false;
    @IBOutlet weak var openmessswitch: UISwitch!
    @IBOutlet weak var openvoiceswitch: UISwitch!
    
    @IBAction func openmess(sender: UISwitch) {
        var open:String="0"
        if sender.on == true
        {
            self.openmessflag=true
            open="1"
        }else
        {
            self.openmessflag=false
            open="0"

        }
        
        let defaults = NSUserDefaults.standardUserDefaults();
       
        defaults.setObject(self.openmessflag, forKey: "openmessflag");
        defaults.synchronize();
        
        Alamofire.request(.POST, "http://api.bbxiaoqu.com/resetuserfield.php", parameters:["userid" : self.userid,"field":"isrecvmess","fieldvalue":open])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                print(response.result.value)
                
                
        }


    }
    
    @IBAction func openvoice(sender: UISwitch) {
          var open:String="0"
        if sender.on == true
        {
            self.openvoiceflag=true
            open="1"

        }else
        {
            self.openvoiceflag=false
            open="0"
            
        }
        
        let defaults = NSUserDefaults.standardUserDefaults();

        defaults.setObject(self.openvoiceflag, forKey: "openvoiceflag");
        defaults.synchronize();
        Alamofire.request(.POST, "http://api.bbxiaoqu.com/resetuserfield.php", parameters:["userid" : self.userid,"field":"isopenvoice","fieldvalue":open])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                print(response.result.value)
                
                
        }
    }
    
    func newMsg(aMsg: WXMessage) {
        //无需实现
    }

    
    @IBAction func exit(sender: UIButton) {
        NSLog("offlineClick")
        zdl().disConnect()

        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
        vc.reloadInputViews();
        self.presentViewController(vc, animated: true, completion: nil)
    }
    var userid:String = "";
    var flag1:String = "";
    var flag2:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.title="我的"
        //self.view.backgroundColor=UIColor.grayColor()
        // Do any additional setup after loading the view.
        self.navigationItem.title="系统设置"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        //self.appDelegate().connect()
        
        let defaults = NSUserDefaults.standardUserDefaults();
        userid = defaults.objectForKey("userid") as! String;
        
        flag1 = defaults.objectForKey("openmessflag") as! String;
        flag2 = defaults.objectForKey("openvoiceflag") as! String;
        
        if flag1=="1"
        {
            openmessswitch.on=true
        }else
        {
            openmessswitch.on=false
        }
        if flag2=="1"
        {
            openvoiceswitch.on=true
        }else
        {
            openvoiceswitch.on=false
        }

//        defaults.setObject(isrecvmess, forKey: "openmessflag");
//        defaults.setObject(isopenvice, forKey: "openvoiceflag");
        zdl().xxdl = self
        
        zdl().connect()
    }

    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
    }
    //获取总代理
    func zdl() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
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
