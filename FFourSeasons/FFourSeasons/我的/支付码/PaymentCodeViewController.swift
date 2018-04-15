//
//  PaymentCodeViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/2.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class PaymentCodeViewController: UIViewController {

    @IBOutlet weak var ScannerImageView: UIImageView!
    @IBOutlet weak var generateCodeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        title = "积分付码"
        navigationItemBack(title: "")
//        HMScannerController.cardImage(withCardName: cardName, avatar: avatar, scale: 0.2) { (image) -> Void in
//
//
//        }
        generateCodeImageView.image = LGYTool.generateBarCode(messgae: "123456789", width: generateCodeImageView.frame.width, height: generateCodeImageView.frame.height)
    }

     
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
