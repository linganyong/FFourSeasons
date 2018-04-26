//
//  MarketViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit


class MarketViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MarkProductTableViewCellDelegate{
    var rightBarItem:UIBarButtonItem!
    var titleDataScoure = Array<String>()
    var imageDataScoure = Array<String>()
    var cateListItem = Array<CateList>() //分类
   
    var collectionViewHeight = CGFloat(0.0)
     let searchView = UIView()
    let searchAhpdView = UIView()
    @IBOutlet weak var shopCarButton: UIButton!
    @IBOutlet weak var pageView: LGYMarkPageView!
    private var allClassView:AllClassView?
     let searchTextField = UITextField()
    
    var listItem = Array<Goods>() //产品
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayout()
        navigationItemBack(title: "    ")
        navigationBarAddSearchTextField()
         rightBarItem = navigationBarAddRightItem(_imageName: "白色搜索", target: self, action: #selector(rightBarAction))
        self.title = "人人商城"
        setBackgroundColor()
        LGYTool.viewLayerShadowAll(view: shopCarButton)
        loadDataScoure()
    }
    
//    //MARK:判断是否需要登录
//    func needLaunch() -> Void {
//        if Model_user_information.getToken().count > 0{
//            loadDataScoure()
//        }else{
//            NotificationCenter.default.addObserver(self, selector: #selector(notificationCenter(notification:)), name: NSNotification.Name(rawValue: NotificationCenterLaunch), object: nil)
//        }
//    }
    
//    @objc func notificationCenter(notification:Notification)->Void{
//        let flag = notification.object as! Bool
//        if flag{
//            loadDataScoure()
//        }
//    }
    
    
    //MARK:导航栏添加搜索
    func navigationBarAddSearchTextField() -> Void {
        searchAhpdView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        searchView.frame =  CGRect(x:self.view.frame.size.width - 80, y: 9, width: 0, height: 26)
       
        searchView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { (make) in
            make.left.equalTo(searchView.snp.left).offset(8)
            make.width.equalTo(searchView.snp.width).offset(-16)
            make.top.equalTo(searchView.snp.top).offset(2)
            make.height.equalTo(searchView.snp.height).offset(-4)
        }
        searchTextField.delegate = self
        searchTextField.backgroundColor = UIColor.clear
        searchTextField.placeholder = "输入产品查询"
        
        searchTextField.font = UIFont.systemFont(ofSize: 12)
        searchView.tag = 1000
        searchView.layer.cornerRadius = searchView.frame.size.height/2;
        searchView.backgroundColor = UIColor.white
//        searchView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
//        searchView.layer.borderWidth = 0.5
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if  textField.text?.count == 0 {
            rightBarAction()
        }else{
            goSearchViewController()
        }
        return true
    }
    
