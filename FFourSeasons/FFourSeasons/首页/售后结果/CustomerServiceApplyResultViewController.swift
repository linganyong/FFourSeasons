//
//  CustomerServiceApplyResultViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/27.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

enum CustomerServiceApplyResult:Int {
    case Fail = 1
    case Success = 2
}

class CustomerServiceApplyResultViewController: UIViewController,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate {

    var resultType:CustomerServiceApplyResult?
    
    @IBOutlet weak var applyButtonHeightLC: NSLayoutConstraint!
    @IBOutlet weak var labelMaginBottomLC: NSLayoutConstraint!
    @IBOutlet weak var titleTableView: UITableView!
    @IBOutlet weak var productTableView: UITableView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var yunFeiLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var orderDetail:OrderList?
    var productDataScoure = Array<OrderDetails>()
    
    @IBOutlet weak var productTableViewLC: NSLayoutConstraint!
    @IBOutlet weak var titleTableViewLC: NSLayoutConstraint!
    var titleLeftDataScoue = Array<String>()
    var titleRightDataScoue = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setProductTableView()
        setTitleTableView()
        self.title = "申请售后"
        navigationItemBack(title: " ")
        setProductTableView()
        setTitleTableView()
    }
    
    
    func setResultType() ->Void{
        switch resultType {
        case .Success?:
           labelMaginBottomLC.constant = 0
           applyButtonHeightLC.constant = 8
            break
        default:
            
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
    
    
    @IBAction func appleAgainAction(_ sender: UIButton) {
        let vc = Bundle.main.loadNibNamed("CustomerServiceViewController", owner: nil, options: nil)?.first as! CustomerServiceViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setProductTableView() -> Void {
        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.rowHeight = 93
         productTableView.bounces = false
        productTableView.separatorColor = UIColor.clear
        productTableView.register(UINib.init(nibName: "CustomeServiceProductTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomeServiceProductTableViewCell")
    }
    
    func setTitleTableView() -> Void {
        titleTableView.delegate = self
        titleTableView.dataSource = self
        titleTableView.rowHeight = 30
         productTableView.bounces = false
        titleTableView.separatorColor = UIColor.clear
        titleTableView.register(UINib.init(nibName: "CustomeServiceTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomeServiceTitleTableViewCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == productTableView{
            productTableViewLC.constant = CGFloat(productDataScoure.count*93)
            self.view.layoutIfNeeded()
            return  productDataScoure.count
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
