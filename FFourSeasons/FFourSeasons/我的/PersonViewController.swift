//
//  PersonViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

let PersonViewControllerLoadDataScoure = "PersonViewControllerLoadDataScoure"
let PersonViewControllerNeedLoadDataScoure = "PersonViewControllerNeedLoadDataScoure"

class PersonViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    public static var infornation:Model_api_profile?
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var vipCountLabel: UILabel!
    @IBOutlet weak var vipNumberLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    var dataScoure = [["庄园":"智慧农场3x.png"],["我的订单":"订单3x.png"],["邀请码":"邀请码3x.png"],["收货地址":"收货地址3x.png"],["设置":"设置3x.png"],["关于我们":"关于我们3x.png"]]

    @IBOutlet weak var vipLabel: UILabel!
    @IBOutlet weak var personView: UIView!
    
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var MyWalletView: UIView!
    
    @IBOutlet weak var persionImageView: UIImageView!
    @IBOutlet weak var MyCollectionView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的"
//        navigationItemBack(title: "    ")
        viewLayerShadow()
        personView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(personViewTapAction)))
        persionImageView.isUserInteractionEnabled = true
        persionImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(personImageViewTapAction)))
        setCollectionView()
        setBackgroundColor()
        setBackgroundColor()
        needLaunch()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationCenter(notification:)), name: NSNotification.Name(rawValue: PersonViewControllerNeedLoadDataScoure), object: nil)
    }
    
    //MARK:判断是否需要登录
    func needLaunch() -> Void {
        if Model_user_information.getToken().count > 0{
            loadDataScoure()
        }else{
            NotificationCenter.default.addObserver(self, selector: #selector(notificationCenter(notification:)), name: NSNotification.Name(rawValue: NotificationCenterLaunch), object: nil)
        }
    }
    
    @objc func notificationCenter(notification:Notification)->Void{
        let flag = notification.object as! Bool
        if flag{
            loadDataScoure()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK:设置阴影
    func viewLayerShadow() -> Void {
        LGYTool.viewLayerShadow(view: personView)
        LGYTool.viewLayerShadow(view: MyWalletView)
        LGYTool.viewLayerShadow(view: MyCollectionView)
        LGYTool.viewLayerShadow(view: collectionView)
    }
    
    func setCollectionView() -> Void {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 32)/3.0, height: 90)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(UINib.init(nibName: "PersonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PersonCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataScoure.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCollectionViewCell", for: indexPath) as! PersonCollectionViewCell
        cell.setDataScoure(value: dataScoure[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: //庄园
            let vc = Bundle.main.loadNibNamed("HundredFarmingGardenViewController", owner: nil, options: nil)?.first as! UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1: //我的订单
            let vc = MyOrderViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2: //邀请码
            let vc = Bundle.main.loadNibNamed("QCodeViewController", owner: nil, options: nil)?.first as! QCodeViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3: //收货地址
            let vc = Bundle.main.loadNibNamed("AddressViewController", owner: nil, options: nil)?.first as! AddressViewController
            self.navigationController?.pushViewController(vc, animated: true)
           
            break
        case 4: //设置
            let vc = Bundle.main.loadNibNamed("SetViewController", owner: nil, options: nil)?.first as! SetViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 5: //关于我们
            let vc = Bundle.main.loadNibNamed("AboutUsViewController", owner: nil, options: nil)?.first as! AboutUsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
         self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:个人资料点击响应
    @objc func personViewTapAction() -> Void {
        let vc = Bundle.main.loadNibNamed("PersioninformationViewController", owner: nil, options: nil)?.first as! PersioninformationViewController
        self.navigationController?.pushViewController(vc, animated: true)
         self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:头像点击响应
    @objc func personImageViewTapAction() -> Void {
        let imageV = UIImageView.init(image: persionImageView.image)
        let window = UIApplication.shared.keyWindow
        imageV.tag = 10000
        imageV.frame = (window?.bounds)!
        imageV.contentMode = .center
        window?.addSubview(imageV)
        imageV.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        imageV.isUserInteractionEnabled = true
        imageV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(personImageViewTapActionCancle)))
    }
    
    //MARK:头像展示图片消失
    @objc func personImageViewTapActionCancle() -> Void {
        let window = UIApplication.shared.keyWindow
        let view = window?.viewWithTag(10000)
        view?.removeFromSuperview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         setNavigationBarStyle(type:.Default)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:会员成长值点击响应
    @IBAction func MemberGrowth(_ sender: UIButton) {
        let vc = WebViewController()
        vc.loadDataRichTextType(type: .AboutRule)
        vc.title = "会员积分规则"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:我的钱包
    @IBAction func myWalletAction(_ sender: UIButton) {
        let vc = Bundle.main.loadNibNamed("MyWalletViewController", owner: nil, options: nil)?.first as! MyWalletViewController
        self.navigationController?.pushViewController(vc, animated: true)
         self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:支付码
    @IBAction func paymentCodeAction(_ sender: Any) {
        let vc = Bundle.main.loadNibNamed("PaymentCodeViewController", owner: nil, options: nil)?.first as! PaymentCodeViewController
        self.navigationController?.pushViewController(vc, animated: true)
         self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:加载数据
    func loadDataScoure() -> Void {
        weak var vc = self;
        let cacheName = "api_profile"
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_profile, parameters: ["token":Model_user_information.getToken()], progress: nil,cacheName:cacheName) { (object,isError) in
            if isError {
                return
            }
            let model = Model_api_profile.yy_model(withJSON: object as Any)
            if model != nil{
                vc?.setDataScoure(model: model!)
            }
        }
    }
    
    func setDataScoure(model:Model_api_profile) -> Void {
        PersonViewController.infornation = model
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: PersonViewControllerLoadDataScoure), object: true)
        if model.head_url != nil{
            persionImageView.imageFromURL(model.head_url, placeholder: UIImage.init(named: "loading.png")!)
        }
        let integ = [1000,2500.0,5000.0,12600.0]
        for item in integ{
            if item > Double(model.integral){
                progress.progress = Float(Double(model.integral)/item)
                break
            }
        }
        telLabel.text = "\(model.phone!)"
        let str = "("
        switch model.grade {
        case 0:
            vipNumberLabel.text = str + "普通会员)"
            break
        case 1:
            vipNumberLabel.text = str + "黄金会员)"
            break
        case 2:
            vipNumberLabel.text = str + "铂金会员)"
            break
        case 3:
            vipNumberLabel.text = str + "砖石会员)"
            break
        case 4:
            vipNumberLabel.text = str + "顶级会员)"
            break
        default:
            break
        }
        vipCountLabel.text = String.init(format: "会员成长值%D", model.integral)
        walletLabel.text = String.init(format: "%D", model.integral)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        loadDataScoure()
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
