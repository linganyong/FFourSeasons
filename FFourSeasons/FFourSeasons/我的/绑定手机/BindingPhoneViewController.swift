//
//  BindingPhoneViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit


class BindingPhoneViewController: UIViewController,UITextFieldDelegate {
    var rightBarItem:UIBarButtonItem!
    @IBOutlet weak var phoneBackView: UIView!
    @IBOutlet weak var VerificationCodeBackView: UIView!
    
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
     weak var persionVC:PersioninformationViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "绑定手机号码"
        viewLayerShadow()
        rightBarItem = navigationBarAddRightItem(_imageName: "黑色确定", target: self, action: #selector(rightBarAction))
        setBackgroundColor()
        setTextViewDelegate()
    }
    
    func setTextViewDelegate() -> Void {
        phoneTextField.delegate = self;
        numberTF.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:监听控制输入
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //控制手机输入位数
        if (textField.text?.count)! + string.count - range.length > 11{
            return false
        }
        
        if textField == phoneTextField{
            //控制手机输入位数
            if (textField.text?.count)! + string.count - range.length > 11{
                return false
            }
            let str = (textField.text! as NSString) .replacingCharacters(in: range, with: string)
            //验证手机输是否正确
            if !LGYTool.isMobileNumber(mobileNum: str){
                LGYTool.cornerAdd(view: textField, text: "手机号码不正确",textColor: UIColor.red)
                
            }else{
                LGYTool.cornerAdd(view: textField, text: "手机号码正确",textColor: UIColor.red)
            }
        }
        return true
    }
    func viewLayerShadow() ->Void{
        LGYTool.viewLayerShadow(view: phoneBackView)
        LGYTool.viewLayerShadow(view: VerificationCodeBackView)
    }

    //MARK:导航栏右边按钮响应事件
    @objc func rightBarAction() ->Void{
        if phoneTextField.text == nil || phoneTextField.text?.count == 0{
            LGYTool.cornerAdd(view: phoneTextField, text: "手机号码不正确",textColor: UIColor.red)
            return
        }
        //验证手机输是否正确
        if !LGYTool.isMobileNumber(mobileNum: phoneTextField.text!){
            LGYTool.cornerAdd(view: phoneTextField, text: "手机号码不正确",textColor: UIColor.red)
            return
        }
        if numberTF.text == nil ||  numberTF.text?.count == 0 {
            LGYToastView.show(message: "请输入验证码！")
            return
        }
        loadDataScoure()
        
        
    }
    
    @IBAction func codeAction(_ sender:VerificationCodeCountdownButton) {
        if phoneTextField.text == nil || phoneTextField.text?.count == 0{
            LGYTool.cornerAdd(view: phoneTextField, text: "手机号码不正确",textColor: UIColor.red)
            return
        }
        //验证手机输是否正确
        if !LGYTool.isMobileNumber(mobileNum: phoneTextField.text!){
            LGYTool.cornerAdd(view: phoneTextField, text: "手机号码不正确",textColor: UIColor.red)
            return
        }
        sender.setRun(count: 60, time: 1)
        LGYAFNetworking.lgyPost(urlString: APIAddress.sms_verificationCode, parameters: ["phone":phoneTextField.text!], progress: nil) { (object,isError) in
            if !isError{
                let model = Model_sms_verificationCode.yy_model(withJSON: object as Any)
                LGYToastView.show(message: (model?.msg)!)
            }
        }
    }
    //MARK:加载数据
    func loadDataScoure() -> Void {
        weak var vc = self
        //MARK:加载产品分类信息
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_bindPhone,
                                parameters: ["phone":phoneTextField.text!
                                    ,"code":numberTF.text!
                                    ,"token":Model_user_information.getToken()]
        , progress: nil) { (object,isError) in
            if isError {
                return
            }
            let model = Model_user_information.yy_model(withJSON: object as Any)
            if model != nil{
                if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                _ = LGYToastView.show(message:  (model?.msg)!, timeInterval: 0.5) {
                    vc?.persionVC?.phoneLabel?.text = vc?.phoneTextField.text
                    vc?.navigationController?.popViewController(animated: true)
                }
                }else{
                    LGYToastView.show(message: (model?.msg)!)
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
         setNavigationBarStyle(type:.Default)
        self.navigationItem.rightBarButtonItems = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
