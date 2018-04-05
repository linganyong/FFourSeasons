//
//  MemberAnalysisViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class MemberAnalysisViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "什么是会员卡"
        setBackgroundColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
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
          navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
    }

}
