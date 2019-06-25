//
//  JLPageCollectionView.swift
//  JLPageView
//
//  Created by panjiulong on 2018/1/29.
//  Copyright © 2018年 panjiulong. All rights reserved.
//

import UIKit

//MARK: 数据源
public protocol JLPageCollectionViewDataSource : class {
    func numberOfSection(in JLPageCollectionView:JLPageCollectionView) -> Int
    func pageCollectionView(_ pageCollectionView:JLPageCollectionView, numberOfItemsInSection section:Int) -> Int
    func pageCollectionView(_ pageCollectionView:JLPageCollectionView,_ collectionView:UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}
//事件代理
public protocol JLPageCollectionViewDelegate : class {
    func pageCollectionView(_ pageCollectionView:JLPageCollectionView, collectionView:UICollectionView,didSelectItemAt indexPath: IndexPath)
}

open class JLPageCollectionView: UIView {

    weak public var  dataSource:JLPageCollectionViewDataSource?
    
    weak public var  delegate:JLPageCollectionViewDelegate?
    
    public var titles : [String]
    public var config : JLPageViewConfig
    public  var collectionView: UICollectionView?
    private  var titleView: JLTitleView!
    public var layout: JLPageColletionLayout
    private  var pageControl: UIPageControl!
    private lazy var currentIndex : IndexPath = IndexPath(item: 0, section: 0)

    public init(config:JLPageViewConfig) {
        self.titles = config.titles
        self.layout = config.layout
        self.config = config
        super.init(frame: config.frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension JLPageCollectionView{
    public func register(_ cellClass:AnyClass?,forCellWithReuseIdentifier identifier:String) {
        collectionView?.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    public func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        collectionView?.register(nib, forCellWithReuseIdentifier: identifier)
    }
    public func reloadData() {
        collectionView?.reloadData()
    }
}
extension JLPageCollectionView{
    private func setupUI() {
        let titleY = config.isTitleInTop ? 0 : bounds.height - config.titleViewHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: config.titleViewHeight)
        let titleView = JLTitleView(frame: titleFrame, config: config, titles: titles)
        titleView.delegate = self
        addSubview(titleView)
        self.titleView = titleView
        
        let collectionY = config.isTitleInTop ? config.titleViewHeight : 0
        let collectionH = bounds.height - config.titleViewHeight - config.pageControlHeight
        let collectionViewFrame = CGRect(x: 0, y: collectionY , width: bounds.width, height: collectionH)
        
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = config.contentViewBackgroundColor
        collectionView?.showsHorizontalScrollIndicator = false
        addSubview(collectionView!)
        
        let pageFrame = CGRect(x: 0, y: collectionViewFrame.maxY, width: bounds.width, height: config.pageControlHeight)
        let pageControl = UIPageControl(frame: pageFrame)
        pageControl.backgroundColor = config.pageControllerBackgroundColor
        pageControl.pageIndicatorTintColor = config.pageIndicatorTintColor
        pageControl.currentPageIndicatorTintColor = config.currentPageIndicatorTintColor
        pageControl.numberOfPages = 4
        addSubview(pageControl)
        self.pageControl = pageControl
    }
}
//MARK:- UICollectionViewDataSource
extension JLPageCollectionView:UICollectionViewDataSource{
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource?.numberOfSection(in: self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionItemCount = self.dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (sectionItemCount - 1 ) / (layout.cols * layout.rows) + 1
        }
        return sectionItemCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return (dataSource?.pageCollectionView(self, collectionView, cellForItemAt: indexPath))!
    }
}
//MARK:- UICollectionViewDelegate
extension JLPageCollectionView:UICollectionViewDelegate{
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView(self,collectionView:collectionView, didSelectItemAt: indexPath)
    }
    //减速停止
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    //拖拽停止
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
             scrollViewEndScroll()
        }
    }
    private func scrollViewEndScroll() {
        let point = CGPoint(x: layout.sectionInset.left + 1 + (collectionView?.contentOffset.x)!, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView?.indexPathForItem(at: point) else{ return }
        
        if indexPath.section != currentIndex.section {
            //改变pageControl
            let itemsCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = ( itemsCount - 1) / (layout.cols * layout.rows) + 1
            pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
            
            //改变titleView
            titleView.setCurrentIndex(index: indexPath.section)
            
            //记录最新indexpath
            currentIndex = indexPath
        }
        
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
    }
}
//MARK:- JLTitleViewDelegate
extension JLPageCollectionView:JLTitleViewDelegate{
    func titleView(_ titleView: JLTitleView, targetIndex: Int) {
        let indexPath = IndexPath(item: 0, section: targetIndex)
        collectionView?.scrollToItem(at: indexPath, at: .left, animated: false)
        //解决最后的偏移bug
        let sectionNum = dataSource?.numberOfSection(in: self) ?? 0
        let sectionItemsNum = dataSource?.pageCollectionView(self, numberOfItemsInSection: targetIndex) ?? 0
        
        pageControl.numberOfPages = (sectionItemsNum - 1 ) / (layout.cols * layout.rows) + 1
        pageControl.currentPage = 0
        
        currentIndex = indexPath
        
        if targetIndex == sectionNum - 1 && sectionItemsNum <= layout.cols * layout.rows{
            return
        }
        collectionView?.contentOffset.x -= layout.sectionInset.left
    }
}
