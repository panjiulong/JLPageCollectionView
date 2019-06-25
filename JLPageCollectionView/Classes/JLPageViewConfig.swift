//
//  JLPageViewConfig.swift
//  JLPageView
//
//  Created by panjiulong on 2018/1/25.
//  Copyright © 2018年 panjiulong. All rights reserved.
//

import UIKit

public struct JLPageViewConfig {
    
    public var isTitleInTop : Bool = true
    
    public var pageControlHeight :CGFloat = 20.0
    
    //选项分类数组
    public var titles = ["热门","高级","专属","豪华"]
    //frame
    public var frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 300)
    
    //title选项条相关
    
    //选项条高度
    public var titleViewHeight: CGFloat = 44.0
    //选项条背景色
    public var titleViewBackgroundColor: UIColor = .gray
    //选项默认色
    public var titleNormColor: UIColor = .white
    //选项选中色
    public var titleSlectedColor: UIColor = .red
    //选项字体
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 14)
    //是否可滚动
    public var titleViewIsScrollEnable: Bool = true
    //选项间距
    public var titleMargin: CGFloat = 60
    //是否显示底部条
    public var isShowBottomLine: Bool = true
    //底部条画颜色
    public var bottomLineColor : UIColor = .black
    //底部条高度
    public var bottomLineHeight : CGFloat = 5.0
    //title是否需要缩放
    public var isNeedScale : Bool = false
    //title最大缩放程度
    public var maxScale: CGFloat = 1.2
    //title是否显示遮盖
    public var isShowCover:Bool = false
    //遮盖颜色
    public var coverViewColor:UIColor = UIColor.black
    public var coverViewAlpha : CGFloat = 0.3
    public var coverViewHeight : CGFloat = 30
    public var coverViewRadius : CGFloat = 10
    public var coverViewMargin : CGFloat = 10
    
    //中间collectionView的背景色
    public var contentViewBackgroundColor:UIColor = .white
    //pageController的背景色
    public var pageControllerBackgroundColor:UIColor = .black
    public var pageIndicatorTintColor:UIColor = .black
    public var currentPageIndicatorTintColor:UIColor = .black
    
    
    public var layout = JLPageColletionLayout()
    
    public init(){}
    
}

public extension UIColor{
    // 便利初始化方法
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    func getRGBValue() -> (CGFloat,CGFloat,CGFloat) {
        var R:CGFloat = 0
        var G:CGFloat = 0
        var B:CGFloat = 0
        self.getRed(&R, green: &G, blue: &B, alpha: nil)
        return (R * 255,G * 255,B * 255)
    }
    class func randomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green:  CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
    }
}
