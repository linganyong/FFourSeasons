//
//  OrderDetailsViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/27.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

public enum OrderDetailsType:Int {
    case WaitForPayment = 0
    case WaitForSend = 2
    case WaitForEvaluation = 4
    case WaitForHarvest = 3
    case ServiceReturnApply = 5
    case ServiceReturnFail = 6
    case ServiceReturnSuccess = 7
    case TransactionCompletion = 8
}

class OrderDetailsViewController: UIViewController,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var couponTitleLabelHeightLC: NSLayoutConstraint!
    @IBOutlet weak var couponTitleLabel: UILabel!
    @IBOutlet weak var buttonMaginTopLC: NSLayoutConstraint!
    @IBOutlet weak var serviceView: UIView!
    @IBOutlet weak var seviceLabel: UILabel!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button1: UIButton!
    
    var rightBarItem:UIBarButtonItem!
    var orderDetailsType:OrderDetailsType = .WaitForPayment
    
    @IBOutlet weak var titleTableView: UITableView!
    @IBOutlet weak var productTableView: UITableView!
    var productDataScoure = Array<OrderDetails>()
    
    @IBOutlet weak var productTableViewLC: NSLayoutConstraint!
    @IBOutlet weak var titleTableViewLC: NSLayoutConstraint!
    var orderDetail:OrderList?
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var yunFeiLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var titleLeftDataScoue = Array<String>()
    var titleRightDataScoue = Array<String>()
    var headerImageUrl:String? //获取物流头部展示的图片的url
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setProductTableView()
        setTitleTableView()
        self.title = "订单详情"
        navigationItemBack(title: nil)
        setProductTableView()
        setTitleTableView()
        setText()
        
    }
    
    func getImage(button:UIButton){
        let img = UIImageView.init(frame:button.bounds)
        img.image = UIImage(named: "背景3x.png")
        button.insertSubview(img, at: 0)
        button.backgroundColor = UIColor.white
        img.LGyCornerRadius = button.LGyCornerRadius
    }
    
    //MARK:统一设置阴影
    func viewLayerShadowCornerRadius(view:UIView) ->Void{
        //添加阴影
        view.layer.shadowOpacity = 1 //不透明图
        view.layer.shadowColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3) // 设置阴影的偏移量
        view.layer.shadowRadius = CGFloat(3)
        view.clipsToBounds = false //添加此句展示效果
    }
    
    //MARK:设置viewController的类型
    func setOrderType(orderType:OrderDetailsType) -> Void {
        orderDetailsType = orderType
        getImage(button: button1)
        getImage(button: button2)
        getImage(button: button3)
        viewLayerShadowCornerRadius(view: button1)
        viewLayerShadowCornerRadius(view: button2)
        viewLayerShadowCornerRadius(view: button3)
        switch orderType {
            
        case .WaitForSend: //待发货
//            self.title = "待发货"
            button1.isHidden = true
            button2.isHidden = true
            button3.isHidden = true
            buttonMaginTopLC.constant = 16
            serviceView.isHidden = true
            break
        case .WaitForPayment: //待付款
//            self.title = "待付款"
            button1.setTitle("取消订单", for: .normal)
            button2.setTitle("支付订单", for: .normal)
            button3.isHidden = true
            buttonMaginTopLC.constant = 16
            serviceView.isHidden = true
            break
        case .WaitForHarvest: //待收货
            self.title = "待收货"
            button1.setTitle("确定收货", for: .normal)
            button2.setTitle("申请退款", for: .normal)
            button3.setTitle("查看物流", for: .normal)
            buttonMaginTopLC.constant = 16
            serviceView.isHidden = true
            break
        case .WaitForEvaluation: //待评价 4
            button1.setTitle("评价", for: .normal)
            button2.setTitle("申请售后", for: .normal)
            button3.setTitle("查看物流", for: .normal)
            buttonMaginTopLC.constant = 16
            serviceView.isHidden = true
            break
        case .ServiceReturnApply: //申请退货
            button3.isHidden = true
            button2.setTitle("查看物流", for: .normal)
            button1.setTitle("取消售后", for: .normal)
            buttonMaginTopLC.constant = 16
            serviceView.isHidden = true
            break
        case .ServiceReturnFail: //退货失败
            button3.isHidden = true
            seviceLabel.text  = "申请情况：申请售后失败"
            button2.setTitle("申请退款", for: .normal)
            button1.setTitle("确定收货", for: .normal)
            buttonMaginTopLC.constant = 16
            serviceView.isHidden = true
            break
        case .ServiceReturnSuccess: //退货成功
            button3.isHidden = true
            button2.setTitle("查看物流", for: .normal)
            button1.setTitle("确定收货", for: .normal)
            seviceLabel.text  = "申请情况：申请通过，重新发货"
            break
        case .TransactionCompletion: //交易完成
            button3.isHidden = true
            button2.isHidden = true
            button1.isHidden = true
            buttonMaginTopLC.constant = 16
            serviceView.isHidden = true
            break
        }
    }
    
    
    func setText(){
        if orderDetail != nil{
            nameLabel.text = "姓名:\(orderDetail!.receive_name!)"
            telLabel.text = "电话:\(orderDetail!.receive_phone!)"
            addressLabel.text = "地址:\(orderDetail!.receive_address!)"
            yunFeiLabel.text = "￥\(orderDetail!.freight!)"
            priceLabel.text = "￥\(orderDetail!.price!)"
            if let msg = orderDetail?.coupon_msg{
                if msg.count > 0{
                    couponTitleLabel.text = msg;
                    couponTitleLabelHeightLC.constant = 41;
                }else{
                    couponTitleLabel.text = nil;
                    couponTitleLabelHeightLC.constant = 11;
                }
            }
        }else{
            nameLabel.text = ""
            telLabel.text = ""
            addressLabel.text = ""
            yunFeiLabel.text = "￥0"
            priceLabel.text = "￥0"
        }
        
       
        
    }

    //MARK:点击button响应
    @IBAction func buttonAction(_ sender: UIButton) {
        if (sender.titleLabel?.text?.contains("支付"))! {
            if let no = orderDetail?.out_trade_no{
                let vc = Bundle.main.loadNibNamed("OrderPaymentViewController", owner: nil, options: nil)?.first as! OrderPaymentViewController
                vc.setOrder(order_no: no, order: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if (sender.titleLabel?.text?.contains("物流"))! {
            let vc = WuliuViewController()
            vc.number = orderDetail?.logistic
//            print(orderDetail?.logistic_msg)
//            vc.dictionary = jsonToDic(jsonString: orderDetail?.logistic_msg) 
            if let url = headerImageUrl {
                 vc.headerImageUrl = url
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if (sender.titleLabel?.text?.contains("取消订单"))! {
            deleteOrder()
        }
        if (sender.titleLabel?.text?.contains("确定收货"))! {
            comfirmOrder()
        }
        if (sender.titleLabel?.text?.contains("取消售后"))! {
            cancelService()
        }
        if (sender.titleLabel?.text?.contains("申请售后"))! || (sender.titleLabel?.text?.contains("重新申请"))! {
            let vc = ApplyCustomerServiceViewController()
            vc.orderDetail = orderDetail
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if (sender.titleLabel?.text?.contains("评价"))! {
            let vc = Bundle.main.loadNibNamed("EvaluateViewController", owner: nil, options: nil)?.first as! EvaluateViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    /*!
     * @brief 把格式化的JSON格式的字符串转换成字典
     * @param jsonString JSON格式的字符串
     * @return 返回字典
     */
    func jsonToDic(jsonString: String?)->[AnyHashable: Any]? {
    if jsonString == nil {
        return nil
    }
    let jsonData: Data? = jsonString?.data(using: .utf8)
    var dic: [AnyHashable: Any]? = nil
    if let aData = jsonData {
        dic = try! JSONSerialization.jsonObject(with: aData, options: .mutableContainers) as? [AnyHashable: Any]
    }
    return dic
}
    
  
    //MARK:取消订单
    func deleteOrder(){
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_cancelOrder, parameters: ["oId":"\(orderDetail!._id)","token":Model_user_information.getToken()], progress: nil) {[weak self] (object, isError) in
            if !isError{
                let model = Model_user_information.yy_model(withJSON: object as Any)
                if let msg = model?.msg {
                    if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                        self?.popViewController()
                    }
                    LGYToastView.show(message: msg)
                }
            }
        }
    }
    
    //MARK:确定收货
    func comfirmOrder(){
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_confirmOrder, parameters: ["oId":"\(orderDetail!._id)","token":Model_user_information.getToken()], progress: nil) {[weak self](object, isError) in
            if !isError{
                let model = Model_user_information.yy_model(withJSON: object as Any)
                if let msg = model?.msg {
                    LGYToastView.show(message: msg)
                    if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                        self?.loadOrderDetails()
                    }
                }
            }
            
        }
    }
    
    //MARK:取消售后
    func cancelService(){
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_cancelService, parameters: ["oId":"\(orderDetail!._id)","token":Model_user_information.getToken()], progress: nil) {[weak self](object, isError) in
            if !isError{
                let model = Model_user_information.yy_model(withJSON: object as Any)
                if let msg = model?.msg {
                    LGYToastView.show(message: msg)
                    if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                        self?.loadOrderDetails()
                    }
                }
            }
            
        }
    }
    
    
    
    //MARK:申请售后点击响应
    @IBAction func applyServiceAcion(_ sender: UIButton) {
        let vc = Bundle.main.loadNibNamed("CustomerServiceViewController", owner: nil, options: nil)?.first as! CustomerServiceViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setProductTableView() -> Void {
        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.rowHeight = 93
        productTableView.separatorColor = UIColor.clear
        productTableView.bounces = false
        productTableView.register(UINib.init(nibName: "CustomeServiceProductTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomeServiceProductTableViewCell")
    }
    
    func setTitleTableView() -> Void {
        titleTableView.delegate = self
        titleTableView.dataSource = self
        titleTableView.rowHeight = 30
        titleTableView.separatorColor = UIColor.clear
        titleTableView.bounces = false
        titleTableView.register(UINib.init(nibName: "CustomeServiceTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomeServiceTitleTableViewCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == productTableView{
            productTableViewLC.constant = CGFloat(productDataScoure.count*93)
            self.view.layoutIfNeeded()
            return productDataScoure.count
        }else
        if tableView == titleTableView {
            titleRightDataScoue.removeAll()
            titleLeftDataScoue.removeAll()
            if let str = orderDetail?.out_trade_no{
                titleRightDataScoue.append(str)
                titleLeftDataScoue.append("订单号：")
            }
            if let str = orderDetail?.created_time {
                titleRightDataScoue.append(str)
                titleLeftDataScoue.append("创建时间：")
            }
            if let str = orderDetail?.pay_time {
                titleRightDataScoue.append(str)
                titleLeftDataScoue.append("支付时间：")
            }
            if let str = orderDetail?.send_goods_time {
                titleRightDataScoue.append(str)
                titleLeftDataScoue.append("发货时间：")
            }
            //根据最后操作日常来确定需要展示cell个数
            if let str = orderDetail?.return_goods_time {
                titleRightDataScoue.append(str)
                titleLeftDataScoue.append("申请退货时间：：")
            }
            if let str = orderDetail?.get_goods_time {
                titleRightDataScoue.append(str)
                titleLeftDataScoue.append("退款成功时间：")
            }
            titleTableViewLC.constant = CGFloat(30*titleLeftDataScoue.count)
            return titleLeftDataScoue.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == productTableView{
            return productCell(tableView:tableView,indexPath: indexPath)
        }else  {
            return titleCell(tableView:tableView,indexPath: indexPath)
        }
    }
    
    func productCell(tableView: UITableView,indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomeServiceProductTableViewCell", for: indexPath) as! CustomeServiceProductTableViewCell
        cell.selectionStyle = .none
        let model = productDataScoure[indexPath.row]
        //获取物流头部展示的图片的url
        if headerImageUrl == nil{
            headerImageUrl = model.small_icon
        }
        cell.setDataScoure(name: model.title!, priceStr:  "￥\(model.price!)", countStr: "x\( model.count)", imageUrl: model.small_icon)
        return cell
    }
    
    func titleCell(tableView: UITableView,indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomeServiceTitleTableViewCell", for: indexPath) as! CustomeServiceTitleTableViewCell
        cell.selectionStyle = .none
        cell.setDataScoure(leftStr: titleLeftDataScoue[indexPath.row], rightStr: titleRightDataScoue[indexPath.row])
        return cell
    }
    
    func loadOrderDetails() -> Void {
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_orderDetail, parameters: ["token":Model_user_information.getToken(),"oId":"\(orderDetail!._id)"], progress: nil) {[weak self] (object, isError) in
            if !isError{
                let model = Model_api_orderDetail.yy_model(withJSON: object as Any)
                if let list = model?.recordList, let weakSelf = self{
                    weakSelf.setProductDataScoure(list:list)
                }
                if let item = model?.orderPay, let weakSelf = self {
                    weakSelf.setTitleDataScoure(item: item)
                }
            }
        }
    }
    
    func setProductDataScoure(list:Array<OrderDetails>)->Void{
        productDataScoure = list;
        productTableView.reloadData()
    }
    
    func setTitleDataScoure(item:OrderList)->Void{
        orderDetail = item
        titleTableView.reloadData()
        if let index = orderDetail?.pay_status{
            setOrderType(orderType:OrderDetailsType(rawValue: index)!)
        }
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }

    @IBAction func addressAction(_ sender: Any) {
        
    }
    
    //MARK:导航栏右边按钮响应
    @objc func rightBarAction() -> Void {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
}
