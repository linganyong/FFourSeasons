//
//  OrderDetailsViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/27.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

public enum OrderDetailsType:Int {
    case WaitForPayment = 1
    case WaitForReceipt = 2
    case WaitForEvaluation = 3
    case WaitForHarvest = 4
    case TransactionCompletion = 5
    case TransactionCosure = 6
}

class OrderDetailsViewController: UIViewController,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var evaluationView: UIView!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button1: UIButton!
    
    var rightBarItem:UIBarButtonItem!
    var orderDetailsType:OrderDetailsType = .TransactionCosure
    
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
    
    //MARK:设置viewController的类型
    func setOrderType(orderType:OrderDetailsType) -> Void {
        orderDetailsType = orderType
        evaluationView.isHidden = true
        switch orderType {
        case .WaitForHarvest: //待收获  4
//            self.title = "待收获"
            button1.setTitle("确定收获", for: .normal)
            button2.setTitle("申请售后", for: .normal)
            button3.setTitle("查看物流", for: .normal)
            break
        case .WaitForPayment: //待付款
//            self.title = "待付款"
            button1.setTitle("取消订单", for: .normal)
            button2.setTitle("支付订单", for: .normal)
            button3.isHidden = true
            break
        case .WaitForReceipt: //待收货 4
            self.title = "待收货"
            button1.setTitle("付款", for: .normal)
            button2.setTitle("退款", for: .normal)
            button3.isHidden = true
            break
        case .WaitForEvaluation: //待评价 4
//            self.title = "待评价"
            button1.setTitle("评价", for: .normal)
            button2.isHidden = true
            button3.isHidden = true
            break
        case .TransactionCompletion: //交易完成
//            self.title = "交易完成"
            evaluationView.isHidden = false
            break
        case .TransactionCosure: //交易关闭
//            self.title = "交易关闭"
            button1.isHidden = true
            button2.isHidden = true
            button3.isHidden = true
            evaluationView.isHidden = false
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
        }else{
            nameLabel.text = ""
            telLabel.text = ""
            addressLabel.text = ""
            yunFeiLabel.text = "￥0"
            priceLabel.text = "￥0"
        }
        
    }

    
    @IBAction func buttonAction(_ sender: UIButton) {
        if (sender.titleLabel?.text?.contains("支付"))! {
            let vc = Bundle.main.loadNibNamed("OrderPaymentViewController", owner: nil, options: nil)?.first as! OrderPaymentViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if (sender.titleLabel?.text?.contains("售后"))! {
            let vc = Bundle.main.loadNibNamed("CustomerServiceViewController", owner: nil, options: nil)?.first as! CustomerServiceViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if (sender.titleLabel?.text?.contains("评价"))! {
            let vc = Bundle.main.loadNibNamed("EvaluateViewController", owner: nil, options: nil)?.first as! EvaluateViewController
            self.navigationController?.pushViewController(vc, animated: true)
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
        productTableView.register(UINib.init(nibName: "CustomeServiceProductTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomeServiceProductTableViewCell")
    }
    
    func setTitleTableView() -> Void {
        titleTableView.delegate = self
        titleTableView.dataSource = self
        titleTableView.rowHeight = 30
        titleTableView.separatorColor = UIColor.clear
        titleTableView.register(UINib.init(nibName: "CustomeServiceTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomeServiceTitleTableViewCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == productTableView{
            productTableViewLC.constant = CGFloat(productDataScoure.count*93)
            self.view.layoutIfNeeded()
            return productDataScoure.count
        }else
        if tableView == titleTableView {
            titleTableViewLC.constant = 30*6
            return 6
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
        cell.setDataScoure(name: model.title!, priceStr:  "￥\(model.price！)", countStr: "x\( model.count)")
        return cell
    }
    
    func titleCell(tableView: UITableView,indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomeServiceTitleTableViewCell", for: indexPath) as! CustomeServiceTitleTableViewCell
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.setDataScoure(leftStr: "订单号：", rightStr: "12345678901")
            break
        case 2:
             cell.setDataScoure(leftStr: "创建时间：", rightStr: "2018-03-08")
            break
        case 3:
             cell.setDataScoure(leftStr: "支付时间：", rightStr: "2018-03-08")
            break
        case 4:
             cell.setDataScoure(leftStr: "发货时间：", rightStr: "2018-03-08")
            break
        case 5:
             cell.setDataScoure(leftStr: "申请退货时间：", rightStr: "2018-03-08")
            break
        case 6:
             cell.setDataScoure(leftStr: "退款成功时间：", rightStr: "2018-03-08")
            break
        default:
            break
        }
        return cell
    }
    
    func loadOrderDetails() -> Void {
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_orderDetail, parameters: ["token":Model_user_information.getToken(),"oId":"\(orderDetail!._id)"], progress: nil) {[weak self] (object, isError) in
            if !isError{
                let model = Model_api_orderDetail.yy_model(withJSON: object as Any)
                if let list = model?.recordList, let weakSelf = self{
                    weakSelf.setDataScoure(list:list)
                }
            }
        }
    }
    
    func setDataScoure(list:Array<OrderDetails>)->Void{
        productDataScoure = list;
        productTableView.reloadData()
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
