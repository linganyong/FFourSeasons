//
//  WebViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/30.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

enum RichTextType:Int {
    case AboutProblem = 1 //常见问题
    , AboutAgreement = 2 //注册协议
    , AboutRule = 3 //积分规则
    , PerksBirth = 4 //生日特权
    , PerksVip = 5 //vip特权
}

class WebViewController: UIViewController {
    let webView = UIWebView()
    var loadType:RichTextType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = self.view.bounds
        webView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(webView)
    }

    //MARK:加载url
    func loadAuthPage(urlString:String){
        let url = NSURL(string:urlString)
        let request = NSURLRequest(url:url! as URL)
        webView.loadRequest(request as URLRequest)
    }
    
    func loadDataRichTextType(type:RichTextType) -> Void {
        navigationItemBack(title: "    ")
        loadType = type
        switch loadType! {
        case .AboutRule: //积分规则
            loadAboutDataScoure()
            break
        case .AboutProblem: //常见问题
            loadAboutDataScoure()
            break
        case .AboutAgreement: //注册协
            loadAboutDataScoure()
            break
        case .PerksBirth: //生日特权
            loadPerksDataScoure()
            break
        case .PerksVip: //vip特权
            loadPerksDataScoure()
            break
        }
    }
    
    //MARK:加载文本
    func loadAuthPage(htmlStr:String){
//        NSURL.fileURL(withPath: Bundle.main.bundlePath)
        webView.loadHTMLString(htmlStr, baseURL: nil)
//        webView.loadHTMLString(htmlStr, baseURL:URL(fileURLWithPath: Bundle.main.bundlePath))
//        webView.loadHTMLString(htmlStr, baseURL: URL(fileURLWithPath: Bundle.main.resourcePath ?? ""))
    }
    
    //MARK:生日特权
    private func loadPerksDataScoure() -> Void {
        weak var vc = self;
        //MARK:加载产品分类信息
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_perks, parameters: ["token":Model_user_information.getToken()],progress: nil, cacheName:"perks") { (object,isError) in
            let model = Model_api_about.yy_model(withJSON: object as Any)
            if model != nil && LGYAFNetworking.isNetWorkSuccess(str: model?.code)
            {
                vc?.aboutDataScoure(model: model!)
            }
        }
    }
    
    
   
    
    //MARK:常见问题 注册协议 积分规则
    private func loadAboutDataScoure() -> Void {
        weak var vc = self;
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_about, parameters: ["token":Model_user_information.getToken()],progress: nil,cacheName:"about") { (object,isError) in
            let model = Model_api_about.yy_model(withJSON: object as Any)
            if model != nil && LGYAFNetworking.isNetWorkSuccess(str: model?.code)
            {
                vc?.aboutDataScoure(model: model!)
            }
        }
    }
    
   private func aboutDataScoure(model:Model_api_about)->Void{
        switch loadType! {
        case .AboutRule:
            loadAuthPage(htmlStr: model.rule)
            break
        case .AboutProblem:
            loadAuthPage(htmlStr: model.problem)
            break
        case .AboutAgreement:
            loadAuthPage(htmlStr: model.agreement)
            break
        case .PerksBirth:
            loadAuthPage(htmlStr: model.birth)
            break
        case .PerksVip:
            loadAuthPage(htmlStr: model.vip)
            break
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
