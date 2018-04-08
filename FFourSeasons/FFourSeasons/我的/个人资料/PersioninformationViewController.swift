//
//  PersioninformationViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class PersioninformationViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate,LGYImageSelectViewControllerDelegate {
  
    var infornation:Model_api_profile?
    var avatar_url:String?
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var persionImageView: UIImageView!
    @IBOutlet weak var persionImageBackView: UIView!
    @IBOutlet weak var line1BackView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var line2BackView: UIView!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var line3BackView: UIView!
    
    @IBOutlet weak var sexLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人资料"
        navigationItemBack(title: "      ")
        viewLayerShadow()
        setBackgroundColor()
        setInformation()
        avatar_url =  PersonViewController.infornation?.head_url
    }

    //MARK:修改头像
    @IBAction func persionImageBackViewTapAction(_ sender: Any) {
        if infornation == nil {
            return
        }
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let vc = Bundle.main.loadNibNamed("LGYImageSelectViewController", owner: nil, options: nil)?.first as! LGYImageSelectViewController
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            alertView(_title: "您还没有开启相册权限", _message: "请您到：设置 > 人人庄园 中添加相册权限", _bText: "确定")
        }
       
    }
    
    func setInformation() -> Void {
        infornation = PersonViewController.infornation
        if infornation != nil {
            noLabel.text = "ID \(PersonViewController.infornation!.phone!)"
            if infornation?.head_url != nil{
                persionImageView.imageFromURL((infornation?.head_url)!, placeholder: UIImage.init(named: "loading.jpg")!)
            }
            nameLabel.text = infornation?.nick_name
            phoneLabel.text = infornation?.phone
            if infornation?.sex == 0{
                sexLabel.text = "保密"
            }
            if infornation?.sex == 1{
                 sexLabel.text = "男"
            }
            if infornation?.sex == 2{
                sexLabel.text = "女"
            }
        }
    }
   
    //MARK:修改头像代理图片回调
    func lgyImageSelectViewController(viewController: LGYImageSelectViewController, image: UIImage, imagePath: String) {
        viewController.navigationController?.popViewController(animated: true)
        weak var vc = self
        LGYAFNetworking.lgyPushImage(urlString: APIAddress.api_upload, parameters: nil,array: [image], progress: nil) { (url, isError) in
            if isError || url == nil || !(url?.contains("http"))!{
                return
            }
            vc?.persionImageView.image = image
            vc?.avatar_url = url
            vc?.loadDataScoure(avatar_url:url!)
            
        }
    }
    
    //MARK:菜单
    @IBAction func lineMenuAction(_ sender: UIButton) {
        weak var selfVC = self
        switch sender.LGYLabelKey {
        case "1"?:
            let view = LGYAlertView.show(title: "修改昵称", placeholder: "请输入新的昵称", leftStr: "确定", rightStr: "取消")
            view.callBlock = { (key,text) in
                if key.elementsEqual("1") && text?.count != 0 {
                    selfVC?.nameLabel.text = text
                    selfVC?.loadDataScoure(avatar_url:(selfVC?.avatar_url!)!)
                }
            }
//            upDateName()
            break
        case "2"?:
            let vc = Bundle.main.loadNibNamed("BindingPhoneViewController", owner: nil, options: nil)?.first as! BindingPhoneViewController
            vc.persionVC = self
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "3"?:
            LGYLineSelectView.show(array: ["男","女"], block: { (sex, index) in
                selfVC?.sexLabel.text = sex
                selfVC?.loadDataScoure(avatar_url: (selfVC?.avatar_url)!)
            })
            break
        default:
            break
        }
        
    }
    
    func viewLayerShadow() ->Void{
        LGYTool.viewLayerShadow(view: persionImageBackView)
        LGYTool.viewLayerShadow(view: line1BackView)
        LGYTool.viewLayerShadow(view: line2BackView)
        LGYTool.viewLayerShadow(view: line3BackView)
    }
    
    
    //MARK:加载数据
    func loadDataScoure(avatar_url:String) -> Void {
        var type = 0
        if (sexLabel.text?.contains("男"))! {
            type = 1
        }
        if (sexLabel.text?.contains("女"))! {
            type = 2
        }
        //MARK:加载产品分类信息
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_editInfo,
                                parameters: ["avatar_url":avatar_url
                                             ,"nick_name":nameLabel.text!
                                             ,"sex":String.init(format: "%D", type)
                                             ,"token":Model_user_information.getToken()]
        , progress: nil) { (object,isError) in
            if isError {
                return
            }
            let model = Model_user_information.yy_model(withJSON: object as Any)
            print(object as Any)
            if model != nil && model?.msg != nil {
                LGYToastView.show(message: (model?.msg)!)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBarStyle(type:.White)
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarStyle(type:.White)
        
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
