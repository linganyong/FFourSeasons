//
//  OrderPaymentViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class OrderPaymentViewController: UIViewController{
    
    @IBOutlet weak var playSelect1ImageView: UIImageView!
    @IBOutlet weak var playSelect2ImageView: UIImageView!
    @IBOutlet weak var playSelect3ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支付"
        setBackgroundColor()
        navigationItemBack(title: nil)
    }
    
    
    
    
    @IBAction func playSelectAction(_ sender: UIButton) {
        playSelect1ImageView.image = UIImage.init(named: "椭圆3x.png")
        playSelect2ImageView.image = UIImage.init(named: "椭圆3x.png")
        playSelect3ImageView.image = UIImage.init(named: "椭圆3x.png")
        let str = "选中3x.png"
        switch sender.LGYLabelKey {
        case "1"?:
            playSelect1ImageView.image = UIImage.init(named: str)
            break
        case "2"?:
            playSelect2ImageView.image = UIImage.init(named: str)
            break
        case "3"?:
            playSelect3ImageView.image = UIImage.init(named: str)
            break
        default:
            break
        }
    }
    
//    //MARK:生成支付订单
//    func loadCreatePayOrder() -> Void {
//        weak var vc = self
//        var orderStr = ""
//        for item in dataScoure! {
//            if orderStr.count == 0{
//                orderStr = String.init(format: "%D:%D", item.item_id,item.count)
//            }else{
//                orderStr += String.init(format: ";%D:%D", item.item_id,item.count)
//            }
//        }
//        LGYAFNetworking.lgyPost(urlString: APIAddress.api_addOrderPay, parameters: ["token":Model_user_information.getToken()
//            ,"itemIds":orderStr
//            ,"addressId":String.init(format: "%D", (defaultAddress?._id)!)], progress: nil) { (object, isError) in
//                let model = Model_user_information.yy_model(withJSON: object)
//                if model != nil && LGYAFNetworking.isNetWorkSuccess(str: model?.code){
//                    vc?.addOrderTrue()
//                }
//        }
//    }
    
    @IBAction func paymentAction(_ sender: UIButton) {
        let view =  LGYAlertViewPayment.show(title: "支付订单 ￥128.00")
        view.callBlock = {(text) ->Void in
            self.alertView(_title: "add", _message: text, _bText: "00")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
