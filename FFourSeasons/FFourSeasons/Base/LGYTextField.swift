//
//  LGYTextField.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/14.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

protocol LGYTextFieldDelegate {
    func lgyTextField(textField:LGYTextField) -> Void;
}

class LGYTextField: UITextField {
    var lgyDelegate:LGYTextFieldDelegate?
    override func deleteBackward() {
        super.deleteBackward()
        lgyDelegate?.lgyTextField(textField: self)
    }

}
