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
    @IBInspectable var LGYTouchesBegan: Callbackfunc? {
        get {
            return objc_getAssociatedObject(self, &LGYTouchesBeganKey) as? Callbackfunc
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGYTouchesBeganKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
    //MARK:扩展闭包属性，简单点击结束
    @IBInspectable var LGYTouchesEnded: Callbackfunc? {
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
    
    
}
