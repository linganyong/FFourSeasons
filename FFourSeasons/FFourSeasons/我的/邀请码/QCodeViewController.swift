//
//  QCodeViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/7.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit


class QCodeViewController: UIViewController,ShareViewDelegate {

 var rightBarItem:UIBarButtonItem!
    var shapeView:ShareView?
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var codeCopyBackView: UIView!
    var cardText = "123456789"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "邀请码"
        navigationItemBack(title: "    ")
        
        let cardName = "123456789"
        let avatar = UIImage(named: "相机.jpg")
        HMScannerController.cardImage(withCardName: cardName, avatar: avatar, scale: 0.2) { (image) -> Void in
            self.cardImageView.image = image
           
        }
        
          rightBarItem = navigationBarAddRightItem(title: "邀请码兑换", target: self, action: #selector(rightBarAction))
        setBackgroundColor()
    }

    @IBAction func copyAction(_ sender: UIButton) {
         UIPasteboard.general.string = self.codeLabel.text
    }
    
    //MARK:绑定好友点击响应
    @IBAction func bindingFriendsAction(_ sender: UIButton) {
        
    }
    
  
    //MARK:点击邀请码兑换
    @objc func rightBarAction() -> Void {
        let vc = Bundle.main.loadNibNamed("BindingGoodFriendsViewController", owner: nil, options: nil)?.first as! BindingGoodFriendsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:点击分享
    @IBAction func sharpeAction(_ sender: UIButton) {
        if shapeView == nil {
            shapeView = ShareView.initShareView(titleArray: ["",""], imageArray: ["sharpF.png","sharpC.png"])
            shapeView?.frame = (UIApplication.shared.keyWindow?.bounds)!
            shapeView?.delegate = self
        }
        shapeView?.show()
    }
    
    
    //MARK:微信分享到回话调用入口
    func weixinShareAction(title:String?,description:String?,imageName:String?,pageUrlStr:String?,isWXSceneSession:Bool) {
        let message = WXMediaMessage()
        if title != nil {
            message.title = title
        }
        if description != nil {
            message.description = description!
        }
        if imageName != nil{
            message.setThumbImage(UIImage(named: imageName!))
        }
        let webPageObject = WXWebpageObject()
        if pageUrlStr != nil {
            webPageObject.webpageUrl = pageUrlStr
        }
        message.mediaObject = webPageObject
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        if isWXSceneSession {
            req.scene = Int32(WXSceneSession.rawValue)
        }else{
            req.scene = Int32(WXSceneTimeline.rawValue)
        }
        WXApi.send(req)
    }
    

    //MARK:ShareViewDelegate pro 分享代理回调
    func shareView(shareView: ShareView, selectIndex: NSInteger) {
        shapeView?.cancle()
        if selectIndex == 0{
            weixinShareAction(title: "分享", description: "这是一段描述",imageName: "icon.jpeg",pageUrlStr:"https://www.baidu.com",isWXSceneSession: true)
        }else{
            weixinShareAction(title: "分享", description: "这是一段描述",imageName: "icon.jpeg",pageUrlStr:"https://www.baidu.com",isWXSceneSession: false)
        }
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
    }
    
    
}
