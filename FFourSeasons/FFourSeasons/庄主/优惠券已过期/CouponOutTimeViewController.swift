//
//  CouponViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit


class CouponOutTimeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var rightBarItem:UIBarButtonItem!
    var dataScoure = Array<CouponDetail>()
    var selectItem:CouponDetail?

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "过期优惠券"
        setTableView()
        navigationItemBack(title: "      ")
        setBackgroundColor()
        loadCouponList()
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
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock:{
             weakSelf?.loadCouponList()
        })
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataScoure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponTableViewCell", for: indexPath) as! CouponTableViewCell
        cell.selectionStyle = .none
        cell.isCanSelect = false
        cell.setItem(item: dataScoure[indexPath.row])
        return cell
        
    }
    
    //MARK:加载过期的优惠券
    func loadCouponList() -> Void {
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_overdueCouponList, parameters: ["token":Model_user_information.getToken()], progress: nil){  [weak self](object, isError) in
            if let tb = self?.tableView {
                tb.mj_header.endRefreshing()
            }
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
    
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         setNavigationBarStyle(type:.Default)
       
    }
    
    //MARK:查看过期优惠券
    @IBAction func lookOutTimeCouponAction(_ sender: UIButton) {
        
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
