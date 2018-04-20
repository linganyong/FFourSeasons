//
//  ChangeUserPassworkViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/2.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class ChangeUserPassworkViewController: UIViewController,UITextFieldDelegate {
     var rightBarItem:UIBarButtonItem!
    @IBOutlet weak var line3View: UIView!
    @IBOutlet weak var line2View: UIView!
    @IBOutlet weak var line1View: UIView!
    
    @IBOutlet weak var oldPassworkTF: UITextField!
    @IBOutlet weak var newPassworkTF: UITextField!
    @IBOutlet weak var newPassworkAgainTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        navigationItemBack(title: "    ")
        viewLayerShadow()
        rightBarItem = navigationBarAddRightItem(_imageName: "黑色确定", target: self, action: #selector(rightBarAction))
        setBackgroundColor()
        setTextFieldDelegate()
    }
    
    //MARK:导航栏右边按钮响应事件
    @objc func rightBarAction() ->Void{
//        if (codeTF.text?.count)!  < 4 || (codeTF.text?.count)! < 4{
//            LGYToastView.show(message: "请输入手机接收到的信息信息！")
//            return
//        }
//        if !LGYTool.isMobileNumber(mobileNum: phoneTF.text){
//            LGYToastView.show(message: "手机号码不正确！")
//            return
//        }
        if oldPassworkTF.text == nil   {
            LGYToastView.show(message: "旧密码不能为空！")
            return
        }
        if newPassworkTF.text == nil   {
            LGYToastView.show(message: "新密码不能为空！")
            return
        }
        
        if newPassworkTF.text != newPassworkAgainTF.text{
            LGYToastView.show(message: "两次输入的密码输入不相同！")
            return
        }
        weak var vc = self
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_alterUserPw, parameters: ["token":Model_user_information.getToken(),"newPw":newPassworkAgainTF.text!,"oldPw":oldPassworkTF.text!], progress: nil) { (object, isError) in
            if isError{
                return
            }
            let model = Model_user_information.yy_model(withJSON: object)
            if model != nil {
                if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                    if model?.msg == nil{
                        model?.msg = "修改成功"
                    }
                    _ = LGYToastView.show(message: (model?.msg!)!, timeInterval: 0.5, block: {
                        vc?.navigationController?.popViewController(animated: true)
                    })
                }else{
                    if model?.msg != nil{
                        LGYToastView.show(message: model!.msg!)
                    }
                }
                
                
            }
            
        }
    }
    
    func viewLayerShadow() -> Void {
        LGYTool.viewLayerShadow(view: line1View)
        LGYTool.viewLayerShadow(view: line2View)
        LGYTool.viewLayerShadow(view: line3View)
    }
    
    func setTextFieldDelegate() -> Void {
        oldPassworkTF.delegate = self
        newPassworkTF.delegate = self
        newPassworkAgainTF.delegate = self
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
        
//        if textField == phoneTF{
//            //控制手机输入位数
//            if (textField.text?.count)! + string.count - range.length > 11{
//                return false
//            }
//            let str = (textField.text! as NSString) .replacingCharacters(in: range, with: string)
//            //验证手机输是否正确
//            if !LGYTool.isMobileNumber(mobileNum: str){
//                LGYTool.cornerAdd(view: textField, text: "手机号码不正确",textColor: UIColor.red)
//
//            }else{
//                LGYTool.cornerAdd(view: textField, text: "手机号码正确",textColor: UIColor.red)
//            }
//        }
        return true
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
