//
//  MainPageMenuView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/8.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class MainPageMenuView: UIView {
    weak var viewController:UIViewController?
    
    class func mainPageMenuView(viewController:UIViewController) -> MainPageMenuView {
        let view = Bundle.main.loadNibNamed("MainPageMenuView", owner: nil, options: nil)?.first as! MainPageMenuView
        view.viewController = viewController
        return view
    }
    
    //MARK:庄园响应
    @IBAction func menuAction1(_ sender: Any) {
        let vc = Bundle.main.loadNibNamed("HundredFarmingGardenViewController", owner: nil, options: nil)?.first as! HundredFarmingGardenViewController
        viewController?.navigationController?.pushViewController(vc, animated: true)
         viewController?.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:积分支付响应
    @IBAction func menuAction2(_ sender: Any) {
        _ = LGYAlertViewSimple.show(title: "功能即将上线！", buttonStr: "确定")
    }
    
    //MARK:周边农场
    @IBAction func menuAction3(_ sender: Any) {
        let vc = Bundle.main.loadNibNamed("SurroundingFarmsViewController", owner: nil, options: nil)?.first as! SurroundingFarmsViewController
        viewController?.navigationController?.pushViewController(vc, animated: true)
        viewController?.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:我的订单响应
    @IBAction func menuAction4(_ sender: Any) {
        let vc = MyOrderViewController()
        viewController?.navigationController?.pushViewController(vc, animated: true)
        viewController?.tabBarController?.tabBar.isHidden = true
    }
    
}
