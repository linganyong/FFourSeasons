//
//  Lin+ UITabBarViewController.swift
//  HuaXiaYiKeIosApp
//
//  Created by LGY  on 2018/1/6.
//  Copyright © 2018年 . All rights reserved.
//

import Foundation
import UIKit
class LinTabBarController: UITabBarController,UITabBarControllerDelegate {
    
    //设置横线
    var lineWidht:CGFloat?
    let lineView = UIView()
    //MARK:设置tabBar
    class func initWidthAppDelegate(appDelegate:AppDelegate) -> Void {
        let tab = LinTabBarController()
        
//        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
//        appDelegate.window?.rootViewController = Bundle.main.loadNibNamed("VipLaunchViewController", owner: nil, options: nil)?.first! as? UIViewController
////        appDelegate.window?.rootViewController = MyHarvestViewController()
//        appDelegate.window?.backgroundColor = UIColor.red
//        appDelegate.window?.makeKeyAndVisible()
        
        LinTabBarController.launchScreen(appDelegate: appDelegate,rootViewController:tab)
        //设置childView
        tab.initChildView();
    }
    
    class func launchScreen(appDelegate:AppDelegate,rootViewController:UIViewController) -> Void {
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = rootViewController
        appDelegate.window?.backgroundColor = UIColor.red
        appDelegate.window?.makeKeyAndVisible()
     
        
    }
    
    
    
    //MARK:设置导航栏
    func initChildView(){
        //设置导航栏
        let tabItem1 = tabBarItem(title:"首页",imageName:"首页3x.png",width:17)
        let story = UIStoryboard(name: "Main", bundle:nil)
        let viewController1 = story.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        viewController1.tabBarItem = tabItem1;
        
        let nav1 = UINavigationController(rootViewController: viewController1)
        nav1.LGYViewControllerTag = 0 //用于识别第几个viewController
        nav1.tabBarItem = tabItem1
        
        let tabItem2 =  tabBarItem(title:"商城",imageName:"商城3x.png",width:17)
        let vController2 = Bundle.main.loadNibNamed("MarketViewController", owner: nil, options: nil)?[0] as! UIViewController
        
        let nav2 = UINavigationController(rootViewController: vController2)
        nav2.LGYViewControllerTag = 1
        nav2.tabBarItem = tabItem2
        
        let tabItem3 = tabBarItem(title:"农夫",imageName:"农夫3x.png",width:19)
        let vController3 = Bundle.main.loadNibNamed("FarmerViewController", owner: nil, options: nil)?[0] as! UIViewController
        
        let nav3 = UINavigationController(rootViewController: vController3)
        nav3.LGYViewControllerTag = 2 //用于识别第几个viewController
        nav3.tabBarItem = tabItem3
        
        let tabItem4 = tabBarItem(title:"我的",imageName:"我3x.png",width:17)
        let vController4 = Bundle.main.loadNibNamed("PersonViewController", owner: nil, options: nil)?[0] as! UIViewController
        
        let nav4 = UINavigationController(rootViewController: vController4)
        nav4.LGYViewControllerTag = 3 //用于识别第几个viewController
        nav4.tabBarItem = tabItem4

        self.viewControllers = [nav1,nav2,nav3,nav4]
        self.delegate = self
        
        
        let defaultColor = UIColor.init(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1)
        let selectColor = UIColor.init(red: 24/255.0, green: 201/255.0, blue: 140/255.0, alpha: 1)
        
        lineWidht = UIScreen.main.bounds.size.width/CGFloat((self.viewControllers?.count)!)*CGFloat(2.0/3.0)
        let x = (UIScreen.main.bounds.size.width/CGFloat((self.viewControllers?.count)!) - lineWidht!)/2
        lineView.frame = CGRect(x: x, y: -1, width: lineWidht!, height: 2)
        lineView.backgroundColor = selectColor
        UITabBar.appearance().addSubview(lineView)
        
        //设置navigationbar 压缩图片后出现横线,通过此方法消除横线阴影
        UITabBar.appearance().layer.borderColor = UIColor.clear.cgColor
        UITabBar.appearance().backgroundColor=UIColor.clear
    
        UITabBar.appearance().layer.shadowColor = UIColor.clear.cgColor
//        UITabBar.appearance().backgroundImage=UIImage(named: "toorBar2x.png")?.resizableImage(withCapInsets:  UIEdgeInsets(), resizingMode: .stretch)
        UITabBar.appearance().tintColor = selectColor
        
        let iV = UIImageView.init(frame: CGRect(x: 0, y: -6, width: UIScreen.main.bounds.size.width, height: 60))
        iV.image = UIImage(named: "toorBar2x.png")
       UITabBar.appearance().insertSubview(iV, at: 1)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: defaultColor], for: .normal) //自然状态下的颜色
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectColor], for: .selected) //选择状态下的颜色
        
//UIImage(named: "life-1")?.withRenderingMode(.alwaysOriginal)
//UIImage(named: "life")?.withRenderingMode(.alwaysOriginal)
        
    }
    
    
    func tabBarItem(title:String,imageName:String,width:CGFloat)->UITabBarItem{
        let Image = UIImage(named: imageName)?.reSizeImage(width: width).withRenderingMode(.alwaysOriginal)
        return UITabBarItem(title: title, image:Image, selectedImage:Image)
    }
    
    //点击响应之前监听
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        weak var vc = self
        let width = UIScreen.main.bounds.size.width/CGFloat((tabBarController.viewControllers?.count)!)*CGFloat(viewController.LGYViewControllerTag)
        let x =  width + (UIScreen.main.bounds.size.width/CGFloat((self.viewControllers?.count)!) - lineWidht!)/2
        UIView.animate(withDuration: 0.25) {
             vc?.lineView.frame = CGRect(x:x, y: -1, width: (vc?.lineWidht!)!, height: 2)
        }
        return true;
    }
  
}
