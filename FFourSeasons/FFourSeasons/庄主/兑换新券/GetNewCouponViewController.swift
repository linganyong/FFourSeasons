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
        rightBarItem = navigationBarAddRightItem(_imageName: "打勾白色.png", target: self, action: #selector(rightBarAction))
        textField.delegate = self
        setBackgroundColor()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:导航栏右边按钮响应事件
    @objc func rightBarAction() ->Void{
        _ = LGYAlertViewSimple.show(title: "恭喜您兑换成功", buttonStr: "确定")
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
