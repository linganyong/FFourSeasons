//
//  mapManger.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/16.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit
import MapKit

class LGYMapMangerTool: NSObject {
    var maps = [[AnyHashable: Any]]()
    var endLocation:CLLocationCoordinate2D?
    
    //mark: 导航方法
    func getInstalledMapApp(endLocation: CLLocationCoordinate2D,viewController:UIViewController) -> Void {
        self.endLocation = endLocation
        //苹果地图
        var iosMapDic = [AnyHashable: Any]()
        iosMapDic["title"] = "苹果地图"
        maps.append(iosMapDic)
        
        //百度地图
        if let aString = URL(string: "baidumap://") {
            if UIApplication.shared.canOpenURL(aString) {
                var baiduMapDic = [AnyHashable: Any]()
                baiduMapDic["title"] = "百度地图"
                let urlString: String? = ("baidumap://map/direction?origin={{我的位置}}&destination=latlng:\(endLocation.latitude),\(endLocation.longitude)|name=北京&mode=driving&coord_type=gcj02" as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                if let aString = urlString {
                    baiduMapDic["url"] = aString
                }
                maps.append(baiduMapDic)
            }
        }
        
        //高德地图
        if let aString = URL(string: "iosamap://") {
            if UIApplication.shared.canOpenURL(aString) {
                var gaodeMapDic = [AnyHashable: Any]()
                gaodeMapDic["title"] = "高德地图"
                let urlString: String? = ("iosamap://navi?sourceApplication=\("导航功能")&backScheme=\("nav123456")&lat=\(endLocation.latitude)&lon=\(endLocation.longitude)&dev=0&style=2" as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                if let aString = urlString {
                    gaodeMapDic["url"] = aString
                }
                maps.append(gaodeMapDic)
            }
        }
        //谷歌地图
        if let aString = URL(string: "comgooglemaps://") {
            if UIApplication.shared.canOpenURL(aString) {
                var googleMapDic = [AnyHashable: Any]()
                googleMapDic["title"] = "谷歌地图"
                let urlString: String? = ("comgooglemaps://?x-source=\("导航测试")&x-success=\("nav123456")&saddr=&daddr=\(endLocation.latitude),\(endLocation.longitude)&directionsmode=driving" as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                if let aString = urlString {
                    googleMapDic["url"] = aString
                }
                maps.append(googleMapDic)
            }
        }
        
        //腾讯地图
        if let aString = URL(string: "qqmap://") {
            if UIApplication.shared.canOpenURL(aString) {
                var qqMapDic = [AnyHashable: Any]()
                qqMapDic["title"] = "腾讯地图"
                let urlString: String? = ("qqmap://map/routeplan?from=我的位置&type=drive&tocoord=\(endLocation.latitude),\(endLocation.longitude)&to=终点&coord_type=1&policy=0" as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                if let aString = urlString {
                    qqMapDic["url"] = aString
                }
                maps.append(qqMapDic)
            }
        }
       alertView(viewController: viewController)
    }
    
    //苹果地图
    private func navAppleMap() {
        let currentLoc = MKMapItem.forCurrentLocation()
        let toLocation = MKMapItem(placemark: MKPlacemark(coordinate: endLocation!, addressDictionary: nil))
        let items = [currentLoc, toLocation]
        
        let dic = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey:NSNumber.init(value: Int8(MKMapType.standard.rawValue)), MKLaunchOptionsShowsTrafficKey: NSNumber.init(value: true)] as [String : Any]
        MKMapItem.openMaps(with: items, launchOptions: dic)
    }
    
    //MARK:弹出提示
    private func alertView(viewController:UIViewController){
        let alertController = UIAlertController(title: "导航", message: "请选择导航应用",
                                                preferredStyle: .actionSheet)
        weak var vc = viewController
        weak var weak_self = self
        for item:[AnyHashable: Any] in maps {
            let cancelAction = UIAlertAction(title: item["title"] as? String, style: .cancel, handler: {(action) -> Void in
                if vc != nil{
                    weak_self?.startMap(title: action.title!,viewController: vc)
                }
            })
            
            alertController.addAction(cancelAction)
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:启动导航
    private func startMap(title:String,viewController:UIViewController?) -> Void {
        var dic:[AnyHashable: Any]?
        if title.contains("苹果"){
            navAppleMap()
            return
        }else if title.contains("百度"){
            dic = maps[1]
        }else if title.contains("高德"){
            dic = maps[2]
        }else if title.contains("谷歌"){
            dic = maps[3]
        }else if title.contains("腾讯"){
            dic = maps[4]
        }else if title.contains("网页"){
            
        }
        let urlString = dic?["url"] as? String
        if urlString != nil  {
            let aString = URL(string: urlString!)
            
            //iOS10以后,使用新API
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(aString!, options: [:], completionHandler: {(_ success: Bool) -> Void in
                })
            } else {
                //iOS10以前,使用旧API
                UIApplication.shared.openURL(aString!)
            }
        }

    }
    
   

}
