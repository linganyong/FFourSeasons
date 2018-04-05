//
//  AboutUsViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/2.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    @IBOutlet weak var line4View: UIView!
    @IBOutlet weak var line3View: UIView!
    @IBOutlet weak var line2View: UIView!
    @IBOutlet weak var line1View: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于我们"
        navigationItemBack(title: "    ")
        viewLayerShadow()
        setBackgroundColor()
    }
    
    func viewLayerShadow() -> Void {
        LGYTool.viewLayerShadow(view: line1View)
        LGYTool.viewLayerShadow(view: line2View)
        LGYTool.viewLayerShadow(view: line3View)
        LGYTool.viewLayerShadow(view: line4View)
    }
    
    @IBAction func action(_ sender: UIButton) {
        switch sender.LGYLabelKey {
        case "1"?:
            
            break
        case "2"?:
            
            break
        case "3"?:
           
            
            break
        case "4"?:
            let vc = Bundle.main.loadNibNamed("OpinionViewController", owner: nil, options: nil)?.first as! OpinionViewController
            self.navigationController?.pushViewController(vc, animated: true)
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
