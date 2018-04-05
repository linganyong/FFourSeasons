//
//  RechargeCollectionViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class RechargeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var line1Label: UILabel!
    @IBOutlet weak var line2Label: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        let image = UIImageView(frame: self.frame)
//        image.image = UIImage.init(named: "组43x.png")
//        self.selectedBackgroundView = image
//
//        let image1 = UIImageView(frame: self.frame)
//        image.image = UIImage.init(named: "组43x.png")
//        self.selectedBackgroundView = image
        self.isSelected = false
        
       self.addObserver(self, forKeyPath: "selected", options: .new, context: nil)
        
   
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath?.elementsEqual("selected"))!{
            if Bool(change![NSKeyValueChangeKey.newKey] as! NSNumber) {
                backImageView.image = UIImage.init(named: "组43x.png")
            }else{
                backImageView.image = UIImage.init(named: "灰色3x.png")
            }

        }
    }
    
    func setDataScoure(line1Str:String,line2Str:String) -> Void {
        line1Label.text = line1Str
        line2Label.text = line2Str
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "selected")
    }
}
