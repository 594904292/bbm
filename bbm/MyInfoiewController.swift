//
//  SubscribeCommunityViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/13.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class MyInfoViewController: UIViewController ,UINavigationControllerDelegate , UIPickerViewDelegate, UIPickerViewDataSource,ChangeWordDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate{
    
    var fullPath:String = "";
    var xiaoquid:String = "";
    var xiaoquname:String = "";
    var xiaoqulat:String = "";
    var xiaoqulng:String = "";
    @IBOutlet weak var headface: UIImageView!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var xiaoqu: UITextField!
    @IBOutlet weak var tel: UITextField!
    @IBOutlet weak var sex: UIPickerView!
    
    var img = UIImage()

    func changeWord(controller:XiaoquTableViewController,xqname:String,xqid:String,xqlat:String,xqlng:String){
        //qzLabel!.text = string
        xiaoqu.text=xqname
        xiaoquid=xqid;
        xiaoquname=xqname;
        xiaoqulat=xqlat;
        xiaoqulng=xqlng;
    }
    
    
    @IBAction func savemyinfo(sender: UIButton) {
       
        NSLog("add")
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! String;
        let lat = defaults.objectForKey("lat") as! String;
        let lng = defaults.objectForKey("lng") as! String;
        var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyMMddHHmmss"
        var strNowTime = timeFormatter.stringFromDate(date) as String
        var fname:String = userid.stringByAppendingString("_").stringByAppendingString(strNowTime).stringByAppendingString(".jpg")
       // NSLog(fullPath)
        
          print("savemyinfo fullPath=\(fullPath)")
         print("savemyinfo fname=\(fname)")
        if(fullPath.characters.count>0)
        {
            uploadImg(fullPath,filename: fname)
        }
        
        var  dic:Dictionary<String,String> = ["userid" : userid, "headface": fname]
        dic["username"]=nickname.text;
        dic["age"] = age.text;
        if(selsexpicker=="男")
        {
            dic["sex"] = "1"
        }else
        {
            dic["sex"] = "0"
        }
        dic["telphone"] = tel.text;
        dic["community"] = xiaoquname;
        dic["community_id"] = xiaoquid;
        dic["community_lat"] = xiaoqulat;
        dic["community_lng"] = xiaoqulng;
        Alamofire.request(.POST, "http://www.bbxiaoqu.com/saveuserinfo.php", parameters: dic)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                print(response.result.value)
        }
    }
    
    @IBAction func selectxq(sender: UIButton) {
        print("xiaoqu")
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("xiaoqutableviewcontroller") as! XiaoquTableViewController
        vc.delegate=self;
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var selsexpicker:String="男";
    var arr = [String]()
     var xiaoqudl : xiaoquDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        arr = ["男","女"]
        self.navigationItem.title="个人资料"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        // Do any additional setup after loading the view.
        sex.delegate = self
        sex.dataSource = self
        headface.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "goImagesel")
        headface .addGestureRecognizer(singleTap)
        
         //headface.addTarget(self, action: "goImagesel", forControlEvents: UIControlEvents.TouchUpInside)
        
        
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
        self.navigationController?.popViewControllerAnimated(true)
        
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
                        var community:String;
                        if(JSON[0].objectForKey("community")!.isKindOfClass(NSNull))
                        {
                            community="";
                        }else
                        {
                            community = JSON[0].objectForKey("community") as! String;
                        }
                        var community_id:String;
                        if(JSON[0].objectForKey("community_id")!.isKindOfClass(NSNull))
                        {
                            community_id="";
                        }else
                        {
                            community_id = JSON[0].objectForKey("community_id") as! String;
                        }
                        
                        var community_lat:String;
                        if(JSON[0].objectForKey("community_lat")!.isKindOfClass(NSNull))
                        {
                            community_lat="";
                        }else
                        {
                            community_lat = JSON[0].objectForKey("community_lat") as! String;
                        }
                        var community_lng:String;
                        if(JSON[0].objectForKey("community_lng")!.isKindOfClass(NSNull))
                        {
                            community_lng="";
                        }else
                        {
                            community_lng = JSON[0].objectForKey("community_lng") as! String;
                        }
                        
                        var age:String;
                        if(JSON[0].objectForKey("age")!.isKindOfClass(NSNull))
                        {
                            age="";
                        }else
                        {
                            age = JSON[0].objectForKey("age") as! String;
                        }
                        
                        var usersex:String;
                        if(JSON[0].objectForKey("sex")!.isKindOfClass(NSNull))
                        {
                            usersex="1";
                        }else
                        {
                            usersex = JSON[0].objectForKey("sex") as! String;
                        }
                        
                        
                        self.xiaoquid=community_id;
                        self.xiaoquname=community;
                        self.xiaoqulat=community_lat;
                        self.xiaoqulng=community_lng;
                        
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
                        
                        
                        self.xiaoquid=community_id;
                        self.xiaoquname=community;
                        self.xiaoqulat=community_lat;
                        self.xiaoqulng=community_lng;
                        
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
                                    
                                    self.headface?.image = UIImage(data: d)
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
    
    
    
    
    
    func uploadImg(image: String,filename: String){
        //设定路径
        var furl: NSURL = NSURL(fileURLWithPath: image)
        /** 把UIImage转化成NSData */
        let imageData = NSData(contentsOfURL: furl)
        if (imageData != nil) {
            
            /** 设置上传图片的URL和参数 */
            let defaults = NSUserDefaults.standardUserDefaults();
            let user_id = defaults.stringForKey("userid")
            let url = "http://www.bbxiaoqu.com/upload.php"
            let request = NSMutableURLRequest(URL: NSURL(string:url)!)
            
            /** 设定上传方法为Post */
            request.HTTPMethod = "POST"
            let boundary = NSString(format: "---------------------------14737809831466499882746641449")
            
            /** 上传文件必须设置 */
            let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            
            /** 设置上传Image图片属性 */
            let body = NSMutableData()
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData(NSString(format:"Content-Disposition: form-data; name=\"uploadfile\"; filename=\"%@\"\r\n",filename).dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData! as! NSData)
            
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            request.HTTPBody = body
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                
                if (error == nil && data?.length > 0) {
                    
                    /** 设置解码方式 */
                    let returnString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    let returnData = returnString?.dataUsingEncoding(NSUTF8StringEncoding)
                    
                    print("returnString----\(returnString)")
                }
            })
        }
    }
    
    func goImagesel()
    {
        let actionSheet = UIActionSheet(title: "图片来源", delegate: self, cancelButtonTitle: "照片", destructiveButtonTitle: "相机")
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex==0)
        {
            goCamera()
        }else
        {
            goImage()
        }
    }
    //打开相机
    func goCamera(){
        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        var sourceType = UIImagePickerControllerSourceType.Camera
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true//设置可编辑
        picker.sourceType = sourceType
        self.presentViewController(picker, animated: true, completion: nil)//进入照相界面
    }
    
    
    //打开相册
    func goImage(){
        let pickerImage = UIImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            pickerImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            pickerImage.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(pickerImage.sourceType)!
        }
        pickerImage.delegate = self
        pickerImage.allowsEditing = true
        self.presentViewController(pickerImage, animated: true, completion: nil)
        
    }
    
    
    //UIImagePicker回调方法
    //    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    //        //获取照片的原图
    //        //let image = (info as NSDictionary).objectForKey(UIImagePickerControllerOriginalImage)
    //        //获得编辑后的图片
    //        let image = (info as NSDictionary).objectForKey(UIImagePickerControllerEditedImage)
    //        //保存图片至沙盒
    //        self.saveImage(image as! UIImage, imageName: iconImageFileName)
    //        let fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(iconImageFileName)
    //        //存储后拿出更新头像
    //        let savedImage = UIImage(contentsOfFile: fullPath)
    //        self.icon.image=savedImage
    //        picker.dismissViewControllerAnimated(true, completion: nil)
    //    }
    
    //选择好照片后choose后执行的方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        //获取照片的原图
        img = info[UIImagePickerControllerEditedImage] as! UIImage
        headface.image=img
        
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! NSString;
        
        
        var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyMMddHHmmss"
        var strNowTime = timeFormatter.stringFromDate(date) as String

        
       var iconImageFileName=userid.stringByAppendingString("_").stringByAppendingString(strNowTime).stringByAppendingString(".jpg")
