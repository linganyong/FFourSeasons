//
//  CustomerServiceApplyResultViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/27.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

enum CustomerServiceApplyResult:Int {
    case Fail = 1
    case Success = 2
}

class CustomerServiceApplyResultViewController: UIViewController,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate {

     var rightBarItem:UIBarButtonItem!
    var resultType:CustomerServiceApplyResult?
    
    @IBOutlet weak var applyButtonHeightLC: NSLayoutConstraint!
    @IBOutlet weak var labelMaginBottomLC: NSLayoutConstraint!
    @IBOutlet weak var titleTableView: UITableView!
    @IBOutlet weak var productTableView: UITableView!
    
    @IBOutlet weak var productTableViewLC: NSLayoutConstraint!
    @IBOutlet weak var titleTableViewLC: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setProductTableView()
        setTitleTableView()
        self.title = "申请售后"
        navigationItemBack(title: " ")
       
        setProductTableView()
        setTitleTableView()
        setResultType()
//        setBackgroundColor()
    }
    
    
    func setResultType() ->Void{
        switch resultType {
        case .Success?:
           labelMaginBottomLC.constant = 0
           applyButtonHeightLC.constant = 8
            break
        default:
            
            break
        }
    }
   
    @IBAction func appleAgainAction(_ sender: UIButton) {
        let vc = Bundle.main.loadNibNamed("CustomerServiceViewController", owner: nil, options: nil)?.first as! CustomerServiceViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setProductTableView() -> Void {
        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.rowHeight = 93
        productTableView.separatorColor = UIColor.clear
        productTableView.register(UINib.init(nibName: "CustomeServiceProductTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomeServiceProductTableViewCell")
    }
    
    func setTitleTableView() -> Void {
        titleTableView.delegate = self
        titleTableView.dataSource = self
        titleTableView.rowHeight = 30
        titleTableView.separatorColor = UIColor.clear
        titleTableView.register(UINib.init(nibName: "CustomeServiceTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomeServiceTitleTableViewCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == productTableView{
            productTableViewLC.constant = 3*93
            self.view.layoutIfNeeded()
            return 3
        }else
        if tableView == titleTableView {
            titleTableViewLC.constant = 30*6
            return 6
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == productTableView{
            return productCell(tableView:tableView,indexPath: indexPath)
        }else  {
            return titleCell(tableView:tableView,indexPath: indexPath)
        }
    }
    
    func productCell(tableView: UITableView,indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomeServiceProductTableViewCell", for: indexPath) as! CustomeServiceProductTableViewCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    func titleCell(tableView: UITableView,indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomeServiceTitleTableViewCell", for: indexPath) as! CustomeServiceTitleTableViewCell
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.setDataScoure(leftStr: "订单号：", rightStr: "12345678901")
            break
        case 2:
             cell.setDataScoure(leftStr: "创建时间：", rightStr: "2018-03-08")
            break
        case 3:
             cell.setDataScoure(leftStr: "支付时间：", rightStr: "2018-03-08")
            break
        case 4:
             cell.setDataScoure(leftStr: "发货时间：", rightStr: "2018-03-08")
            break
        case 5:
             cell.setDataScoure(leftStr: "申请退货时间：", rightStr: "2018-03-08")
            break
        case 6:
             cell.setDataScoure(leftStr: "退款成功时间：", rightStr: "2018-03-08")
            break
        default:
            break
        }
        return cell
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }

    @IBAction func addressAction(_ sender: Any) {
        
    }
    
    //MARK:导航栏右边按钮响应
    @objc func rightBarAction() -> Void {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
}
