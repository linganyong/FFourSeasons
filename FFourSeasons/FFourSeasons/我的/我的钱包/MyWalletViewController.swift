//
//  MyWalletViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/2.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class MyWalletViewController: UIViewController {

    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var persionImageView: UIImageView!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var ChangePayPassworkView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的积分"
        viewLayerShadow()
        navigationItemBack(title: "    ")
        setBackgroundColor()
        setDataScoure()
    }
   
   
    
    //MARK:点击充值
    @IBAction func rechargeAction(_ sender: Any) {
        let vc = Bundle.main.loadNibNamed("RechargeViewController", owner: nil, options: nil)?.first as! RechargeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
     //MARK:设置界面值
    func setDataScoure() -> Void {
        if PersonViewController.infornation != nil{
            nameLabel.text = PersonViewController.infornation!.nick_name
            if PersonViewController.infornation!.head_url != nil{
                persionImageView.imageFromURL((PersonViewController.infornation!.head_url)!, placeholder: UIImage.init(named: "loading.png")!)
            }else{
                persionImageView.image = UIImage(named: "defaultHeader.png")
            }
            moneyLabel.text = String.init(format: "积分：%D", PersonViewController.infornation!.integral)
        }
    }
    
    
    func viewLayerShadow() -> Void {
        LGYTool.viewLayerShadow(view: walletView)
         LGYTool.viewLayerShadow(view: ChangePayPassworkView)
    }
    
    @IBAction func changePayPassworkAction(_ sender: Any) {
        let vc = Bundle.main.loadNibNamed("ChangePayPassworkViewController", owner: nil, options: nil)?.first as! ChangePayPassworkViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBarStyle(type:.White)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarStyle(type:.White)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
