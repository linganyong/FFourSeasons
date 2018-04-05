//
//  SignAddIntegralTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class SignAddIntegralTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func setModel(date:String?,countStr:String,detail:String) -> Void {
        dateLabel.text = date
        countLabel.text = countStr
        detailLabel.text = detail
    }
}
