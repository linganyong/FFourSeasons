//
//  ChangePayPassworkViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/2.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

enum ChangePassworkType : Int {
    case PayPasswork = 1
    case LaunchPasswork = 2
}

class ChangePayPassworkViewController: UIViewController,UITextFieldDelegate {
    var rightBarItem:UIBarButtonItem!
    
    @IBOutlet weak var passworkAgainTF: UITextField!
    @IBOutlet weak var passworkTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var verificationCodeView: UIView!
    @IBOutlet weak var passworkView: UIView!
    @IBOutlet weak var passworkAgainView: UIView!
    var type:ChangePassworkType = ChangePassworkType.PayPasswork
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置修改密码"
        navigationItemBack(title: "    ")
        viewLayerShadow()
        rightBarItem = navigationBarAddRightItem(_imageName: "黑色确定", target: self, action: #selector(rightBarAction))
        setBackgroundColor()
        setTextFieldDelegate()
    }
    
    //MARK:导航栏右边按钮响应事件
    @objc func rightBarAction() ->Void{
        loadChange()
    }
    
    func viewLayerShadow() -> Void {
        LGYTool.viewLayerShadow(view: phoneView)
        LGYTool.viewLayerShadow(view: verificationCodeView)
        LGYTool.viewLayerShadow(view: passworkView)
        LGYTool.viewLayerShadow(view: passworkAgainView)
        if type == .PayPasswork{
            self.title = "设置修改支付密码"
            let phone = PersonViewController.infornation?.phone
            //        let startIndex = phone?.index((phone?.startIndex)!, offsetBy: 3)
            //        let endIndex = phone?.index((phone?.startIndex)!, offsetBy: 7)
            if let range = phone?.lgyRange(nsRange: NSMakeRange(2, 6)){
                phoneTF.text =  phone?.replacingCharacters(in:range , with: "******")
            }
            phoneTF.isEnabled = false
        }
        
    }
    
    func setTextFieldDelegate() -> Void {
        phoneTF.delegate = self;
        codeTF.delegate = self
        passworkTF.delegate = self
        passworkAgainTF.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func codeAction(_ sender: Any) {
        if !LGYTool.isMobileNumber(mobileNum: phoneTF.text!){
            //            viewController?.alertView(_title: "提示", _message: "请输入正确的手机号码!", _bText: "确定")
            LGYToastView.show(message: "请输入正确的手机号码!")
            return
        }
        var codeType = "1"
        if type == .PayPasswork{
            codeType = "2"
        }
        LGYAFNetworking.lgyPost(urlString: APIAddress.sms_verificationCode, parameters: ["phone":phoneTF.text!,"verifyType":codeType], progress: nil) { (object,isError) in
            if !isError{
                let model = Model_sms_verificationCode.yy_model(withJSON: object)
                if let msg = model?.msg {
                    LGYToastView.show(message: msg)
                }
            }
        }
    }
    
    //MARK:监听控制输入
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //控制手机输入位数
        if (textField.text?.count)! + string.count - range.length > 36{
            return false
        }
        
        if textField == phoneTF{
            //控制手机输入位数
            if (textField.text?.count)! + string.count - range.length > 11{
                return false
            }
            let str = (textField.text! as NSString) .replacingCharacters(in: range, with: string)
            //验证手机输是否正确
            if !LGYTool.isMobileNumber(mobileNum: str){
                LGYTool.cornerAdd(view: textField, text: "手机号码不正确",textColor: UIColor.red)
                
            }else{
                LGYTool.cornerAdd(view: textField, text: "",textColor: UIColor.red)
            }
        }
        if textField == passworkAgainTF {
            let str = (textField.text! as NSString) .replacingCharacters(in: range, with: string)
            //验证码是否一致
            if (passworkTF.text?.count)! > 0 {
                if !(passworkTF.text?.elementsEqual(str))! {
                    cornerAdd(view: textField, text: "输入密码不一致",textColor: UIColor.red)
                }else{
                    cornerAdd(view: textField, text: "",textColor: UIColor.red)
                }
            }
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
    
    
    //MARK:修改密码
    func loadChange(){
        if (codeTF.text?.count)!  < 4 || (codeTF.text?.count)! < 4{
            LGYToastView.show(message: "请输入手机接收到的信息信息！")
            return
        }
        if !LGYTool.isMobileNumber(mobileNum: phoneTF.text){
            LGYToastView.show(message: "手机号码不正确！")
            return
        }
        if passworkAgainTF.text == nil || passworkTF.text == nil {
            LGYToastView.show(message: "密码不能为空！")
            return
        }
        if passworkAgainTF.text != passworkTF.text{
            LGYToastView.show(message: "密码输入不正确！")
            return
        }
        weak var vc = self
        if type == .PayPasswork{
            LGYAFNetworking.lgyPost(urlString: APIAddress.api_alterPayPw, parameters: ["token":Model_user_information.getToken(),"phone":phoneTF.text!,"code":codeTF.text!,"password":passworkTF.text!], progress: nil) { (object, isError) in
                if isError{
                    return
                }
                let model = Model_user_information.yy_model(withJSON: object)
                vc?.isFinish(model: model)
            }
        }
        if type == .LaunchPasswork{
            LGYAFNetworking.lgyPost(urlString: APIAddress.api_alterPw, parameters: ["token":Model_user_information.getToken(),"phone":phoneTF.text!,"code":codeTF.text!,"password":passworkTF.text!], progress: nil) { (object, isError) in
                if isError{
                    return
                }
                let model = Model_user_information.yy_model(withJSON: object)
                vc?.isFinish(model: model)
            }
        }
    }
    
    //MARK:修改完成
    func isFinish(model:Model_user_information?){
        if model != nil {
            if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                if model?.msg == nil{
                    model?.msg = "修改成功"
                }
                _ = LGYToastView.show(message: (model?.msg!)!, timeInterval: 0.5, block: {
                    
                    if self.type == .LaunchPasswork{
                        let ss = "ashf4lasjd%&fhasdh9sdih"
                        //设置原来密码为空
                        let passwordItem = KeychainConfiguration.get(forKey: ss)
                        KeychainConfiguration.save(userName: (passwordItem?.account)!, passwork: "", forKey: ss)
                        let vc = Bundle.main.loadNibNamed("RegisterOrLaunchViewController", owner: nil, options: nil)?.first as! RegisterOrLaunchViewController
                        vc.isNeedRootPage = false
                        self.present(vc, animated: true, completion: {
                            
                        })
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }else{
                if model?.msg != nil{
                    LGYToastView.show(message: model!.msg!)
                }
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBarStyle(type:.White)
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarStyle(type:.White)
        self.navigationItem.rightBarButtonItems = [rightBarItem]
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.rightBarButtonItems = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
