//
//  CouponRuleView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/21.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class CouponRuleView: UIView {

    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var connetLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
   
    
    class func defaultView()->CouponRuleView{
        return Bundle.main.loadNibNamed("CouponRuleView", owner: nil, options: nil)?.first as! CouponRuleView
        
    }
    
    func setText(title:String,text:String) -> Void {
        titleLabel.text = title;
        connetLabel.text = text;
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancle)))
    }
    
    func show()->Void{
        if let window = UIApplication.shared.keyWindow{
            self.frame = window.bounds
            window.addSubview(self)
        }
    }
    
    @IBAction func action(_ sender: UIButton) {
        cancle()
    }
    @objc func cancle(){
        self.removeFromSuperview()
    }
    

}
