//
//  ViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,LCycleViewDelegate {
    var rightBarItem: UIBarButtonItem?
    var locationManager : CLLocationManager?
    let row1Height = CGFloat(70+28)
    var headerView:LCycleView = LCycleView()
    
    let luckDrawButton = LGFloatButton()
    @IBOutlet weak var tableView: UITableView!
    var cycledataScoure = Array<Shufflings>()
    
    var leftLocationButton : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        setStyle()
        setTableView()
        navigationItemBack(title: "    ")
        leftLocationButton(_imageName: "定位", _title: "请先定位", target: self, action: #selector(loaction))
        print(row1Height,"  ",(UIScreen.main.bounds.size.width-32.0)/(4*2.5))
        rightBarItem = navigationBarAddRightItem(_imageName: "扫一扫", target: self, action: #selector(rightBarAction))
        startLocationManager()
        extendedLayout()
        setBackgroundColor()
        loadDataScoure()
        needLaunch()
    }
    
    //MARK:判断是否需要登录
    func needLaunch() -> Void {
        let passwordItem = KeychainConfiguration.get(forKey: userDefaultsKey)
        do{
            let password = try passwordItem?.readPassword()
            if password != nil && password!.count > 0{
                NotificationCenter.default.addObserver(self, selector: #selector(notificationCenter(notification:)), name: NSNotification.Name(rawValue: NotificationCenterLaunch), object: nil)
                let userName = passwordItem?.account
                RegisterOrLaunchViewController.api_launch(userName: userName!, passwork: password!)
            }
        }catch{
            LBuyly.lBuglyError(error: error)
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
        if locationPermissionsCheck(){
            startLocationManager()
        }
    }
    
    //权限检测
    private func locationPermissionsCheck()->Bool{
        
        if CLLocationManager.locationServicesEnabled(){
            print("请确认已开启定位服务");
            return true;
        }
        
        // 请求用户授权
       _ = LGYAlertViewSimple.show(title: "请开启定位授权！", buttonStr: "确定")
        return false
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
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            vc?.loadDataScoure()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.lgyDataScoure.count == 0 {
            if cycledataScoure.count == 0{
                return 0
            }else{
                return 2
            }
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
        self.navigationItem.rightBarButtonItems = [rightBarItem!]
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.rightBarButtonItems = nil
    }
    
    //MARK:开始定位
    func startLocationManager() -> Void {
        
        if self.locationManager != nil {
            return
        }
        
        self.locationManager = CLLocationManager()
        
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }else {
            //提示打开定位
            LGYToastView.show(message: "请先打开定位")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getCityName(location: manager.location!)
        self.locationManager?.stopUpdatingLocation()
        self.locationManager = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        LGYToastView.show(message: "定位失败，稍后再试")
        self.locationManager?.stopUpdatingLocation()
        self.locationManager = nil
    }
    
    //MARK:反向地理编码
    private func getCityName(location : CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            var cityName = ""
            if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    cityName = city
                }else {
                    cityName = placemark.administrativeArea!
                }
                self.leftLocationButton?.setTitle(cityName, for: UIControlState.normal)
            }else if error != nil {
               LGYToastView.show(message: "获取定位地址失败，稍后再试")
            }
        }
    }

    
    func pushToLaunch(){
        let vc = Bundle.main.loadNibNamed("RegisterOrLaunchViewController", owner: nil, options: nil)?.first as! RegisterOrLaunchViewController
        vc.isNeedRootPage = false
        let na = UINavigationController(rootViewController: vc);
        self.present(na, animated: true, completion: {
            
        })
    }
    
    //MARK:加载数据
    func loadDataScoure() -> Void {
        weak var vc = self;
        let cacheName = "api_index_1"
        //MARK:加载产品分类信息
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_index, parameters: nil, progress: nil,cacheName:cacheName) { (object,isError) in
            vc?.tableView?.mj_header?.endRefreshing()
            vc?.tableView?.mj_footer?.endRefreshing()
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
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK：左边导航
    func leftLocationButton(_imageName:String,_title:String,target:Any?, action: Selector?) -> Void {
        let leftLocationView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 120, height: 44))
        self.leftLocationButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
         self.leftLocationButton?.isUserInteractionEnabled = false
        let locationImageView = UIImageView.init(frame: CGRect(x:0, y: (self.leftLocationButton!.frame.size.height - 15)/2, width: 15, height: 15))
        locationImageView.image = UIImage.init(named: _imageName)
        if action != nil{
            leftLocationView.addGestureRecognizer(UITapGestureRecognizer.init(target: target, action: action))
        }
        self.leftLocationButton!.setTitle(_title, for: .normal)
        self.leftLocationButton!.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        leftLocationView.addSubview(self.leftLocationButton!)
        leftLocationView.addSubview(locationImageView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftLocationView)
    }
    
}

