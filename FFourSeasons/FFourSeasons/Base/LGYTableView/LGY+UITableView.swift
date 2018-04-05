//
//  LGY+UITableView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit
private var LGYDataScoureKey:Array<Any>?
private var LGYPageIndexKey:NSInteger?
private var LGYIsLoadingKey:Bool?
private var LGYtypeKey:String?
extension UITableView {
    //MARK:扩展属性,展示数据源
    var lgyDataScoure: Array<Any>! {
        get {
            if objc_getAssociatedObject(self, &LGYDataScoureKey)  == nil {
                return nil
            }
            return objc_getAssociatedObject(self, &LGYDataScoureKey) as? Array<Any>
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGYDataScoureKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    //MARK:分页第几页
    var lgyPageIndex: NSInteger! {
        get {
            if objc_getAssociatedObject(self, &LGYPageIndexKey)  == nil {
                return 0
            }
            return objc_getAssociatedObject(self, &LGYPageIndexKey) as? NSInteger
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGYPageIndexKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    //MARK:分页第几页
    var lgyTypeKey: String? {
        get {
            return objc_getAssociatedObject(self, &LGYtypeKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGYtypeKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //MARK:isLoading
    var lgyIsLoading: Bool! {
        get {
            if objc_getAssociatedObject(self, &LGYIsLoadingKey)  == nil {
                return false
            }
            return objc_getAssociatedObject(self, &LGYIsLoadingKey) as? Bool
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGYIsLoadingKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
   
}
