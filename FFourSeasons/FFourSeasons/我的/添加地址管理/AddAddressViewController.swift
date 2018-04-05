//
//  AddAddressViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/27.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController,UITextFieldDelegate {
    var rightBarItem:UIBarButtonItem!
    
    let editType = 1
    let addType = 2
    var type = 2
    var addressInformation:Addresses?
    
    @IBOutlet weak var back1View: UIView!
    @IBOutlet weak var back2View: UIView!
    @IBOutlet weak var back3View: UIView!
    @IBOutlet weak var back4View: UIView!
    
    @IBOutlet weak var address2TF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var address1TF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    var selectTextField:UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新增收货地址"
        navigationItemBack(title: "    ")
        viewLayerShadow()
        rightBarItem = navigationBarAddRightItem(_imageName: "打勾.png", target: self, action: #selector(rightBarAction))
        setBackgroundColor()
        setTextFieldDelegate()
    }
    //MARK:设置阴影
    func viewLayerShadow()->Void{
        LGYTool.viewLayerShadow(view: back1View)
         LGYTool.viewLayerShadow(view: back2View)
         LGYTool.viewLayerShadow(view: back3View)
         LGYTool.viewLayerShadow(view: back4View)
    }
    
    func setTextFieldDelegate() -> Void {
        phoneTF.delegate = self
        nameTF.delegate = self
        address1TF.delegate = self
        address2TF.delegate = self
    }
    
    func setAddressInformation(address:Addresses) -> Void {
        type = editType
        self.title = "编辑收货地址"
        addressInformation = address
        phoneTF.text = address.phone
        nameTF.text = address.name
        address1TF.text = address.located
        address2TF.text = address.address
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        selectTextField = textField
        return true
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
        return true
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:导航栏右边按钮响应事件
    @objc func rightBarAction() ->Void{
        if nameTF.text == nil || (nameTF.text?.count)! < 1{
            LGYToastView.show(message: "收货人不能为空！")
            return
        }
        if phoneTF.text == nil || (phoneTF.text?.count)! < 1{
            LGYToastView.show(message: "请填写联系电话！")
            return
        }
        //验证手机输是否正确
        if !LGYTool.isMobileNumber(mobileNum: phoneTF.text!){
                LGYToastView.show(message: "请填电话不正确！")
             LGYTool.cornerAdd(view: phoneTF, text: "手机号码不正确",textColor: UIColor.red)
             return
        }
        if address1TF.text == nil || (address1TF.text?.count)! < 1{
            LGYToastView.show(message: "请填写收货城市！")
            return
        }
        if address2TF.text == nil || (address2TF.text?.count)! < 1{
            LGYToastView.show(message: "请填写详细地址！")
            return
        }
        selectTextField?.resignFirstResponder()
        switch type {
        case editType:
            loadAlterAdderss()
            break
        default:
            loadAddAdderss()
            break
        }
        
    }
    
    /*
     @IBOutlet weak var address2TF: UITextField!
     @IBOutlet weak var nameTF: UITextField!
     @IBOutlet weak var address1TF: UITextField!
     @IBOutlet weak var phoneTF: UITextField!
     */
    //MARK:联网添加地址
    func loadAddAdderss() ->Void {
        weak var vc = self
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_addAddress,
                                parameters: ["name":nameTF.text!
                                    ,"phone":phoneTF.text!
                                    ,"address":address2TF.text!
                                    ,"located":address1TF.text!
                                    ,"token":Model_user_information.getToken()]
        , progress: nil) { (object, isError) in
            if !isError {
                let model = Model_user_information.yy_model(withJSON: object as Any)
                if model == nil || vc == nil{
                    return
                }
                if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                    _ = LGYToastView.show(message: (model?.msg)!, timeInterval: 0.5, block: {
                        vc?.navigationController?.popViewController(animated: true)
                    })
                }else{
                    LGYToastView.show(message:(model?.msg)!)
                }
            }
        }
    }
    
    //MARK:联网修改地址
    func loadAlterAdderss() ->Void {
        weak var vc = self
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_alterAddress,
                                parameters: ["aId":String.init(format: "%D",(addressInformation?._id)!),
                                    "name":nameTF.text!
                                    ,"phone":phoneTF.text!
                                    ,"address":address2TF.text!
                                    ,"located":address1TF.text!
                                    ,"token":Model_user_information.getToken()]
        , progress: nil) { (object, isError) in
            if !isError {
                let model = Model_user_information.yy_model(withJSON: object as Any)
                if model == nil || vc == nil{
                    return
                }
                if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                    _ = LGYToastView.show(message: (model?.msg)!, timeInterval: 0.5, block: {
                        vc?.navigationController?.popViewController(animated: true)
                    })
                }else{
                    LGYToastView.show(message:(model?.msg)!)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
