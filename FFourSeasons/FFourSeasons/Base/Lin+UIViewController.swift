//
//  Lin+NavigationBar.swift
//  Created by LGY  on 2018/1/6.
//  Copyright © 2018年 All rights reserved.
//

import UIKit

private var LGYToolBarKey: Void?
private var LGYNumberKeyBoardReturnBtnKey: UIButton?
private var LGYKeyBoardTFKey: UITextField?
private var LGYViewControllerTagKey:NSInteger?

enum NavigationBarStyle:Int{
    case Default = 1;
    case White = 2;
    case Clear = 3
}

extension UIViewController {
    static let LGYViewTagEmptyWhite = 1233423
    
    //MARK:扩展属性
    var LGYViewControllerTag: NSInteger! {
        get {
            if objc_getAssociatedObject(self, &LGYViewControllerTagKey)  == nil {
                return 0
            }
            return objc_getAssociatedObject(self, &LGYViewControllerTagKey) as? NSInteger
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGYViewControllerTagKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    //MARK:扩展属性
     var LGYToolBar: UIToolbar? {
        get {
            return objc_getAssociatedObject(self, &LGYToolBarKey) as? UIToolbar
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGYToolBarKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //MARK:扩展数字键盘return按钮属性
    var LGYNumberKeyBoardReturnBtn: UIButton? {
        get {
            return objc_getAssociatedObject(self, &LGYNumberKeyBoardReturnBtnKey) as? UIButton
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGYNumberKeyBoardReturnBtnKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //MARK:扩展数字键盘TextField属性
    @IBInspectable var LGYKeyBoardTF: UITextField? {
        get {
            return objc_getAssociatedObject(self, &LGYKeyBoardTFKey) as? UITextField
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGYKeyBoardTFKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setBackgroundColor() -> Void {
        self.view.backgroundColor = UIColor.white
       
    }
    func setBackgroundColor(color:UIColor) -> Void {
        self.view.backgroundColor = color
    }
    //MARK:设置导航栏
    class func navigationBarInitPush(_appDelegate:AppDelegate) -> UINavigationController {
        let story = _appDelegate.window?.rootViewController?.storyboard
        let noloVC = story?.instantiateViewController(withIdentifier: "nolo") as! ViewController
        return UINavigationController(rootViewController: noloVC)
    }
    
    func navigationItemBack(title:String?) ->Void{
//        if navigationItem.leftBarButtonItems == nil && navigationItem.backBarButtonItem == nil {
//        let backButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(popViewController))
//        backButton.image = UIImage(named: "左箭头")
////        navigationItem.backBarButtonItem = backButton
//        navigationItem.leftBarButtonItems = [backButton]
////        self.navigationItem.backBarButtonItem?.title = ""
//        }
        var backBtn = UIBarButtonItem()
        backBtn.title = "  "
        navigationItem.backBarButtonItem = backBtn
        
    }
    
    @objc func popViewController()->Void{
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: {
                
            })
    }
    
    //MARK:添加左边导航button
    func navigationBarAddLeftButton(_imageName:String,_title:String,target:Any?, action: Selector?,tag:Int) -> Void {
        let leftButton = UIButton(frame: CGRect(x: 30, y: 0, width: 40, height: 40))
        let iView = UIImageView.init(frame: CGRect(x:-15, y: (leftButton.frame.size.height - 15)/2, width: 15, height: 15))
        iView.image = UIImage.init(named: _imageName)
        leftButton.tag = tag
        if action != nil{
            leftButton.addTarget(target, action: action!, for: .touchUpInside)
        }
        leftButton.setTitle(_title, for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftButton.addSubview(iView)
        self.navigationController?.navigationBar.addSubview(leftButton)
    }
    
    //MARK:添加由边导航控件
    func navigationBarAddRightItem(_imageName:String,target:Any, action: Selector?) ->UIBarButtonItem {
        var rightItem = UIBarButtonItem()
        let image = UIImage(named: _imageName)
        rightItem = UIBarButtonItem(image: image, style: .plain, target: target, action: action)
        self.navigationItem.rightBarButtonItems = [rightItem]
        return rightItem
    }
    
    //MARK:添加由边导航控件
    func navigationBarAddRightItem(title:String,target:Any, action: Selector?) ->UIBarButtonItem {
        var rightItem = UIBarButtonItem()
        rightItem = UIBarButtonItem(image: nil, style: .plain, target: target, action: action)
        rightItem.title = title
        self.navigationItem.rightBarButtonItems = [rightItem]
        rightItem.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12)], for: .normal)
        return rightItem
    }

    
    
    //MARK:设置导航栏颜色
    func setNavigationBarStyle(type:NavigationBarStyle) -> Void {
        var backgroundImage = UIImage(color: UIColor.white)
        var tintColor = UIColor.black;
        switch type {
        case .Default:
            backgroundImage = UIImage(named: "导航矩形3x.png")?.resizableImage(withCapInsets:  UIEdgeInsets(), resizingMode: .stretch);
             tintColor = UIColor.white;
            setNaviagtionShadowOffset(color: UIColor.clear)
            UIApplication.shared.statusBarStyle = .lightContent
            break
        case .Clear:
            backgroundImage = UIImage.init(color: UIColor.clear);
            tintColor = UIColor.white;
            setNaviagtionShadowOffset(color: UIColor.clear)
            UIApplication.shared.statusBarStyle = .lightContent
            break
        default:
            setNaviagtionShadowOffset(color: UIColor.black)
            UIApplication.shared.statusBarStyle = .default
            break
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(backgroundImage!, for: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = tintColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: tintColor]
        
    }
    
    
    
    //MARK:设置navigationController导航阴影
    func  setNaviagtionShadowOffset(color:UIColor) -> Void {
        //1.设置阴影颜色
        navigationController?.navigationBar.layer.shadowColor = color.cgColor
        //2.设置阴影偏移范围
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        //3.设置阴影颜色的透明度
        navigationController?.navigationBar.layer.shadowOpacity = 0.1
        //4.设置阴影半径
        navigationController?.navigationBar.layer.shadowRadius = 2
        //5.设置阴影路径
        let aBounds = navigationController?.navigationBar.bounds
        if aBounds != nil {
            navigationController?.navigationBar.layer.shadowPath = UIBezierPath(rect: aBounds!).cgPath
        }
    }
    
    //MARK:快速弹出框
    func alertView(_title:String,_message:String,_bText:String) -> Void {
        let aV = UIAlertController(title: _title, message: _message, preferredStyle: .alert)
        aV.addAction(UIAlertAction(title: _bText, style: .default, handler: { (action) in
            
        }))
        self.present(aV, animated: true, completion: nil)
    }
    
    //MARK:监听键盘弹出和消失
    func notificationCenterKeyboardWillShowOrHidden() ->Void{
        //监听键盘弹出通知
        NotificationCenter.default
            .addObserver(self,selector: #selector(numberKeyboardAddReturnKeyboardWillShow(note:)),
                         name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //监听键盘隐藏通知
        NotificationCenter.default
            .addObserver(self,selector: #selector(numberKeyboardAddReturnKeyboardWillHide(notification:)),
                         name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK:设置数据键盘完成按钮
    func numberKeyboardAddReturn() {
        if LGYNumberKeyBoardReturnBtn == nil{
            //创建要添加到键盘上的“完成”按钮
            LGYNumberKeyBoardReturnBtn = UIButton()
            LGYNumberKeyBoardReturnBtn!.setTitle("完成", for: UIControlState())
            LGYNumberKeyBoardReturnBtn!.setTitleColor(UIColor.black, for: UIControlState())
            LGYNumberKeyBoardReturnBtn!.frame = CGRect(x: 0, y: 0, width: 106, height: 53)
            LGYNumberKeyBoardReturnBtn!.adjustsImageWhenHighlighted = false
            LGYNumberKeyBoardReturnBtn!.addTarget(self, action: #selector(LGYNumberKeyBoardReturnBtnAction), for: .touchUpInside)
            
        }
    }
    
    //MARK:键盘弹出监听，回调
    @objc func numberKeyboardAddReturnKeyboardWillShow(note : Notification) -> Void{
        DispatchQueue.main.async { () -> Void in
            //防止输入框被键盘覆盖
            if self.LGYKeyBoardTF != nil {
                let userInfo = note.userInfo
                let KeyboardFrameEndUserInfoKey = (userInfo?["UIKeyboardFrameEndUserInfoKey"] as AnyObject).cgRectValue
                let marginBottom = UIScreen.main.bounds.size.height - (self.LGYKeyBoardTF?.frame.size.height)! - (self.LGYKeyBoardTF?.frame.origin.y)! - 5
                let margin = marginBottom - (KeyboardFrameEndUserInfoKey?.size.height)!
                if margin < 0 {
                    self.viewAnimations(-margin)
                }
            }
            //设置数字键盘
            if self.LGYKeyBoardTF == nil || self.LGYKeyBoardTF?.keyboardType != UIKeyboardType.numberPad {
                self.LGYNumberKeyBoardReturnBtn?.isHidden = true
                return
            }
            if !(self.LGYKeyBoardTF?.isFirstResponder)!{
                self.LGYNumberKeyBoardReturnBtn?.isHidden = true
                return
            }
            
            self.LGYNumberKeyBoardReturnBtn?.removeFromSuperview()
            //找到键盘的window
            let keyBoardWindow = UIApplication.shared.windows.last
            //将“完成”按钮添加到键盘的window中
            keyBoardWindow?.addSubview(self.LGYNumberKeyBoardReturnBtn!)
            keyBoardWindow?.bringSubview(toFront: self.LGYNumberKeyBoardReturnBtn!)
            
            //显示“完成”按钮
            self.LGYNumberKeyBoardReturnBtn?.isHidden = false
            //计算“完成”按钮最终要显示的y坐标
            let LGYNumberKeyBoardReturnBtnY = (keyBoardWindow?.frame.size.height)! - 53
            
            if let userInfo = note.userInfo,
                let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
                let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
                let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
                let frame = value.cgRectValue
                //获取虚拟键盘实际的位置和尺寸
                let intersection = frame.intersection(self.view.frame)
                
                //设置“完成”按钮最开始的y坐标
                self.LGYNumberKeyBoardReturnBtn?.frame = CGRect(x: 0, y: LGYNumberKeyBoardReturnBtnY + intersection.height, width: intersection.width/3, height:(intersection.height-40)/4)
                
                //让“完成”按钮跟随键盘出现动画移动到最终的位置
                UIView.animate(withDuration: duration, delay: 0.0,
                               options: UIViewAnimationOptions(rawValue: curve),
                               animations: {
                                self.LGYNumberKeyBoardReturnBtn?.frame.origin.y = LGYNumberKeyBoardReturnBtnY
                }, completion: nil)
            }
        }
    }
    
    //MARK:数字键盘，键盘隐藏
    @objc func numberKeyboardAddReturnKeyboardWillHide(notification: Notification) {
        //隐藏“完成”按钮
        self.LGYNumberKeyBoardReturnBtn?.isHidden = true
        viewAnimations(0)
    }
    
    //MARK:数字键盘 ，“完成“按钮点击响应
    @objc func LGYNumberKeyBoardReturnBtnAction() {
        //收起键盘
        self.LGYKeyBoardTF?.resignFirstResponder()
    }
    
    //MARK:启动Toorbar
    func LGYToolBarShow() {
        LGYToolBar = UIToolbar(frame:CGRect(x:0, y:UIScreen.main.bounds.size.height-44, width:UIScreen.main.bounds.size.height, height:44))
        // 将工具条添加到当前应用的界面中
        self.view.addSubview(LGYToolBar!)
        LGYToolBar?.barTintColor = UIColor(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
    }
    
    //Mark:设置child
    func toorBarAddChild() -> Void {
        let btnback =  UIBarButtonItem(image:UIImage(named:"back.png"),
                                       style: .plain, target:self,
                                       action:#selector(backClick(_:)))
        let btngap1 =  UIBarButtonItem(barButtonSystemItem:.flexibleSpace,
                                       target:nil,
                                       action:nil)
        let btnforward = UIBarButtonItem(image:UIImage(named:"forward.png"),
                                         style: .plain, target:self,
                                         action:#selector(forwardClick(_:)))
        let btngap2 =  UIBarButtonItem(barButtonSystemItem:.flexibleSpace,
                                       target:nil,
                                       action:nil)
        LGYToolBar?.setItems([btnback, btngap1, btnforward, btngap2], animated: false)
    }
    
    @objc func backClick(_ sender:UIBarButtonItem) {
        //后退
        print("后退按钮点击")
    }
    
    @objc func forwardClick(_ sender:UIBarButtonItem) {
        //前进
        print("前进按钮点击")
    }
    
    //MARK:textField做动画
    func viewAnimations(_ move: CGFloat) {
        let frame: CGRect = view.frame
        //首尾式动画
        UIView.beginAnimations(nil, context: nil)
        //执行动画
        //设置动画执行时间
        UIView.setAnimationDuration(0.25)
        //设置代理
        UIView.setAnimationDelegate(self)
        //设置动画执行完毕调用的事件
        view.bounds = CGRect(x: 0, y: move, width: frame.size.width, height: frame.size.height)
        UIView.commitAnimations()
    }
    
    func viewAnimations(_ bounds: CGRect, duration time: CGFloat, view: UIView) {
        //首尾式动画
        UIView.beginAnimations(nil, context: nil)
        //执行动画
        //设置动画执行时间
        UIView.setAnimationDuration(time as? TimeInterval ?? 0.0)
        //设置代理
        UIView.setAnimationDelegate(self)
        //设置动画执行完毕调用的事件
        view.bounds = bounds
        UIView.commitAnimations()
    }
    
    //MARK:防止scroller被遮挡
    func extendedLayout() ->Void{
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.extendedLayoutIncludesOpaqueBars = false
        self.modalPresentationCapturesStatusBarAppearance = false
    }
    
    
    //MARK:获取当前的ViewController
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
    
    func addEmptyView(frame:CGRect?){
        let whiteView = UIView()
        whiteView.tag = UIViewController.LGYViewTagEmptyWhite
        if frame != nil{
            whiteView.frame = frame!
        }else{
            whiteView.frame = UIScreen.main.bounds
        }
        whiteView.backgroundColor = UIColor.white
        view.addSubview(whiteView)
    }
    
     func removeEmptyView(){
        let whiteView = view.viewWithTag(UIViewController.LGYViewTagEmptyWhite)
        whiteView?.removeFromSuperview()
    }
    
}

