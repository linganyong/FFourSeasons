//
//  MyOrderViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/7.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit


let orderAll = "-1" //全部
let orderWaitPay = "0" //未付款
let orderPaySuccess = "2" //付款成功
let orderWaitReceipt = "3" //待收货
let orderWaitEvaluate = "4" //待评价
let orderCustomerService = "5" //售后 加载数据时：同时获取 退款中 退款失败 退款成功
let orderCustomerFail = "6" //售后失败
let orderCustomerSuccess = "7" //售后成功
let orderCancle = "1" //取消订单
let orderComplete = "8" //已完成


class MyOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MyHarvestTableViewCellDelegate{
    let pageView = LGYPageView()
    let titleArray = ["全部","待发货","待收货","待评价","售后"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPageView()
        self.view.backgroundColor = UIColor.init(red: 247/255.0, green: 248/255.0, blue: 249/255.0, alpha: 1)
        self.title = "我的订单"
        navigationItemBack(title: "    ")
        setBackgroundColor()
    }
    
    func setPageView() -> Void {
        pageView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height-64)
        self.view .addSubview(pageView)
        pageView.addContent(titleArray:titleArray , height: 30, isHiddenHeader: false)
        pageView.headerBtnStyle(defaultTextColor: UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1), selectTextColor: UIColor.init(red: 42/255.0, green: 201/255.0, blue: 140/255.0, alpha: 1), headerBtnWidth: self.view.frame.size.width/6, headerLineHeight: 1,textFront: 12)
         pageView.setLineViewWidth(width: 40)
        weak var vc = self
        for i in 0..<titleArray.count{
            let tb = pageView.pageViewtableView(index: i)
            tb?.delegate = self
            tb?.rowHeight = self.view.frame.size.width/4+16
            tb?.dataSource = self
            tb?.backgroundColor = UIColor.clear
            tb?.separatorColor = UIColor.clear
            tb?.showsVerticalScrollIndicator = false
            tb?.register(UINib.init(nibName: "MyHarvestTableViewCell", bundle: nil), forCellReuseIdentifier: "MyHarvestTableViewCell")
            if tb?.lgyDataScoure == nil{
                tb?.lgyDataScoure = Array<String>()
                tb?.lgyPageIndex = 1
                switch i{
                case 0:
                    tb?.lgyTypeKey = orderAll
                    break
//                case 1:
//                    tb?.lgyTypeKey = orderWaitPay //未付款
//                    break
                case 1:
                    tb?.lgyTypeKey = orderPaySuccess //付款成功
                    break
                case 2: //
                    tb?.lgyTypeKey = orderWaitReceipt //待收货
                    break
                case 3: //
                    tb?.lgyTypeKey = orderWaitEvaluate //待评价
                    break
                case 4: //
                    tb?.lgyTypeKey = orderCustomerService //售后
                    break
                case 6: //
                    tb?.lgyTypeKey = orderCancle //取消订单
                    break
                case 7: //
                    tb?.lgyTypeKey = orderComplete //已完成
                    break
                default:
                    break
                }
                vc?.loadDataScoure(tableView: tb!)
                tb?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
                    tb?.lgyPageIndex = 1
                    vc?.loadDataScoure(tableView: tb!)
                })
                tb?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
