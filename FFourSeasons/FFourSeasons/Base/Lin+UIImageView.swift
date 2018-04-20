//
//  LGY+UIImageView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/20.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import Foundation
import UIKit

private var LGyImageNameKey:String?

extension UIImageView{
    //MARK:位IB设置圆角
    @IBInspectable var LGyImageName:String? {
        get {
            return objc_getAssociatedObject(self, &LGyImageNameKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGyImageNameKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            if let str = newValue{
                self.image = reSizeImage(image: UIImage(named:str as String))
            }
            
        }
    }
    
    /**
     *  图片去锯齿
     */
    func reSizeImage(image:UIImage?)->UIImage?{
        if image == nil{
            return nil;
        }
        UIGraphicsBeginImageContextWithOptions(image!.size,false,0.0);
        image?.draw(in:CGRect(x: 0, y: 0, width:image!.size.width, height:image!.size.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
}
