//
//  LBuyly.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/2.
//  Copyright © 2018年 LGY. All rights reserved.
//

import UIKit
import Bugly

//TODO 这里需要修改
let BuylyID = "b1af0e5b01"

//重写异常收集方法，方便后期修改第三方类库
class LBuyly: Bugly {
    
    //MARK:启用腾讯的Bugly进行异常收集
    class func buglyGo() -> Void {
        Bugly.start(withAppId: BuylyID) // 腾讯请求的Bugly应用id
        Bugly.setUserIdentifier(LGYTool.uuidGet()) // 设置当前应用
        let infoDictionary = Bundle.main.infoDictionary  //获取当前应用信息
        Bugly.updateAppVersion((infoDictionary!["CFBundleVersion"])! as! String)
        Bugly.setUserValue((infoDictionary!["CFBundleShortVersionString"])! as! String, forKey: "CFBundleShortVersionString")  //app版本
        Bugly.setUserValue(UIDevice.current.systemVersion, forKey: "systemVersion") //添加系统版本信息
        Bugly.setUserValue(UIDevice.current.systemName, forKey: "systemName") //添加设备名称
        Bugly.setUserValue(UIDevice.current.model, forKey: "model") //手机型号
    }

    //MARK:手动上传异常
    class func lBuglyNSException(exception:NSException) ->Void{
        NSLog("%@", exception.reason as! String)
        Bugly.report(exception)
    }
    
    //MARK:手动上传异常
    class func lBuglyError(error:Error) ->Void{
        NSLog("%@", error.localizedDescription)
        Bugly.reportError(error)
    }
    
}
