//
//  LGY+UIimage.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/2.
//  Copyright © 2018年 LGY. All rights reserved.
//

import UIKit

extension UIImage {
    
    //MARK:保存图片至沙盒
    func lGYSaveImage(persent: CGFloat, imageName: String){
        if let imageData = UIImageJPEGRepresentation(self, persent) as NSData? {
            let fullPath = NSHomeDirectory().appending("/Documents/").appending(imageName)
            imageData.write(toFile: fullPath, atomically: true)
        }
    }
    
    //MARK:通过网络图片替换本地图片
    class func lGYLocalImageChageToImage(imageName:String,toImageUrl:String,persent: CGFloat) -> Void {
        //首先, 需要获取路径
        let name = "01474d58f84d01a8012049efb7a609.png"
        let pathName = Bundle.main.path(forResource: name, ofType: nil)
        // 拼接图片的路径
        let imageFilePath = URL(fileURLWithPath: pathName ?? "").absoluteString
        //获取网络请求中的url地址
        UIImage.image(fromURL: toImageUrl, placeholder:UIImage.init(named: name)!, closure: { (image) in
            if(image != nil){
                //转换为图片保存到以上的沙盒路径中
                if let imageData = UIImageJPEGRepresentation(image!, persent) as NSData? {
                    if imageData.write(toFile: imageFilePath, atomically: true){
                        NSLog(">>>>> --localImageChageToImage- true")
                    }
                }
            }
        })
    }
    
    //MARK:错误收集
    class func lGYDoError(error:Error) -> Void {
        LBuyly.lBuglyError(error: error)
    }
}

