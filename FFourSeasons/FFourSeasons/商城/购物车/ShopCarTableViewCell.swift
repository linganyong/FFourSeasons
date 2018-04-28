//
//  ShopCarTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/2.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

protocol ShopCarTableViewCellDelegate:NSObjectProtocol {
    func shopCarTableViewCellTapDeleteAction(cell:ShopCarTableViewCell,indexPath:IndexPath,isSelect:Bool) -> Void
    func shopCarTableViewCell(cell:ShopCarTableViewCell,indexPath:IndexPath,isSelect:Bool) -> Void
    func shopCarTableViewCell(newCount:Int,oldCount:Int,price:Float,ndexPath:IndexPath,isSelect:Bool)
    func animationShouldStart(cell: ShopCarTableViewCell) ->Void
    func animationDidStop(cell: ShopCarTableViewCell) ->Void
}

class ShopCarTableViewCell: UITableViewCell,CAAnimationDelegate,UITextFieldDelegate {

    let animationDuration = CFTimeInterval(0.6)
   
    weak var _tableView:UITableView?
    var timer:Timer?
    weak var viewController:UIViewController?
    let copyCellTag = 100000
    var animationFinish = true
    var isImageSelected = false
    var indexPath:IndexPath!
    weak var delegate:ShopCarTableViewCellDelegate?
    var model:CartList?
    
