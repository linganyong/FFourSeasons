//
//  MyOrderViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/7.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit
import LCRefresh

class MyOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
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
        pageView.addContent(titleArray: ["全部","待付款","待发货","待收货","待评价","售后"], height: 30, isHiddenHeader: false)
        pageView.headerBtnStyle(defaultTextColor: UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1), selectTextColor: UIColor.init(red: 42/255.0, green: 201/255.0, blue: 140/255.0, alpha: 1), headerBtnWidth: self.view.frame.size.width/6, headerLineHeight: 1,textFront: 12)
         pageView.setLineViewWidth(width: 40)
        weak var vc = self
        for i in 0...5{
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
                tb?.lgyTypeKey = "1"
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
        cell.setDataScoure(imageUrl: "https://img13.360buyimg.com/n1/s160x160_jfs/t16288/180/1610373802/424365/94d94a/5a5708bfN8e93b650.jpg", line1Str: "车厘子", line2Str: "配送中", line3Str: String.init(format: "x%d箱", 200))
//        cell.set
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case 2005: //售后
            let vc = Bundle.main.loadNibNamed("CustomerServiceApplyResultViewController", owner: nil, options: nil)?.first as! CustomerServiceApplyResultViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            let vc = Bundle.main.loadNibNamed("OrderDetailsViewController", owner: nil, options: nil)?.first as! OrderDetailsViewController
            switch tableView.tag{
            case 2000: //全部
                break
                vc.setOrderType(orderType: .TransactionCompletion)
            case 2001: //待付款
                vc.setOrderType(orderType:.WaitForPayment)
                break
            case 2002: //待发货
                vc.setOrderType(orderType:.WaitForPayment)
                break
            case 2003: //待收货
                vc.setOrderType(orderType:.WaitForReceipt)
                break
            case 2004: //待评价
                vc.setOrderType(orderType:.WaitForEvaluation)
                break
            default:
                break
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
       
    }
    
    
    func loadDataScoure(tableView:UITableView) -> Void {
        weak var tb = tableView
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_orderList, parameters: ["type":(tb?.lgyTypeKey)!
            ,"pageNumber":String.init(format: "%D", (tb?.lgyPageIndex)!)
            ,"token":Model_user_information.getToken()], progress: nil) { (object, isError) in
                if isError{
                    return
                }
                let model = Model_api_findGoodsByCateId.yy_model(withJSON: object as Any)
                if model?.cateList != nil {
                    if tb?.lgyPageIndex == 1{
                        tb?.lgyDataScoure.removeAll();
                    }
                    for item in (model?.goodsList.list)!{
                        tb?.lgyDataScoure.append(item)
                        
                    }
                    tb?.reloadData();
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

