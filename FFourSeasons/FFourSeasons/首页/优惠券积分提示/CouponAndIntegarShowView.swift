//
//  CouponAndIntegarShowView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class CouponAndIntegarShowView: UIView {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
//    var <#name#> = <#value#>
    
    
    class func defaultView() -> CouponAndIntegarShowView? {
        if let view = Bundle.main.loadNibNamed("CouponAndIntegarShowView", owner: nil, options: nil)?.first as? CouponAndIntegarShowView{
            view.backView.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(cancle)))
            return view
        }
        return nil
    }
    
    
    func loadWithArray() -> Void {
        
    }

    func show() -> Void {
        if let vindow = UIApplication.shared.keyWindow{
            self.frame = vindow.bounds
            vindow.addSubview(self)
        }
    }
    
    
    @IBAction func action(_ sender: UIButton) {
        cancle()
    }
    
    @objc func cancle() -> Void {
        
    }
}
