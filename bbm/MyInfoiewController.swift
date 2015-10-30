//
//  SubscribeCommunityViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/13.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class MyInfoViewController: UIViewController ,UINavigationControllerDelegate , UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var headface: UIImageView!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var xiaoqu: UITextField!
    @IBOutlet weak var tel: UITextField!
    @IBOutlet weak var sex: UIPickerView!
    
    @IBAction func selxiaoqu(sender: UIButton) {
    }
    
    @IBAction func savemyinfo(sender: UIButton) {
        print("JSON1: \(self.sex?.selectedRowInComponent(0))")
        
        //self.sex?.s
    }
    var selsexpicker:String="男";
    var arr = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        arr = ["男","女"]
        self.navigationItem.title="个人资料"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        // Do any additional setup after loading the view.
        
        
        
        sex.delegate = self
       
       sex.dataSource = self
        let defaults = NSUserDefaults.standardUserDefaults();
      
        
        
        
        let userid = defaults.objectForKey("userid") as! NSString;
        loaduserinfo(userid as String)
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func backClick()
    {
        NSLog("back");
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("homeController") as! HomeViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    func loaduserinfo(userid:String)
    {
         var url_str:String = "http://www.bbxiaoqu.com/getuserinfo.php?userid=".stringByAppendingString(userid)
        Alamofire.request(.POST,url_str, parameters:nil)
            .responseJSON { response in
                //                print(response.request)  // original URL request
                //                print(response.response) // URL response
                //                print(response.data)     // server data
                //                print(response.result)   // result of response serialization
                                print(response.result.value)
                
                
                if let JSON = response.result.value {
                    print("JSON1: \(JSON.count)")
                    if(JSON.count==0)
                    {
                        
                       
                        
                    }else
                    {
                        //let userid:String = JSON.objectForKey("userid") as! String;
                        //let pass:String = JSON.objectForKey("pass") as! String;
                        let telphone:String = JSON[0].objectForKey("telphone") as! String;
                        let headfaceurl:String = JSON[0].objectForKey("headface") as! String;
                        let username:String = JSON[0].objectForKey("username") as! String;
                         let community:String = JSON[0].objectForKey("community") as! String;
                         let age:String = JSON[0].objectForKey("age") as! String;
                         let usersex:String = JSON[0].objectForKey("sex") as! String;
                        self.nickname.text=username;
                        self.tel.text=telphone;
                        self.xiaoqu.text=community;
                        self.age.text=age;
                        
                        //print("JSON1: \(self.sex?.selectedRowInComponent(0))")
                        if(usersex=="1")
                        {//男
                            self.sex.selectRow(0, inComponent: 0, animated: true)
                        }else
                        {//女
                            self.sex.selectRow(1, inComponent: 0, animated: true)
                        }
                        
                        
                        //if(headfaceurl.isKindOfClass(NSNull))
                         //{
                            let url="http://www.bbxiaoqu.com/uploads/"+headfaceurl;
                        Alamofire.request(.GET, url).response { (_, _, data, _) -> Void in
                            if let d = data as? NSData!
                            {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    
                                    headface?.image = UIImage(data: d)
                                })
                            }
                        }
                        //}
                    }

                    
                }
        }
    }
    
    
    // 设置列数
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
   
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                  return arr.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
       if(component == 0){
            return arr[row]
        }
        return nil
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //NSLog(arr[row])
        selsexpicker=arr[row];
    }
    
    

    
    
}
