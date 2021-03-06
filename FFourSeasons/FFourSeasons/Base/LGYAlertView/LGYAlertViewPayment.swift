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
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
        @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var textField6: UITextField!

    var _inPutStrLength = 1

    
    var callBlock:LGYAlertViewPaymentCallBlock?
    
    class func show(title:String) ->LGYAlertViewPayment{
        let view = Bundle.main.loadNibNamed("LGYAlertViewPayment", owner: nil, options: nil)?.first as!LGYAlertViewPayment
        view.frame = UIScreen.main.bounds
        view.titleLabel.text = title
        UIApplication.shared.keyWindow?.addSubview(view)
        
        let tap = UITapGestureRecognizer.init(target: view, action: #selector(removeFromSuperview))
        view.addGestureRecognizer(tap)
        view.textField1.delegate = view
        view.textField2.delegate = view
        view.textField3.delegate = view
        view.textField4.delegate = view
        view.textField5.delegate = view
        view.textField6.delegate = view
        view.textField1.becomeFirstResponder()
        return view
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField1 == textField {
            textField2.becomeFirstResponder()
        }else if textField2 == textField {
            textField3.becomeFirstResponder()
        }else if textField3 == textField {
            textField4.becomeFirstResponder()
        }else if textField4 == textField {
            textField5.becomeFirstResponder()
        }else if textField5 == textField {
            textField6.becomeFirstResponder()
        }
        
        let text = String(format: "%@%@%@%@%@%@", textField1.text!, textField2.text!,textField3.text!,textField4.text!, textField5.text!,textField6.text!)
        
        if text.count == _inPutStrLength*6{
            callBlock?(text)
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
