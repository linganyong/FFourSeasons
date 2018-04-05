//
//  RegisterViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/6.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit


enum LGYReginsterLaunchShowView:Int {
    case Reginster = 1
    case Launch = 2
    
}

let userDefaultsKey = "ashf4lasjd%&fhasdh9sdih"
let NotificationCenterLaunch = "32412eerrf"

class RegisterOrLaunchViewController: UIViewController,UITextFieldDelegate{
    
    var guideView:APPGuideView?
    @IBOutlet weak var registerMaginTopLC: NSLayoutConstraint!
    
    @IBOutlet weak var registerMaginRrailingLC: NSLayoutConstraint!
    @IBOutlet weak var registerMaginjLeadingLC: NSLayoutConstraint!
    
    @IBOutlet weak var launchOrRegisterButton: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var registerView: RegisterView!
    //底层的View
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var launchView: LaunchView!
    
    @IBOutlet weak var backHeightLC: NSLayoutConstraint!
    @IBOutlet weak var launchMaginTrailingLC: NSLayoutConstraint!
    
    @IBOutlet weak var launchMaginLeadingLC: NSLayoutConstraint!
    
    @IBOutlet weak var launchMaginTopLC: NSLayoutConstraint!
    private var showViewType = LGYReginsterLaunchShowView.Reginster
    var isNeedRootPage = true //是否需要弹出引导页
    var userName:String?
    var password:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCornerRadiusAndShadowView()
        launchView.viewStyle(vController: self)
        registerView.viewStyle(vController: self)
        addViewTapGestureRecognizer()
        setPassworkDataScoure()
        if showViewType == .Launch {
            addLaunchOrReginsterAnimation(showView: .Reginster, withDuration: 0.1)
        }else{
            addLaunchOrReginsterAnimation(showView: .Launch, withDuration: 0.1)
        }
        setBackgroundColor()
        UIApplication.shared.statusBarStyle = .lightContent
        NotificationCenter.default.addObserver(self, selector: #selector(notificationCenter(notification:)), name: NSNotification.Name(rawValue: NotificationCenterLaunch), object: nil)
    }
    
    @objc func notificationCenter(notification:Notification)->Void{
        let flag = notification.object as! Bool
        if flag{
            pushViewController(userName:userName,passwork:password)
        }
    }
    