//        //保存图片至沙盒
//        //self.saveImage(img, newSize: CGSize(width: 256, height: 256), percent: 0.5, imageName: imgname)
        self.saveImage(img, newSize: CGSize(width: 256, height: 256), percent: 0.5,imageName: iconImageFileName)
//        
//        //let fullPath: String = NSHomeDirectory().stringByAppendingString("/").stringByAppendingString("Documents").stringByAppendingString("/").stringByAppendingString(pos).stringByAppendingString(".png")
        fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(iconImageFileName)
//        
        print("imagePickerController fullPath=\(fullPath)")
//        imgarr.append(fullPath);
//        
//        print("pos\(imgarr.count)")
//        
//        
//        
//        if(mCurrent<5)
//        {
//            mCurrent=mCurrent+1;
//            let addbtn:UIButton = arr[mCurrent] as UIButton;
//            addbtn.setTitle("添加", forState:UIControlState.Normal)
//            addbtn.enabled=true
//            addbtn.setImage(UIImage(named:"ic_add_picture"), forState:UIControlState.Normal)
//            
//        }
//        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    //MARK: - 保存图片至沙盒
    func saveImage(currentImage:UIImage,newSize: CGSize, percent: CGFloat,imageName:String){
        
        UIGraphicsBeginImageContext(newSize)
        currentImage.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imageData: NSData = UIImageJPEGRepresentation(newImage, percent)!
        
        
        //var imageData = NSData()
        //imageData = UIImageJPEGRepresentation(currentImage, 0.5)!
        // 获取沙盒目录
        fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(imageName)
        print("saveImage fullPath=\(fullPath)")

        // 将图片写入文件
        imageData.writeToFile(fullPath, atomically: false)
    }
    
    //    func saveImage(currentImage: UIImage, newSize: CGSize, percent: CGFloat, imageName: String){
    //                 //压缩图片尺寸
    //                 UIGraphicsBeginImageContext(newSize)
    //                  currentImage.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    //                 let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    //                 UIGraphicsEndImageContext()
    //                  //高保真压缩图片质量
    //                  //UIImageJPEGRepresentation此方法可将图片压缩，但是图片质量基本不变，第二个参数即图片质量参数。
    //                 let imageData: NSData = UIImageJPEGRepresentation(newImage, percent)!
    //                  // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
    //                  //应用程序目录的路径
    //                  let fullPath: String = NSHomeDirectory().stringByAppendingString("/").stringByAppendingString(imageName)
    //                 // 将图片写入文件
    //                 imageData.writeToFile(fullPath, atomically: false)
    //              }
    
    
    //cancel后执行的方法
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        //println("cancel--------->>")
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    
}
