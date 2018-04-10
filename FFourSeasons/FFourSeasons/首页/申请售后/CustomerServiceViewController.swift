//
//  CustomerServiceViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/27.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class CustomerServiceViewController: UIViewController,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate {

     var rightBarItem:UIBarButtonItem!
    @IBOutlet weak var titleTableView: UITableView!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var prictureCollectionView: UICollectionView!
    @IBOutlet weak var describleTextView: UITextView!
    @IBOutlet weak var describleLabel: UILabel!
    @IBOutlet weak var descibleBackView: UIView!
    
    @IBOutlet weak var productTableViewLC: NSLayoutConstraint!
    @IBOutlet weak var titleTableViewLC: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
        setProductTableView()
        setTitleTableView()
        self.title = "申请售后"
        navigationItemBack(title: "    ")
        rightBarItem = navigationBarAddRightItem(_imageName: "打勾白色.png", target: self, action: #selector(rightBarAction))
        setProductTableView()
        setTitleTableView()
       notificationCenterKeyboard()
//        setBackgroundColor()
    }
    
   
    
    func setProductTableView() -> Void {
        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.rowHeight = 93
         productTableView.bounces = false
        productTableView.separatorColor = UIColor.clear
        productTableView.register(UINib.init(nibName: "CustomeServiceProductTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomeServiceProductTableViewCell")
    }
    
    func setTitleTableView() -> Void {
        titleTableView.delegate = self
        titleTableView.dataSource = self
        titleTableView.rowHeight = 30
         productTableView.bounces = false
        titleTableView.separatorColor = UIColor.clear
        titleTableView.register(UINib.init(nibName: "CustomeServiceTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomeServiceTitleTableViewCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == productTableView{
            productTableViewLC.constant = 3*93
            self.view.layoutIfNeeded()
            return 3
        }else
        if tableView == titleTableView {
            titleTableViewLC.constant = 30*5
            return 5
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == productTableView{
            return productCell(tableView:tableView,indexPath: indexPath)
        }else  {
            return titleCell(tableView:tableView,indexPath: indexPath)
        }
    }
    
    func productCell(tableView: UITableView,indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomeServiceProductTableViewCell", for: indexPath) as! CustomeServiceProductTableViewCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    func titleCell(tableView: UITableView,indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomeServiceTitleTableViewCell", for: indexPath) as! CustomeServiceTitleTableViewCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    func setTextView() -> Void {
        LGYTool.viewLayerShadow(view: descibleBackView)
        
         let tap = UITapGestureRecognizer.init(target: self, action: #selector(registerKeyBoard))
        self.view.addGestureRecognizer(tap)
        describleTextView.delegate = self
    }
    
    @objc func registerKeyBoard() ->Void{
        describleTextView.resignFirstResponder()
        if describleTextView.text == nil || describleTextView.text.count == 0{
            describleLabel.text = " 请输入退货原因"
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        describleLabel.text = ""
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == nil || textView.text.count == 0{
            describleLabel.text = " 请输入退货原因"
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }

    @IBAction func addressAction(_ sender: Any) {
        
    }
    
    //MARK:导航栏右边按钮响应
    @objc func rightBarAction() -> Void {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.rightBarButtonItems = [rightBarItem]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItems = [rightBarItem]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.rightBarButtonItems = nil
    }
    
    //MARK:监听键盘弹出和消失
    func notificationCenterKeyboard() ->Void{
        //监听键盘弹出通知
        NotificationCenter.default
            .addObserver(self,selector: #selector(keyboardWillShow(note:)),
                         name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //监听键盘隐藏通知
        NotificationCenter.default
            .addObserver(self,selector: #selector(keyboardWillHide(notification:)),
                         name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK:键盘弹出监听，回调
    @objc func keyboardWillShow(note : Notification) -> Void{
        DispatchQueue.main.async { () -> Void in
            //防止输入框被键盘覆盖
                let userInfo = note.userInfo
                let KeyboardFrameEndUserInfoKey = (userInfo?["UIKeyboardFrameEndUserInfoKey"] as AnyObject).cgRectValue
            let focusFrame = self.describleTextView.convert(self.describleTextView.frame, to: self.view)
            let marginBottom = UIScreen.main.bounds.size.height - focusFrame.size.height - focusFrame.origin.y - 5
                let margin = marginBottom - (KeyboardFrameEndUserInfoKey?.size.height)!
                if margin < 0 {
                    self.viewAnimations(-margin)
                }
            }
    }
    
    //MARK:数字键盘，键盘隐藏
    @objc func keyboardWillHide(notification: Notification) {
        //隐藏“完成”按钮
        viewAnimations(0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
