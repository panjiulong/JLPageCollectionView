//
//  JLPageColletionLayout.swift
//  JLPageView
//
//  Created by panjiulong on 2018/1/29.
//  Copyright © 2018年 panjiulong. All rights reserved.
//

import UIKit

public class JLPageColletionLayout: UICollectionViewLayout {
    public var sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    public var itemMargin: CGFloat = 10
    public var lineMargin: CGFloat = 10
    public var cols : Int = 5
    public var rows: Int = 4
    public var totalWidth: CGFloat = 0
    
    private lazy var attributes:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
}
extension JLPageColletionLayout{
    override public func prepare() {
        
        guard let colletionView = collectionView else{return}
        
        let sections = colletionView.numberOfSections
        
        //计算itemSize
        let itemW = (colletionView.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * itemMargin) / CGFloat(cols)
        let itemH = (colletionView.bounds.height - sectionInset.top - sectionInset.bottom -  CGFloat(rows - 1) * lineMargin) / CGFloat(rows)
        
        var previousNumberOfPage = 0
        
        for section in 0..<sections {
            let items = colletionView.numberOfItems(inSection: section)
            
            for item in 0..<items{
                let indexPath = IndexPath(item: item, section: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let currentPage = item / (cols * rows)
                let currentIndex = item % (cols * rows)
                let X = CGFloat(previousNumberOfPage + currentPage) * colletionView.bounds.width + sectionInset.left + (itemW + itemMargin) * CGFloat(currentIndex % cols)
                let Y = sectionInset.top + (itemH + lineMargin) * CGFloat(currentIndex / cols)
                attribute.frame = CGRect(x: X, y: Y, width: itemW, height: itemH)
                attributes.append(attribute)
            }
            previousNumberOfPage += ( items - 1)/(cols * rows) + 1
        }
        totalWidth = CGFloat(previousNumberOfPage) * colletionView.bounds.width
    }
}
extension JLPageColletionLayout{
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
}
extension JLPageColletionLayout{
    override public var collectionViewContentSize: CGSize{
        return CGSize(width: totalWidth, height: 0)
    }
}
