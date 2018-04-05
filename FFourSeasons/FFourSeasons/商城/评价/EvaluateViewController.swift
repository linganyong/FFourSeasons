//
//  EvaluateViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/8.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class EvaluateViewController: UIViewController,UITextViewDelegate {
    var rightBarItem:UIBarButtonItem!
    @IBOutlet weak var desTextView: UITextView!
    @IBOutlet weak var desLabel: UILabel!
    let desLabelStr = "请输入您的评价"
    @IBOutlet weak var imageBackView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评价"
        navigationItemBack(title: "    ")
        rightBarItem = navigationBarAddRightItem(_imageName: "打勾白色.png", target: self, action: #selector(rightBarAction))
        LGYTool.viewLayerShadow(view: imageBackView)
        setTextView()
        setBackgroundColor()
    }

    //MARK:导航栏右边按钮响应事件
    @objc func rightBarAction() ->Void{
        LGYAlertViewSimple.show(title: "评论成功！", buttonStr: "确定")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if desTextView.text == nil || desTextView.text.count == 0{
            desLabel.text = desLabelStr
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        desLabel.text = ""
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == nil || textView.text.count == 0{
            desLabel.text = desLabelStr
        }
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItems = [rightBarItem]
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.rightBarButtonItems = nil
    }
    
}
