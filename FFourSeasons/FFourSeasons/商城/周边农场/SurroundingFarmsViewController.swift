//
//  SurroundingFarmsViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/15.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit


class SurroundingFarmsViewController: UIViewController,MAMapViewDelegate,TYAttributedLabelDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var myLocationBtn: UIButton!
    var mapZoomLevel = 13.5
    ///初始化地图
    let mapView = MAMapView()
    let locationManager = CLLocationManager()
    var userAnnotation = MAPointAnnotation()
    let tool = LGYMapMangerTool() //启动导航
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "人人庄园"
        addMapView()
        setTextViewText()
        navigationItemBack(title: nil)
        startLocationManager()
        LGYTool.viewLayerShadowShadowOffsetHeight(view: myLocationBtn)
    }
    
    //MARK:设置地图
    func addMapView() ->Void{
        mapView.frame = CGRect(x: 0, y: 60, width: view.bounds.size.width, height: view.bounds.size.height - 60)
//        //指南针
//        mapView.showsCompass = true
//        mapView.compassOrigin = CGPoint(x: 10, y: 10)
//        //地图比例尺寸
//        mapView.showsScale = true
//        mapView.scaleOrigin = CGPoint(x: 10, y: 10)
        
        mapView.setZoomLevel(mapZoomLevel, animated: true)
        view.insertSubview(mapView, at: 0)
        mapView.delegate = self
        
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = .follow;
    }
    
    //MARK:设置地图上面浮动文字
    func setTextViewText() ->Void{
        let backViewWidth = view.frame.width - 32
        let backView = UIView(frame: CGRect(x: 16, y: 0, width: backViewWidth, height: 0))
        backView.backgroundColor = UIColor.white
        backView.LGyCornerRadius = 10
        LGYTool.viewLayerShadow(view: backView)
        self.view.addSubview(backView)
        
        let label = TYAttributedLabel(frame: CGRect(x: 20, y: 12, width: backViewWidth - 40, height: 0))
        label.delegate = self
        let text = "夏至刚过，位于韶关的翁源的三华李是应节的，果搭肉厚，无渣核小，清甜爽口，促进血红蛋白再生的奇效。<立即前往>"
        label.text = text
        label.font = UIFont.systemFont(ofSize: 9)
        
        let linkStorage = TYLinkTextStorage()
        linkStorage.range = text.lgyNSRange(range: text.range(of: "<立即前往>"))!
        linkStorage.underLineStyle = .init(rawValue: 0)
        linkStorage.textColor = UIColor(red: 187/255.0, green: 187/255.0, blue: 187/255.0, alpha: 1)
        label.addTextStorage(linkStorage)
        label.sizeToFit()
        
        backView.addSubview(label)
        backView.layoutSubviews()
        
        backView.frame = CGRect(x: 16, y: 80, width: backViewWidth, height: label.frame.size.height + 24)
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
           
            annotationView?.image = UIImage(named: "农场图标.png")
            return annotationView
        }
        return nil
    }

    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        weak var vc = self
        if view != nil{
            DetailsView.show {
               
               
            }
        }
    }
    
    //MARK:开始定位
    func startLocationManager() -> Void {
        if locationManager.delegate != nil{
            return
        }
        locationManager.desiredAccuracy = CLLocationAccuracy.init(kCLLocationAccuracyBest)
        locationManager.distanceFilter = 300.0 //每隔100米更新一次
        locationManager.delegate = self
        //        if CLLocationManager.locationServicesEnabled(){
        //            LGYAlertViewSimple.show(title: "开启定位功能开启失败，请到：设置 > 人人庄园 中添加权限", buttonStr: "确定")
        //
        //        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.removeAnnotation(self.userAnnotation)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    func attributedLabel(_ attributedLabel: TYAttributedLabel!, textStorageClicked textStorage: TYTextStorageProtocol!, at point: CGPoint) {
   
        
        tool.getInstalledMapApp(endLocation: self.userAnnotation.coordinate, viewController: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
