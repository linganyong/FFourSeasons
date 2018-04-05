//
//  APPGuideView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/6.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit
typealias APPGuideViewFinishBackBlock = ()->Void
class APPGuideView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    private var timer: Timer?
    private var imageNameUrl:NSArray?
    private var picArr = NSMutableArray(capacity: 100)
    private var currentPage = 0
    private let CycleReuseIdentifier = "APPGuideViewCell"
    private var selectIndex = 0
    var finishBackBlock:APPGuideViewFinishBackBlock?
    var timeInterval = 3.0
    var isAutoFinish = false
    var isAutoScroller = false
    
    func setup(iamgeNameArray:NSArray,timeToChange:Double) {
        timeInterval = timeToChange
        getDataScoure(array:iamgeNameArray)
        //设置flowLayout属性
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: self.frame.height)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.register(LCycleCell.classForCoder(), forCellWithReuseIdentifier: CycleReuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        //默认滚动到中间的那一组
        addSubview(collectionView)
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = iamgeNameArray.count
        pageControl.currentPageIndicatorTintColor = UIColor.white
        addSubview(pageControl)
        
        if isAutoScroller{
            //添加定时器
            addTimer()
        }
        
        //设置collectionView和pageControl的约束
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.bottom.equalTo(self.snp.bottom)
            make.right.equalTo(self.snp.right)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height)
    }
    
    func getDataScoure(array:NSArray) -> Void {
        picArr = NSMutableArray(capacity: 100)
        for  i in array{
            picArr.add(UIImage.init(named: i as! String) as Any)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK:用于循环滚动数量。
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArr.count
    }
    
    //MARK:设置cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CycleReuseIdentifier, for: indexPath) as! LCycleCell
        selectIndex = indexPath.row % picArr.count
        cell.addImage(image: (picArr[selectIndex] as? UIImage)!)
        cell.backgroundColor = UIColor.white
        if !isAutoFinish{
            if indexPath.row == picArr.count - 1{
                let widht = cell.frame.size.width*1/3
                let maginLeft = cell.frame.size.width*1/3
                let height = CGFloat(40)
                let maginTop = cell.frame.size.height - height - CGFloat(80)
                let btn = UIButton()
                btn.tag = 10000
                btn.setTitle("立即开始", for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                btn.setTitleColor(UIColor.darkGray, for: .normal)
                btn.frame = CGRect(x: maginLeft, y:maginTop, width: widht, height: 40)
                btn.addTarget(self, action: #selector(startAction), for: .touchUpInside)
                btn.backgroundColor = UIColor.white
                btn.LGyCornerRadius = 10
                LGYTool.viewLayerShadow(view: btn)
                cell.addSubview(btn)
            }else{
                let btn = cell.viewWithTag(10000)
                btn?.removeFromSuperview()
            }
        
        }
        
        return cell
    }
    //MARK:定时器方法
    @objc private func startAction(){
        finishBackBlock?()
        timer?.invalidate()
        cancle()
    }
    
    
    //MARK:定时器
    private func timerCancle() {
        if(selectIndex < picArr.count){
            timer = Timer(timeInterval: 1, target: self, selector: #selector( cancle), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .commonModes)
        }
    }
    
    //MARK:设置循环滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x/(scrollView.frame.size.width-1))
        selectIndex = currentPage % picArr.count
        pageControl?.currentPage = currentPage % picArr.count
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
        if(selectIndex < picArr.count){
            timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .commonModes)
        }
    }
    
    //MARK:定时器方法
    @objc private func cancle() {
        self.removeFromSuperview()
    }
    
    //MARK:定时器方法
    @objc private func nextImage() {
        //获取中间那一组的indexPath
        if currentPage < picArr.count-1{
            let middleIndexPath = IndexPath.init(row: currentPage+1, section: 0)
            collectionView.scrollToItem(at: middleIndexPath, at: .left, animated: true)
            
        }
        if (isAutoFinish){
            if(selectIndex == picArr.count-1){
                finishBackBlock?()
                timer?.invalidate()
                timer = nil
                //self.removeFromSuperview()
            }
        }else{
            if  currentPage == picArr.count - 1{
                self.timer?.invalidate()
                self.timer = nil
            }
            
        }
    }

}
