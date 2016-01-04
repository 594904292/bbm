//
//  PicViewController.swift
//  bbm
//
//  Created by ericsong on 16/1/4.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class PicViewController: UIViewController,UINavigationControllerDelegate {
    var url:String = "";
    @IBOutlet weak var pic: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title="图片"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        
        
        Alamofire.request(.GET, url).response { (_, _, data, _) -> Void in
            if let d = data as? NSData!
            {
                self.pic.image=UIImage(data: d)
                
               
            }
        }

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
        self.navigationController?.popViewControllerAnimated(true)
        
    }
}
