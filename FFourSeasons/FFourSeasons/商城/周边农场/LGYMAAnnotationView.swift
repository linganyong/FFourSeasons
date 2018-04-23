//
//  MyMAAnnotationView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/24.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

protocol LGYMAAnnotationViewDelegate {
    func lgyMAAnnotationViewFarm(farm:Farm)->Void;
}

class LGYMAAnnotationView: MAAnnotationView {
    var farm:Farm? //农场信息
    var myDelegete:LGYMAAnnotationViewDelegate?
    
    func setDelegate(delegete:LGYMAAnnotationViewDelegate)->Void{
        myDelegete = delegete
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    @objc func tapAction()->Void{
        myDelegete?.lgyMAAnnotationViewFarm(farm: farm!)
    }
}
