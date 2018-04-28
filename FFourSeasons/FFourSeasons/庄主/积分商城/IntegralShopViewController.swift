//
//  IntegralShopViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit


class IntegralShopViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,IntegralShopTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "积分商店"
        setTableView()
        setBackgroundColor()
        navigationItemBack(title: "")
    }
    
    func setTableView() -> Void {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = self.view.frame.size.width/4+16
        tableView.separatorColor = UIColor.clear
        tableView.register(UINib.init(nibName: "IntegralShopTableViewCell", bundle: nil), forCellReuseIdentifier: "IntegralShopTableViewCell")
        tableView.lgyDataScoure = Array<String>()
        tableView.lgyPageIndex = 1
        weak var vc = self
        weak var tb = tableView
        loadIntegralShop(tableView: tableView)
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            tb?.lgyPageIndex = 1
            vc?.loadIntegralShop(tableView: tb!)
        })
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            tb?.mj_footer.alpha = 1
            tb?.lgyPageIndex = 1 + (tb?.lgyPageIndex)!
            vc?.loadIntegralShop(tableView: tb!)
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.lgyDataScoure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IntegralShopTableViewCell", for: indexPath) as! IntegralShopTableViewCell
        cell.selectionStyle = .none
        let good = tableView.lgyDataScoure[indexPath.row] as! Goods
        cell.setDataScoure(item: good, delegate: self)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! IntegralShopTableViewCell
        let na = Bundle.main.loadNibNamed("ProductSaleDetailsViewController", owner: nil, options: nil)![0] as! ProductSaleDetailsViewController
        na.addContentProductSaleInformaiton(product:cell.model!, productId: (cell.model?._id)!)
        self.navigationController?.pushViewController(na, animated: true)
    }
    
    func integralShopTableViewCellButtonAction(cell: IntegralShopTableViewCell) {
        
    }
    
   @objc func cellButtonAction(btn:UIButton) -> Void {
        LGYAlertViewSimple.show(title: "您确定要兑换此产品码？", leftStr: "确定", rightStr: "取消").callBlock = {
            (position) in
        
        }
    }
    
    
    //MARK:加载数据
    func loadIntegralShop(tableView:UITableView) ->Void {
        weak var tb = tableView
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_integralShop, parameters: ["pageNumber":String.init(format: "%D", (tb?.lgyPageIndex)!)
            ,"token":Model_user_information.getToken()], progress: nil) { (object, isError) in
                tb?.mj_header?.endRefreshing()
                tb?.mj_footer?.endRefreshing()
                tb?.mj_footer.alpha = 0
                if !isError {
                    if isError{
                        return
                    }
                    let model = Model_api_integralShop.yy_model(withJSON: object as Any)
                    if model?.goodsList != nil {
                        if model?.goodsList.list != nil {
                            if tb?.lgyPageIndex == 1{
                                tb?.lgyDataScoure.removeAll();
                            }
                            for item in (model?.goodsList.list)!{
                                tb?.lgyDataScoure.append(item)
                            }
                        }
                    }
                    tb?.reloadData();
                   
                }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBarStyle(type:.White)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarStyle(type:.White)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
