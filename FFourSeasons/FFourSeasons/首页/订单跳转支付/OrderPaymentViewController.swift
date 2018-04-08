//
//  OrderPaymentViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit
enum PayType : Int {
    case Alipay = 2
    case WeiXin = 1
    case Point  = 3
}

class OrderPaymentViewController: UIViewController{
    
    let selectedImageName = "选中3x.png"
    let unSelectedImageName = "椭圆3x.png"
    var outTradeNo = ""
    @IBOutlet weak var playSelect1ImageView: UIImageView!
    @IBOutlet weak var playSelect2ImageView: UIImageView!
    @IBOutlet weak var playSelect3ImageView: UIImageView!
    
    //订单字符串
    var orderString : String = ""
    //地址ID
    var addressID : Int = 0
    //留言
    var liuyan : String = ""
    //总价
    var totalPrice : String = ""
    
    //支付类型，默认为积分支付
    var payType : PayType = PayType.Point
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支付"
        self.initPayType()
        setBackgroundColor()
        navigationItemBack(title: nil)
        if addressID != 0{
            addEmptyView(frame: nil)
        }
    }
    
    private func initPayType() {
        payType = PayType.Point
        playSelect3ImageView.image = UIImage.init(named: selectedImageName)
    }

    @IBAction func playSelectAction(_ sender: UIButton) {
        playSelect1ImageView.image = UIImage.init(named: unSelectedImageName)
        playSelect2ImageView.image = UIImage.init(named: unSelectedImageName)
        playSelect3ImageView.image = UIImage.init(named: unSelectedImageName)
        let str = selectedImageName
        switch sender.LGYLabelKey {
        case "1"?:
            payType = PayType.Alipay
            playSelect1ImageView.image = UIImage.init(named: str)
            break
        case "2"?:
            payType = PayType.WeiXin
            playSelect2ImageView.image = UIImage.init(named: str)
            break
        case "3"?:
            payType = PayType.Point
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
        if payType == PayType.Point {
            let view =  LGYAlertViewPayment.show(title: "支付订单 ￥\(totalPrice)")
            view.callBlock = {[weak self](text) ->Void in
                if let weakSelf = self {
                   weakSelf.toPay(outTradeNo: weakSelf.outTradeNo, payPw: text)
                }
            }
        }else if payType == PayType.Alipay {
            toPay(outTradeNo: outTradeNo, payPw: nil)
        }else {
            LGYToastView.show(message: "微信支付暂无开发,请选择其它开发方式")
        }
    }
    
     func getOrderAction() {
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_addOrderPay, parameters: ["token":Model_user_information.getToken(),
             "itemIds":self.orderString,
             "addressId":self.addressID,
             "msg":self.liuyan], progress: nil) { [weak self] (object, isError) in
            if let weakSelf = self {
                if !isError {
                    let model = Model_api_orderPay.yy_model(withJSON: object as Any)
                    if let errMsg = model?.msg {
                        if !(LGYAFNetworking.isNetWorkSuccess(str: model?.code)) {
                            LGYToastView.show(message: errMsg)
                            return
                        }
                    }
                    if let order_no = model?.orderPay.out_trade_no as? String {
                         weakSelf.removeEmptyView()
                        weakSelf.outTradeNo = order_no
                    }
                }
            }
        }
    }
    
    private func toPay(outTradeNo : String,payPw : String? = nil) {
        var parmeter = [
            "token": Model_user_information.getToken(),
            "type" : "\(payType.rawValue)",
            "outTradeNo" : outTradeNo]
        if payPw != nil {
            parmeter["payPw"] = payPw
        }
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_toPay, parameters:parmeter , progress: nil) { [weak self] (object, isError) in
            if let weakSelf = self {
                if !isError {
                    let model = Model_api_pay.yy_model(withJSON: object as Any)
                    if let errMsg = model?.msg {
                        if !(LGYAFNetworking.isNetWorkSuccess(str: model?.code)) {
                            LGYToastView.show(message: errMsg)
                            return
                        }
                    }
                    if let payString = model?.pay {
                        if weakSelf.payType == PayType.Alipay {
                            //支付宝支付
                            AlipaySDK.defaultService().payOrder(payString, fromScheme: "ffourSeasons", callback: { (result) in
                                //这个是H5支付的回调
                                
                            })
                        }else if weakSelf.payType == PayType.WeiXin {
                            //微信支付
                        }else {
                            //积分支付
                        }
                    }
                   
                }
            }
        }
    }
    
    
//   class func removeSelfViewController()->Void {
//        let vController = UIViewController.currentViewController()
//        let arrayVC = NSMutableArray.init(array: (vController?.navigationController?.viewControllers)!)
//        for vc in arrayVC {
//            if (vc as! UIViewController).classForCoder == self.classForCoder  {
//                arrayVC.remove(vc)
//                break;
//            }
//        }
//        self.navigationController?.viewControllers = arrayVC as! [UIViewController];
//    }
    
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
