//
//  GetNewCouponViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/7.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class GetNewCouponViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    var rightBarItem:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "兑换新券"
        navigationItemBack(title: "    ")
        rightBarItem = navigationBarAddRightItem(_imageName: "白色确定", target: self, action: #selector(rightBarAction))
        textField.delegate = self
        setBackgroundColor()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    //MARK:加载优惠券
    func loadExchangeCoupon(code:String) -> Void {
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_exchangeCoupon, parameters: ["token":Model_user_information.getToken(),"uuid":code], progress: nil) { (object, isError) in
            if !isError{
                if let model = Model_user_information.yy_model(withJSON: object){
                    if LGYAFNetworking.isNetWorkSuccess(str: model.code){
                        self.navigationController?.popViewController(animated: true)
                        LGYToastView.show(message: "恭喜您，兑换成功！")
                    }else{
                        if let msg = model.msg{
                            LGYToastView.show(message: msg)
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK:导航栏右边按钮响应事件
    @objc func rightBarAction() ->Void{
        if textField.text?.count == 0{
            LGYToastView.show(message: "请输入兑换码！")
            return
        }
         loadExchangeCoupon(code: textField.text!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
