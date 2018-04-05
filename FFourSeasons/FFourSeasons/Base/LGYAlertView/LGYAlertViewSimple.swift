//
//  LGYAlertViewSimple.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

typealias LGYAlertViewSimpleCallBlock = (_ position:Int) ->Void

class LGYAlertViewSimple: UIView {
    static let view = Bundle.main.loadNibNamed("LGYAlertViewSimple", owner: nil, options: nil)?.first as!LGYAlertViewSimple
    @IBOutlet weak var leftBtnWidthLC: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!

    @IBOutlet weak var butttonRight: UIButton!
    
    var callBlock:LGYAlertViewSimpleCallBlock?
    
    class func show(title:String,buttonStr:String) ->LGYAlertViewSimple{
        
        view.frame = UIScreen.main.bounds
        view.titleLabel.text = title
        
        view.button.setTitle(buttonStr, for: .normal)
        UIApplication.shared.keyWindow?.addSubview(view)
        
        let tap = UITapGestureRecognizer.init(target: view, action: #selector(removeFromSuperview))
        view.addGestureRecognizer(tap)
        view.leftBtnWidthLC.constant = UIScreen.main.bounds.size.width*7/10
        view.layoutIfNeeded()
        return view
    }
    
    class func show(title:String,leftStr:String,rightStr:String) ->LGYAlertViewSimple{
        let view = Bundle.main.loadNibNamed("LGYAlertViewSimple", owner: nil, options: nil)?.first as!LGYAlertViewSimple
        view.frame = UIScreen.main.bounds
        view.titleLabel.text = title
        
        view.button.setTitle(leftStr, for: .normal)
        view.butttonRight.setTitle(rightStr, for: .normal)
        UIApplication.shared.keyWindow?.addSubview(view)
        
        let tap = UITapGestureRecognizer.init(target: view, action: #selector(removeFromSuperview))
        view.addGestureRecognizer(tap)
        view.leftBtnWidthLC.constant = (UIScreen.main.bounds.size.width*7/10)/2
        view.layoutIfNeeded()
        return view
    }
   
    
    @IBAction func Action(_ sender: UIButton) {
        callBlock?(sender.tag)
        self.removeFromSuperview()
    }
    

}
