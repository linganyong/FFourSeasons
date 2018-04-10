//
//  AppDelegate.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

let wxApi_id = "wxcf5e70f7ba0877fe" //微信接入 正式

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {

    var cacheNameArray = Array<String>() //防止重发调用缓存
    
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        LBuyly.buglyGo()  //腾讯buyly开启异常收集
        launchScreen() //跟视图
        setNavigationBarStyle() //导航栏设置
        LGYAFNetworking.lgyReachabilityStatus() //网络提示
        AMapServices.shared().apiKey = "32551cbf411055ca9114325c28655c3a" //高德地图 正式
        WXApi.registerApp(wxApi_id)//微信接入 正式
        return true
    }
    
    //MARK:设置跟控制器
     func launchScreen() -> Void {
        if (LGYTool.isFrist(str: "app88Rei9slssldk")){
            let vc = Bundle.main.loadNibNamed("RegisterOrLaunchViewController", owner: nil, options: nil)?.first as! RegisterOrLaunchViewController
            window?.rootViewController = vc
        }else{
            let tb = LinTabBarController()
            tb.initChildView()
            window?.rootViewController = tb
        }
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
    }
    
    //MARK:设置导航栏
    func setNavigationBarStyle() ->Void{
        let bgImage = UIImage(named: "导航矩形3x.png")?.resizableImage(withCapInsets:  UIEdgeInsets(), resizingMode: .stretch)
        UINavigationBar.appearance().setBackgroundImage(bgImage, for: .default)
        //设置navigationbar 压缩图片后出现横线,通过此方法消除横线阴影
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white] //设置title颜色
    }

   
    //MARK:微信、QQ分享，重写方法
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        //支付宝回调
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        //        let result: Bool = UMSocialManager.default.handleOpen(url, options: options)
        //        if !result {
        // 其他如支付等SDK的回调
        if (url.host == "safepay") {
            //跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: {(_ resultDic: [AnyHashable: Any]?) -> Void in
                
                let memo = resultDic?["msg"] as? String
                if ((resultDic?["resultStatus"] as? String) == "9000") {
                   NotificationCenter.default.post(name: Notification.Name.init(NotificationCenterOrderPayment), object: true)
                } else if memo != nil {
                    LGYToastView.show(message: memo!)
                }
                
            })
            
        }
        let result = "\(url.absoluteString)"
        if result.contains(wxApi_id) && result.contains("ret=0"){
            NotificationCenter.default.post(name: Notification.Name.init(NotificationCenterOrderPayment), object: true)
        }
        
        //        }
        //QQ分享
        //[TencentOAuth HandleOpenURL:url];
        //QQApiInterface.handleOpen(url, delegate: self)
        //微信分享
        return WXApi.handleOpen(url, delegate: self)
    }
    
    //MARK:代理方法（QQ、微信一样）
    func on(_ req: BaseReq?) {
        //支付回调
        //支付回调
        if (req?.isKind(of: PayReq.classForCoder()))!{
            
        }
    }
    
    //MARK:代理方法（QQ、微信一样）
    func on(_ resp: BaseResp?) {
        
     
    }

    
    //MARK:判断缓存是否被使用，判断的用时也在使用（判断数组是否存在和添加到数组）
     func isExistCacheNameUse(cacheName:String) -> Bool {
        for item in cacheNameArray{
            if item.elementsEqual(cacheName){
                return true
            }
        }
        cacheNameArray.append(cacheName)
        return false
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
      
            // 其他如支付等SDK的回调
            if (url.host == "safepay") {
                //跳转支付宝钱包进行支付，处理支付结果
                AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: {(_ resultDic: [AnyHashable: Any]?) -> Void in
                    
                    let memo = resultDic?["msg"] as? String
                    if ((resultDic?["resultStatus"] as? String) == "9000") {
                        NotificationCenter.default.post(name: Notification.Name.init(NotificationCenterOrderPayment), object: true)
                    } else if memo != nil {
                        LGYToastView.show(message: memo!)
                    }
                })
            }
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if (url.host == "safepay") {
            //跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: {(_ resultDic: [AnyHashable: Any]?) -> Void in
                
                let memo = resultDic?["msg"] as? String
                if ((resultDic?["resultStatus"] as? String) == "9000") {
                    NotificationCenter.default.post(name: Notification.Name.init(NotificationCenterOrderPayment), object: true)
                } else if memo != nil {
                    LGYToastView.show(message: memo!)
                }
            })
        }
        return true
    }
    
  
    
    

}

