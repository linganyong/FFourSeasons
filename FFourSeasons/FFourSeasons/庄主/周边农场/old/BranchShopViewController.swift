//
//  BranchShopViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class BranchShopViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "周边农场"
        setTableView()
        setBackgroundColor()
    }

    func setTableView() -> Void {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        tableView.separatorColor = UIColor.clear
        tableView.register(UINib.init(nibName: "BranchShopTableViewCell", bundle: nil), forCellReuseIdentifier: "BranchShopTableViewCell")
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BranchShopTableViewCell", for: indexPath) as! BranchShopTableViewCell
       cell.selectionStyle = .none
        
        return cell
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBarStyle(type:.White)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarStyle(type:.White)
  
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         setNavigationBarStyle(type:.Default)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
