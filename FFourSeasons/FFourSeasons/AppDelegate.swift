//
//  AppDelegate.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit


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
        WXApi.registerApp("wxcf5e70f7ba0877fe")//微信接入 正式
        
        
        return true
    }
    
    //MARK:设置跟控制器
     func launchScreen() -> Void {
        if (LGYTool.isFrist(str: "appReislssldk")){
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
        //QQ分享
        //[TencentOAuth HandleOpenURL:url];
        //QQApiInterface.handleOpen(url, delegate: self)
        //微信分享
        return WXApi.handleOpen(url, delegate: self)
    }
    
    //MARK:代理方法（QQ、微信一样）
    func on(_ req: BaseReq?) {
        
    }
    
    //MARK:代理方法（QQ、微信一样）
    func on(_ resp: BaseResp?) {
        //支付回调
        if (resp?.isKind(of: PayResp.classForCoder()))!{
            switch resp?.errCode{
            case 0?:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                _ = LGYToastView.show(message: "支付成功", timeInterval: 2, block: {

                })
                break
            default:
                _ = LGYAlertViewSimple.show(title: "支付失败，"+(resp?.errStr)!, buttonStr: "确定")
                break
            }
        }
    }

    //MARK:微信分享调用入口
    class func weixinShareAction(title:String?,description:String?,imageName:String?,pageUrlStr:String?) {
        let message = WXMediaMessage()
        if title != nil {
            message.title = title
        }
        if description != nil {
            message.description = description!
        }
        if imageName != nil{
            message.setThumbImage(UIImage(named: imageName!))
        }
        let webPageObject = WXWebpageObject()
        if pageUrlStr != nil {
            webPageObject.webpageUrl = pageUrlStr
        }
        message.mediaObject = webPageObject
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue)
        WXApi.send(req)
    }
    
    //MARK:微信支付
    func weixinPay(partnerId:String,prepayid:String){
        //获取nonceStr随机数
        let uuid_ref = CFUUIDCreate(nil)
        let uuid_string_ref = CFUUIDCreateString(nil , uuid_ref)
        let uuid = uuid_string_ref! as String
        let timeStamp = UInt32(Date().timeIntervalSince1970)
        let stringA = "appid=wxd930ea5d5a258f4f&nonce_str="+uuid+"&partnerId="+partnerId+"&prepayId="+prepayid+"&timeStamp="+String(format: "%D", timeStamp)
        let stringSignTemp = stringA+"&key=192006250b4c09247ec02edce69f6a2d"
        let sign = stringSignTemp.md5().uppercased()
        let request = PayReq()
        request.partnerId = partnerId //微信支付分配的商户号
        request.prepayId = prepayid  //微信返回的支付交易会话ID
        request.package = "Sign=WXPay" //默认
        request.nonceStr = uuid
        request.timeStamp = timeStamp
        request.sign = sign
        WXApi.send(request)
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

}

