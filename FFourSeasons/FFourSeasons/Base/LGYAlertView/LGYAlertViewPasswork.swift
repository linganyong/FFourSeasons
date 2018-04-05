//
//  LGYAlertViewPayment.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

typealias LGYAlertViewPaymentCallBlock = (_ text:String) ->Void

class LGYAlertViewPayment: UIView,UITextFieldDelegate {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var _inPutStrLength = 6

    
    var callBlock:LGYAlertViewPaymentCallBlock?
    
    class func show(title:String,placeholder:String,inPutStrLength:Int) ->LGYAlertViewPayment{
        let view = Bundle.main.loadNibNamed("LGYAlertViewPayment", owner: nil, options: nil)?.first as!LGYAlertViewPayment
        view.frame = UIScreen.main.bounds
        view.titleLabel.text = title
        view.textField.placeholder = placeholder
        UIApplication.shared.keyWindow?.addSubview(view)
        
        let tap = UITapGestureRecognizer.init(target: view, action: #selector(removeFromSuperview))
        view.addGestureRecognizer(tap)
        view.textField.delegate = view
        view._inPutStrLength = inPutStrLength
        return view
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == _inPutStrLength{
            callBlock?(textField.text!)
            self.removeFromSuperview()
        }
    }
    
    //MARK:监听控制输入
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //控制手机输入位数
        let count = (textField.text?.count)! + string.count - range.length
        if count  == _inPutStrLength{
            UIView.animate(withDuration: 0.1, animations: {
                
            }, completion: { (finish) in
                textField.resignFirstResponder()
            })
            return true
        }else if count > _inPutStrLength{
            return false
        }
       
        return true
    }
    

    
}
