//
//  ViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit
import CoreLocation
import LCRefresh

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,LCycleViewDelegate {
    var rightBarItem:UIBarButtonItem?
    let locationManager = CLLocationManager()
    let row1Height = CGFloat(70+28)
    var headerView:LCycleView = LCycleView()
    
    let luckDrawButton = LGFloatButton()
    @IBOutlet weak var tableView: UITableView!
    var cycledataScoure = Array<Shufflings>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        setStyle()
        setTableView()
        navigationBarAddLeftButton(_imageName: "定位2x.png", _title: "广州", target: self, action: #selector(loaction),tag: 1000)
        print(row1Height,"  ",(UIScreen.main.bounds.size.width-32.0)/(4*2.5))
        rightBarItem = navigationBarAddRightItem(_imageName: "扫码.png", target: self, action: #selector(rightBarAction))
        startLocationManager()
        extendedLayout()
        setBackgroundColor()
        needLaunch()
        
    }
    
    //MARK:判断是否需要登录
    func needLaunch() -> Void {
        if Model_user_information.getToken().count > 0{
            loadDataScoure()
        }else{
            let passwordItem = KeychainConfiguration.get(forKey: userDefaultsKey)
            do{
                let password = try passwordItem?.readPassword()
                if password == nil || password?.count == 0{
                    pushToLaunch()
                    return
                }
                let userName = passwordItem?.account
                RegisterOrLaunchViewController.api_launch(userName: userName!, passwork: password!)
            }catch{
                LBuyly.lBuglyError(error: error)
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(notificationCenter(notification:)), name: NSNotification.Name(rawValue: NotificationCenterLaunch), object: nil)
        }
       
    }
    
    @objc func notificationCenter(notification:Notification)->Void{
        let flag = notification.object as! Bool
        if flag{
            loadDataScoure()
        }else{
            pushToLaunch()
        }
    }
    

    //MARK:导航栏右边按钮响应事件
    @objc func rightBarAction() ->Void{
        let scanner = HMScannerController.scanner(withCardName: "123456789", avatar: nil) { (stringValue) -> Void in
          
        }
        self.showDetailViewController(scanner!, sender: nil)
    }
    
    //MARK:定位
    @objc func loaction() -> Void {
        alertView(_title: "提示", _message: "功能未开启！", _bText: "我知道了")
    }
    
    
    //MARK:设置样式
    func setStyle(){
        self.title = "人人庄园"
        self.navigationController?.tabBarItem.title = "首页"
        luckDrawButton.frame = CGRect(x: self.view.frame.size.width - 90, y: self.view.frame.size.height - 90-44, width: 80, height: 80)
        view.addSubview(luckDrawButton)
        luckDrawButton.imageView?.image = UIImage.init(named: "抽奖3x.png")
        LGYTool.viewLayerShadowShadowOffsetHeight(view: luckDrawButton)
        luckDrawButton.imageView?.contentMode = .scaleAspectFit
        luckDrawButton.backgroundColor = UIColor.white
         luckDrawButton.isHidden = true
    }
    

    func setTableView() -> Void {
        tableView.delegate = self;
        tableView.dataSource = self
        tableView.bounces = true
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib.init(nibName: "MainPageProductTableViewCell", bundle: nil), forCellReuseIdentifier: "MainPageProductTableViewCell")
        tableView.lgyDataScoure = Array<Goods>()
        weak var vc = self;
        tableView.refreshHeader = LCRefreshHeader.init(refreshBlock: {
            vc?.needLaunch()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.lgyDataScoure.count == 0 {
            return 0
        }
        return tableView.lgyDataScoure.count+2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return self.view.frame.size.width/750*272
        }
        
        if indexPath.row == 1{
           return row1Height
        }
        return self.view.frame.size.width/4+16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainPageProductTableViewCell", for: indexPath) as! MainPageProductTableViewCell
        cell.selectionStyle = .none
        if indexPath.row == 0{ //滚动图片
            let height1 = self.view.frame.size.width/750*272
            headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: height1)
            headerView.pageControlBackView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            headerView.tag = 10001
            cell.addSubview(headerView)
            headerView.delegate = self
        }else
            if indexPath.row == 1 { //横向菜单栏设置
                var view = cell.viewWithTag(10002)
                if view == nil{
                   view = MainPageMenuView.mainPageMenuView(viewController: self)
                }
                view?.frame = CGRect(x: 16, y: 20, width: self.view.frame.size.width-32, height: row1Height-28)
                view?.tag = 10002
                cell.backgroundColor = UIColor.clear
                LGYTool.viewLayerShadow(view: view!)
                cell.contentView.alpha = 0
                cell.addSubview(view!)
        } else { //推荐产品
            cell.contentView.alpha = 1
            cell.viewWithTag(10001)?.removeFromSuperview()
            cell.viewWithTag(10002)?.removeFromSuperview()
                let item = tableView.lgyDataScoure[indexPath.row-2]
            cell.setModel(item: item as! Goods)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 1{
             self.tabBarController?.tabBar.isHidden = true
            let cell = tableView.cellForRow(at: indexPath) as! MainPageProductTableViewCell
            let na = Bundle.main.loadNibNamed("ProductSaleDetailsViewController", owner: nil, options: nil)![0] as! ProductSaleDetailsViewController
            na.addContentProductSaleInformaiton(product: cell.model,productId: (cell.model?._id)!)
            self.navigationController?.pushViewController(na, animated: true)
            
        }
    }
    
    //MARK:LCycleViewDelegate pro 滚动图片点击图片回调
    func lcyCleView(lcyCleView: LCycleView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row%cycledataScoure.count
        if index >= cycledataScoure.count{
            return
        }
        let item = cycledataScoure[index]
        switch item.type {
        case 1: //网页跳转
            let vc = WebViewController()
            vc.loadAuthPage(urlString: item.url)
            self.navigationController?.pushViewController(vc, animated: true)
             self.tabBarController?.tabBar.isHidden = true
            break
        case 0:
            let na = Bundle.main.loadNibNamed("ProductSaleDetailsViewController", owner: nil, options: nil)![0] as! ProductSaleDetailsViewController
            na.addContentProductSaleInformaiton(product: nil,productId: Int(item.url)!)
            self.navigationController?.pushViewController(na, animated: true)
             self.tabBarController?.tabBar.isHidden = true
            break
        default:
            break
        }
    }
    
    //MARK:抽奖跳转
    @IBAction func luckDrawAction(_ sender: Any) {
        let vc = Bundle.main.loadNibNamed("LuckDrawViewController", owner: nil, options: nil)?.first as! UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
         self.tabBarController?.tabBar.isHidden = true
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.viewWithTag(1000)?.isHidden = false
        locationManager.startUpdatingLocation()
        self.navigationItem.rightBarButtonItems = [rightBarItem!]

    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.viewWithTag(1000)?.isHidden = true
         locationManager.stopUpdatingLocation()
        self.navigationItem.rightBarButtonItems = nil
    }
    
    //MARK:开始定位
    func startLocationManager() -> Void {
        if locationManager.delegate != nil{
            return
        }

        locationManager.desiredAccuracy = CLLocationAccuracy.init(kCLLocationAccuracyBest)
        locationManager.distanceFilter = 300.0 //每隔100米更新一次
        locationManager.delegate = self

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getAddressStringFromLocation(location: locations.last!)
    }
    
    //MARK:反向地理编码
    func getAddressStringFromLocation(location:CLLocation) -> Void {
        let clGeoCoder = CLGeocoder()
        let cl = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        clGeoCoder.reverseGeocodeLocation(cl) { (placemarks, error) in
            for placeMark: CLPlacemark in placemarks! {
                let addressDic = placeMark.addressDictionary
                let state = addressDic?["State"] as? String
                var city = addressDic?["City"] as? String
                let subLocality = addressDic?["SubLocality"] as? String
                let street = addressDic?["Street"] as? String
                print("所在城市====\(state) \(city) \(subLocality) \(street)")
            }
        }
    }
    
    
    func pushToLaunch(){
        let vc = Bundle.main.loadNibNamed("RegisterOrLaunchViewController", owner: nil, options: nil)?.first as! RegisterOrLaunchViewController
        vc.isNeedRootPage = false
        self.present(vc, animated: true, completion: {
            
        })
    }
    
    //MARK:加载数据
    func loadDataScoure() -> Void {
        weak var vc = self;
        let cacheName = "api_index_1"
        //MARK:加载产品分类信息
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_index, parameters: ["token":Model_user_information.getToken()], progress: nil,cacheName:cacheName) { (object,isError) in
            if isError {
                return
            }
            let model = Model_api_index.yy_model(withJSON: object as Any)
            if model != nil{
                vc?.setTableReload(model: model!)
            }
        }
    }
    
    func setTableReload(model:Model_api_index) -> Void {
//
        if model.shufflings != nil{
            let array = NSMutableArray()
            cycledataScoure.removeAll()
            for item in (model.shufflings)!{
                let ss = item.img_url
                cycledataScoure.append(item as! Shufflings)
                array.add(ss as Any)
            }
            headerView.setup(array: array)
        }
        
        tableView.lgyDataScoure.removeAll();
        for item in (model.goodsList)!{
            tableView.lgyDataScoure.append(item)
            
        }
        tableView.reloadData();
        if (tableView.isHeaderRefreshing()) {
            tableView.endHeaderRefreshing()
        }
        
        if (tableView.isFooterRefreshing()) {
            tableView.endFooterRefreshing()
            
        }
        tableView.setDataLoadover()
        tableView.resetDataLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
    
}

