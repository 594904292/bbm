//
//  BmUserViewController.swift
//  bbm
//
//  Created by songgc on 16/3/30.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class BmUserViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var _tableview: UITableView!
    var items:[ItemBm]=[]

    var guid:String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.title="报名列表"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        
        
        _tableview.delegate=self
        _tableview.dataSource=self
        querydata();

        
       
    }
    
    @IBAction func run(sender: UIButton) {
       
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
    
    
    func querydata()
            {
                var url:String="http://api.bbxiaoqu.com/getbmuserlist.php?guid=".stringByAppendingString(guid);
                print("url: \(url)")
                Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
            if(response.result.isSuccess)
        {
        if let jsonItem = response.result.value as? NSArray{
            for data in jsonItem{
                print("data: \(data)")
                let id:String = data.objectForKey("id") as! String;
                let userid:String = data.objectForKey("userid") as! String;
                let username:String = data.objectForKey("username") as! String;
                let telphone:String = data.objectForKey("telphone") as! String;
                let headface:String = data.objectForKey("headface") as! String;
                let status:String = data.objectForKey("status") as! String;
        
        
                let item_obj:ItemBm = ItemBm(id: id, userid: userid, username: username, telphone: telphone, headface: headface, status: status)
                self.items.append(item_obj)
            
            }
            self._tableview.reloadData()
            self._tableview.doneRefresh()
        
        }
        }else
        {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
            }
        }
                
    }

    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return self.items.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //var ppp:String = (items[indexPath.row] as itemMess).photo;
        
        let cellId="bmcell"
        var cell:BmuserUITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! BmuserUITableViewCell?
        if(cell == nil)
    {
        cell = BmuserUITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
        }
        cell?.username.text=(items[indexPath.row] as ItemBm).username
        cell?.telphone.text=(items[indexPath.row] as ItemBm).telphone
                
        cell?.zanbtn.tag = indexPath.row
                
        cell?.zanbtn.addTarget(self,action:Selector("tapped:"),forControlEvents:.TouchUpInside)
                

       
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        //NSLog("select \(items[indexPath.row])")
        
    }
    
    
    func tapped(button:UIButton){
            //print(button.titleForState(.Normal))
            var pos:Int = button.tag
        self.setupSendPanel1()
//        let alertController = UIAlertController(title: "系统登录",
//            message: "请输入用户名和密码", preferredStyle: UIAlertControllerStyle.Alert)
//        alertController.addTextFieldWithConfigurationHandler {
//            (textField: UITextField!) -> Void in
//            textField.placeholder = "评价"
//        }
//        alertController.addTextFieldWithConfigurationHandler {
//            (textField: UITextField!) -> Void in
//            textField.placeholder = "得分"
//           // textField.secureTextEntry = true
//        }
//        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
//        let okAction = UIAlertAction(title: "好的", style: .Default,
//            handler: {
//            action in
//            //也可以用下标的形式获取textField let login = alertController.textFields![0]
//            let login = alertController.textFields!.first! as UITextField
//            let password = alertController.textFields!.last! as UITextField
//            print("用户名：\(login.text) 密码：\(password.text)")
//            })
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
//        self.presentViewController(alertController, animated: true, completion: nil)
         }
            
    

var sendView:UIView!;
var txtMsg:UITextField!;
func setupSendPanel1()
{
                self.sendView = UIView(frame:CGRectMake(0,self.view.frame.size.height-100,self.view.frame.size.width,100))
                
                self.sendView.backgroundColor=UIColor.grayColor()
                self.sendView.alpha=0.9
    
               txtMsg = UITextField(frame:CGRectMake(7,10,self.view.frame.size.width-14,36))
                txtMsg.backgroundColor = UIColor.whiteColor()
                txtMsg.textColor=UIColor.blackColor()
               txtMsg.font=UIFont.boldSystemFontOfSize(12)
                txtMsg.layer.cornerRadius = 10.0
//                
//                //Set the delegate so you can respond to user input
//                txtMsg.delegate=self
//                txtMsg.placeholder = "输入消息内容"
//                txtMsg.returnKeyType = UIReturnKeyType.Send
//                txtMsg.enablesReturnKeyAutomatically  = true
//                
                self.sendView.addSubview(txtMsg)
    
                self.view.addSubview(sendView)
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:"handleTouches:")
    tapGestureRecognizer.cancelsTouchesInView = false
    self.view.addGestureRecognizer(tapGestureRecognizer)
    

    
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
    
}

    func textFieldShouldReturn(textField:UITextField) -> Bool
    {
                    
                    return true
    }

    func keyBoardWillShow(note:NSNotification)
{
                    let userInfo  = note.userInfo as! NSDictionary
                    var  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
                    let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
                    
                    var keyBoardBoundsRect = self.view.convertRect(keyBoardBounds, toView:nil)
                    
                    var keyBaoardViewFrame = sendView.frame
                    var deltaY = keyBoardBounds.size.height
                    
                    let animations:(() -> Void) = {
        
        self.sendView.transform = CGAffineTransformMakeTranslation(0,-deltaY)
                    }
                    
                    if duration > 0 {
        let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
        
        UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        
        
    }else{
        
        animations()
                    }
                    
                    
    }
    
    func keyBoardWillHide(note:NSNotification)
                    {
                        
                        let userInfo  = note.userInfo as! NSDictionary
                        
                        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
                        
                        
                        let animations:(() -> Void) = {
                        
                        self.sendView.transform = CGAffineTransformIdentity
                        
                        }
                        
                        if duration > 0 {
        let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
        
        UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        
        
    }else{
        
        animations()
                        }
                        
                        
                        
                        
    }
    
    func handleTouches(sender:UITapGestureRecognizer){
                            
                            if sender.locationInView(self.view).y < self.view.bounds.height - 250{
                            txtMsg.resignFirstResponder()
                            
                            
                            }
                            
                            
    }

}
