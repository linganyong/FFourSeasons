//
//  CouponViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class CouponViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

     var rightBarItem:UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "优惠券"
        setTableView()
        navigationItemBack(title: "      ")
        rightBarItem = navigationBarAddRightItem(title: "兑换新券", target: self, action: #selector(rightBarAction))
        setBackgroundColor()
    }
    
    @objc func rightBarAction() -> Void {
        let vc = Bundle.main.loadNibNamed("GetNewCouponViewController", owner: nil, options: nil)?.first as! GetNewCouponViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setTableView() -> Void {
        let height = UIScreen.main.bounds.size.width * CGFloat(249/1077.0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = height
        tableView.separatorColor = UIColor.clear
        tableView.register(UINib.init(nibName: "CouponTableViewCell", bundle: nil), forCellReuseIdentifier: "CouponTableViewCell")
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponTableViewCell", for: indexPath) as! CouponTableViewCell
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         setNavigationBarStyle(type:.Default)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         setNavigationBarStyle(type:.Default)
        self.navigationItem.rightBarButtonItems = [rightBarItem]
        
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
