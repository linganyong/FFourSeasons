//
//  SetViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/2.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {

    @IBOutlet weak var line5View: UIView!
    @IBOutlet weak var line3View: UIView!
    @IBOutlet weak var line2View: UIView!
    @IBOutlet weak var line1View: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        navigationItemBack(title: "    ")
        viewLayerShadow()
        setBackgroundColor()
    }
    
    func viewLayerShadow() -> Void {
        LGYTool.viewLayerShadow(view: line1View)
        LGYTool.viewLayerShadow(view: line2View)
        LGYTool.viewLayerShadow(view: line3View)
        LGYTool.viewLayerShadow(view: line5View)
    }

    @IBAction func Action(_ sender: UIButton) {
        switch sender.LGYLabelKey {
        case "1"?:
            let vc = Bundle.main.loadNibNamed("ChangeUserPassworkViewController", owner: nil, options: nil)?.first as! ChangeUserPassworkViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "2"?:
            let vc = WebViewController()
            vc.loadDataRichTextType(type: .AboutProblem)
            vc.title = "常见问题"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "3"?:
            let vc = Bundle.main.loadNibNamed("OpinionViewController", owner: nil, options: nil)?.first as! OpinionViewController
           
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "4"?:
            let ss = "ashf4lasjd%&fhasdh9sdih"
            //设置原来密码为空
            if let passwordItem = KeychainConfiguration.get(forKey: ss){
                KeychainConfiguration.save(userName: passwordItem.account, passwork: "", forKey: ss)
            }
            let vc = Bundle.main.loadNibNamed("RegisterOrLaunchViewController", owner: nil, options: nil)?.first as! RegisterOrLaunchViewController
            vc.isNeedRootPage = false
            let na = UINavigationController(rootViewController: vc);
            self.present(na, animated: true, completion: {
                
            })
            
            break
            
        default:
             break
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
}
