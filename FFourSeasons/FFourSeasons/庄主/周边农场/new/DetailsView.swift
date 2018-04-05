//
//  DetailsView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/13.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class DetailsView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    private static let defaultView = Bundle.main.loadNibNamed("DetailsView", owner: nil, options: nil)?.first as! DetailsView
    private var callBlock:LGYToastViewCallBlock?
 
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:模仿Android toast 弹出提示
    class func show(block:LGYToastViewCallBlock?) ->DetailsView{
        let view = DetailsView.defaultView
        let window = UIApplication.shared.keyWindow
        view.frame = (window?.bounds)!
        window?.addSubview(view)
        view.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
        view.setCollectionView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(cancle)))
        return view
    }
    
    func setCollectionView() -> Void {
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (collectionView.frame.size.width-20)/3, height: collectionView.frame.size.height)
        layout.minimumInteritemSpacing = 10
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.bounces = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        var imageView = cell.viewWithTag(10000) as?  UIImageView
        if imageView == nil{
           imageView = UIImageView(frame: cell.bounds)
            imageView?.tag = 10000
            cell.addSubview(imageView!)
        }
        imageView?.image = UIImage.init(named: "loading.jpg")
        
        return cell
    }
    
    @objc func cancle() ->Void{
        self.removeFromSuperview()
    }
}
