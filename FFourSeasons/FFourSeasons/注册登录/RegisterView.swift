//
//  RegisterView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/9.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class RegisterView: UIView,UITextFieldDelegate {

    //上层的View，承载着注册相关之类
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var line1View: UIView!
    @IBOutlet weak var line2View: UIView!
    @IBOutlet weak var line3View: UIView!
    

    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var passworkTextField: UITextField!
    @IBOutlet weak var passworkAgainTextField: UITextField!
    @IBOutlet weak var verificationTextField: UITextField!
    @IBOutlet weak var verficationButton: UIButton!
        weak var viewController:UIViewController?
    
    func viewStyle(vController:UIViewController) -> Void {
        viewController = vController
        setCornerRadiusAndShadowView()
        setTextFieldDelegate()
        setLineView()
    }
   
    //MARK:设置划分线
    func setLineView() -> Void {
        let color = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        LGYTool.drawDottedLine(view: line1View, color: color)
        LGYTool.drawDottedLine(view: line2View, color: color)
        LGYTool.drawDottedLine(view: line3View, color: color)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:textField设置代理
    func setTextFieldDelegate() -> Void {
        passworkAgainTextField.delegate = self
        passworkTextField.delegate = self
        phoneNumberTextField.delegate = self
        verificationTextField.delegate = self
    }
    
    //MARK:监听控制输入
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //控制手机输入位数
        if (textField.text?.count)! + string.count - range.length > 36{
            return false
        }
        
        if textField == verificationTextField{
            //控制验证码输入位数
            if (textField.text?.count)! + string.count - range.length > 6{
                return false
            }
        }
        
        if textField == phoneNumberTextField{
            //控制手机输入位数
            if (textField.text?.count)! + string.count - range.length > 11{
                return false
            }
            let str = (textField.text! as NSString) .replacingCharacters(in: range, with: string)
            //验证手机输是否正确
            if !LGYTool.isMobileNumber(mobileNum: str){
                cornerAdd(view: textField, text: "手机号码不正确",textColor: UIColor.red)
                
            }else{
                cornerAdd(view: textField, text: "",textColor: UIColor.red)
            }
        }
        
        if textField == passworkAgainTextField {
            let str = (textField.text! as NSString) .replacingCharacters(in: range, with: string)
            //验证码是否一致
            if (passworkTextField.text?.count)! > 0 {
                if !(passworkTextField.text?.elementsEqual(str))! {
                    cornerAdd(view: textField, text: "输入密码不一致",textColor: UIColor.red)
                }else{
                    cornerAdd(view: textField, text: "",textColor: UIColor.red)
                }
            }
        }
        
        return true
    }
    
    //MARK:geitextField设置提示Label
    func cornerAdd(view:UIView?,text:String,textColor:UIColor){
        if view == nil {
            return
        }
        var label = view?.viewWithTag(100) as? UILabel
        if label == nil {
            label = UILabel.init(frame: CGRect(x: 0, y: 0, width: (view?.frame.size.width)!-8 , height: (view?.frame.size.height)!))
            label?.tag = 100
            view?.addSubview(label!)
        }
        label?.font = UIFont.systemFont(ofSize: 10)
        label?.text = text;
        label?.textAlignment = .right
        label?.textColor = textColor
    }
    
    //MARK:判断是否可以注册
     func isCanRegister() ->Bool{
        if !LGYTool.isMobileNumber(mobileNum: phoneNumberTextField.text!){
//            viewController?.alertView(_title: "提示", _message: "请输入正确的手机号码!", _bText: "确定")
            LGYToastView.show(message: "请输入正确的手机号码!")
            return false
        }
        if (passworkTextField.text?.count)!  < 6 || (passworkTextField.text?.count)! < 6{
            LGYToastView.show(message: "请输入正确的密码，密码长度不能少于6位!")
//            viewController?.alertView(_title: "提示", _message: "请输入正确的密码，密码长度不能少于6位!", _bText: "确定")
            return false
        }
        if passworkTextField.text == nil || passworkAgainTextField.text == nil{
            LGYToastView.show(message: "密码不能为空！")
            //            viewController?.alertView(_title: "提示", _message: "两次输入的密码不相等!", _bText: "确定")
            return false
        }
        if !(passworkTextField.text?.elementsEqual(passworkAgainTextField.text!))!{
            LGYToastView.show(message: "两次输入的密码不相等！")
//            viewController?.alertView(_title: "提示", _message: "两次输入的密码不相等!", _bText: "确定")
            return false
        }
        if (verificationTextField.text?.count)!  < 4 || (passworkTextField.text?.count)! < 4{
            LGYToastView.show(message: "请输入手机接收到的信息信息！")
//            viewController?.alertView(_title: "提示", _message: "请输入手机接收到的信息信息!", _bText: "确定")
            return false
        }
        return true
    }
    
    //MARK:判断是否可以获取验证码
    func isCanGetVercifitionCode() ->Bool{
        
        if !LGYTool.isMobileNumber(mobileNum: phoneNumberTextField.text!){
            //            viewController?.alertView(_title: "提示", _message: "请输入正确的手机号码!", _bText: "确定")
            LGYToastView.show(message: "请输入正确的手机号码!")
            return false
        }
        if (passworkTextField.text?.count)!  < 6 || (passworkTextField.text?.count)! < 6{
            LGYToastView.show(message: "请输入正确的密码，密码长度不能少于6位!")
            //            viewController?.alertView(_title: "提示", _message: "请输入正确的密码，密码长度不能少于6位!", _bText: "确定")
            return false
        }
        if !(passworkTextField.text?.elementsEqual(passworkAgainTextField.text!))!{
            LGYToastView.show(message: "两次输入的密码不相等！")
            //            viewController?.alertView(_title: "提示", _message: "两次输入的密码不相等!", _bText: "确定")
            return false
        }
        return true
    }
   
    //MARK:设置view的圆角和阴影
    func setCornerRadiusAndShadowView() -> Void {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        LGYTool.viewLayerShadow(view: backView)
        
    }
    

}
