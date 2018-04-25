//
//  LaunchView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/15.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class VIPLaunchView: UIView,UITextFieldDelegate {
    var viewController:UIViewController?
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passworkTextField: UITextField!
    
    
    class func defaultView()->VIPLaunchView{
        let view = Bundle.main.loadNibNamed("VIPLaunchView", owner: nil, options: nil)?.first as! VIPLaunchView
        return view;
    }
    
    func cController(vController:UIViewController) -> Void {
        viewController = vController
        setTextFieldDelegate()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationCenter(notification:)), name: NSNotification.Name(rawValue: NotificationCenterLaunch), object: nil)
    }
    
    func show()->Void{
        self.frame = (viewController?.view.bounds)!
        viewController?.view.addSubview(self)
    }
    
    @objc func notificationCenter(notification:Notification)->Void{
        let flag = notification.object as! Bool
        if flag{
            self.removeFromSuperview()
        }
    }
    
    @IBAction func launchAction(_ sender: UIButton) {
        if isCanLaunch(){
            RegisterOrLaunchViewController.api_launch(userName: phoneNumberTextField.text!, passwork: passworkTextField.text!)
        }
        
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        let vc = Bundle.main.loadNibNamed("RegisterOrLaunchViewController", owner: nil, options: nil)?.first as! RegisterOrLaunchViewController
        vc.isNeedRootPage = false
        viewController?.present(vc, animated: true) {
            self.removeFromSuperview()
        }
        vc.changeLaunchOrRegister()
    }
    
    @IBAction func forgetAction(_ sender: UIButton) {
        let vc = Bundle.main.loadNibNamed("ChangePayPassworkViewController", owner: nil, options: nil)?.first as! ChangePayPassworkViewController
        vc.title = "找回密码"
        vc.type = .LaunchPasswork
        viewController?.navigationController?.pushViewController(vc, animated: true)
        self.removeFromSuperview()
        
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
            LGYToastView.show(message: "请输入正确的手机号码!");
            return false
        }
        if passworkTextField.text!.count < 6 {
            LGYToastView.show(message: "请输入正确的密码，密码长度不能少于6位!")
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
    
    //MARK:设置view的圆角和阴影
    func setCornerRadiusAndShadowView() -> Void {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
}
