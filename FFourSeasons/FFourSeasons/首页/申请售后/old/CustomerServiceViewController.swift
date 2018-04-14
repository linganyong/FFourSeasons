//
//  CustomerServiceViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/27.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class CustomerServiceViewController: UIViewController,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var refundButton: UIButton!
    @IBOutlet weak var onlyRefundMoneyButton: UIButton!
    var rightBarItem:UIBarButtonItem!
    @IBOutlet weak var titleTableView: UITableView!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var prictureCollectionView: UICollectionView!
    @IBOutlet weak var describleTextView: UITextView!
    @IBOutlet weak var describleLabel: UILabel!
    @IBOutlet weak var descibleBackView: UIView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var yunFeiLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var orderDetail:OrderList?
    var productDataScoure = Array<OrderDetails>()
    @IBOutlet weak var productTableViewLC: NSLayoutConstraint!
    @IBOutlet weak var titleTableViewLC: NSLayoutConstraint!
    var selectType = 0 //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
        setProductTableView()
        setTitleTableView()
        self.title = "申请售后"
        navigationItemBack(title: "    ")
        rightBarItem = navigationBarAddRightItem(_imageName: "打勾白色.png", target: self, action: #selector(rightBarAction))
        setProductTableView()
        setTitleTableView()
       notificationCenterKeyboard()
        buttonSelectStyle(button:onlyRefundMoneyButton)
        buttonSelectStyle(button:refundButton)
    }
    
    func setText(){
        if orderDetail != nil{
            nameLabel.text = "姓名:\(orderDetail!.receive_name!)"
            telLabel.text = "电话:\(orderDetail!.receive_phone!)"
            addressLabel.text = "地址:\(orderDetail!.receive_address!)"
            yunFeiLabel.text = "￥\(orderDetail!.freight!)"
            priceLabel.text = "￥\(orderDetail!.price!)"
        }else{
            nameLabel.text = ""
            telLabel.text = ""
            addressLabel.text = ""
            yunFeiLabel.text = "￥0"
            priceLabel.text = "￥0"
        }
        
    }
    
    func setProductTableView() -> Void {
        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.rowHeight = 93
         productTableView.bounces = false
        productTableView.separatorColor = UIColor.clear
        productTableView.register(UINib.init(nibName: "CustomeServiceProductTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomeServiceProductTableViewCell")
    }
    
    @IBAction func onlyRefundAction(_ sender: Any) {
        buttonSelectStyle(button:onlyRefundMoneyButton)
        buttonSelectStyle(button:refundButton)
    }
    
    @IBAction func refundAction(_ sender: Any) {
        buttonSelectStyle(button:refundButton)
        buttonSelectStyle(button:onlyRefundMoneyButton)
    }
    
    func buttonSelectStyle(button:UIButton){
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 0/255.0, green: 216/255.0, blue: 135/255.0, alpha: 1)
        LGYTool.viewLayerShadow(view: button)
    }
    func buttonDefaultStyle(button:UIButton){
        button.setTitleColor(UIColor.init(red: 52/255.0, green: 52/255.0, blue: 52/255.0, alpha: 1), for: .normal)
        button.backgroundColor = UIColor.white
        LGYTool.viewLayerShadow(view: button)
    }
    
    func setTitleTableView() -> Void {
        titleTableView.delegate = self
        titleTableView.dataSource = self
        titleTableView.rowHeight = 30
         productTableView.bounces = false
        titleTableView.separatorColor = UIColor.clear
        titleTableView.register(UINib.init(nibName: "CustomeServiceTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomeServiceTitleTableViewCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == productTableView{
            productTableViewLC.constant = CGFloat(productDataScoure.count*93)
            self.view.layoutIfNeeded()
            return  productDataScoure.count
        }else
            if tableView == titleTableView {
                var count = 0
                //根据最后操作日常来确定需要展示cell个数
                if orderDetail?.return_goods_time != nil{
                    count = 6
                }else if orderDetail?.get_goods_time != nil{
                    count = 5
                }else if orderDetail?.send_goods_time != nil{
                    count = 4
                }else if orderDetail?.pay_time != nil{
                    count = 3
                }else if orderDetail?.created_time != nil{
                    count = 2
                }else if orderDetail?.out_trade_no != nil{
                    count = 1
                }
                titleTableViewLC.constant = CGFloat(30*count)
                return count
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
        let model = productDataScoure[indexPath.row]
        cell.setDataScoure(name: model.title!, priceStr:  "￥\(model.price!)", countStr: "x\( model.count)", imageUrl: model.small_icon)
        
        return cell
    }
    
    func titleCell(tableView: UITableView,indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomeServiceTitleTableViewCell", for: indexPath) as! CustomeServiceTitleTableViewCell
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.setDataScoure(leftStr: "订单号：", rightStr:(orderDetail?.out_trade_no)!)
            break
        case 1:
            cell.setDataScoure(leftStr: "创建时间：", rightStr:(orderDetail?.created_time)!)
            break
        case 2:
            cell.setDataScoure(leftStr: "支付时间：", rightStr:(orderDetail?.pay_time)!)
            break
        case 3:
            cell.setDataScoure(leftStr: "发货时间：", rightStr: (orderDetail?.send_goods_time)!)
            break
        case 4:
            cell.setDataScoure(leftStr: "收货时间：", rightStr: (orderDetail?.get_goods_time)!)
            break
        case 5:
            cell.setDataScoure(leftStr: "申请退货时间：", rightStr: (orderDetail?.return_goods_time)!)
            break
        case 6:
            cell.setDataScoure(leftStr: "退款成功时间：", rightStr: "")
            break
        default:
            break
        }
        return cell
    }
    
    func setTextView() -> Void {
        LGYTool.viewLayerShadow(view: descibleBackView)
         let tap = UITapGestureRecognizer.init(target: self, action: #selector(registerKeyBoard))
        self.view.addGestureRecognizer(tap)
        describleTextView.delegate = self
    }
    
    @objc func registerKeyBoard() ->Void{
        describleTextView.resignFirstResponder()
        if describleTextView.text == nil || describleTextView.text.count == 0{
            describleLabel.text = " 请输入退货原因"
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        describleLabel.text = ""
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == nil || textView.text.count == 0{
            describleLabel.text = " 请输入退货原因"
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }

    @IBAction func addressAction(_ sender: Any) {
        
    }
    
    //MARK:导航栏右边按钮响应
    @objc func rightBarAction() -> Void {
        if describleTextView.text == nil || describleTextView.text.count == 0{
            LGYToastView.show(message: "请输入退货原因")
            return
        }
        loadCustomerService()
    }
    
    func loadCustomerService(){
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_customerService, parameters: ["token":Model_user_information.getToken()
            ,"oId":"\(orderDetail!._id)"
            ,"content":describleTextView.text!
            ,"imgs":""], progress: nil, cacheName: nil) { (object, isError) in
            if !isError {
                let model = Model_user_information.yy_model(withJSON: object as Any)
                if let msg = model?.msg{
                    LGYToastView.show(message: msg)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.rightBarButtonItems = [rightBarItem]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItems = [rightBarItem]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.rightBarButtonItems = nil
    }
    
    //MARK:监听键盘弹出和消失
    func notificationCenterKeyboard() ->Void{
        //监听键盘弹出通知
        NotificationCenter.default
            .addObserver(self,selector: #selector(keyboardWillShow(note:)),
                         name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //监听键盘隐藏通知
        NotificationCenter.default
            .addObserver(self,selector: #selector(keyboardWillHide(notification:)),
                         name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK:键盘弹出监听，回调
    @objc func keyboardWillShow(note : Notification) -> Void{
        DispatchQueue.main.async { () -> Void in
            //防止输入框被键盘覆盖
                let userInfo = note.userInfo
                let KeyboardFrameEndUserInfoKey = (userInfo?["UIKeyboardFrameEndUserInfoKey"] as AnyObject).cgRectValue
            let focusFrame = self.describleTextView.convert(self.describleTextView.frame, to: self.view)
            let marginBottom = UIScreen.main.bounds.size.height - focusFrame.size.height - focusFrame.origin.y - 5
                let margin = marginBottom - (KeyboardFrameEndUserInfoKey?.size.height)!
                if margin < 0 {
                    self.viewAnimations(-margin)
                }
            }
    }
    
    //MARK:数字键盘，键盘隐藏
    @objc func keyboardWillHide(notification: Notification) {
        //隐藏“完成”按钮
        viewAnimations(0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
