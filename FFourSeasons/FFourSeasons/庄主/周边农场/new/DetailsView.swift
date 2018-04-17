//
//  DetailsView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/13.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

protocol DetailsViewDelegate {
    func detailsView(view:DetailsView,farmGoods:FarmGoods)->Void
    func detailsViewGoToAction(view:DetailsView)->Void
}

class DetailsView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    private static let defaultView = Bundle.main.loadNibNamed("DetailsView", owner: nil, options: nil)?.first as! DetailsView
    private var delegate:DetailsViewDelegate?
    let layout = UICollectionViewFlowLayout()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var goToButton: UIButton!
    var listGoods = Array<FarmGoods>()
    
    @IBOutlet weak var desTitleHeightLC: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var desTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionViewHeightLC: NSLayoutConstraint!
    //MARK:模仿Android toast 弹出提示
    class func show(array:Array<FarmGoods>,superView:UIView,delegate:DetailsViewDelegate?) ->DetailsView{
        let view = DetailsView.defaultView
        view.listGoods = array
        view.delegate = delegate
        view.frame = superView.bounds
        superView.addSubview(view)
        view.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
        view.setCollectionView()
        if array.count == 0{
            view.collectionViewHeightLC.constant = 0
        }else{
            let row = Int(array.count/3+1)
            view.collectionViewHeightLC.constant = ((view.collectionView.frame.size.width)/3)*CGFloat(row)
        }
        return view
    }
    
    func setCollectionView() -> Void {
        LGYTool.buttonCornerRadiusImage(button: goToButton, imageName: "背景3x.png", title: "立即前往")
        if collectionView.delegate == nil {
            backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancle)))
            self.layoutIfNeeded()
            layout.itemSize = CGSize(width: (collectionView.frame.size.width-20)/3, height: (collectionView.frame.size.width-20)/3)
            layout.minimumInteritemSpacing = 10
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.collectionViewLayout = layout
            collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "UICollectionViewCell")
            collectionView.bounces = false
        }else{
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listGoods.count == 0{
            desTitleLabel.isHidden = true
            desTitleHeightLC.constant = 0
        }else{
            desTitleLabel.isHidden = false
            desTitleHeightLC.constant = 40
        }
        return listGoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        var imageView = cell.viewWithTag(10000) as?  UIImageView
        if imageView == nil{
           imageView = UIImageView(frame: cell.bounds)
            imageView?.tag = 10000
            cell.addSubview(imageView!)
        }
        let  good = listGoods[indexPath.row]
        if let url = good.small_icon {
            imageView?.imageFromURL(url, placeholder:  UIImage.init(named: "loading.png")!)
            imageView?.contentMode = .scaleAspectFill
        }else{
            imageView?.image = nil
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.detailsView(view: self, farmGoods: listGoods[indexPath.row])
        cancle()
    }
    
    @IBAction func goToAction(_ sender: Any) {
        self.delegate?.detailsViewGoToAction(view: self)
    }
    @objc func cancle() ->Void{
        self.removeFromSuperview()
    }
}
