//
//  Notice.swift
//  bbm
//
//  Created by songgc on 16/5/23.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import AudioToolbox

class Notice{
    
   
   
    
    func systemSound() {
        //建立的SystemSoundID对象
        var soundID:SystemSoundID = 0
        //获取声音地址
        let path = NSBundle.mainBundle().pathForResource("msg", ofType: "wav")
        //地址转换
        let baseURL = NSURL(fileURLWithPath: path!)
        //赋值
        AudioServicesCreateSystemSoundID(baseURL, &soundID)
        //播放声音
        AudioServicesPlaySystemSound(soundID)
    }
    
    func systemAlert() {
        //建立的SystemSoundID对象
        var soundID:SystemSoundID = 0
        //获取声音地址
        let path = NSBundle.mainBundle().pathForResource("msg", ofType: "wav")
        //地址转换
        let baseURL = NSURL(fileURLWithPath: path!)
        //赋值
        AudioServicesCreateSystemSoundID(baseURL, &soundID)
        //提醒（同上面唯一的一个区别）
        AudioServicesPlayAlertSound(soundID)
    }
    
    
    func systemVibration() {
        //建立的SystemSoundID对象
        var soundID = SystemSoundID(kSystemSoundID_Vibrate)
        //振动
        AudioServicesPlaySystemSound(soundID)
    }
    

}
