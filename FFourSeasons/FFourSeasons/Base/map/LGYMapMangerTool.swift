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
    var endName = ""
    
    
    //导航
    func mapNavigation(vController:UIViewController) {
        self.availableMapsApps()
        let alert = UIAlertController.init(title: "选择地图", message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction.init(title: "苹果地图", style: .default) { (action) in
            self.useDefaultMapNavigation()
        }
        alert.addAction(defaultAction)
        for mapAppDict in self.availableMaps {
            let action = UIAlertAction.init(title: mapAppDict["name"], style: .default) { (action) in
                
                UIApplication.shared.openURL(URL.init(string: mapAppDict["url"]!)!)
                
            }
            alert.addAction(action)
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        vController.present(alert, animated: true, completion: nil)
    }
    
    //可选导航类型
    private var availableMaps : [[String : String]] = []
    
    func availableMapsApps() {
        self.availableMaps.removeAll()
        let endCoordinate2D = endLocation
        let destinationName = endName
        let endLat   = String(describing: endCoordinate2D!.latitude)
        let endLng   = String(describing: endCoordinate2D!.longitude)
        let urlScheme = "shareba://"
        let displayName = String(describing: Bundle.main.infoDictionary!["CFBundleDisplayName"])
        //百度地图
        if UIApplication.shared.canOpenURL(URL.init(string: "baidumap://map/")!) {
            var urlString = "baidumap://map/direction?origin={{我的位置}}&destination=latlng:\(endLat),\(endLng)|name:\(destinationName)&mode=transit"
            urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let dict = ["name" : "百度地图",
                        "url" : urlString]
            self.availableMaps.append(dict)
            
        }
        //高德地图
        if UIApplication.shared.canOpenURL(URL.init(string: "iosamap://")!) {
            var urlString = "iosamap://navi?sourceApplication=\(displayName)&backScheme=\(urlScheme)&lat=\(endLat)&lon=\(endLng)&dev=0&style=2"
            urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let dict = ["name" : "高德地图",
                        "url" : urlString]
            self.availableMaps.append(dict)
            
        }
        //谷歌地图
        if UIApplication.shared.canOpenURL(URL.init(string: "comgooglemaps://")!) {
            var urlString = "comgooglemaps://?x-source=\(displayName)&x-success=\(urlScheme)&saddr=&daddr=\(endLat),\(endLng)&directionsmode=transit"
            urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let dict = ["name" : "谷歌地图",
                        "url" : urlString]
            self.availableMaps.append(dict)
            
        }
        
    }
    
    //苹果自带地图
    func useDefaultMapNavigation() {
        if let addressCoordinate = endLocation {
            let currentLocation = MKMapItem.forCurrentLocation()
            let toLocation = MKMapItem.init(placemark: MKPlacemark(coordinate: addressCoordinate, addressDictionary: nil))
            toLocation.name = endName
            let items = [currentLocation,toLocation]
            let options : [String : Any] = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                                            MKLaunchOptionsShowsTrafficKey : true]
            MKMapItem.openMaps(with: items, launchOptions: options)
        }
    }

}