//                    tb?.mj_footer?.alpha = 1
                    tb?.lgyPageIndex = 1 + (tb?.lgyPageIndex)!
                    vc?.loadDataScoure(tableView: tb!)
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.lgyDataScoure == nil{
            return 0
        }
        return tableView.lgyDataScoure!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyHarvestTableViewCell", for: indexPath) as! MyHarvestTableViewCell
        cell.selectionStyle = .none
        cell.maginLeftLayoutConstraint.constant = self.view.frame.size.width/12-8
        cell.maginTopLayoutConstraint.constant = self.view.frame.size.width/12
        cell.maginBottomLayoutConstraint.constant = 8
        if let item = tableView.lgyDataScoure[indexPath.row] as? OrderList{
            cell.setModelOrder(item: item, delegate: self)
        }
        let str = "\(cell.modelOrder!.pay_status)"
        switch str{
        case orderWaitPay: //未付款
            cell.buttonTitle(leftStr: "支付订单", rightStr: "取消订单")
            break
        case orderCancle: //取消订单
            cell.buttonTitle(leftStr: nil, rightStr: nil)
            break
        case orderPaySuccess: //付款成功
            cell.buttonTitle(leftStr: nil, rightStr: nil)
            break
        case orderWaitReceipt: //待收货
            cell.buttonTitle(leftStr: "申请售后", rightStr: "确定收货")
            break
        case orderWaitEvaluate: //待评价
            cell.buttonTitle(leftStr: "申请售后", rightStr: "评价")
            break
        case orderCustomerService: //售后申请
            cell.buttonTitle(leftStr: nil, rightStr: "取消售后")
            break
        case orderCustomerFail: //售后失败
            cell.buttonTitle(leftStr: nil, rightStr: nil)
            break
        case orderCustomerSuccess: //售后成功
            cell.buttonTitle(leftStr: nil, rightStr: "确定收货")
            break
        case orderComplete:  //已完成
            cell.buttonTitle(leftStr: nil, rightStr: nil)
            break
        default:
            break
        }
        return cell
    }
    
    func myHarvestTableViewCell(cell: MyHarvestTableViewCell, actionKey: String) {
        switch actionKey {
        case "支付订单":
            if let array  = cell.modelOrder?.detail{
                var orderString = ""
                for item in array{
                    if orderString.count == 0{
                        orderString += "\(item.g_id):\(item.count)"
                    }else{
                        orderString += ";\(item.g_id):\(item.count)"
                    }
                }
                if let no = cell.modelOrder?.out_trade_no{
                    let vc = Bundle.main.loadNibNamed("OrderPaymentViewController", owner: nil, options: nil)?.first as! OrderPaymentViewController
                    vc.setOrder(order_no: no, order:cell.modelOrder)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            }
            break
        case "取消订单":
            deleteOrder(cell: cell)
            break
        case "取消售后":
            cancelService(cell: cell)
            break
        case "确定收货":
            comfirmOrder(cell: cell)
            break
        case "申请售后":
            let vc = ApplyCustomerServiceViewController()
            vc.orderDetail = cell.modelOrder
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case "评价":
            let vc = Bundle.main.loadNibNamed("EvaluateViewController", owner: nil, options: nil)?.first as! EvaluateViewController
            if let oId = cell.modelOrder?._id{
                vc.oId = "\(oId)"
            }
            if let list = cell.modelOrder?.detail{
                vc.productLsit = list
            }
            vc.setTableView()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        default:
            break
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MyHarvestTableViewCell
        let vc = Bundle.main.loadNibNamed("OrderDetailsViewController", owner: nil, options: nil)?.first as! OrderDetailsViewController
        if let index =  cell.modelOrder?.pay_status{
            vc.setOrderType(orderType:OrderDetailsType(rawValue: index)!)
        }
        vc.orderDetail = cell.modelOrder
        vc.loadOrderDetails()
        vc.setText()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteOrder(cell:MyHarvestTableViewCell){
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_cancelOrder, parameters: ["oId":"\(cell.modelOrder!._id)","token":Model_user_information.getToken()], progress: nil) { [weak self](object, isError) in
            if !isError{
                let model = Model_user_information.yy_model(withJSON: object as Any)
                if let msg = model?.msg {
                    LGYToastView.show(message: msg)
                }
                if LGYAFNetworking.isNetWorkSuccess(str: model?.code) {
                    if let weakSelf = self{
                        weakSelf.reloadDataScoure()
                    }
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarStyle(type: .Default)
        reloadDataScoure()
    }
    
    
    func comfirmOrder(cell:MyHarvestTableViewCell){
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_confirmOrder, parameters: ["oId":"\(cell.modelOrder!._id)","token":Model_user_information.getToken()], progress: nil) { [weak self](object, isError) in
            if !isError{
                let model = Model_user_information.yy_model(withJSON: object as Any)
                if let msg = model?.msg {
                    LGYToastView.show(message: msg)
                }
                if LGYAFNetworking.isNetWorkSuccess(str: model?.code) {
                    if let weakSelf = self{
                        weakSelf.reloadDataScoure()
                    }
                }
            }
            
        }
    }
    
    //MARK:取消售后
    func cancelService(cell:MyHarvestTableViewCell){
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_cancelService, parameters: ["oId":"\(cell.modelOrder!._id)","token":Model_user_information.getToken()], progress: nil) {[weak self](object, isError) in
            if !isError{
                let model = Model_user_information.yy_model(withJSON: object as Any)
                if let msg = model?.msg {
                    LGYToastView.show(message: msg)
                    if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                        self?.reloadDataScoure()
                    }
                }
            }
            
        }
    }
    
    func reloadDataScoure(){
        for i in 0..<titleArray.count{
            let tb = pageView.pageViewtableView(index: i)
            tb?.lgyPageIndex = 1
            loadDataScoure(tableView: tb!)
        }
    }
    
    func loadDataScoure(tableView:UITableView) -> Void {
        weak var tb = tableView
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_orderList, parameters: ["type":(tb?.lgyTypeKey)!
            ,"pageNumber":String.init(format: "%D", (tb?.lgyPageIndex)!)
            ,"token":Model_user_information.getToken()], progress: nil) { (object, isError) in
                if !isError{
                    let model = Model_api_orderList.yy_model(withJSON: object as Any)
                    if let list =  model?.page?.list {
                        if tb?.lgyPageIndex == 1{
                            tb?.lgyDataScoure.removeAll();
                        }
                        for item in list {
                            tb?.lgyDataScoure.append(item)
                        }
                        tb?.reloadData();
                    }
                }
                
                tb?.mj_header?.endRefreshing()
                tb?.mj_footer?.endRefreshing()
                
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

