//
//  LGYAlertView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

typealias LGYAlertViewCallBlock = (_ key:String,_ text:String?) ->Void

class LGYAlertView: UIView {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var callBlock:LGYAlertViewCallBlock?
    
    class func show(title:String,placeholder:String,leftStr:String,rightStr:String) ->LGYAlertView{
        let view = Bundle.main.loadNibNamed("LGYAlertView", owner: nil, options: nil)?.first as!LGYAlertView
        view.frame = UIScreen.main.bounds
        view.titleLabel.text = title
        view.textField.placeholder = placeholder
        view.leftButton.setTitle(leftStr, for: .normal)
        view.rightButton.setTitle(rightStr, for: .normal)
        UIApplication.shared.keyWindow?.addSubview(view)
        
        let tap = UITapGestureRecognizer.init(target: view, action: #selector(removeFromSuperview))
        view.addGestureRecognizer(tap)
        return view
    }
    
   
    
    @IBAction func Action(_ sender: UIButton) {
        callBlock?(sender.LGYLabelKey!,self.textField.text)
        self.removeFromSuperview()
    }
    

}
