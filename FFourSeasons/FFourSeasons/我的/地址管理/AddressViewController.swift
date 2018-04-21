//
//  AddressViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/27.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit



class AddressViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AddressTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var showIndexPath:IndexPath?
    var rightBarItem:UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        navigationItemBack(title: "    ")
        self.title = "地址管理"
        rightBarItem = navigationBarAddRightItem(_imageName: "加.png", target: self, action: #selector(rightBarAction))
        setBackgroundColor()
    }

    
    func setTableView() -> Void {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.clear
        tableView.lgyDataScoure = Array<Addresses>()
        tableView.register(UINib.init(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.lgyDataScoure!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        cell.selectionStyle = .none
        let address = tableView.lgyDataScoure[indexPath.row] as! Addresses
        cell.setModel(item: address)
        cell.delegate = self
        cell.indexPath = indexPath
        if showIndexPath != nil && indexPath.row == showIndexPath?.row{
            cell.editShow()
        }else{
             cell.edithidden()
        }
       
        return cell
    }
    
    //MARK:AddressTableViewCellDelegate pro cell点击回调
    func addressTableViewCell(buttonKey: String, cell: AddressTableViewCell, model: Addresses?) {
            if buttonKey.elementsEqual("1"){ //展开
                cellButtonAction(cell: cell,indexPath:cell.indexPath!)
            }
        if buttonKey.elementsEqual("2"){ //编辑
            let vc = Bundle.main.loadNibNamed("AddAddressViewController", owner: nil, options: nil)?.first as! AddAddressViewController
            vc.setAddressInformation(address: cell.model!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if buttonKey.elementsEqual("3"){ //删除
            loadDelAddress(aId: String.init(format: "%D", (cell.model?._id)!))
        }
        
    }
    
    //MARK:点击cell按钮响应展开处理
    func cellButtonAction(cell:AddressTableViewCell,indexPath: IndexPath) ->Void{
        if showIndexPath?.row == indexPath.row{
            self.showIndexPath = nil
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }else {
            let index = showIndexPath
            showIndexPath = indexPath
            if index != nil {
                tableView.reloadRows(at: [indexPath,index!], with: .automatic)
            }else{
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if showIndexPath != nil && indexPath.row == showIndexPath?.row{
            return 88+60
        }
        return 88
    }

    //MARK:导航栏右边按钮响应事件
    @objc func rightBarAction() ->Void{
        weak var selfVC = self
        AddOrSelectDefaultView.show { (index,view) in
            view.removeFromSuperview()
            if index == 1{
                let vc = Bundle.main.loadNibNamed("AddressShowViewController", owner: nil, options: nil)?.first as! AddressShowViewController
                vc.title = "选择默认地址"
                selfVC?.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = Bundle.main.loadNibNamed("AddAddressViewController", owner: nil, options: nil)?.first as! AddAddressViewController
                selfVC?.navigationController?.pushViewController(vc, animated: true)
            }
        }
       
    }
    
    //MARK:加载数据
    func loadAddressList() ->Void {
        weak var vc = self
        self.showIndexPath = nil
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
    
    //MARK:删除数据
    func loadDelAddress(aId:String) ->Void {
        weak var vc = self
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_delAddress, parameters: ["aId":aId,"token":Model_user_information.getToken()], progress: nil) { (object, isError) in
            if !isError {
                let model = Model_api_addressList.yy_model(withJSON: object as Any)
                if model == nil || vc == nil{
                    return
                }
                LGYToastView.show(message:(model?.msg)!)
                if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                    vc?.loadAddressList()
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
        loadAddressList()
    }
    
 
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
