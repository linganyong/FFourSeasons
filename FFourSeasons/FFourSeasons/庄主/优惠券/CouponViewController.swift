//
//  CouponViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

protocol CouponViewControllerDelegate {
    func couponViewController(selectItem:CouponDetail)->Void
}

var CouponViewControllerNeedLoad = true
class CouponViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var rightBarItem:UIBarButtonItem!
    var delegate:CouponViewControllerDelegate?
    var dataScoure = Array<CouponDetail>()
    var selectItem:CouponDetail?
    var isOrderNeed = false
    var orderItemIds:String?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "优惠券"
        setTableView()
        navigationItemBack(title: "      ")
        setBackgroundColor()
    }
    
    @objc func rightBarAction() -> Void {
        if isOrderNeed {
              self.navigationController?.popViewController(animated: true)
            delegate?.couponViewController(selectItem: selectItem!)
            
        }else{
            let vc = Bundle.main.loadNibNamed("GetNewCouponViewController", owner: nil, options: nil)?.first as! GetNewCouponViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setTableView() -> Void {
        let height = UIScreen.main.bounds.size.width * CGFloat(249/1077.0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = height
        tableView.separatorColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "CouponTableViewCell", bundle: nil), forCellReuseIdentifier: "CouponTableViewCell")
        weak var weakSelf = self
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock:{
             weakSelf?.loadList(orderIds: weakSelf?.orderItemIds)
        })
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataScoure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponTableViewCell", for: indexPath) as! CouponTableViewCell
        cell.selectionStyle = .none
        cell.isCanSelect = isOrderNeed
        cell.setItem(item: dataScoure[indexPath.row])
        return cell
        
    }
    
    //MARK:加载我的优惠券
    func loadList(orderIds:String?) -> Void{
        if isOrderNeed{
            orderItemIds = orderIds
            loadaddOrderCouponList(itemIds: orderItemIds!)
        }else{
            loadCouponList()
        }
    }
    
    //MARK:加载我的优惠券
    func loadCouponList() -> Void {
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_couponList, parameters: ["token":Model_user_information.getToken()], progress: nil){  [weak self](object, isError) in
            if !isError{
                if let model = Model_api_couponList.yy_model(withJSON: object as Any) {
                    if LGYAFNetworking.isNetWorkSuccess(str: model.code){
                        if let weakSelf = self,let array = model.data{
                            weakSelf.dataScoure = array;
                            weakSelf.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    //MARK:加载下单优惠券
    func loadaddOrderCouponList(itemIds:String) -> Void {
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_addOrderCouponList, parameters: ["token":Model_user_information.getToken(),"itemIds":itemIds], progress: nil){  [weak self](object, isError) in
            if !isError{
                if let model = Model_api_couponList.yy_model(withJSON: object as Any) {
                    if LGYAFNetworking.isNetWorkSuccess(str: model.code){
                        if let weakSelf = self,let array = model.data{
                            weakSelf.dataScoure = array;
                            weakSelf.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isOrderNeed{
            selectItem = dataScoure[indexPath.row]
             rightBarItem = navigationBarAddRightItem(_imageName: "黑色确定", target: self, action: #selector(rightBarAction))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         setNavigationBarStyle(type:.Default)
        if !isOrderNeed {
            if CouponViewControllerNeedLoad{
                CouponViewControllerNeedLoad = false
                loadCouponList()
            }
            rightBarItem = navigationBarAddRightItem(title: "兑换新券", target: self, action: #selector(rightBarAction),textSize:15)
        }else if selectItem != nil{
            rightBarItem = navigationBarAddRightItem(_imageName: "黑色确定", target: self, action: #selector(rightBarAction))
        }else{
             self.navigationItem.rightBarButtonItems = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         setNavigationBarStyle(type:.Default)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.rightBarButtonItems = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