    //MARK:设置pageView
    func setPageView() ->Void{
        self.view.layoutIfNeeded()
        pageView.frame = CGRect(x: 0, y: 6, width: UIScreen.main.bounds.size.width, height: self.view.bounds.size.height)
        pageView.addContent(titleArray: titleDataScoure, height: 26, maginLeft: 10)
       pageView.setBackgroundColor(defaultBackgroundColor: UIColor.clear, selectBackgroundColor: UIColor.init(red: 42/255.0, green: 201/255.0, blue: 140/255.0, alpha: 1))
        pageView.headerBtnStyle(defaultTextColor: UIColor.black, selectTextColor: UIColor.white, headerBtnMagin: 20, headerLineHeight: 0, textFront: 15)
        pageView.layoutIfNeeded()
        for i in 0..<titleDataScoure.count{
            let tb = pageView.pageViewtableView(index: i)
            tb?.delegate = self
            tb?.rowHeight = self.view.frame.size.width/4+16
            tb?.dataSource = self
            tb?.backgroundColor = UIColor.white
            tb?.separatorColor = UIColor.clear
            tb?.showsVerticalScrollIndicator = false
            if tb?.lgyDataScoure == nil{
                tb?.lgyDataScoure = Array<GoodsList>()
            }
            
            tb?.register(UINib.init(nibName: "MarkProductTableViewCell", bundle: nil), forCellReuseIdentifier: "MarkProductTableViewCell")
            if tb?.mj_header == nil{
                let cateItem = cateListItem[i]
                tb?.lgyTypeKey = String(format: "%D",cateItem._id)
                tb?.lgyPageIndex = 1
                loadProduct(cateId:String(format: "%D",cateItem._id), tableView: tb)
                weak var vc = self;
                tb?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
                    tb?.lgyPageIndex = 1
                    vc?.loadProduct(cateId: (tb?.lgyTypeKey)!, tableView: tb)
                })
                tb?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
                    tb?.mj_footer.alpha = 1
                    tb?.lgyPageIndex = 1+(tb?.lgyPageIndex)!
                    vc?.loadProduct(cateId: (tb?.lgyTypeKey)!, tableView: tb)
                   
                })
            }
        }
        pageView.allClassButton.addTarget(self, action: #selector(allClassButtonAction), for: .touchUpInside)
    }
    
    func markPageView(pageView: LGYMarkPageView, showTableView: UITableView) {
        
    }
 
    @objc func allClassButtonAction() ->Void{
        allClassView?.show()
        setNavigationBarStyle(type: .White)
    }
    
    //MARK:点击弹出分类菜单
    func addView() -> Void {
        allClassView = AllClassView.initAllClassView(titleArray: titleDataScoure, imageArray: imageDataScoure)
        allClassView?.frame = CGRect(x: 0, y: -UIScreen.main.bounds.size.height, width: self.view.bounds.size.width, height: UIScreen.main.bounds.size.height)
        UIApplication.shared.keyWindow?.insertSubview(allClassView!, at: 1)
        weak var vc = self
        allClassView?.selectIndexBlock = {
            view,index ->Void in
            view.cancle()
            if index >= 0{
                vc?.pageView.select(index: index)
            }
            vc?.setNavigationBarStyle(type: .Default)
        }
    }
    
    
    
    //MARK:导航栏右边按钮响应事件
    @objc func rightBarAction() ->Void{
        if searchView.frame.width == 0 || searchView.superview == nil{
            searchViewShow()
            searchAhpdView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(searchViewHidden)))
        }else{
            if searchTextField.text?.count == 0 {
                searchViewHidden()
            }else{
                goSearchViewController()
            }
            
            
        }
    }
    
     //MARK:搜索展示
    func searchViewShow() -> Void{
        searchTextField.becomeFirstResponder()
        searchView.frame =  CGRect(x:self.view.frame.size.width - 80, y: 9, width: 0, height: 26)
        self.navigationController?.navigationBar.addSubview(searchView)
        searchAhpdView.frame = CGRect(x: UIScreen.main.bounds.size.width, y: -12, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.view.addSubview(searchAhpdView)
        UIView.animate(withDuration: 0.25) {
            self.searchView.frame =  CGRect(x:80, y: self.searchView.frame.origin.y, width: self.view.frame.size.width - 80*2, height: self.searchView.frame.height)
            self.searchAhpdView.frame = CGRect(x: 0, y: -12, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }
    }
    
    //MARK:搜索隐藏
    @objc func searchViewHidden() -> Void {
        searchTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.25) {
            self.searchView.frame =  CGRect(x:80, y: self.searchView.frame.origin.y, width: 0, height: self.searchView.frame.height)
            self.searchAhpdView.frame = CGRect(x: UIScreen.main.bounds.size.width, y: -12, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }
    }
    
    //MARK:跳转搜索
    func goSearchViewController() -> Void {
        let vc = Bundle.main.loadNibNamed("SearchProductViewController", owner: nil, options: nil)?.first as! SearchProductViewController
        self.navigationController?.pushViewController(vc, animated: true)
         vc.setSearchText(text: searchTextField.text)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.lgyDataScoure.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarkProductTableViewCell", for: indexPath) as! MarkProductTableViewCell
        cell.selectionStyle = .none
        let item = tableView.lgyDataScoure[indexPath.row] as? Goods
        cell.setModel(item: item!)
        cell.delegate = self
        return cell
    }
    
   
    //代理回调
    func markProductTableViewCell(cell: MarkProductTableViewCell) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MarkProductTableViewCell
        if let na = Bundle.main.loadNibNamed("ProductSaleDetailsViewController", owner: nil, options: nil)![0] as? ProductSaleDetailsViewController{
            na.addContentProductSaleInformaiton(product:cell.model!, productId: (cell.model?._id)!)
            self.navigationController?.pushViewController(na, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addView()
        setNavigationBarStyle(type:.Default)
        self.tabBarController?.tabBar.isHidden = false
        self.view.layoutIfNeeded()
        self.view.reloadInputViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarStyle(type:.Default)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    //MARK:加载数据 分类
    func loadDataScoure() -> Void {
        weak var vc = self;
        //MARK:加载产品分类信息
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_findGoodsByCateId, parameters: ["pageNumber":"1","cateId":"0","title":""],progress: nil, cacheName:"api_findGoodsByCateId_class") { (object,isError) in
            let model = Model_api_findGoodsByCateId.yy_model(withJSON: object as Any)
            if model?.cateList != nil {
                vc?.titleDataScoure.removeAll()
                vc?.imageDataScoure.removeAll()
                vc?.cateListItem.removeAll()
                for item in (model?.cateList)! {
                    vc?.cateListItem.append(item)
                    vc?.titleDataScoure.append(item.name!)
                    vc?.imageDataScoure.append(item.icon!)
                }
                vc?.setPageView()
            }
        }
    }
    
    //MARK:加载数据 分类获取产品数据
    func loadProduct(cateId:String, tableView:UITableView?) -> Void {
        weak var tb = tableView ;
        var cacheName:String?
        if tb?.lgyPageIndex == 1 {
            cacheName = "api_findGoodsByCateId_index1_" + cateId
        }
        //MARK:加载产品分类信息
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_findGoodsByCateId, parameters: ["pageNumber":String(format: "%D", (tableView?.lgyPageIndex)!),"cateId":cateId,"title":""], progress: nil,cacheName:cacheName) { (object,isError) in
//            tb?.mj_footer?.alpha = 0
            tb?.mj_header?.endRefreshing()
            tb?.mj_footer?.endRefreshing()
            tb?.layoutIfNeeded()
            if !isError{
                let model = Model_api_findGoodsByCateId.yy_model(withJSON: object as Any)
                if model?.cateList != nil {
                    if tb?.lgyPageIndex == 1{
                        tb?.lgyDataScoure.removeAll();
                    }
                    for item in (model?.goodsList.list)!{
                        tb?.lgyDataScoure.append(item)
                        
                    }
                    tb?.reloadData();
                    
                }
            }
            
        }
    }
    
    @IBAction func shopCarAction(_ sender: Any) {
        let vc = Bundle.main.loadNibNamed("ShopCarViewController", owner: nil, options: nil)?.first as! ShopCarViewController
        self.navigationController?.pushViewController(vc, animated: true)
        self.tabBarController?.tabBar.isHidden = true
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        allClassView?.cancle()
        searchView.removeFromSuperview()
        self.searchAhpdView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

