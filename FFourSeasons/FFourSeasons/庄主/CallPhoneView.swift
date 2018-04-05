//
//  CallPhoneView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class CallPhoneView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func action(_ sender: UIButton) {
        
    }
    
    class func show(tel:String,leftStr:String,rightStr:String) ->Void{
        let view = Bundle.main.loadNibNamed("CallPhoneView", owner: nil, options: nil)?.first as! CallPhoneView
        view.titleLabel.text = tel
    
    
    }
    
    
}
