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
    var shareTitle:String?
    var shareConnet:String?
    var shareImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "邀请码"
        navigationItemBack(title: "    ")
        rightBarItem = navigationBarAddRightItem(title: "邀请码兑换", target: self, action: #selector(rightBarAction))
        setBackgroundColor()
        loadInviteCode()
    }

    func setInviteCode(code:String){
        //设置二维码
        HMScannerController.cardImage(withCardName: "/\(code)", avatar: nil, scale: 0.2) { (image) -> Void in
            self.cardImageView.image = image
        }
        codeLabel.text = code
    }
    
    @IBAction func copyAction(_ sender: UIButton) {
        LGYToastView.show(message: "复制成功！")
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
    func weixinShareAction(title:String?,description:String?,image:UIImage,pageUrlStr:String?,isWXSceneSession:Bool) {
        let message = WXMediaMessage()
        if title != nil {
            message.title = title
        }
        if description != nil {
            message.description = description!
        }
         message.setThumbImage(image)
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
        if let code = codeLabel.text {
            let url = "\(APIAddress.api_domainName())/share?code=\(code)"
            if selectIndex == 0{
                weixinShareAction(title: shareTitle, description: shareConnet,image: shareImage!,pageUrlStr:url,isWXSceneSession: true)
            }else{
                weixinShareAction(title:shareTitle, description:shareConnet,image: shareImage!,pageUrlStr:url,isWXSceneSession: false)
            }
        }
    }
    
    //MARK:加载邀请码
    func loadInviteCode() -> Void {
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_inviteCode, parameters: ["token":Model_user_information.getToken()], progress: nil) { [weak self](object, isError) in
            if !isError{
                if let weakSelf = self, let dic = object as? NSDictionary{
                    if let inviteCode = dic["inviteCode"] as? String{
                        weakSelf.setInviteCode(code:inviteCode)
                    }
                    if let item = dic["data"] as? NSDictionary { //分享
                        if let title = item["title"] as? String //分享标题
                            , let mesg = item["content"] as? String //分享内容
                            ,let icon = item["icon"] as? String //分享内容
                        {
                            weakSelf.getShare(title: title, mesg: mesg, icon: icon)
                        }
                    }
                }
                
            }
        }
    }
    
    func getShare(title:String,mesg:String,icon:String)->Void{
        shareImage = UIImage.image(fromURL: icon, placeholder: UIImage(named: "icon.jpeg")!, closure: {[weak self] (image) in
            if image != nil{
                self?.shareImage = image;
            }
        })
        shareTitle = title
        shareConnet = mesg
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
