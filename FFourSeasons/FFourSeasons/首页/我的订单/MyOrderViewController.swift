//
//  MyOrderViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/7.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit
import LCRefresh

class MyOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MyHarvestTableViewCellDelegate{
    let pageView = LGYPageView()
    
    
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
        pageView.addContent(titleArray: ["全部","待付款","待发货","待收货","待评价","售后","已取消","已完成"], height: 30, isHiddenHeader: false)
        pageView.headerBtnStyle(defaultTextColor: UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1), selectTextColor: UIColor.init(red: 42/255.0, green: 201/255.0, blue: 140/255.0, alpha: 1), headerBtnWidth: self.view.frame.size.width/6, headerLineHeight: 1,textFront: 12)
         pageView.setLineViewWidth(width: 40)
        weak var vc = self
        for i in 0...7{
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
                    tb?.lgyTypeKey = "-1" //全部
                    break
                case 1:
                    tb?.lgyTypeKey = "0" //未付款
                    break
                case 2:
                    tb?.lgyTypeKey = "2" //付款成功
                    break
                case 3: //
                    tb?.lgyTypeKey = "3" //待收货
                    break
                case 4: //
                    tb?.lgyTypeKey = "4" //待评价
                    break
                case 5: //
                    tb?.lgyTypeKey = "5" //售后
                    break
                case 6: //
                    tb?.lgyTypeKey = "1" //取消订单
                    break
                case 7: //
                    tb?.lgyTypeKey = "6" //已完成
                    break
                default:
                    break
                }
                vc?.loadDataScoure(tableView: tb!)
                tb?.refreshHeader = LCRefreshHeader.init(refreshBlock: {
                    tb?.lgyPageIndex = 1
                    vc?.loadDataScoure(tableView: tb!)
                })
                tb?.refreshFooter = LCRefreshFooter.init(refreshBlock: {
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
        return cell
    }
    
    func myHarvestTableViewCell(cell: MyHarvestTableViewCell, actionKey: String) {
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MyHarvestTableViewCell
            let vc = Bundle.main.loadNibNamed("OrderDetailsViewController", owner: nil, options: nil)?.first as! OrderDetailsViewController
            switch tableView.lgyTypeKey!{
            case "0": //未付款
                vc.setOrderType(orderType:.WaitForPayment)
                break
            case "1": //取消订单
                vc.setOrderType(orderType: .TransactionCosure)
                break
            case "2": //付款成功
                vc.setOrderType(orderType:.WaitForPayment)
                break
            case "3": //待收货
                vc.setOrderType(orderType:.WaitForReceipt)
                break
            case "4": //待评价
                vc.setOrderType(orderType:.WaitForEvaluation)
                break
            case "5": //售后
                let vc = Bundle.main.loadNibNamed("CustomerServiceApplyResultViewController", owner: nil, options: nil)?.first as! CustomerServiceApplyResultViewController
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case "6":  //已完成
                vc.setOrderType(orderType: .TransactionCompletion)
                break
            default:
                break
            }
            vc.orderDetail = cell.modelOrder
            self.navigationController?.pushViewController(vc, animated: true)
       
       
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
                
                if (tb?.isHeaderRefreshing())! {
                    tb?.endHeaderRefreshing()
                }
                if (tb?.isFooterRefreshing())! {
                    tb?.endFooterRefreshing()
                }
                tb?.setDataLoadover()
                tb?.resetDataLoad()
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

