//
//  EvaluateTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/22.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class EvaluateTableViewCell: UITableViewCell,UITextViewDelegate {
    @IBOutlet weak var desTextView: UITextView!
    @IBOutlet weak var desLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    let desLabelStr = "请输入您的评价"
    @IBOutlet weak var imageBackView: UIView!
    var model:OrderDetails?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.masksToBounds = true
        LGYTool.viewLayerShadow(view: imageBackView)
        setTextView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setModel(item:OrderDetails)->Void{
        model = item
        if let imageUrl = item.small_icon{
            iconImageView.imageFromURL(imageUrl, placeholder: UIImage.init(named: "loading.png")!)
        }else{
            iconImageView.image = UIImage.init(named: "loading.png")
        }
    }
    
    func setTextView() -> Void {
        desLabel.text = desLabelStr
        desTextView.delegate = self
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == nil || textView.text.count == 0{
            desLabel.text = desLabelStr
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        desLabel.text = ""
        return true
    }
    
}
