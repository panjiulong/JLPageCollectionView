//
//  JLContentView.swift
//  JLPageView
//
//  Created by panjiulong on 2018/1/24.
//  Copyright © 2018年 panjiulong. All rights reserved.
//

import UIKit

protocol JLContentViewDelegate:class {
    func contentView(_ contentView:JLContentView , didEndScroll inIndex:Int)
    func contentVIew(_ contentView:JLContentView,sourceIndex:Int,targetIndex:Int,progress:CGFloat)
}

private let kContentCellID = "cellId"

class JLContentView: UIView {
    //MARK: 属性
    weak var delegate:JLContentViewDelegate?
    fileprivate var childVcs : [UIViewController]
    private var parentVc :UIViewController
    private var startOffsetX :CGFloat = 0
    private var isForbidDelegate :Bool = false
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout:layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        return collectionView
    }()
    //MARK: 构造函数
    init(frame:CGRect , childVcs:[UIViewController],parentVc:UIViewController) {
        self.childVcs = childVcs;
        self.parentVc = parentVc
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension JLContentView{
    private func setupUI(){
        for childVc in childVcs {
            parentVc.addChildViewController(childVc)
        }
        addSubview(collectionView)
    }
}
//MARK: UICollectionViewDelegate
extension JLContentView:UICollectionViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll()
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollView.isScrollEnabled = false
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndScroll()
        }
    }
    private func scrollViewDidEndScroll() {
        collectionView.isScrollEnabled = true
        let index = Int(collectionView.contentOffset.x/collectionView.bounds.width)
        print("didEndScroll: \(index) contentOffset:\(collectionView.contentOffset)")
        delegate?.contentView(self, didEndScroll: index)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //判断有没有滑动
        let contentOffsetX = scrollView.contentOffset.x
        guard contentOffsetX < CGFloat(childVcs.count) * collectionView.bounds.width && contentOffsetX > 0 else {
            return
        }
        guard contentOffsetX != startOffsetX && !isForbidDelegate else{
            return
        }
        
        var  sourceIndex : Int = 0
        var  targetIndex : Int = 0
        var  progress : CGFloat = 0.0
        let collectionWidth = collectionView.bounds.width
        if contentOffsetX > startOffsetX {//左滑
            sourceIndex = Int(contentOffsetX / collectionWidth)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count{
                targetIndex = childVcs.count - 1
            }
            progress = (contentOffsetX - startOffsetX) / collectionWidth
            if (contentOffsetX - startOffsetX) >= collectionWidth{ //这个是解决左滑的跳title的bug
                return
            }
        }else{//右滑
            targetIndex =  Int(contentOffsetX / collectionWidth)
            sourceIndex = targetIndex + 1
            progress = (startOffsetX - contentOffsetX)/collectionWidth
            if (startOffsetX - contentOffsetX) >= collectionWidth{ //这个是解决左滑的跳title的bug
                return
            }
        }
        print("   contentOffsetX:\(contentOffsetX),sourceIndex:\(sourceIndex), targetIndex: \(targetIndex), progress: \(progress)")
        delegate?.contentVIew(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
        
    }
}
//MARK: UICollectionViewDataSource
extension JLContentView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        cell.contentView.addSubview(childVc.view)
        return cell;
    }
}
extension JLContentView:JLTitleViewDelegate{
    func titleView(_ titleView: JLTitleView, targetIndex: Int) {
        //禁止执行代理方法
        isForbidDelegate = true
        let indexPath = IndexPath(item: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}
