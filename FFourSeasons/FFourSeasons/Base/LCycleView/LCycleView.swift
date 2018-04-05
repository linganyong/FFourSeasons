//
//  MCCycleView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/2.
//  Copyright © 2018年 LGY. All rights reserved.
//

import UIKit
import SnapKit

protocol LCycleViewDelegate {
    func lcyCleView(lcyCleView:LCycleView,didSelectItemAt indexPath:IndexPath) -> Void ;
}

class LCycleView: UIView, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    private var collectionView: UICollectionView!
    private var pageControl:UIPageControl!
    private var timer: Timer?
    private var imageNameUrl:NSArray?
    private var picArr = NSMutableArray(capacity: 100)
    private var currentPage = 0
    private let CycleReuseIdentifier = "LCycleCell"
    private var maxCount = 900000000
    private var selectIndex = 0
    let pageControlBackView = UIView.init()
    var delegate:LCycleViewDelegate?
    var isAutoScroller = true
    
    func setup(array:NSArray) {
        getDataScoure(array:array)
        
        //设置flowLayout属性
        if collectionView == nil{
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.scrollDirection = .horizontal
            collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
            collectionView.isPagingEnabled = true
            collectionView.register(LCycleCell.classForCoder(), forCellWithReuseIdentifier: CycleReuseIdentifier)
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.delegate = self
            collectionView.dataSource = self
            addSubview(collectionView)
            collectionView.snp.makeConstraints { (make) in
                make.top.equalTo(self.snp.top)
                make.left.equalTo(self.snp.left)
                make.bottom.equalTo(self.snp.bottom)
                make.right.equalTo(self.snp.right)
            }
        }
        
        
        if pageControl == nil{
           addSubview(pageControlBackView)
            pageControl = UIPageControl()
            pageControl.currentPageIndicatorTintColor = UIColor.white
            pageControlBackView.addSubview(pageControl)
            
            pageControl.snp.makeConstraints { (make) in
                make.centerY.equalTo(pageControlBackView.snp.centerY)
                make.right.equalTo(pageControlBackView.snp.right).offset(-10)
                make.left.equalTo(pageControlBackView.snp.left).offset(10)
            }
            
            pageControlBackView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.snp.centerX)
                make.bottom.equalTo(self.snp.bottom).offset(-5)
                make.height.equalTo(10.0)
            }
            pageControlBackView.LGyCornerRadius = 5
         
        }
        
       
            //默认滚动到中间的那一组
            maxCount = picArr.count*3
            pageControl.numberOfPages = array.count
            if isAutoScroller{
                 if array.count > 1{
                    //添加定时器
                    addTimer()
                 }else{
                     pageControlBackView.isHidden = true
                }
            }
        collectionView.reloadData()
    }
    
    //MARK:设置圆点颜色
    func pageColor(defaultColor:UIColor,selectColor:UIColor) -> Void {
        pageControl.currentPageIndicatorTintColor = selectColor
        pageControl.pageIndicatorTintColor = defaultColor
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height)
    }
    
    func getDataScoure(array:NSArray) -> Void {
        picArr = NSMutableArray(capacity: 100)
        for  item in array{
            picArr.add(item)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK:用于循环滚动，分三组，滚动到第一组或第三组就移动到第二组，让cell一直保持在第二组，这样就可以循环滚动和拖动。
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxCount //三倍
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.lcyCleView(lcyCleView: self, didSelectItemAt: indexPath)
    }
    
    //MARK:设置cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CycleReuseIdentifier, for: indexPath) as! LCycleCell
        selectIndex = indexPath.row % picArr.count
        cell.addImageUrl(imageUrl: (picArr[selectIndex] as? String)!)
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    //MARK:设置循环滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x/(scrollView.frame.size.width-1))
        pageControl?.currentPage = currentPage % picArr.count
        
        if scrollView.contentOffset.x == 0 {
            let middleIndexPath = IndexPath.init(row: picArr.count*1, section: 0)
            collectionView.scrollToItem(at: middleIndexPath, at: .right, animated: false)
        }
        if currentPage == maxCount - 1{
            let middleIndexPath = IndexPath.init(row: picArr.count*1+currentPage%picArr.count, section: 0)
            collectionView.scrollToItem(at: middleIndexPath, at: .right, animated: false)
        }
    }
    
    //MARK:在开始拖拽的时候移除定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    
    //MARK:结束拖拽的时候重新添加定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutoScroller{
            //添加定时器
            addTimer()
        }
    }
    
    //MARK:定时器
    private func addTimer() {
        timer?.invalidate()
        timer = nil
        timer = Timer(timeInterval: 4, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    //MARK:定时器方法
    @objc private func nextImage() {
        //获取中间那一组的indexPath
        if currentPage < maxCount{
            let middleIndexPath = IndexPath.init(row: currentPage+1, section: 0)
            collectionView.scrollToItem(at: middleIndexPath, at: .left, animated: true)
        }
    }
}
