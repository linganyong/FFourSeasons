//
//  WuliuViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/22.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class WuliuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var deslabel: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 247/255.0, green: 248/255.0, blue: 249/255.0, alpha: 1)
        self.title = "物流信息"
        navigationItemBack(title: "    ")
        setTableView()
    }

    func setTableView() -> Void {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.separatorColor = UIColor.clear
        tableView.register(UINib.init(nibName: "IntegralShopTableViewCell", bundle: nil), forCellReuseIdentifier: "IntegralShopTableViewCell")
        tableView.lgyDataScoure = Array<String>()
        loadIntegralShop(tableView: tableView)
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
    
    //MARK:加载数据
    func loadIntegralShop(tableView:UITableView) ->Void {
        weak var tb = tableView
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_integralShop, parameters: ["pageNumber":String.init(format: "%D", (tb?.lgyPageIndex)!)
            ,"token":Model_user_information.getToken()], progress: nil) { (object, isError) in
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
                    tb?.mj_header?.endRefreshing()
                    tb?.mj_footer?.endRefreshing()
                    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
