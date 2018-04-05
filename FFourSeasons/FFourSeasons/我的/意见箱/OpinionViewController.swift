//
//  OpinionViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/2.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit



class OpinionViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var desBackView: UIView!
    @IBOutlet weak var contaceBackView: UIView!
    @IBOutlet weak var desLabel: UILabel!
    let desLabelStr = " 欢迎反馈任何意见和问题，你的反馈也是我们产品进步的动力哦！"
    @IBOutlet weak var desTextView: UITextView!
    @IBOutlet weak var contactTextField: UITextField!
    var rightBarItem:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        navigationItemBack(title: "    ")
        viewLayerShadow()
        setTextView()
        rightBarItem = navigationBarAddRightItem(_imageName: "打勾.png", target: self, action: #selector(rightBarAction))
        contactTextField.delegate = self
        setBackgroundColor()
    }
    
    //MARK:导航栏右边按钮响应事件
    @objc func rightBarAction() ->Void{
        if desTextView.text == nil || desTextView.text?.count == 0{
            LGYToastView.show(message: "意见内容不能为空！")
            return
        }
        if contactTextField.text == nil || contactTextField.text?.count == 0{
            LGYToastView.show(message: "联系信息不能为空！")
            return
        }
        loadDataScoure()
    }
    
    func setTextView() -> Void {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(registerKeyBoard))
        self.view.addGestureRecognizer(tap)
        desLabel.text = desLabelStr
        desTextView.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func registerKeyBoard() ->Void{
        desTextView.resignFirstResponder()
        contactTextField.resignFirstResponder()
        if desTextView.text == nil || desTextView.text.count == 0{
            desLabel.text = desLabelStr
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        desLabel.text = ""
        return true
    }
    
    
    //MARK:加载数据 分类
    func loadDataScoure() -> Void {
        let parm = ["token":Model_user_information.getToken()
            ,"content":desTextView.text
            ,"phone":contactTextField.text]
        //MARK:加载产品分类信息
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_about, parameters: parm,progress: nil) { (object,isError) in
            let model = Model_user_information.yy_model(withJSON: object as Any)
            if model != nil && model?.msg != nil
            {
                LGYToastView.show(message: (model?.msg)!)
                
            }else{
                if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                    LGYToastView.show(message: "提交成功")
                }
            }
            
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == nil || textView.text.count == 0{
            desLabel.text = desLabelStr
        }
        return true
    }
    
    func viewLayerShadow() -> Void {
        LGYTool.viewLayerShadow(view: desBackView)
        LGYTool.viewLayerShadow(view: contaceBackView)
      
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