    @IBOutlet weak var specLabel: UILabel!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var isSelectImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageBackView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageBackView.LGyCornerRadius = productImageView.LGyCornerRadius
        LGYTool.viewLayerShadow(view: productImageBackView)
        countTextField.delegate = self
        addKVO()
    }
    
    func addKVO() {
        countTextField.addObserver(self, forKeyPath: "text", options: [.new, .old], context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "text"){
            let newStr = change![NSKeyValueChangeKey.newKey] as! String
            let oldStr = change![NSKeyValueChangeKey.oldKey] as! String
            delegate?.shopCarTableViewCell(newCount: Int(newStr)!, oldCount: Int(oldStr)!, price: Float((priceLabel.text?.replacingOccurrences(of: "￥", with: ""))!)!, ndexPath: indexPath, isSelect: isImageSelected)
        }
    }
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //MARK:点击选择或非选择响应
    @IBAction func action(_ sender: UIButton) {
        tapIsSelect()
    }
    
    func tapIsSelect(){
        isImageSelected = !isImageSelected
        if isImageSelected {
            isSelectImageView.image = UIImage.init(named: "首页卡片左上角圆")
        }else{
            isSelectImageView.image = nil
        }
        if self.priceLabel.text!.contains("￥"){
            delegate?.shopCarTableViewCell(cell: self, indexPath: indexPath, isSelect: isImageSelected)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func add(_ sender: UIButton) {
        var count = Int(countTextField.text!)!
        
            count += 1
            countTextField.text = String(format: "%d", arguments: [count])
        
    }
    
    @IBAction func reduce(_ sender: UIButton) {
        var count = Int(countTextField.text!)!
        if count  > 0 {
            count -= 1
            countTextField.text = String(format: "%d", arguments: [count])
        }
    }
    
    func setDataScoure(tableView:UITableView,buttonTag:Int,item:CartList?,imageSelected:Bool,cellIndexPath:IndexPath,isEdit:Bool) -> Void {
        if item == nil{
            return
        }
        model = item
        var price = "￥\(model!.price!)"
        if item?.goods_type == 1{
            price = "\(model!.price!) 积分"
        }
        setDataScoure(tableView: tableView, buttonTag: buttonTag, imageUrl: model!.item_url, productName:model!.name, price: price, imageSelected: imageSelected, cellIndexPath: cellIndexPath, isEdit: isEdit)
    }
    

    func setDataScoure(tableView:UITableView,buttonTag:Int,imageUrl:String?,productName:String,price:String,imageSelected:Bool,cellIndexPath:IndexPath,isEdit:Bool){
        _tableView = tableView
        deleteButton.tag = buttonTag
        isImageSelected = imageSelected
        indexPath = cellIndexPath
        
        priceLabel.text = price
        if imageUrl != nil{
            productImageView.imageFromURL(imageUrl!, placeholder: UIImage(named: "loading.png")!)
        }else{
             productImageView.image = UIImage(named: "loading.png")
        }
        productNameLabel.text = productName
        specLabel.text = model?.spec
        countTextField.text = String.init(format: "%D", model!.count)
        if isEdit {
            deleteButton.isHidden = false
        }else{
            deleteButton.isHidden = true
        }
       
        if isImageSelected {
            isSelectImageView.image = UIImage.init(named: "首页卡片左上角圆")
        }else{
            isSelectImageView.image = nil
        }
        if self.priceLabel.text!.contains("￥"){
            delegate?.shopCarTableViewCell(cell: self, indexPath: indexPath, isSelect: isImageSelected)
        }
    }

    
    @IBAction func delegateAction(_ sender: UIButton) {
        if self.priceLabel.text!.contains("￥"){
            self.delegate?.shopCarTableViewCellTapDeleteAction(cell: self, indexPath: indexPath, isSelect: isImageSelected)
        }
    }
    
    
    //MARK:做动画,cell高度变小之外的动画效果在此实现
    @objc func animation() -> Void {
        if viewController == nil || _tableView == nil {
            return
        }
        
        animationFinish = false
        /*
         由于能力有限，无法实现直接的cell动画效果，思路：将动画效果添加到superView上面
         */
        let view = Bundle.main.loadNibNamed("ShopCarTableViewCell", owner: nil, options: nil)?.first as! ShopCarTableViewCell
        view.tag = copyCellTag
        view.priceLabel.text = self.priceLabel.text
        view.productImageView.image = self.productImageView.image
        view.productNameLabel.text = self.productNameLabel.text
        LGYTool.viewLayerShadow(view: view.productImageBackView)
        view.frame = self.convert(self.bounds, to: viewController?.view)
        viewController?.view.insertSubview(view, belowSubview: _tableView!)
        
        transformRotationAnimation(view: view.productImageView)
        transformRotationAnimation(view: view.productImageBackView)
        transformScaleAnimation(cell: view)
        opacityAnimation(cell: view)
        positionAnimation(cell: view)
        delegate?.animationShouldStart(cell: self)
        //删除动画进行时重写设置是否选中状态
        isSelectImageView.image = nil
        isImageSelected = false
        if self.priceLabel.text!.contains("￥"){
            delegate?.shopCarTableViewCell(cell: self, indexPath: indexPath, isSelect: isImageSelected)
        }
    }
    
    //MARK:做旋转动画
    func transformRotationAnimation(view:UIView) -> Void {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = -Float(2.0)*Float(M_PI)
        animation.duration = animationDuration
        //保持动画位置
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = 0
        animation.delegate = self
        view.layer.add(animation, forKey: "555")
    }
     //MARK:做旋缩放动画
    func transformScaleAnimation(cell:ShopCarTableViewCell) {
        // 设定为缩放
        let animation = CABasicAnimation(keyPath: "transform.scale")
        // 动画选项设定
        animation.duration = animationDuration
        // 重复次数(无限)
        animation.repeatCount = 0
        //保持动画位置
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        // 缩放倍数
        animation.fromValue = 1
        // 开始时的倍率
        animation.toValue = 0.3
        animation.delegate = self
        // 结束时的倍率
        // 添加动画
        cell.contentView.layer.add(animation, forKey: "scale-layer")
    }
    
     //MARK:做淡出动画
    func opacityAnimation(cell:ShopCarTableViewCell) {
        // Opacity 属性和alpha属性类似，通过设置 0~1.0的浮点数字可以实现透明效果，默认值为0，表示初试状态为隐藏
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = animationDuration  //动画执行周期
        //保持动画结束之后的状态
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        cell.contentView.layer.add(animation, forKey: "opacity") //添加动画到layer层
    }
    
    //MARK:做平移动画
    func positionAnimation(cell:ShopCarTableViewCell) {
        //1.平移
        let positionAnimation = CABasicAnimation(keyPath: "position.x")
        positionAnimation.duration = animationDuration*2
        //配置起始位置（fromeVaue）和终止位置（toValue）
        positionAnimation.fromValue = self.contentView.frame.size.width/2
        positionAnimation.toValue = -self.contentView.frame.size.width
        //防止执行完成后移除
        positionAnimation.isRemovedOnCompletion = false
        positionAnimation.fillMode = kCAFillModeForwards
        positionAnimation.delegate = self
        cell.contentView.layer.add(positionAnimation, forKey: "position")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let view = viewController?.view.viewWithTag(copyCellTag)
        view?.removeFromSuperview()
        animationFinish = true
        delegate?.animationDidStop(cell: self)
    }
    
    func cellCopy(view: UIView) -> UIView {
        let tempArchive = NSKeyedArchiver.archivedData(withRootObject: view)
        return NSKeyedUnarchiver.unarchiveObject(with: tempArchive) as? UIView ?? UIView()
    }
    
    deinit {
        countTextField.removeObserver(self, forKeyPath: "text", context: nil)
    }
 
}
