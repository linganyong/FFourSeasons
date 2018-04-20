//
//  SignAddIntegralViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

let letIntegralStatusAll = ""
let letIntegralStatusIn = "0"
let letIntegralStatusOut = "1"

class SignAddIntegralViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var menu1Label: UILabel! //积分详情
    @IBOutlet weak var menu2Label: UILabel! //积分规则
    @IBOutlet weak var menu3Label: UILabel! //积分兑换
    @IBOutlet weak var intgralLabel: UILabel!
    @IBOutlet weak var integralDesLabel: UILabel!
    @IBOutlet weak var animationButtonView: AnimationButtonView!
    @IBOutlet weak var menuBackView: UIView!
    let dataScoure = ["全部","支出","收入"]
    @IBOutlet weak var pageView: LGYPageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "每日签到"
        setPageView()
        navigationItemBack(title: "      ")
        LGYTool.viewLayerShadow(view: menuBackView)
        setAnimationButtonView()
        intgralLabel.alpha = 0
        integralDesLabel.alpha = 0
        setBackgroundColor()
        isTap()
    }
    
    //MARK:保存唯一
    func isTap() -> Void{
        if let forkey = PersonViewController.infornation?.phone{
            let dateForm = DateFormatter()
            dateForm.dateFormat = "yyyyMMdd"
            let dateStr = dateForm.string(from: Date.init())
            let str = UserDefaults.standard.string(forKey: forkey)
            //判断UserDefaults中是否已经存在
            if(str == nil){
                animationButtonView.isHidden = false
                intgralLabel.alpha = 0
                intgralLabel.text = String.init(format: "0")
                integralDesLabel.alpha = 0
            }else{
                if (str?.contains(dateStr))!{
                    animationButtonView.isHidden = true
                    intgralLabel.alpha = 1
                    intgralLabel.text = String.init(format: "%D",(PersonViewController.infornation?.integral)!)
                    integralDesLabel.alpha = 1
                }
            }
        }
//        UserDefaults.standard.set(dateForm, forKey: forkey)
    }

    
    
    @IBAction func menuAction(_ sender: UIButton) {
        
        switch sender.LGYLabelKey {
        case "1"?: //积分详情
            
            break
        case "2"?: //积分规则
            let vc = WebViewController()
            vc.loadDataRichTextType(type: .AboutRule)
            vc.title = "积分规则"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "3"?: //积分兑换
            let vc = Bundle.main.loadNibNamed("IntegralShopViewController", owner: nil, options: nil)?.first as! IntegralShopViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
       
    }
    
    
    
    //MARK:签到点击按钮设置
    func setAnimationButtonView() ->Void{
        animationButtonView.setStyle()
        animationButtonView.addTarget(self, action: #selector(animationButtonViewAction), for: .touchUpInside)
    }
    
    //MARK:签到点击按钮响应
   @objc func animationButtonViewAction() -> Void {
        loadSignIn()
    }
    
    func integeralAdd(integral:Int){
        weak var vc = self
        let dateForm = DateFormatter()
        dateForm.dateFormat = "yyyyMMdd"
        let dateStr = dateForm.string(from: Date.init())
        UserDefaults.standard.set(dateStr, forKey:(PersonViewController.infornation?.phone)!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PersonViewControllerNeedLoadDataScoure), object: true)
        UIView.animate(withDuration: 1, animations: {
            vc?.animationButtonView.frame = CGRect(x: -200, y: 500, width: (vc?.animationButtonView.frame.size.width)!, height: (vc?.animationButtonView.frame.size.height)!)
            vc?.intgralLabel.alpha = 1
            vc?.intgralLabel.text = String.init(format: "%D", integral)
            vc?.integralDesLabel.alpha = 1
        }) { (finish) in
            if (finish){
                vc?.animationButtonView.removeFromSuperview()
            }
        }
        for i in 0...dataScoure.count-1{
            let tb = pageView.pageViewtableView(index: i)
            tb?.mj_header.beginRefreshing()
        }
    }
    
    //MARK:设置pageView
    func setPageView() ->Void{
        LGYTool.viewLayerShadow(view: pageView)
        pageView.addContent(titleArray: dataScoure, height: 30, isHiddenHeader: false)
        pageView.headerBtnStyle(defaultTextColor: UIColor.init(red: 187/255.0, green: 187/255.0, blue: 187/255.0, alpha: 1), selectTextColor: UIColor.init(red: 42/255.0, green: 201/255.0, blue: 140/255.0, alpha: 1), headerBtnWidth: (self.view.frame.size.width-24)/CGFloat(dataScoure.count), headerLineHeight: 1,textFront: 12)
        pageView.setLineViewWidth(width: 65)
        for i in 0...dataScoure.count-1{
            let tb = pageView.pageViewtableView(index: i)
            tb?.delegate = self
            tb?.rowHeight = 60
            tb?.dataSource = self
            tb?.backgroundColor = UIColor.clear
            tb?.separatorColor = UIColor.clear
            tb?.showsVerticalScrollIndicator = false
            tb?.register(UINib.init(nibName: "SignAddIntegralTableViewCell", bundle: nil), forCellReuseIdentifier: "SignAddIntegralTableViewCell")
            weak var vc = self
            if tb?.lgyDataScoure == nil{
                tb?.lgyDataScoure = Array<String>()
                tb?.lgyPageIndex = 1
                switch i{
                case 0:
                    tb?.lgyTypeKey = letIntegralStatusAll
                    break
                case 1:
                    tb?.lgyTypeKey = letIntegralStatusOut
                    break
                case 2:
                    tb?.lgyTypeKey = letIntegralStatusIn
                    break
                default:
                    break
                }
                vc?.loadSignInList(tableView: tb!)
                tb?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
                    tb?.lgyPageIndex = 1
                    vc?.loadSignInList(tableView: tb!)
                })
                tb?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
                    tb?.lgyPageIndex = 1 + (tb?.lgyPageIndex)!
                    vc?.loadSignInList(tableView: tb!)
                })
                
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.lgyDataScoure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignAddIntegralTableViewCell", for: indexPath) as! SignAddIntegralTableViewCell
        cell.selectionStyle = .none
        let model = tableView.lgyDataScoure[indexPath.row] as! IntegralItem
        var countStr = ""
        if model.type == 1{
            countStr = String.init(format: "-%D", model.number)
        }else{
            countStr = String.init(format: "+%D", model.number)
        }
        cell.setModel(date: model.created_time, countStr: countStr, detail: model.detail)
        return cell
        
    }
    
    //MARK:加载数据
    func loadSignIn() ->Void {
        weak var vc = self
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_signIn, parameters: ["token":Model_user_information.getToken()], progress: nil) { (object, isError) in
            if !isError {
                let model = Model_api_signIn.yy_model(withJSON: object as Any)
                if model == nil || vc == nil || !LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                    LGYToastView.show(message: (model?.msg)!)
                    return
                }
                vc?.integeralAdd(integral:(model?.integral)!)
//                vc?.removeEmptyView()
            }
        }
    }
    
    //MARK:加载数据
    func loadSignInList(tableView:UITableView) ->Void {
        weak var tb = tableView
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_signInList, parameters: ["type":(tb?.lgyTypeKey)!
            ,"pageNumber":String.init(format: "%D", (tb?.lgyPageIndex)!)
            ,"token":Model_user_information.getToken()], progress: nil) { (object, isError) in
            if !isError {
                if isError{
                    return
                }
                let model = Model_api_signInList.yy_model(withJSON: object as Any)
                if model?.list != nil {
                    let list = model?.list
                    if tb?.lgyPageIndex == 1{
                        tb?.lgyDataScoure.removeAll();
                    }
                    if list != nil{
                        for item in (list!.list)!{
                            tb?.lgyDataScoure.append(item)
                            
                        }
                        tb?.reloadData();
                    }
                }
                tb?.mj_header?.endRefreshing()
                tb?.mj_footer?.endRefreshing()
                
            }
        }
    }
 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBarStyle(type: .Clear)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarStyle(type: .Clear)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         setNavigationBarStyle(type:.Default)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
