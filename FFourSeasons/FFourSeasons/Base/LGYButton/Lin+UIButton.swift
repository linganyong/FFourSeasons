//
//  Lin+UIButton.swift
//  Created by LGY on 2018/1/9.
//  Copyright © 2018年 . All rights reserved.
//

import Foundation
import UIKit

enum ButtonShowImage:Int {
    case ButtonShowImageDefault = 1
    case ButtonShowImageSelect = 2
}

typealias Callbackfunc = ()->Void
private var LGYTouchesBeganKey: Void?
private var LGYtouchesEndedKey: Void?
private var LGYLabelKeyKey:String?
private var LGyNormalImageNameKey:String?

extension UIButton{
    
    //MARK:扩展String属性,用于自定义标记button
    @IBInspectable var LGYLabelKey: String? {
        get {
            return objc_getAssociatedObject(self, &LGYLabelKeyKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGYLabelKeyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //MARK:扩展闭包属性，监听点击开始
     var LGYTouchesBegan: Callbackfunc? {
        get {
            return objc_getAssociatedObject(self, &LGYTouchesBeganKey) as? Callbackfunc
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGYTouchesBeganKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
    //MARK:扩展闭包属性，简单点击结束
    var LGYTouchesEnded: Callbackfunc? {
        get {
            return objc_getAssociatedObject(self, &LGYtouchesEndedKey) as? Callbackfunc
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGYtouchesEndedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
     //MARK:重写点击开始
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.LGYTouchesBegan?()
    }
    
    //MARK:重写点击结束
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
         self.LGYTouchesEnded?()
    }
    
    //MARK:位IB设置圆角
    @IBInspectable var LGyNormalImageName:String? {
        get {
            return objc_getAssociatedObject(self, &LGyNormalImageNameKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGyNormalImageNameKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            if let str = newValue{
                self .setImage(reSizeImage(image: UIImage(named:str as String)), for: .normal)
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
//    
//    /**
//     *  重设图片大小
//     */
//    func reSizeImage(image:UIImage？)->UIImage？ {
//        //        UIGraphicsBeginImageContext(reSize);
//        if image == nil{
//            return nil;
//        }
//        let scale = self.size.width/self.size.height
//        var height = reSize.height
//        var width = reSize.width
//        if scale > 1{
//            height = width/scale
//        }else{
//            width = height*scale
//        }
//        
//        UIGraphicsBeginImageContextWithOptions(reSize,false,0.0);
//        self.draw(in:CGRect(x: 0, y: 0, width:width, height:height));
//        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
//        UIGraphicsEndImageContext();
//        return reSizeImage;
//    }
}
