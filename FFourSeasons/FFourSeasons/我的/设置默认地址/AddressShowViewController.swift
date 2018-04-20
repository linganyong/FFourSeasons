//
//  AddressShowViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/27.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit
class AddressShowViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var rightBarItem:UIBarButtonItem!
    var defaultSelectRow = -1
    var isDefaultSelect = true //是否可以修改默认
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        navigationItemBack(title: "    ")
        rightBarItem = navigationBarAddRightItem(_imageName: "黑色确定", target: self, action: #selector(rightBarAction))
        setBackgroundColor()
        loadAddressList()
    }
    
    func setTableView() -> Void {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.clear
        tableView.register(UINib.init(nibName: "AddressShowTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressShowTableViewCell")
        tableView.lgyDataScoure = Array<Addresses>()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.lgyDataScoure!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressShowTableViewCell", for: indexPath) as! AddressShowTableViewCell
        cell.selectionStyle = .none
        let item = tableView.lgyDataScoure![indexPath.row] as? Addresses
        cell.setModel(item: item)
        
        if defaultSelectRow < 0{
            if item?.state == 1{
                defaultSelectRow = indexPath.row
            }
        }
        if indexPath.row == defaultSelectRow {
            cell.defaultLabel.isHidden = false
        }else{
            cell.defaultLabel.isHidden = true
        }
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isDefaultSelect {
            defaultSelectRow = indexPath.row
            tableView.reloadData()
        }else{
            
        }
    }
    
    //MARK:导航栏右边按钮响应事件
    @objc func rightBarAction() ->Void{
        if defaultSelectRow < 0{
            LGYToastView.show(message: "你还没有选择默认地址！")
            return
        }
        let item = tableView.lgyDataScoure![defaultSelectRow] as! Addresses
        loadAddAdderss(item:item)
    }
    
    //MARK:加载数据
    func loadAddressList() ->Void {
        weak var vc = self
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_addressList, parameters: ["token":Model_user_information.getToken()], progress: nil) { (object, isError) in
            if !isError {
                let model = Model_api_addressList.yy_model(withJSON: object as Any)
                if model == nil || vc == nil || !LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                    LGYToastView.show(message: (model?.msg)!)
                    return
                }
                
                vc?.tableView.lgyDataScoure.removeAll()
                for item in (model?.addresses)!{
                    vc?.tableView.lgyDataScoure?.append(item)
                }
                vc?.tableView.reloadData()
                
            }
        }
    }
    
    //MARK:设置默认地址
    func loadAddAdderss(item:Addresses) ->Void {
        weak var vc = self
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_selectAddress,
                                parameters: ["aId":String.init(format: "%D", item._id)
                                    ,"token":Model_user_information.getToken()]
        , progress: nil) { (object, isError) in
            if !isError {
                let model = Model_user_information.yy_model(withJSON: object as Any)
                if model == nil || vc == nil{
                    return
                }
                if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                    _ = LGYToastView.show(message: (model?.msg)!, timeInterval: 0.5, block: {
                        vc?.navigationController?.popViewController(animated: true)
                    })
                }else{
                    LGYToastView.show(message:(model?.msg)!)
                }
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
        self.navigationItem.rightBarButtonItems = [rightBarItem]
      
    }
    
 
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let bgImage = UIImage(named: "导航矩形3x.png")?.resizableImage(withCapInsets:  UIEdgeInsets(), resizingMode: .stretch)
        setNavigationBarStyle(type:.Default)
        self.navigationItem.rightBarButtonItems = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
