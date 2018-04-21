//
//  CouponTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class CouponTableViewCell: UITableViewCell {
    var ruleView:CouponRuleView?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var unitLabelWidthLC: NSLayoutConstraint!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    var isCanSelect = false
    var model:CouponDetail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSelected = false
        self.addObserver(self, forKeyPath: "selected", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !isCanSelect{
            return
        }
        if (keyPath?.elementsEqual("selected"))!{
            if Bool(truncating: change![NSKeyValueChangeKey.newKey] as! NSNumber) {
                backImageView.image = UIImage.init(named: "选中优惠券背景3x.png")
            }else{
                backImageView.image = UIImage.init(named: "优惠券背景3x.png")
            }
            
        }
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "selected")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func action(_ sender: UIButton) {
        if ruleView == nil{
           ruleView = CouponRuleView.defaultView()
        }
        ruleView?.setText(title: "提示", text: "这是一段文字")
        ruleView?.show()
    }
    
    func setItem(item:CouponDetail) -> Void {
        model = item
        if model?.category == 0 { //代扣
            unitLabel.text = "￥"
            countLabel.text = model?.price
        }else{
            unitLabel.text = ""
            countLabel.text = "%.1lf\(model!.discount/10.0)折"
//            limitLabel.text = "限\(model!.total_price!)元用"
        }
//        countLabel.text = "\(100.000/10.00)折"
        limitLabel.text = "满\(model!.total_price!)元用"
        if let str = model?.end_time {
            dateLabel.text = "有效期到：\(str.replacingCharacters(in: str.lgyRange(nsRange: NSRange.init(location: 10, length: str.count - 10))!, with: ""))"
        }
    }
    
}
