//
//  SurroundingFarmsViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/15.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit


class SurroundingFarmsViewController: UIViewController,MAMapViewDelegate,TYAttributedLabelDelegate,CLLocationManagerDelegate,DetailsViewDelegate,LGYMAAnnotationViewDelegate {
    
    @IBOutlet weak var myLocationBtn: UIButton!
    var mapZoomLevel = CGFloat(17)
    ///初始化地图
    let mapView = MAMapView()
    let locationManager = CLLocationManager()
    var userAnnotation = MAPointAnnotation()
    let tool = LGYMapMangerTool() //启动导航
    let backView = UIView()
    let textLabel = TYAttributedLabel()
    var listFarm = Array<Farm>() //其他农场列
    var firstFarm:Farm? //推荐农场
    var selectFarm:Farm? //点击展开的农场
    var isFirst = true //判断第一次
    let lock = NSLock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "周边农场"
        addMapView()
        setTextViewText()
        navigationItemBack(title: nil)
        startLocationManager()
        LGYTool.viewLayerShadowShadowOffsetHeight(view: myLocationBtn)
    }
    
    //MARK:设置地图
    func addMapView() ->Void{
        mapView.frame = CGRect(x: 0, y: 60, width: view.bounds.size.width, height: view.bounds.size.height - 60)
        //        mapView.setZoomLevel(mapZoomLevel, animated: true)
        view.insertSubview(mapView, at: 0)
        mapView.delegate = self
        AMapServices.shared().enableHTTPS = true
        mapView.setZoomLevel(mapZoomLevel, animated: true)
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow;
    }
    
    //MARK:设置地图上面的View
    func setTextViewText() ->Void{
        let backViewWidth = view.frame.width - 32
        backView.frame = CGRect(x: 16, y: 0, width: backViewWidth, height: 30)
        backView.backgroundColor = UIColor.white
        backView.LGyCornerRadius = 10
        LGYTool.viewLayerShadow(view: backView)
        self.view.addSubview(backView)
        
        textLabel.delegate = self
        textLabel.frame = CGRect(x: 8, y: 8, width: backViewWidth-16, height: 0)
        backView.addSubview(textLabel)
        backView.layoutSubviews()
    }
    
    //MARK:设置地图上面浮动文字
    func setTextLabelText(text:String) -> Void {
        let backViewWidth = view.frame.width - 32
        let text = "\(text)<立即前往>"
        textLabel.text = text
        textLabel.font = UIFont.systemFont(ofSize: 9)
        let linkStorage = TYLinkTextStorage()
        linkStorage.range = text.lgyNSRange(range: text.range(of: "<立即前往>"))!
        linkStorage.underLineStyle = .init(rawValue: 0)
        linkStorage.textColor = UIColor(red: 187/255.0, green: 187/255.0, blue: 187/255.0, alpha: 1)
        textLabel.addTextStorage(linkStorage)
        textLabel.sizeToFit()
        textLabel.layoutIfNeeded()
        backView.layoutIfNeeded()
        backView.frame = CGRect(x: 16, y: 84, width: backViewWidth, height: textLabel.frame.size.height + 16)
    }
    
    
    @IBAction func addAction(_ sender: UIButton) {
        if mapZoomLevel < 19{
            mapZoomLevel += 1
            mapView.setZoomLevel(mapZoomLevel, animated: true)
        }
        
    }
    
    @IBAction func reduceAction(_ sender: Any) {
        if mapZoomLevel > 3{
            mapZoomLevel -= 1
            mapView.setZoomLevel(mapZoomLevel, animated: true)
        }
        
    }
    
    
    //MARK:修改大头标
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if (annotation.isKind(of: MAUserLocation.classForCoder())) {
            if isFirst{
                self.loadDataScoure()
                isFirst = false
            }
            return nil
        }
        if (annotation.isKind(of: LGYMAPointAnnotation.classForCoder())) {
           
            let pointReuseIndentifier = "pointReuseIndentifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndentifier) as? LGYMAAnnotationView
            if annotationView == nil {
                annotationView = LGYMAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndentifier)
            }
            if let myAnnotation = annotation as? LGYMAPointAnnotation,let view = annotationView{
                view.image =  myAnnotation.image;
                view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                view.backgroundColor = UIColor.white
                view.contentMode = .center
                view.farm = myAnnotation.farm
                view.LGyCornerRadius = 25
                LGYTool.viewLayerShadowShadowOffsetHeight(view: view)
                view.setDelegate(delegete: self)
                view.reloadInputViews()
//
            }
            return annotationView
        }
        return nil
    }
    
    //MARK:点击大头标响应,此方法只能点击一次
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
//        tapAnnotationView(annota:view as! LGYMAAnnotationView)
    }
    
    func lgyMAAnnotationViewFarm(farm: Farm) {
        selectFarm = farm
        loadGoodData(sid: selectFarm!._id, description: selectFarm!.shop_introduce, title: selectFarm!.shop_name)
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
        //        mapView.removeAnnotation(self.userAnnotation)
        let location = locations.last!
        let clGeoCoder = CLGeocoder()
        let cl = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        userAnnotation.coordinate = location.coordinate
        clGeoCoder.reverseGeocodeLocation(cl) { (placemarks, error) in
            //            for placeMark: CLPlacemark in placemarks! {
            //
            //            }
        }
        
        mapView.addAnnotation(self.userAnnotation)
    }
    
    
    
    //MARK:获取周边农场
    func loadDataScoure() -> Void {
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_getFarm, parameters: ["token":Model_user_information.getToken()], progress: nil) { [weak self](object, isError) in
            if let weakSelf = self {
                let model = Model_api_farm.yy_model(withJSON: object as Any)
                weakSelf.setData(model: model)
            }
        }
    }
    
    //MARK:获取周边农场
    func loadGoodData(sid:Int,description:String,title:String) -> Void {
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_getGoods, parameters: ["sid":"\(sid)","token":Model_user_information.getToken()], progress: nil) { [weak self](object, isError) in
            if let weakSelf = self {
                let model = Model_api_getGoods.yy_model(withJSON: object as Any)
                if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                    if let list = model?.goodsList.list{
                        let view =  DetailsView.show(array: list, superView: weakSelf.view, delegate: weakSelf)
                        view.descriptionLabel.text = description
                        view.descriptionLabel.setlineSpace(lineSpace: 4)
                        view.titleLabel.text = title
                    }
                }
            }
        }
    }
    
    //MARK: DetailsViewDelegate pro 获取周边农场产品图片点击回调
    func detailsView(view: DetailsView, farmGoods: FarmGoods) {
        let na = Bundle.main.loadNibNamed("ProductSaleDetailsViewController", owner: nil, options: nil)![0] as! ProductSaleDetailsViewController
        na.addContentProductSaleInformaiton(product: nil,productId:farmGoods._id)
        self.navigationController?.pushViewController(na, animated: true)
    }
    
    //MARK: DetailsViewDelegate pro 获取周边农场立即前往点击回调
    func detailsViewGoToAction(view: DetailsView) {
        let cl = CLLocation(latitude: selectFarm!.lat, longitude: selectFarm!.lng)
        tool.endLocation = cl.coordinate
        tool.mapNavigation(vController: self)
    }
    //插入大图标
    func setData(model:Model_api_farm?)->Void{
        if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
            backView.isHidden = false
            if let farm = model?.farm{
                firstFarm = farm
                setTextLabelText(text: farm.recommendation!)
                //                let cl = CLLocation(latitude: farm.lat, longitude: farm.lng)
                //                let annotation = MAPointAnnotation()
                //                annotation.coordinate = cl.coordinate
                //                annotation.lgyTag = 10000
                //                mapView.addAnnotation(annotation)
            }
            listFarm.removeAll()
            if let farms = model?.farms{
                listFarm.removeAll()
                for item in farms{ //插入大图标
                    var flag = true
                    for object in listFarm{
                        if object.lat == item.lat && object.lng == item.lng{
                            flag = false
                            break;
                        }
                    }
                    if flag{
                        listFarm.append(item)
                        let cl = CLLocation(latitude: item.lat, longitude: item.lng)
                        let annotation = LGYMAPointAnnotation()
                        annotation.coordinate = cl.coordinate
                        annotation.farm = item;
                        _ = UIImage.image(fromURL: item.imgs, placeholder: UIImage.init(named: "农场图标.png")!, shouldCacheImage: false, closure: { [weak self](image) in
                            self?.lock.lock()
                            if image != nil{
                                annotation.image = image
                            }else{
                                annotation.image = UIImage.init(named: "农场图标.png")
                                
                            }
                            self?.lock.unlock()
                            self?.mapView.addAnnotation(annotation)
//
                        })
                    }
                }
                mapView.setZoomLevel(mapZoomLevel, animated: true)
//                addTimer()
            }
        }else{
            backView.isHidden = true
        }
    }
    
    //
    @IBAction func selfLocationAction(_ sender: UIButton) {
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow;
    }
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    func attributedLabel(_ attributedLabel: TYAttributedLabel!, textStorageClicked textStorage: TYTextStorageProtocol!, at point: CGPoint) {
        let cl = CLLocation(latitude: firstFarm!.lat, longitude: firstFarm!.lng)
        tool.endLocation = cl.coordinate
        tool.mapNavigation(vController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

