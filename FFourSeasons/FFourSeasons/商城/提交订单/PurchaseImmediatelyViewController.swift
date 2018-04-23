//
//  PurchaseImmediatelyViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/27.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

enum CouponType:Int {
    case None = -1;
    case Price = 0;//代扣
//    case Other = 1; //折扣
}

class PurchaseImmediatelyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AddressViewControllerDelegate,CouponViewControllerDelegate,UITextFieldDelegate {
   
    @IBOutlet weak var couponTitleHeightLC: NSLayoutConstraint!
    @IBOutlet weak var couponCountLabel: UILabel!
    @IBOutlet weak var couponTitleLabel: UILabel!
    var dataScoure:Array<CartList>?
    var defaultAddress:Addresses?
    @IBOutlet weak var payMoneyLabel: UILabel!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var totalFreightLabel: UILabel!
    @IBOutlet weak var contactAddressLabel: UILabel!
    @IBOutlet weak var contactPhonelabel: UILabel!
    var selectCouponItem:CouponDetail?
    var orderItemStr:String? //产品规格id和数量格式化
    @IBOutlet weak var liuYanTF: UITextField!
//    @IBOutlet weak var maginTop: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightLC: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var orderString = ""
    var totalPrice = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItemBack(title: "")
        self.title = "提交订单"
        setTableView()
        loadAddressList()
        textField()
        addEmptyView(frame: nil)
        setCoupon(count: "")
    }

    func textField()->Void{
        liuYanTF.delegate = self    }
    
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
        if item.goods_type == 0{
            cell.setDataScoure(name: item.name, priceStr:"￥\(item.price!)", countStr: String.init(format: "x%D", item.count), imageUrl:item.item_url)
            
        }else{
            cell.setDataScoure(name: item.name, priceStr: "\(item.price!) 积分", countStr: String.init(format: "x%D", item.count), imageUrl: item.item_url)
        }
        return cell
    }
    
    //MARK:点击收货联系信息响应
    @IBAction func contactAction(_ sender: Any) {
        let vc = Bundle.main.loadNibNamed("AddressShowViewController", owner: nil, options: nil)?.first as! AddressShowViewController
        vc.delegate = self
        vc.title = "选择收货地址"
        vc.isDefaultSelect = false
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
        
        if dataScoure == nil {
             LGYToastView.show(message: "请先选择商品！")
            return
        }
        
        var liuyan = ""
        if let liuyuanMsg = liuYanTF.text {
            liuyan = liuyuanMsg
        }
        
        let vc = Bundle.main.loadNibNamed("OrderPaymentViewController", owner: nil, options: nil)?.first as! OrderPaymentViewController
        vc.orderString = orderString
        if let addressID = defaultAddress?._id {
           vc.addressID = addressID
        }
        vc.liuyan = liuyan
        vc.totalPrice = totalPrice
        var cId = "0"
        if let _id = selectCouponItem?._id{
            cId = "\(_id)"
        }
        vc.cId = cId
        vc.getOrderAction()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:设置优惠券折扣
    func setCoupon(count:String) -> Void {
        if count.count > 0 && Double(count)! > 0.0{
            couponTitleLabel.text = "已优惠："
            couponTitleHeightLC.constant = 41
            couponCountLabel.text = "￥\(count)"
        }else{
            couponTitleLabel.text = ""
            couponTitleHeightLC.constant = 11
            couponCountLabel.text = ""
        }
        
    }
    @IBAction func selectCouponAction(_ sender: UIButton) {
        let vc = Bundle.main.loadNibNamed("CouponViewController", owner: nil, options: nil)?.first as! CouponViewController
        vc.delegate = self
        vc.isCanSelect = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func couponViewController(selectItem: CouponDetail) {
        selectCouponItem = selectItem
        loadAddOrder(orderStr: orderItemStr!)
    }
    
    func loadAddOrder(orderStr:String){
        orderItemStr = orderStr
        var cId = "0"
        if let _id = selectCouponItem?._id{
            cId = "\(_id)"
        }
        self.orderString = orderStr
        weak var vc = self
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_addOrder
        , parameters: ["token":Model_user_information.getToken()
        ,"cId":cId
        ,"itemIds":orderStr]
        , progress: nil) { (object, isError) in
            let model = Model_api_addOrder.yy_model(withJSON: object)
            vc?.setData(model: model)
        }
    }
    
    //MARK:根据请求数据绘图
    func setData(model:Model_api_addOrder?){
        removeEmptyView()
        if model != nil && LGYAFNetworking.isNetWorkSuccess(str: model?.code){
            let array = model!.list
            dataScoure = array
            tableView.reloadData()
            totalFreightLabel.text =  String.init(format: "￥%@",(model?.totalFreight)!)
            payMoneyLabel.text = String.init(format: "￥%@", (model?.payMoney)!)
            self.totalPrice = model!.payMoney!
            if let str = model?.couponMoney{
                setCoupon(count: str)
            }
            
        }
    }
    

    //MARK:获取地址信息
    func loadAddressList() ->Void {
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_addressList, parameters: ["token":Model_user_information.getToken()], progress: nil) { [weak self] (object, isError) in
            if let weakSelf = self {
                if !isError {
                    let model = Model_api_addressList.yy_model(withJSON: object as Any)
                    if let errMsg = model?.msg {
                        if !(LGYAFNetworking.isNetWorkSuccess(str: model?.code)) {
                            LGYToastView.show(message: errMsg)
                            return
                        }
                    }
                    if let addresses = model?.addresses {
                        for item in addresses {
                            if item.state == 1 {
                                weakSelf.setAddress(item: item)
                            }
                        }
                    }
                    if weakSelf.defaultAddress == nil {
                        weakSelf.setAddress(item: nil)
                    }
                }
            }
        }
    }
    
    private func setAddress(item:Addresses?) -> Void {
        if item != nil {
            defaultAddress = item
            contactNameLabel.text = "收货人：" + defaultAddress!.name
            contactPhonelabel.text = defaultAddress?.phone
            contactAddressLabel.text = "收货地址：" + defaultAddress!.located.replacingOccurrences(of: "/", with: "") + defaultAddress!.address
        }else {
            contactNameLabel.text = "收货人：暂无"
            contactAddressLabel.text = "收货地址：暂无"
            contactPhonelabel.text = "电话：暂无"
        }
        
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
