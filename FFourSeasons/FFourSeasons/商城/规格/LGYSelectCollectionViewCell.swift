//
//  LGYSelectCollectionViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/26.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class LGYSelectCollectionViewCell: UICollectionViewCell {

    let defaultBackColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
    let selectBackColor = UIColor(red: 42/255.0, green: 201/255.0, blue: 140/255.0, alpha: 1)
    
    let defaultTextColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
    let selectTextColor = UIColor.white
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setText(text:String?) -> Void{
        textLabel.text = text
        textLabel.font = UIFont.systemFont(ofSize: 8.0)
//        defualtStyle()
    }
    
    func defualtStyle() -> Void {
        textLabel.textColor = defaultTextColor
        textLabel.backgroundColor = defaultBackColor
    }
    
    func selectStyle() -> Void {
        textLabel.textColor = selectTextColor
        textLabel.backgroundColor = selectBackColor
    }
    
    
}
