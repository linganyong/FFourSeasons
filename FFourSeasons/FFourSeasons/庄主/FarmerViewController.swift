//
//  FarmerViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class FarmerViewController: UIViewController {

    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var vipNumberLabel: UILabel!
    @IBOutlet weak var menuBackView: UIView!
    
    @IBOutlet weak var line1BackView: UIView!
    @IBOutlet weak var line2BackView: UIView!
    @IBOutlet weak var line3BackView: UIView!
    @IBOutlet weak var line4BackView: UIView!
    @IBOutlet weak var line5BackView: UIView!
    @IBOutlet weak var line6BackView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItemBack(title: "    ")
         viewLayerShadow()
        setBackgroundColor()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationCenter(notification:)), name: NSNotification.Name(rawValue: PersonViewControllerLoadDataScoure), object: nil)
        setText()
    }
    
    @objc func notificationCenter(notification:Notification)->Void{
        let flag = notification.object as! Bool
        if flag{
                setText()
        }
    }
    
    
    func viewLayerShadow() -> Void {
        LGYTool.viewLayerShadow(view: menuBackView)
        LGYTool.viewLayerShadow(view: line1BackView)
        LGYTool.viewLayerShadow(view: line2BackView)
        LGYTool.viewLayerShadow(view: line3BackView)
        LGYTool.viewLayerShadow(view: line4BackView)
        LGYTool.viewLayerShadow(view: line5BackView)
        LGYTool.viewLayerShadow(view: line6BackView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK:会员特权说明
    @IBAction func MemberPrivilegesDetailAction(_ sender: Any) {
        let vc = MemberPrivilegesDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:充值
    @IBAction func RechargeAction(_ sender: UIButton) {
        let vc = Bundle.main.loadNibNamed("RechargeViewController", owner: nil, options: nil)?.first as! RechargeViewController
        self.navigationController?.pushViewController(vc, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    @IBAction func menuAction(_ sender: UIButton) {
        //私人客服
        if (sender.LGYLabelKey?.elementsEqual("1"))!{
            //自动打开拨号页面并自动拨打电话
            let urlString = "tel://020-3807-8100"
            if let url = URL(string: urlString) {
                //根据iOS系统版本，分别处理
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        //支付码
        if (sender.LGYLabelKey?.elementsEqual("2"))!{
            let vc = Bundle.main.loadNibNamed("PaymentCodeViewController", owner: nil, options: nil)?.first as! PaymentCodeViewController
            self.navigationController?.pushViewController(vc, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        }
        //周边农场
        if (sender.LGYLabelKey?.elementsEqual("3"))!{
            let vc = Bundle.main.loadNibNamed("SurroundingFarmsViewController", owner: nil, options: nil)?.first as! SurroundingFarmsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        }
        
    }
    
    //MARK:线型菜单响应
    @IBAction func lineMenuAction(_ sender: UIButton) {
        switch sender.LGYLabelKey {
        case "1"?: //签到赢积分
            let vc = Bundle.main.loadNibNamed("SignAddIntegralViewController", owner: nil, options: nil)?.first as! SignAddIntegralViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "2"?://积分商店
            let vc = Bundle.main.loadNibNamed("IntegralShopViewController", owner: nil, options: nil)?.first as! IntegralShopViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        case "3"?: //优惠券
            let vc = Bundle.main.loadNibNamed("CouponViewController", owner: nil, options: nil)?.first as! CouponViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "4"?: //每日尝鲜
            _ = LGYAlertViewSimple.show(title: "功能即将上线！", buttonStr: "确定")
            return
//            let vc = Bundle.main.loadNibNamed("EverydayFreshViewController", owner: nil, options: nil)?.first as! EverydayFreshViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//            break
        case "5"?: //生日特权
            let vc = WebViewController()
            vc.loadDataRichTextType(type: .PerksBirth)
            vc.title = "生日特权"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "6"?: //更多特权即将上线
            return
        default:
            break
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    func  setText(){
        let dateForm = DateFormatter()
        dateForm.dateFormat = "yyyy-MM-dd"
        let dateStr = dateForm.string(from: Date.init())
        if let model = PersonViewController.infornation{
            var integal = 1000
            var netVip = "普通会员"
            switch model.grade {
            case 0:
                netVip  =  "黄金会员"
                vipNumberLabel.text = "普通会员"
                integal = 1000
                break
            case 1:
                 netVip  = "铂金会员"
                vipNumberLabel.text = "黄金会员"
                 integal = 2500
                break
            case 2:
                 netVip  = "砖石会员"
                vipNumberLabel.text = "铂金会员"
                 integal = 5000
                break
            case 3:
                 netVip  = "顶级会员"
                vipNumberLabel.text = "砖石会员"
                integal = 12600
                break
            case 4:
                vipNumberLabel.text = "顶级会员"
                break
            default:
                break
            }
            dateLabel.text = "\(dateStr) \(model.integral)点 "
            desLabel.text = "(再获取\(integal - model.integral)点积分升级\(netVip))"
        }else{
            vipNumberLabel.text = "会员"
            dateLabel.text = "\(dateStr) 0点"
            desLabel.text = "(再获取\(0)点积分升级会员)"
        }
    }
    
}
