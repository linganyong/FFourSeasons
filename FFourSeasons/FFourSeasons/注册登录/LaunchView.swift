//
//  LaunchView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/9.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class LaunchView: UIView,UITextFieldDelegate {

  
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var line1View: UIView!
    @IBOutlet weak var passworkTextField: UITextField!
    weak var viewController:UIViewController?
    
    func viewStyle(vController:UIViewController) -> Void {
        viewController = vController
        setCornerRadiusAndShadowView()
        setTextFieldDelegate()
        setLineView()
    }
    
    //MARK:textField设置代理
    func setTextFieldDelegate() -> Void {
        phoneNumberTextField.delegate = self
        passworkTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK:监听控制输入
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //控制手机输入位数
        if (textField.text?.count)! + string.count - range.length > 36{
            return false
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
        return true
    }
    
    //MARK:判断是否可以登录
    func isCanLaunch()->Bool {
        if !LGYTool.isMobileNumber(mobileNum: phoneNumberTextField.text!){
            viewController?.alertView(_title: "手机号码有误！", _message: "请输入正确的手机号码!", _bText: "确定")
            return false
        }
        if passworkTextField.text!.count < 6 {
            viewController?.alertView(_title: "密码有误！", _message: "请输入正确的密码，密码长度不能少于6位!", _bText: "确定")
            return false
        }
        
        return true
    }
    
    //MARK:geitextField设置提示Label
    private func cornerAdd(view:UIView?,text:String,textColor:UIColor){
        if view == nil {
            return
        }
        var label = view?.viewWithTag(100) as? UILabel
        if label == nil {
            label = UILabel.init(frame: CGRect(x: 0, y: (view?.frame.size.height)!-10, width: (view?.frame.size.width)!-20 , height: 20))
            label?.tag = 100
            view?.addSubview(label!)
        }
        label?.font = UIFont.systemFont(ofSize: 10)
        label?.text = text;
        label?.textAlignment = .right
        label?.textColor = textColor
    }
    
    //MARK:设置划分线
    func setLineView() -> Void {
        LGYTool.drawDottedLine(view: line1View, color: UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1))
    }
    
    //MARK:设置view的圆角和阴影
    func setCornerRadiusAndShadowView() -> Void {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        LGYTool.viewLayerShadow(view: self.backView)
    }
    

    
}
