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

let NotificationCenterOrderPayment = "letNotificationCenterOrderPayment"
let IsFirstToPayPoint = "IsFirstToPayPoint"  //用于判断应用是否是第一次

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
        NotificationCenter.default.addObserver(self, selector: #selector(notificationCenter(notification:)), name: NSNotification.Name(rawValue: NotificationCenterOrderPayment), object: nil)
    }
    
    @objc func notificationCenter(notification:Notification) ->Void{
        if let flag = notification.object as? Bool {
            if flag {
                let vc = MyOrderViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                removeSelfViewController()
            }
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
            
            if LGYTool.isFrist(str: IsFirstToPayPoint){
                LGYAlertViewSimple.show(title: "默认支付密码为手机号码后6位", leftStr: "修改密码", rightStr:"我知道啦").callBlock = {(position) in
                    if position == 0 {
                        let vc = Bundle.main.loadNibNamed("ChangePayPassworkViewController", owner: nil, options: nil)?.first as! ChangePayPassworkViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                return
            }
            
            let view =  LGYAlertViewPayment.show(title: "支付订单 ￥\(totalPrice)")
            view.callBlock = {[weak self](text) ->Void in
                if let weakSelf = self {
                   weakSelf.toPay(outTradeNo: weakSelf.outTradeNo, payPw: text)
                }
            }
        }else  {
            toPay(outTradeNo: outTradeNo, payPw: nil)
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
                    if let order_no = model?.orderPay.out_trade_no {
                         weakSelf.removeEmptyView()
                        weakSelf.outTradeNo = order_no
                    }
                }
            }
        }
    }
    
    func setPayType(type:Int){
        if type == 0{
            
        }else{
            
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
                   
                    if weakSelf.payType == PayType.Alipay {
                            //支付宝支付
                        if let payString = model?.pay {
                            AlipaySDK.defaultService().payOrder(payString, fromScheme: "ffourSeasons", callback: { (result) in
                                //这个是H5支付的回调
                                
                            })
                        }
                    }
                    if weakSelf.payType == PayType.WeiXin {
                        //微信支付
                        if (LGYAFNetworking.isNetWorkSuccess(str: model?.code)) {
                            weakSelf.weixinPay(model:model!)
                        }
                    }
                    if weakSelf.payType == PayType.Point{
                        //积分支付
                        if (LGYAFNetworking.isNetWorkSuccess(str: model?.code)) {
                            NotificationCenter.default.post(name: Notification.Name.init(NotificationCenterOrderPayment), object: true)
                        }else{
                            
                        }
                    }
                   
                }
            }
        }
    }
    
    //MARK:微信支付
    func weixinPay(model:Model_api_pay){
        //获取nonceStr随机数
        //        let uuid_ref = CFUUIDCreate(nil)
        //        let uuid_string_ref = CFUUIDCreateString(nil , uuid_ref)
        //        let uuid = uuid_string_ref! as String
        //        let timeStamp = UInt32(Date().timeIntervalSince1970)
        //        let stringA = "appid=wxd930ea5d5a258f4f&nonce_str="+uuid+"&partnerId="+partnerId+"&prepayId="+prepayid+"&timeStamp="+String(format: "%D", timeStamp)
        //        let stringSignTemp = stringA+"&key=192006250b4c09247ec02edce69f6a2d"
        //        let sign = stringSignTemp.md5().uppercased()
        let request = PayReq()
        request.partnerId = model.partnerid //微信支付分配的商户号
        request.prepayId = model.prepayid  //微信返回的支付交易会话ID
        request.package = model.package //默认
        request.nonceStr = model.noncestr
        request.timeStamp =  UInt32.init(model.timestamp)
        request.sign = model.sign
        WXApi.send(request)
    }
    
    func removeSelfViewController()->Void {
        let arrayVC = NSMutableArray.init(array: (self.navigationController?.viewControllers)!)
        for vc in arrayVC {
            if (vc as! UIViewController).classForCoder == OrderPaymentViewController.classForCoder()  {
                arrayVC.remove(vc)
                break;
            }
        }
        for vc in arrayVC {
            if (vc as! UIViewController).classForCoder == PurchaseImmediatelyViewController.classForCoder()  {
                arrayVC.remove(vc)
                break;
            }
        }
        self.navigationController?.viewControllers = arrayVC as! [UIViewController];
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
                NotificationCenter.default.post(name: Notification.Name.init(NotificationCenterOrderPayment), object: true)
                break
            default:
                _ = LGYAlertViewSimple.show(title: "支付失败，"+(resp?.errStr)!, buttonStr: "确定")
                break
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
