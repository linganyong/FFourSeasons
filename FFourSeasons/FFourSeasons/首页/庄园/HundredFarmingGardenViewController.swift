//
//  HundredFarmingGardenViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/7.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class HundredFarmingGardenViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var menuButtonView: UIView!
    @IBOutlet weak var myHarvestButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var showMessageView: UIView!
    
    
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBAction func menuAction(_ sender: UIButton) {
        _ = LGYAlertViewSimple.show(title: "功能即将上线！", buttonStr: "确定")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMenuButtonView()
        setTableView()
        self.title = "庄园"
        navigationItemBack(title: "    ")
        setBackgroundColor()
        headImageView.layer.masksToBounds = true
    }
    
 
    
    
    //MARK:设置菜单样式
    func setMenuButtonView() -> Void {
        menuButtonView.layer.cornerRadius = 10
        menuButtonView.layer.masksToBounds = true
        LGYTool.viewLayerShadow(view: menuButtonView, color: UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1).cgColor,shadowRadius: 3)
    }

    //MARK:我的收成点击响应
    @IBAction func myHarvestAction(_ sender: Any) {
         _ = LGYAlertViewSimple.show(title: "功能即将上线！", buttonStr: "确定")
    }
    
    //MARK:充值升级点击响应
    @IBAction func rechargeAction(_ sender: UIButton) {
        let vc = Bundle.main.loadNibNamed("RechargeViewController", owner: nil, options: nil)?.first as! RechargeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setTableView() -> Void {
        tableView.delegate = self;
        tableView.dataSource = self
        tableView.rowHeight = self.view.frame.size.width/4+16
        tableView.bounces = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib.init(nibName: "MyHarvestTableViewCell", bundle: nil), forCellReuseIdentifier: "MyHarvestTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyHarvestTableViewCell", for: indexPath) as! MyHarvestTableViewCell
        cell.selectionStyle = .none
        cell.setDataScoure(imageUrl: "https://img13.360buyimg.com/n1/s160x160_jfs/t16288/180/1610373802/424365/94d94a/5a5708bfN8e93b650.jpg", line1Str: "车厘子", line2Str: "配送中", line3Str: String.init(format: "x%d箱", 200))
        return cell
    }
 
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
