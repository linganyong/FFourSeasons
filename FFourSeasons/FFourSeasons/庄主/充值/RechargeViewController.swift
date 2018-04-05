//
//  RechargeViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class RechargeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var personBackView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHieghtLC: NSLayoutConstraint!
    @IBOutlet weak var playSelect1ImageView: UIImageView!
    @IBOutlet weak var playSelect2ImageView: UIImageView!
    @IBOutlet weak var playSelect3ImageView: UIImageView!
    @IBOutlet weak var playSelect4ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        self.title = "充值"
        LGYTool.viewLayerShadow(view: personBackView)
        setBackgroundColor()
        navigationItemBack(title: "    ")
    }
    
    
    func setCollectionView() ->Void{
        let width = (self.view.frame.size.width-24.0*2.0)/3.0
        let height = width*116/216
        collectionViewHieghtLC.constant = height*2+12
        self.view.layoutIfNeeded()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 12
        flowLayout.itemSize = CGSize( width:width, height: height)
       
        
        collectionView.collectionViewLayout = flowLayout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "RechargeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RechargeCollectionViewCell")
        collectionView.bounces = false
    }
    
    //MARK:会员信息点击响应
    @IBAction func persionAction(_ sender: Any) {
        let vc = Bundle.main.loadNibNamed("PersioninformationViewController", owner: nil, options: nil)?.first as! PersioninformationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func playSelectAction(_ sender: UIButton) {
        playSelect1ImageView.image = UIImage.init(named: "椭圆3x.png")
        playSelect2ImageView.image = UIImage.init(named: "椭圆3x.png")
        playSelect3ImageView.image = UIImage.init(named: "椭圆3x.png")
        playSelect4ImageView.image = UIImage.init(named: "椭圆3x.png")
  
        let str = "选中3x.png"
        switch sender.LGYLabelKey {
        case "1"?:
            playSelect1ImageView.image = UIImage.init(named: str)
            break
        case "2"?:
            playSelect2ImageView.image = UIImage.init(named: str)
            break
        case "3"?:
            playSelect3ImageView.image = UIImage.init(named: str)
            break
        case "4"?:
            playSelect4ImageView.image = UIImage.init(named: str)
            break
        default:
            break
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RechargeCollectionViewCell", for: indexPath)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
       
        
        if (cell?.isFocused)! {
             NSLog("11111111 ------")
        }
        if (cell?.isSelected)! {
            NSLog("22222222 ------")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBarStyle(type: .Default)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarStyle(type: .Default)
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
