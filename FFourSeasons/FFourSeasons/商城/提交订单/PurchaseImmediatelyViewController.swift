//
//  PurchaseImmediatelyViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/27.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class PurchaseImmediatelyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AddressViewControllerDelegate,UITextFieldDelegate {
   

   
    var dataScoure:Array<CartList>?
    var defaultAddress:Addresses?
    @IBOutlet weak var payMoneyLabel: UILabel!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var totalFreightLabel: UILabel!
    @IBOutlet weak var contactAddressLabel: UILabel!
    @IBOutlet weak var contactPhonelabel: UILabel!
    @IBOutlet weak var playSelect1ImageView: UIImageView!
    @IBOutlet weak var playSelect2ImageView: UIImageView!
    @IBOutlet weak var playSelect3ImageView: UIImageView!
    @IBOutlet weak var playSelect4ImageView: UIImageView!
    @IBOutlet weak var playSelect5ImageView: UIImageView!
    @IBOutlet weak var liuYanTF: UITextField!
    @IBOutlet weak var faPiaoTF: UITextField!
//    @IBOutlet weak var maginTop: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightLC: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItemBack(title: "")
        self.title = "提交订单"
        setTableView()
        loadAddressList()
        addEmptyView(frame: nil)
        textField()
    }

    func textField()->Void{
        faPiaoTF.delegate = self
        liuYanTF.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 93
        tableView.separatorColor = UIColor.clear
        tableView.register(UINib.init(nibName: "PurchaseImmediatelyTableViewCell", bundle: nil), forCellReuseIdentifier: "PurchaseImmediatelyTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataScoure == nil{
           return 0
        }
         tableViewHeightLC.constant = CGFloat(93 * dataScoure!.count)
        return dataScoure!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseImmediatelyTableViewCell", for: indexPath) as! PurchaseImmediatelyTableViewCell
        cell.selectionStyle = .none
        let item = dataScoure![indexPath.row]
        cell.setDataScoure(name: item.name, priceStr: String.init(format: "￥%D", item.price), countStr: String.init(format: "%D", item.count))
        return cell
    }
    
    //MARK:点击收货联系信息响应
    @IBAction func contactAction(_ sender: Any) {
        let vc = Bundle.main.loadNibNamed("AddressViewController", owner: nil, options: nil)?.first as! AddressViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:AddressViewControllerDelegate pro 地址管理选择地址回调
    func addressViewController(address: Addresses) {
        setAddress(item: address)
    }
    
    //MARK:提交订单
    @IBAction func submitOrderAction(_ sender: UIButton) {
        if defaultAddress == nil || defaultAddress?._id == nil{
            LGYToastView.show(message: "请填写收货联系信息！")
            return
        }
        let vc = Bundle.main.loadNibNamed("OrderPaymentViewController", owner: nil, options: nil)?.first as! OrderPaymentViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadAddOrder(orderStr:String){
        weak var vc = self
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_addOrder, parameters: ["token":Model_user_information.getToken(),"itemIds":orderStr], progress: nil) { (object, isError) in
            let model = Model_api_addOrder.yy_model(withJSON: object)
            vc?.setData(model: model)
        }
    }
    
    //MARK:根据请求数据绘图
    func setData(model:Model_api_addOrder?){
        if model != nil && LGYAFNetworking.isNetWorkSuccess(str: model?.code){
            let array = model!.list
            dataScoure = array
            tableView.reloadData()
            totalFreightLabel.text =  String.init(format: "￥%@",(model?.totalFreight)!)
            payMoneyLabel.text = String.init(format: "￥%@", (model?.payMoney)!)
        }
    }
    
    
    //MARK:设置支付方式
    @IBAction func playSelectAction(_ sender: UIButton) {
        playSelect1ImageView.image = UIImage.init(named: "椭圆3x.png")
        playSelect2ImageView.image = UIImage.init(named: "椭圆3x.png")
        playSelect3ImageView.image = UIImage.init(named: "椭圆3x.png")
        playSelect4ImageView.image = UIImage.init(named: "椭圆3x.png")
        playSelect5ImageView.image = UIImage.init(named: "椭圆3x.png")
        let str = "选中3x.png"
        switch sender.LGYLabelKey {
        case "1"?:
            playSelect1ImageView.image = UIImage.init(named: str)
            break
        case "2"?:
            playSelect2ImageView.image = UIImage.init(named: str)
            break
        case "3"?:
            playSelect3ImageView.image = UIImage.init(named: str)
            break
        case "4"?:
            playSelect4ImageView.image = UIImage.init(named: str)
            break
        case "5"?:
            playSelect5ImageView.image = UIImage.init(named: str)
            break
        default:
            break
        }
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
                for item in (model?.addresses)!{
                    let address = item as Addresses
                    if address.state == 1{
                        vc?.setAddress(item: address)
                    }
                }
            }
        }
    }
    
    private func setAddress(item:Addresses) -> Void {
        defaultAddress = item
        removeEmptyView()
        contactNameLabel.text = "收货人：" + defaultAddress!.name
        contactPhonelabel.text = defaultAddress?.phone
        contactAddressLabel.text = "地址：" + defaultAddress!.located.replacingOccurrences(of: "/", with: "") + defaultAddress!.address
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarStyle(type: .Default)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
