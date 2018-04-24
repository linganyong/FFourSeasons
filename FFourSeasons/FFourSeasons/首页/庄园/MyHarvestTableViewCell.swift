//
//  MyHarvestTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/7.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

protocol MyHarvestTableViewCellDelegate {
    func myHarvestTableViewCell(cell:MyHarvestTableViewCell,actionKey:String) ->Void
}

class MyHarvestTableViewCell: UITableViewCell {
    var modelOrder:OrderList?
    @IBOutlet weak var maginLeftLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var maginTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var maginBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var line1Label: UILabel!
    @IBOutlet weak var line2Label: UILabel!
    @IBOutlet weak var line3Label: UILabel!
    @IBOutlet weak var butonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    
    @IBOutlet weak var btnLeftWidthLC: NSLayoutConstraint!
    @IBOutlet weak var btnRightWidthLC: NSLayoutConstraint!
    @IBOutlet weak var buttonLeftView: UIView!
    @IBOutlet weak var buttonRightView: UIView!
    var model:Goods?
    var myDelegate:MyHarvestTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        LGYTool.viewLayerShadow(view: backView)
        //背景3x.png
        buttonLeftView.LGyCornerRadius = butonLeft.LGyCornerRadius
        buttonRightView.LGyCornerRadius = buttonRight.LGyCornerRadius
        LGYTool.viewLayerShadow(view: buttonLeftView) //添加阴影
        LGYTool.viewLayerShadow(view: buttonRightView) //添加阴影
    }

    func setDataScoure(imageUrl:String?,line1Str:String?,line2Str:String?,line3Str:String?) -> Void {
       
        if imageUrl != nil{
            productImageView.lGYImageFromURL(imageUrl: imageUrl!, placeholderImageName: "loading.png")
        }
        
        line1Label.text = line1Str
        line2Label.text = line2Str
        line3Label.text = line3Str
    }
    
    func setModel(item:Goods,delegate:MyHarvestTableViewCellDelegate?) -> Void {
        model = item
        myDelegate = delegate
        if model?.small_icon != nil{
            productImageView.lGYImageFromURL(imageUrl: (model?.small_icon!)!, placeholderImageName: "loading.png")
        }else{
            productImageView.image = nil
        }
        
        line1Label.text = model?.title
        line2Label.text = model?.profile
        line3Label.text = String.init(format: "x%@", (model?.price)!)
    }
    
    func setModelOrder(item:OrderList,delegate:MyHarvestTableViewCellDelegate?) -> Void {
        modelOrder = item
        myDelegate = delegate
        if  let details = item.detail?.first{
            if let imageUrl = details.small_icon{
                productImageView.lGYImageFromURL(imageUrl: imageUrl, placeholderImageName: "loading.png")
            }else{
                productImageView.image = nil
            }
            line1Label.text = "\(details.title!) x\(details.count)"
            let str = "\(modelOrder!.pay_status)"
            switch str{
            case orderWaitPay: //未付款
                line2Label.text = "待付款"
                break
            case orderCancle: //取消订单
                line2Label.text = "交易关闭"
                break
            case orderPaySuccess: //付款成功
                line2Label.text = "待发货"
                break
            case orderWaitReceipt: //待收货
                line2Label.text = "待收货"
                break
            case orderWaitEvaluate: //待评价
                line2Label.text = "待评价"
                break
            case orderCustomerService: //售后
                line2Label.text = "申请售后中"
                break
            case orderCustomerFail: //售后
                line2Label.text = "售后审核失败"
                break
            case orderCustomerSuccess: //售后
                line2Label.text = "售后审核成功"
                break
            case orderComplete:  //已完成
                line2Label.text = "交易完成"
                break
            default:
                break
            }
            if modelOrder?.order_type == 0{
                line3Label.text = "￥\((modelOrder?.price)!)"
            }else{
                line3Label.text = "\((modelOrder?.pay_integral)!) 积分"
            }
            
        }
    }
    
    func buttonTitle(leftStr:String?,rightStr:String?) -> Void {
        if rightStr == nil {
            buttonRight.isHidden = true
            btnRightWidthLC.constant = 0
            
        }else{
            buttonRight.isHidden = false
            btnRightWidthLC.constant = 50
            buttonRight.setTitle(rightStr, for: .normal)
        }
        
        if leftStr == nil {
            butonLeft.isHidden = true
            btnLeftWidthLC.constant = 0
        }else{
            butonLeft.isHidden = false
            btnLeftWidthLC.constant = 50
            butonLeft.setTitle(leftStr, for: .normal)
        }
    }
    
    @IBAction func action(_ sender: UIButton) {
        myDelegate?.myHarvestTableViewCell(cell: self, actionKey: (sender.titleLabel?.text)!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
