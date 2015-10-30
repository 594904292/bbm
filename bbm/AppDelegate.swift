//
//  AppDelegate.swift
//  bbm
//
//  Created by ericsong on 15/9/24.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mapManager: BMKMapManager?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        
        mapManager = BMKMapManager() // 初始化 BMKMapManager
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = mapManager?.start("uaiX1ZQ8vdbRQp6tRUBgL5Me", generalDelegate: nil)  // 注意此时 ret 为 Bool? 类型
        if !ret! {  // 如果 ret 为 false，先在后面！强制拆包，再在前面！取反
            NSLog("manager start failed!") // 这里推荐使用 NSLog，当然你使用 println 也是可以的
        }
        
        print("\(NSHomeDirectory())")
        
        let str:NSString = UIDevice.currentDevice().systemVersion
        let version:Float = str.floatValue
        if version >= 8.0 {
            //UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound |..UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
            
            //public convenience init(forTypes types: UIUserNotificationType, categories: Set<UIUserNotificationCategory>?)
           
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil))

            
            
            UIApplication.sharedApplication().registerForRemoteNotifications()
        } else {
            //UIApplication.sharedApplication().registerForRemoteNotificationTypes( UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound |UIRemoteNotificationType.Alert)
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let token:String = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        print("token==\(token)")
        
        let defaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject(token, forKey: "token");
        defaults.synchronize();

        //将token发送到服务器
    }


    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        let alert:UIAlertView = UIAlertView(title: "", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    
    //代理成员变量
    var apnsdelegate:ApnsDelegate?
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("userInfo==\(userInfo)")
        //调用代理函数，改变Label值
        self.apnsdelegate?.NewMessage("newmess")
    }
    

  

}



protocol ApnsDelegate:NSObjectProtocol{
    //回调方法
    func NewMessage(string:String)
}

