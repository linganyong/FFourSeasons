//
//  Lin+MAAnnotationView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit
private var LGYViewTagKey:NSInteger?
extension MAAnnotationView {
    //MARK:扩展属性
    var lgyTag: NSInteger! {
        get {
            if objc_getAssociatedObject(self, &LGYViewTagKey)  == nil {
                return -1
            }
            return objc_getAssociatedObject(self, &LGYViewTagKey) as? NSInteger
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGYViewTagKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
