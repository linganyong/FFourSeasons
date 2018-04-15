//
//  ShopCarViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/2.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class ShopCarViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ShopCarTableViewCellDelegate {
    
    var timer:Timer?
    var productAllCount = 0
    var productAllPrice = Float(0.0)
    var timerCount = 60
    var rightBarItem:UIBarButtonItem!
    var selectIndex = -1
    var rowHeight = UIScreen.main.bounds.size.width/4+16
    var selectRowHeight:CGFloat =  CGFloat(120)
    var animationHeight = CGFloat(0)
    var selectProductDictionary = NSMutableDictionary(capacity: 100) //存放被选中的商品
    var dataScoure = NSMutableArray()
    var delegateArray = Array<IndexPath>()
    var isEdit = false
    
    @IBOutlet weak var payViewBottomLC: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var productCountLabel: UILabel!
    let emptyBackgroundView = LGYEmptyBackgroundView.loadViewFromNib(message: "空空的购物车，赶快去挑一件吧")
    @IBOutlet weak var productPriceLabel: UILabel!
    var firstSelect:[Int:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购物车"
        setTableView()
        setBackgroundColor()
        navigationItemBack(title: "")
        rightBarItem = navigationBarAddRightItem(_imageName: "加.png", target: self, action: #selector(rightBarAction))
        loadDataScoure()
        
    }
    
    //MARK:导航栏右边按钮响应事件
    @objc func rightBarAction() ->Void{
        isEdit = !isEdit
        if isEdit{
            rightBarItem.image = UIImage(named: "打勾.png")
        }else{
            rightBarItem.image = UIImage(named: "加.png")
        }
        tableView.reloadData()
    }
    
    func setTableView() -> Void {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = rowHeight
        tableView.separatorColor = UIColor.clear
        tableView.register(UINib.init(nibName: "ShopCarTableViewCell", bundle: nil), forCellReuseIdentifier: "ShopCarTableViewCell")
        animationHeight = rowHeight/CGFloat(timerCount)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyView()
        return dataScoure.count
    }
    
    func emptyView() {
        if dataScoure.count == delegateArray.count || dataScoure.count == 0{
            payViewBottomLC.constant = 97
            self.navigationItem.rightBarButtonItems = nil
            self.view.layoutIfNeeded()
        }else{
            payViewBottomLC.constant = 0
            self.navigationItem.rightBarButtonItems = [rightBarItem]
            self.view.layoutIfNeeded()
        }
        emptyBackgroundView.addToSuperview(view: tableView, frame: nil, dataScoureCount: dataScoure.count-delegateArray.count)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isDelegate(indexPath: indexPath){
            return 0
        }else{
            return rowHeight
        }
    }
    
    //MARK:判断是否已经添加到删除项
    func isDelegate(indexPath: IndexPath) -> Bool {
        var flag = false
        for iP:IndexPath in delegateArray{
            if iP.row == indexPath.row {
                flag = true
            }
        }
        return flag
    }
    
    //MARK:判断是否已经添加到选择购买项
    func isSelectedPurchase(indexPath: IndexPath) -> Bool {
        var flag = false
        let str = selectProductDictionary.value(forKey: String(format: "%d,%d", arguments: [indexPath.section,indexPath.row])) as? String
        if str != nil && (str?.elementsEqual("true"))!{
            flag = true
        }
        return flag
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarStyle(type: .White)
        self.navigationItem.rightBarButtonItems = [rightBarItem]
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.rightBarButtonItems = nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCarTableViewCell", for: indexPath) as! ShopCarTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.viewController = self
        let flag = isSelectedPurchase(indexPath: indexPath)
        let cartList =  dataScoure[indexPath.row] as! CartList
        cell.setDataScoure(tableView: tableView, buttonTag: indexPath.row,item:cartList, imageSelected: flag, cellIndexPath: indexPath, isEdit: isEdit)
        //判断是否已经添加到删除项
        if isDelegate(indexPath: indexPath) {
            cell.isHidden = true
            
        }else{
            cell.isHidden = false
        }
        if firstSelect[indexPath.row] == nil {
            cell.tapIsSelect()
            firstSelect[indexPath.row] = "STR"
        }
        
        return cell
    }
    
    @IBAction func addOrderAction(_ sender: UIButton) {
        loadAddOrder()
    }
    //MARK:添加订单
    func loadAddOrder() -> Void {
        var orderStr = ""
        var productArray = Array<CartList>()
        //拼接订单信息
        let array = selectProductDictionary.allKeys
        for item in array {
            let str = selectProductDictionary.value(forKey: item as! String) as? String
            if str != nil && (str?.elementsEqual("true"))!{
                let keyIndexPaht = (item as! String).split(separator: ",")
                let keyInt = Int(String.init(format: "%@", keyIndexPaht[1] as CVarArg))
                let product = dataScoure[keyInt!] as! CartList
                productArray.append(product)
                if orderStr.count < 3{
                    orderStr = String.init(format: "%D:%D", product.item_id,product.count)
                }else{
                    orderStr += String.init(format: ";%D:%D", product.item_id,product.count)
                }
            }
        }
        if orderStr.count < 3 {
           LGYToastView.show(message: "请选择产品！")
            return
        }
        
        goToPurcaseImmendiately(array:productArray,orderStr:orderStr)
    }
    
    func goToPurcaseImmendiately(array:Array<CartList>,orderStr:String) -> Void {
        let vc = PurchaseImmediatelyViewController()
        vc.loadAddOrder(orderStr: orderStr)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //MARK:ShopCarTableViewCellDelegate 代理，点击删除按钮响应
    func shopCarTableViewCellTapDeleteAction(cell: ShopCarTableViewCell, indexPath: IndexPath, isSelect: Bool) {
        weak var cl = cell
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_delCart, parameters: ["itemId":String.init(format: "%D", (cell.model?.item_id)!),"token":Model_user_information.getToken()], progress: nil, responseBlock: { (object, isError) in
            if !isError {
                let model = Model_user_information.yy_model(withJSON: object as Any)
                if model == nil || cl == nil{
                    return
                }
                if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                    cl?.animation()
                }
                LGYToastView.show(message: (model?.msg)!)
            }
        })
        
    }
    
    //MARK:ShopCarTableViewCellDelegate 代理，判断是否选择商品cell的回调
    func shopCarTableViewCell(cell: ShopCarTableViewCell, indexPath: IndexPath, isSelect: Bool) {
        let flag = isSelectedPurchase(indexPath: indexPath)
        let count = Int(cell.countTextField.text!)!
        var str = cell.priceLabel.text!
        str.remove(at: str.characters.index(of:"￥")!)
        let price = Float(str)!
        if isSelect{
            if !flag{
                productAllCount = productAllCount + count
                productAllPrice = productAllPrice + Float(count) * price
            }
            selectProductDictionary.setValue("true", forKey: String(format: "%d,%d", arguments: [indexPath.section,indexPath.row]))
        }else{
            if flag{
                selectProductDictionary.removeObject(forKey: String(format: "%d,%d", arguments: [indexPath.section,indexPath.row]))
                productAllCount = productAllCount - count
                productAllPrice = productAllPrice - Float(count) * price
                
            }
        }
        productCountLabel.text = String(format: "合计(%d个物品)", arguments: [productAllCount])
        productPriceLabel.text = String(format:  "￥%.2lf", productAllPrice)
    }
    
    //MARK:ShopCarTableViewCellDelegate 代理，判断是否选择商品cell的回调
    func shopCarTableViewCell(newCount: Int, oldCount: Int, price: Float, ndexPath: IndexPath, isSelect: Bool) {
        if isSelect{
            productAllCount  = productAllCount - oldCount + newCount
            productAllPrice = productAllPrice + Float(newCount - oldCount) * price
            productCountLabel.text = String(format: "合计(%d个物品)", arguments: [productAllCount])
            productPriceLabel.text = String(format:  "￥%.2lf", productAllPrice)
        }
    }
    
    
    func animationDidStop(cell: ShopCarTableViewCell) {
       
    }
    
    func animationShouldStart(cell: ShopCarTableViewCell) {
        tableView.beginUpdates()
        cell.isHidden = true
        delegateArray.append(cell.indexPath)
        tableView.endUpdates()
        
    }
    
    //MARK:加载数据
    func loadDataScoure() -> Void {
        weak var tb = tableView
        weak var vc = self
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_cartList, parameters: ["token":Model_user_information.getToken()], progress: nil, responseBlock: { (object, isError) in
            if !isError {
                let model = Model_api_cartList.yy_model(withJSON: object as Any)
                if model == nil || vc == nil{
                    return
                }
                vc?.dataScoure.removeAllObjects()
                vc?.dataScoure.addObjects(from: (model?.cartList)!)
                tb?.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
