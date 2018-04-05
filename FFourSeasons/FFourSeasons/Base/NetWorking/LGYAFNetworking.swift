//
//  LGYAFNetworking.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/12.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit
import AFNetworking

/*
 统一第三方类库，方便后期修改类库
 */

typealias  LGYAFNetworkingBlock = ()->Void



class LGYAFNetworking: NSObject {
    let view = UIView()
    
    //MARK:POST网络请求入口
    class func lgyPost(urlString: String, parameters: [String:Any]?,progress:UIProgressView?,responseBlock:((_ responseObject:Any?,_ isError:Bool)->Void)?) ->Void{
       lgyPost(urlString: urlString, parameters: parameters, progress: progress, cacheName: nil, responseBlock: responseBlock)
    }
    
    func addLoadingView() -> Void {
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let vc = UIViewController.currentViewController()
        vc?.view.addSubview(view)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeLoadingView)))
        view.backgroundColor = UIColor.clear
        let imgWidth = 100.0
        let imgHeight = 100.0
        let size = view.frame.size
        let imageView = UIImageView(frame: CGRect(x:(Double(size.width) - imgWidth)/2.0 , y: (Double(size.height) - imgHeight)/2 - 44, width: imgWidth, height: imgHeight))
        imageView.backgroundColor = UIColor.white
        imageView.LGyCornerRadius = 10
        view.addSubview(imageView)
        loadingGif(imageView: imageView, gifName: "loading.gif")
    }
    
    func addLoadingView(viewSuper:UIView) -> Void {
        view.frame = CGRect(x: 0, y: -22, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        viewSuper.addSubview(view)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeLoadingView)))
        view.backgroundColor = UIColor.clear
        let imgWidth = 100.0
        let imgHeight = 100.0
        let size = view.frame.size
        let imageView = UIImageView(frame: CGRect(x:(Double(size.width) - imgWidth)/2.0 , y: (Double(size.height) - imgHeight)/2 - 44, width: imgWidth, height: imgHeight))
        imageView.backgroundColor = UIColor.white
        imageView.LGyCornerRadius = 10
        view.addSubview(imageView)
        loadingGif(imageView: imageView, gifName: "loading.gif")
    }
    
    //MARK:网络加载gif
    func loadingGif(imageView:UIImageView,gifName:String) {
        guard let path = Bundle.main.path(forResource: gifName, ofType: nil),
            let data = NSData(contentsOfFile: path),
            let imageSource = CGImageSourceCreateWithData(data, nil) else { return }
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0..<CGImageSourceGetCount(imageSource) {
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            i == 0 ? imageView.image = image : ()
            images.append(image)
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary,
                let gifDict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary,
                let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
        }
        imageView.animationImages = images
        imageView.animationDuration = totalDuration
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
    }
    
    @objc func removeLoadingView() -> Void {
        view.removeFromSuperview()
    }
    
    //MARK:POST网络请求入口
    class func lgyPost(urlString: String, parameters: [String:Any]?,progress:UIProgressView?,cacheName:String?,responseBlock:((_ responseObject:Any?,_ isError:Bool)->Void)?) ->Void{
        let network = LGYAFNetworking()
        network.addLoadingView()
        if cacheName != nil{
            let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
            if !appDelegate.isExistCacheNameUse(cacheName: cacheName!){
                let data = readNetWorkCahe(key: cacheName)
                if data != nil {
                    let JSONString = NSString(data:data!,encoding: String.Encoding.utf8.rawValue)
                    responseBlock?(JSONString, false)
                    network.removeLoadingView()
                }
            }
        }
        
        let manager = AFHTTPSessionManager();
        //申明请求的数据是json类型
        manager.requestSerializer = AFHTTPRequestSerializer()
        //使用 application/x-www-form-urlencoded; charset=utf-8
        manager.requestSerializer.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        manager.responseSerializer.acceptableContentTypes = ["application/json", "text/json", "text/javascript", "text/html","text/plain"];
        
        manager.post(urlString, parameters: parameters, progress: { (press) in
            
        }, success: { (dataTask, any) in
            print("\n",urlString,parameters,any)
            lgyObjectReturnBlock(any: any,cacheName:cacheName, responseBlock: responseBlock)
            network.removeLoadingView()
        }) { (dataTask, error) in
             print("error  ",error)
            print("\n",urlString,parameters)
            _ = LGYAlertViewSimple.show(title: error.localizedDescription, buttonStr: "确定")
            responseBlock?(error.localizedDescription, true)
            LBuyly.lBuglyError(error: error)
            network.removeLoadingView()
        }
        
    }
    
    
   
    
    //请求 图片格式 multipart/form-data ，返回数据格式 text/plain
    class func lgyPushImage(urlString: String, parameters: [String:Any]?,array:Array<UIImage>,progress:UIProgressView?,responseBlock:((_ urlString:String?,_ isError:Bool)->Void)?)->Void{
        let manager = AFHTTPSessionManager()
        
        //设置相应数据支持的类型
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer.timeoutInterval = 10;
        manager.post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
            var index = 0
            for item in array{
                let data = UIImagePNGRepresentation(item)
                if data != nil{
                    let dateForm = DateFormatter()
                    dateForm.dateFormat = "yyyyMMddHHmmss"
                    let namePaht = dateForm.string(from: Date.init())
                    let name = String.init(format: "%@%D.jpg", namePaht,index)
                    index += 1
                    formData.appendPart(withFileData:data!, name:"file", fileName: name, mimeType: "multipart/form-data")
                }
            }
        }, progress: { (pross) in
            
        }, success: { (dataTask, any) in
            let url = String.init(data: any as! Data, encoding: .utf8)
            responseBlock?(url,false)
        }) { (dataTask, error) in
            print("error  ",error,dataTask)
            _ = LGYAlertViewSimple.show(title: error.localizedDescription, buttonStr: "确定")
            responseBlock?(error.localizedDescription, true)
            LBuyly.lBuglyError(error: error)
        }
    }
    
    
    class func lgyObjectReturnBlock(any:Any?,cacheName:String?,responseBlock:((_ responseObject:Any?,_ isError:Bool)->Void)?) ->Void{
        if any == nil{
            responseBlock?(any, true)
            return
        }
        let data = try? JSONSerialization.data(withJSONObject: any!, options: [])
        let JSONString = NSString(data:data!,encoding: String.Encoding.utf8.rawValue)
        if (JSONString?.contains("ERROR"))!{
            let model = Model_user_information.yy_model(withJSON: any!)
            if model != nil  && model?.msg != nil{
                if model!.msg!.contains("用户不存在"){
                    isTolaunch()
                }
                if  (model?.code.elementsEqual("ERROR"))!{
                    LGYToastView.show(message: (model?.msg)!)
                }
            }
            
            responseBlock?(any, true)
        }else{
            responseBlock?(any, false)
            if data != nil && cacheName != nil {
                writeNetWorkCahe(key: cacheName, data: data!)
            }
        }
    }
    
    //MARK:跳转到登录
    class func isTolaunch(){
        let vc = UIViewController.currentViewController()
        let toVc = Bundle.main.loadNibNamed("RegisterOrLaunchViewController", owner: nil, options: nil)?.first as! RegisterOrLaunchViewController
        toVc.isNeedRootPage = false
        vc?.present(toVc, animated: true, completion: {
            
        })
    }
    
    //MARK:判断是否联网成功
    class func isNetWorkSuccess(str:String?) -> Bool {
        if str == nil {
            return false
        }
        if "SUCCESS".elementsEqual(str!){
            return true
        }
        return false
    }
    
    //MARK:网络状态检查
    class func lgyReachabilityStatus() ->Void {
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status) in
            switch status {
            case .unknown :
                break
                case .notReachable :
                    _ = LGYAlertViewSimple.show(title: "网络连接已断开！", buttonStr: "确定")
                break
                case .reachableViaWiFi :
                    
                break
                case .reachableViaWWAN :
                    
                break
            }
            
        }
        AFNetworkReachabilityManager.shared().startMonitoring()
    }
    
    private class func getCahePaht()->String{
        return "/Library/Caches/NetWorkCache";
    }
    
    //MARK:保存缓存
    private class func readNetWorkCahe(key:String?) ->Data?{
        if key == nil {
            return nil
        }
        return LGYTool.readToFile(homeFolder: getCahePaht(), fileName: key!)
    }
    
    //MARK:保存缓存
    private class func writeNetWorkCahe(key:String?,data:Data) ->Void{
        if key == nil {
            return
        }
        LGYTool.writeToFile(homeFolder: getCahePaht(), fileName: key!, data: data)
    }
    
    
    
    
    
    //
    //    class func lgyGET(urlString: String, parameters: [String:Any]?,progress:UIProgressView?,responseBlock:((_ responseObject:Any?,_ isError:Bool)->Void)?) ->Void{
    //
    //        let manager = AFHTTPSessionManager();
    //        //申明返回的结果是json类型
    //        manager.responseSerializer = AFJSONResponseSerializer()
    //        //申明请求的数据是json类型
    //        manager.requestSerializer = AFJSONRequestSerializer()
    //        manager.get(urlString, parameters: parameters, progress: { (press) in
    //
    //        }, success: { (dataTask, any) in
    //             print("\n",urlString,"\n",parameters)
    //             lgyObjectReturnBlock(any: any,cacheName:nil, responseBlock: responseBlock)
    //        }) { (dataTask, error) in
    //            _ = LGYAlertViewSimple.show(title: error.localizedDescription, buttonStr: "确定")
    //            responseBlock?(error.localizedDescription, true)
    //            LBuyly.lBuglyError(error: error)
    //        }
    //    }
    
    //    class func lgyGET(urlString: String, parameters: [String:Any]?,progress:UIProgressView?,cacheName:String?,responseBlock:((_ responseObject:Any?,_ isError:Bool)->Void)?) ->Void{
    //
    //
    //        if cacheName != nil{
    //            let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    //            if !appDelegate.isExistCacheNameUse(cacheName: cacheName!){
    //                let data = readNetWorkCahe(key: cacheName)
    //                if data != nil {
    //                    let JSONString = NSString(data:data!,encoding: String.Encoding.utf8.rawValue)
    //                    responseBlock?(JSONString, false)
    //                }
    //            }
    //        }
    //        let manager = AFHTTPSessionManager();
    //        //申明返回的结果是json类型
    //        manager.responseSerializer = AFJSONResponseSerializer()
    //        //申明请求的数据是json类型
    //        manager.requestSerializer = AFJSONRequestSerializer()
    //        manager.get(urlString, parameters: parameters, progress: { (press) in
    //
    //        }, success: { (dataTask, any) in
    //             print("\n",urlString,"\n",parameters,any)
    //            lgyObjectReturnBlock(any: any,cacheName:cacheName, responseBlock: responseBlock)
    //        }) { (dataTask, error) in
    //             print("error  ",error)
    //            _ = LGYAlertViewSimple.show(title: error.localizedDescription, buttonStr: "确定")
    //            responseBlock?(error.localizedDescription, true)
    //            LBuyly.lBuglyError(error: error)
    //        }
    //    }
    
    
    
    
}
