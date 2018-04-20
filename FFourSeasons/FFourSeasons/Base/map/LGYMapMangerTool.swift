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
    var endLocation:CLLocationCoordinate2D? //高德地图
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
        var endLat   = String(describing: endCoordinate2D!.latitude)
        var endLng   = String(describing: endCoordinate2D!.longitude)
        let urlScheme = "shareba://"
        let displayName = String(describing: Bundle.main.infoDictionary!["CFBundleDisplayName"])
        //百度地图
        if UIApplication.shared.canOpenURL(URL.init(string: "baidumap://map/")!) {
            let endCoor = bd09(fromGCJ02: endCoordinate2D!)
            endLat   = String(describing: endCoor.latitude)
            endLng   = String(describing: endCoor.longitude)
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
    
    // 高德坐标转百度坐标
    func bd09(fromGCJ02 coor: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let x_pi = CLLocationDegrees(3.14159265358979324 * 3000.0 / 180.0)
        let x: CLLocationDegrees = coor.longitude
        let y: CLLocationDegrees = coor.latitude
        let z = CLLocationDegrees(sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi))
        let theta = CLLocationDegrees(atan2(y, x) + 0.000003 * cos(x * x_pi))
        let bd_lon = CLLocationDegrees(z * cos(theta) + 0.0065)
        let bd_lat = CLLocationDegrees(z * sin(theta) + 0.006)
        return CLLocationCoordinate2DMake(bd_lat, bd_lon)
    }
    
    /// 百度坐标转高德坐标
    func gcj02(fromBD09 coor: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let x_pi = CLLocationDegrees(3.14159265358979324 * 3000.0 / 180.0)
        let x = CLLocationDegrees(coor.longitude - 0.0065)
        let y = CLLocationDegrees(coor.latitude - 0.006)
        let z = CLLocationDegrees(sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi))
        let theta = CLLocationDegrees(atan2(y, x) - 0.000003 * cos(x * x_pi))
        let gg_lon: CLLocationDegrees = z * cos(theta)
        let gg_lat: CLLocationDegrees = z * sin(theta)
        return CLLocationCoordinate2DMake(gg_lat, gg_lon)
    }

}
