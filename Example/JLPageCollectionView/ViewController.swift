//
//  ViewController.swift
//  JLPageCollectionView
//
//  Created by panjiulong on 06/24/2019.
//  Copyright (c) 2019 panjiulong. All rights reserved.
//

import UIKit
import JLPageCollectionView

private let kReuseCell = "cell"

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.randomColor()
        
        let pageCollectionView = JLPageCollectionView(config: config)
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        pageCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kReuseCell)
        view.addSubview(pageCollectionView)
    }
    
    lazy var config:JLPageViewConfig = {
        var config = JLPageViewConfig()
        config.titles = ["热门","高级","专属","豪华","热门1","高级1","专属1","豪华1"]
        config.isTitleInTop = true
        config.pageControlHeight = 10.0
        config.titleNormColor = .gray
        config.titleViewBackgroundColor = .white
        config.titleSlectedColor = UIColor.red
        config.isShowCover = true
        config.isNeedScale = true
        
        config.pageControllerBackgroundColor = .white
        config.pageIndicatorTintColor = .gray
        config.currentPageIndicatorTintColor = .red
        
        config.bottomLineHeight = 3.0
        return config
    }()
    
}

extension UIViewController: JLPageCollectionViewDelegate{
    public func pageCollectionView(_ pageCollectionView: JLPageCollectionView, collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension UIViewController:JLPageCollectionViewDataSource{
    public func numberOfSection(in JLPageCollectionView: JLPageCollectionView) -> Int {
        return 8
    }
    
    public func pageCollectionView(_ pageCollectionView: JLPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 59
        }else if section == 1{
            return 43
        }else if section == 2{
            return 35
        }else{
            return 41
        }
    }
    
    public func pageCollectionView(_ pageCollectionView: JLPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseCell, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
}

extension UIColor{
    class func randomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green:  CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
    }
}