    //MARK:添加点击事件，用于切换登录或注册
    func addViewTapGestureRecognizer() -> Void {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(changeLaunchOrRegister))
        view1.addGestureRecognizer(tap)
    }
    
    //MARK:切换登录或注册响应
    @objc func changeLaunchOrRegister() -> Void {
        if showViewType == .Launch {
            addLaunchOrReginsterAnimation(showView: .Reginster, withDuration: 2)
        }else{
            addLaunchOrReginsterAnimation(showView: .Launch, withDuration: 2)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isNeedRootPage {
            addRootPage()
        }
    }
    
    //MARK:切换登录或注册方法
    func addLaunchOrReginsterAnimation(showView:LGYReginsterLaunchShowView,withDuration:TimeInterval) -> Void {
        weak var vc = self
        switch showView {
        case .Reginster:
            lauchShow()
            registerView.alpha = 0.3
            UIView.animate(withDuration: withDuration, animations: {
                
                self.registerShow()
                vc?.registerView.setLineView()
            }, completion: { (finish) in
                vc?.registerView.setLineView()
            })
            
            showViewType = .Reginster
            break
        case .Launch:
            registerShow()
            launchView.alpha = 0.3
            UIView.animate(withDuration: withDuration, animations: {
                self.lauchShow()
                vc?.launchView.setLineView()
            }, completion: { (finish) in
                vc?.launchView.setLineView()
            })
            showViewType = .Launch
            break
        }
        
    }
    
    //MARK:展示登录
    func lauchShow()->Void{
        backHeightLC.constant = 80+20
        registerMaginTopLC.constant = 0
        registerMaginjLeadingLC.constant = 0
        registerMaginRrailingLC.constant = 0
        registerView.alpha = 0
        
        launchMaginTopLC.constant = -20
        launchMaginLeadingLC.constant = 30
        launchMaginTrailingLC.constant = -30
        launchView.alpha = 1
        launchView.backgroundColor = UIColor.black
        launchOrRegisterButton.setTitle("登录", for: .normal)
        
        self.view.layoutIfNeeded();
        
    }
    
    //MARK:把原来保存的账号密码取出来展示，同事修改保存的值
    func setPassworkDataScoure() -> Void {
        let passwordItem = KeychainConfiguration.get(forKey: userDefaultsKey)
        
        do{
            let str = try passwordItem?.readPassword()
            if str == nil || str?.count == 0{
                return
            }
            launchView.phoneNumberTextField.text = passwordItem?.account
            launchView.passworkTextField.text = str
            
            //设置原来密码为空
            KeychainConfiguration.save(userName: launchView.phoneNumberTextField.text!, passwork: "", forKey: userDefaultsKey)
        }catch{
            LBuyly.lBuglyError(error: error)
        }
    }
    
    //MARK:展示注册
    func registerShow()->Void{
        backHeightLC.constant = 160+20
        registerMaginTopLC.constant = -20
        registerMaginjLeadingLC.constant = 30
        registerMaginRrailingLC.constant = -30
        registerView.alpha = 1
        
        launchMaginTopLC.constant = 0
        launchMaginLeadingLC.constant = 0
        launchMaginTrailingLC.constant = 0
        launchView.alpha = 0
        launchOrRegisterButton.setTitle("完成注册", for: .normal)
        
        self.view.layoutIfNeeded();
    }
    
    //MARK:点击注册或登录响应事件
    @IBAction func registerAction(_ sender: Any) {
        switch showViewType {
        case .Reginster:
            if registerView.isCanRegister() {
                api_register()
            }
            break
        case .Launch:
            if launchView.isCanLaunch() {
                password = launchView.passworkTextField.text
                userName =  launchView.phoneNumberTextField.text
                RegisterOrLaunchViewController.api_launch(userName:userName!, passwork: password!)
            }
            break
        }
    }
    
    //MARK:注册用户
    func api_register() -> Void {
         userName = registerView.phoneNumberTextField.text!
         password = registerView.passworkTextField.text!
        LGYAFNetworking.lgyPost( urlString: APIAddress.api_register, parameters: ["nickName":registerView.phoneNumberTextField.text!
            ,"phone":userName!
            ,"password":password!
            ,"code":registerView.verificationTextField.text!], progress: nil) { (object,isError) in
                if !isError{
                    let model = Model_user_information.yy_model(withJSON: object as Any)
                    Model_user_information.setToken(model?.token)
                    if model != nil && LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterLaunch), object: true)
                    }else{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterLaunch), object: false)
                       
                    }
                    if let errmsg = model?.msg {
                        LGYToastView.show(message: errmsg)
                    }
                }
        }
    }
    
    @IBAction func registerAgreementAction(_ sender: UIButton) {
        let vc = WebViewController()
        vc.loadDataRichTextType(type: .AboutAgreement)
        vc.title = "注册协议"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:用户登录
    class func api_launch(userName:String,passwork:String) -> Void {
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_login, parameters: ["phone":
            userName,"password":passwork], progress: nil) { (object,isError) in
                if !isError{
                    let model = Model_user_information.yy_model(withJSON: object as Any)
                    Model_user_information.setToken(model?.token)
                    if model != nil && LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterLaunch), object: true)
                    }else{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterLaunch), object: false)
                    }
                }
                
        }
    }
    
    //MARK:设置引导页
    func addRootPage() -> Void {
        let mainWindow = UIApplication.shared.keyWindow//获取到app的主屏幕
        guideView = mainWindow?.viewWithTag(100) as? APPGuideView
        if guideView == nil{
            guideView = APPGuideView(frame: UIScreen.main.bounds)
            mainWindow?.addSubview(guideView!)
        }
        let array = ["引导1.png","引导2.png","引导3.png"]
        let timeInterval = 0.2
        guideView?.setup(iamgeNameArray:array as NSArray,timeToChange:timeInterval)
    }
    
    //MARK:登录成功，界面跳转
    func pushViewController(userName:String?,passwork:String?) ->Void{
        if passwork != nil && passwork != "" && userName != nil {
            KeychainConfiguration.save(userName: userName!, passwork: passwork!, forKey: userDefaultsKey)
            let tb = LinTabBarController()
            tb.initChildView()
            self.present(tb, animated: true, completion: {
                
            })
        }
    }
    
    //MARK:获取验证码
    @IBAction func verificationCodeAction(_ sender: Any) {
        if registerView.isCanGetVercifitionCode(){
            LGYAFNetworking.lgyPost(urlString: APIAddress.sms_verificationCode, parameters: ["phone":registerView.phoneNumberTextField.text!], progress: nil) { (object,isError) in
                //                let model = Model_user_information.yy_model(withJSON: any)
                if !isError{
                    let model = Model_sms_verificationCode.yy_model(withJSON: object)
                    LGYToastView.show(message: (model?.msg)!)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:设置view的圆角和阴影
    func setCornerRadiusAndShadowView() -> Void {
        LGYTool.viewLayerShadowCornerRadius(view: shadowView, cornerRadius: 10)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}

