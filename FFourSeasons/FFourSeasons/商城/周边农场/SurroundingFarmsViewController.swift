//
//  SurroundingFarmsViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/15.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit


class SurroundingFarmsViewController: UIViewController,MAMapViewDelegate,TYAttributedLabelDelegate,CLLocationManagerDelegate,DetailsViewDelegate {
    
    @IBOutlet weak var myLocationBtn: UIButton!
    var mapZoomLevel = 10.5
    ///初始化地图
    let mapView = MAMapView()
    let locationManager = CLLocationManager()
    var userAnnotation = MAPointAnnotation()
    let tool = LGYMapMangerTool() //启动导航
    let backView = UIView()
    let textLabel = TYAttributedLabel()
    var listFarm = Array<Farm>() //其他农场列表
    var firstFarm:Farm? //推荐农场
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "人人庄园"
        addMapView()
        setTextViewText()
        navigationItemBack(title: nil)
        startLocationManager()
        LGYTool.viewLayerShadowShadowOffsetHeight(view: myLocationBtn)
        loadDataScoure()
    }
    
    //MARK:设置地图
    func addMapView() ->Void{
        mapView.frame = CGRect(x: 0, y: 60, width: view.bounds.size.width, height: view.bounds.size.height - 60)
        mapView.setZoomLevel(mapZoomLevel, animated: true)
        view.insertSubview(mapView, at: 0)
        mapView.delegate = self
        AMapServices.shared().enableHTTPS = true
        
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = .follow;
    }
    
    //MARK:设置地图上面的View
    func setTextViewText() ->Void{
        let backViewWidth = view.frame.width - 32
        backView.frame = CGRect(x: 16, y: 0, width: backViewWidth, height: 0)
        backView.backgroundColor = UIColor.white
        backView.LGyCornerRadius = 10
        LGYTool.viewLayerShadow(view: backView)
        self.view.addSubview(backView)
        
        textLabel.delegate = self
        backView.addSubview(textLabel)
        backView.layoutSubviews()
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(84)
            make.right.equalTo(view.snp.right).offset(-8)
            make.left.equalTo(view.snp.left).offset(8)
        }
        textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backView.snp.top).offset(8)
            make.right.equalTo(backView.snp.right).offset(-8)
            make.left.equalTo(backView.snp.left).offset(8)
            make.bottom.equalTo(backView.snp.bottom).offset(-8)
            make.height.greaterThanOrEqualTo(30)
        }
        
    }
    
    //MARK:设置地图上面浮动文字
    func setTextLabelText(text:String) -> Void {
        let text = "\(text)<立即前往>"
        textLabel.text = text
        textLabel.font = UIFont.systemFont(ofSize: 9)
        let linkStorage = TYLinkTextStorage()
        linkStorage.range = text.lgyNSRange(range: text.range(of: "<立即前往>"))!
        linkStorage.underLineStyle = .init(rawValue: 0)
        linkStorage.textColor = UIColor(red: 187/255.0, green: 187/255.0, blue: 187/255.0, alpha: 1)
        textLabel.addTextStorage(linkStorage)
        textLabel.sizeToFit()
//        backView.frame = CGRect(x: 16, y: 80, width: backViewWidth, height: textLabel.frame.size.height + 24)
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
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if (annotation.isKind(of: MAPointAnnotation.classForCoder())) {
            let pointReuseIndentifier = "pointReuseIndentifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndentifier) as? MAPinAnnotationView
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndentifier)
            }
            if annotation.lgyTag < 0{
                
                
            }else if annotation.lgyTag < 10000 && annotation.lgyTag >= 0{
                let farm = listFarm[annotation.lgyTag]
                if farm.imgs != nil{
                  _ = UIImage.image(fromURL: farm.imgs, placeholder: UIImage.init(), shouldCacheImage: true, closure: { [weak annotationView](image) in
                        annotationView?.image = image
                        annotationView?.reloadInputViews()
                    })
                }
            }else if annotation.lgyTag == 10000{
                
            }
            annotationView?.lgyTag = annotation.lgyTag
            return annotationView
        }
        return nil
    }

    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        if view.lgyTag < 0{
            
            
        }else if view.lgyTag < 10000 && view.lgyTag >= 0{
            let farm = listFarm[view.lgyTag]
            loadGoodData(sid: farm._id, description: farm.shop_introduce, title: farm.shop_name)
        }else if view.lgyTag == 10000{
            
        }
        view.setSelected(false, animated: false)
        
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
            for placeMark: CLPlacemark in placemarks! {
                let addressDic = placeMark.addressDictionary
                let state = addressDic?["State"] as? String
                var city = addressDic?["City"] as? String
                let subLocality = addressDic?["SubLocality"] as? String
                let street = addressDic?["Street"] as? String
            }
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
                var count = 0
                for item in farms{
                    if item != nil{
                        listFarm.append(item)
                        let cl = CLLocation(latitude: item.lat, longitude: item.lng)
                        let annotation = MAPointAnnotation()
                        annotation.lgyTag = count
                        annotation.coordinate = cl.coordinate
                        mapView.addAnnotation(annotation)
                        
                        count += 1
                    }
                }
            }
        }else{
            backView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    func attributedLabel(_ attributedLabel: TYAttributedLabel!, textStorageClicked textStorage: TYTextStorageProtocol!, at point: CGPoint) {
        let cl = CLLocation(latitude: firstFarm!.lat, longitude: firstFarm!.lng)
        tool.getInstalledMapApp(endLocation: cl.coordinate, viewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
