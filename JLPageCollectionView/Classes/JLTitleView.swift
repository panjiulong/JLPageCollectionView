//
//  JLTitleView.swift
//  JLPageView
//
//  Created by panjiulong on 2018/1/24.
//  Copyright © 2018年 panjiulong. All rights reserved.
//

import UIKit

protocol JLTitleViewDelegate : class {
    func titleView(_ titleView:JLTitleView, targetIndex:Int)
}

class JLTitleView: UIView {
    
    //MARK: 属性
    weak var delegate : JLTitleViewDelegate?
    private var titles : [String]
    private var config : JLPageViewConfig
    
    private var currentIndex = 0
    private lazy var titleLabels : [UILabel] = [UILabel]()
    private lazy var normalRGB : (CGFloat ,CGFloat,CGFloat) = self.config.titleNormColor.getRGBValue()
    private lazy var selectRGB : (CGFloat ,CGFloat,CGFloat)  = self.config.titleSlectedColor.getRGBValue()
    private lazy var deltaRGB : (CGFloat ,CGFloat,CGFloat) = {
        let deltaR = self.selectRGB.0 - self.normalRGB.0
        let deltaG = self.selectRGB.1 - self.normalRGB.1
        let deltaB = self.selectRGB.2 - self.normalRGB.2
        return (deltaR,deltaG,deltaB)
    }()
    private lazy var bottomLine:UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = self.config.bottomLineColor
        return bottomView
    }()
    private lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.config.coverViewColor
        coverView.alpha = self.config.coverViewAlpha
        return coverView
    }()
    
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView(frame:self.bounds)
        scrollView.backgroundColor = config.titleViewBackgroundColor
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    

    //MARK: 构造函数
    init(frame:CGRect , config:JLPageViewConfig,titles:[String]) {
        self.titles = titles;
        self.config = config
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension JLTitleView{
    //MARK: 设置UI
    private func setupUI(){
        
       addSubview(scrollView)
        
        setupTitleLables()
        
        if config.isShowBottomLine {
            setupBottomLine()
        }
        
        if config.isShowCover {
            setupCoverView()
        }
        
    }
    private func setupCoverView(){
        scrollView.insertSubview(coverView, at: 0)
        let firstLabel = titleLabels.first!
        var coverW : CGFloat = firstLabel.frame.width
        let coverH : CGFloat = config.coverViewHeight
        var coverX : CGFloat = firstLabel.frame.origin.x
        let coverY : CGFloat = (scrollView.frame.height - coverH) * 0.5
        if config.titleViewIsScrollEnable{
            coverX -= config.coverViewMargin
            coverW += config.coverViewMargin * 2
        }
        
        coverView.frame = CGRect(x:coverX, y:coverY, width: coverW, height: coverH)
        
        if config.titleViewIsScrollEnable{
            
        }
        
        coverView.layer.cornerRadius = config.coverViewRadius
        coverView.layer.masksToBounds = true;
    }
    private func setupBottomLine(){
        scrollView.addSubview(bottomLine)
        bottomLine.frame = titleLabels.first!.frame
        bottomLine.frame.size.height = config.bottomLineHeight
        bottomLine.frame.origin.y = config.titleViewHeight - config.bottomLineHeight
    }
    private func setupTitleLables() {
        
        for (i, title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i == 0 ? config.titleSlectedColor : config.titleNormColor
            titleLabel.font = config.titleFont
            titleLabel.isUserInteractionEnabled = true
            scrollView.addSubview(titleLabel)
            
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClicked(tapGes:)))
            titleLabel.addGestureRecognizer(tapGes)
            
            titleLabels.append(titleLabel)
        }
        //设置frame
        var labelW : CGFloat = bounds.width/CGFloat(titles.count)
        let labelH : CGFloat = config.titleViewHeight
        let labelY : CGFloat = 0
        var labelX : CGFloat = 0
        for (i,titleLabel) in titleLabels.enumerated() {
            if config.titleViewIsScrollEnable{
                labelW = (titleLabel.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: labelH), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : config.titleFont], context: nil).width
                labelX =  i == 0 ? config.titleMargin : (config.titleMargin + titleLabels[i - 1].frame.maxX)
            }else{
                labelX = labelW * CGFloat(i)
            }
             titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        }
        if config.titleViewIsScrollEnable {
            scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + config.titleMargin, height: 0)
        }
        //设置缩放
        if config.isNeedScale{
            titleLabels.first?.transform = CGAffineTransform.init(scaleX: config.maxScale, y: config.maxScale)
        }
        
        
    }
}
//MARK: 点击事件监听
extension JLTitleView{
    @objc func titleLabelClicked(tapGes:UITapGestureRecognizer) {
      
        guard let targetLabel =  tapGes.view as? UILabel else {
            return
        }
        guard targetLabel.tag != currentIndex else {
            return
        }

        //通知代理
        delegate?.titleView( self, targetIndex: targetLabel.tag)
        
        //调整label
       adjustTitles(targetLabel)
        
    }
    private func adjustTitles(_ targetLabel:UILabel){
        let sourceLabel = titleLabels[currentIndex]
        sourceLabel.textColor = config.titleNormColor
        targetLabel.textColor = config.titleSlectedColor
        
        currentIndex = targetLabel.tag
        
        //滚到中间
        adjustLabelPosition()
        
        //调整bottomLine位置
        if config.isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.size.width
            })
        }
        //调整缩放
        if config.isNeedScale{
            UIView.animate(withDuration: 0.25, animations: {
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform.init(scaleX: self.config.maxScale, y: self.config.maxScale)
            })
        }
        //调整coverView
        if config.isShowCover{
            
            UIView.animate(withDuration: 0.25, animations: {
                self.coverView.frame.origin.x = self.config.titleViewIsScrollEnable ? (targetLabel.frame.origin.x - self.config.coverViewMargin) : targetLabel.frame.origin.x
                self.coverView.frame.size.width = self.config.titleViewIsScrollEnable ? (targetLabel.frame.size.width + self.config.coverViewMargin*2) : targetLabel.frame.size.width
            })
        }
    }
    private func adjustLabelPosition(){
        guard config.titleViewIsScrollEnable else {
            return
        }
        let targetLabel = titleLabels[currentIndex]
        var offsetX = targetLabel.center.x - scrollView.bounds.width/2
        if offsetX < 0  {
            offsetX = 0.0
        }
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.size.width
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        scrollView.setContentOffset( CGPoint(x: offsetX, y: 0), animated: true)
    }
    private func adjustCoverViewPosition(){
        let targetLabel = titleLabels[currentIndex]
        UIView.animate(withDuration: 0.25) {
            self.coverView.frame.origin.x = self.config.titleViewIsScrollEnable ? (targetLabel.frame.origin.x - self.config.coverViewMargin) : targetLabel.frame.origin.x
            self.coverView.frame.size.width = self.config.titleViewIsScrollEnable ? (targetLabel.frame.size.width + self.config.coverViewMargin * 2) : targetLabel.frame.size.width
        }

    }
}
extension JLTitleView{
    func setCurrentIndex(index:Int) {
        
        let tagetLabe = titleLabels[index]
        
        adjustTitles(tagetLabe)
    }
}
//MARK: JLContentViewDelegate
extension JLTitleView:JLContentViewDelegate{
    
    func contentView(_ contentView: JLContentView, didEndScroll inIndex: Int) {
        currentIndex = inIndex
        adjustLabelPosition()
        adjustCoverViewPosition()
    }
    
    func contentVIew(_ contentView: JLContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        sourceLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        
         //计算bottomLine宽度变化/X变化
        let deltaWidth = targetLabel.frame.width - sourceLabel.frame.size.width
        let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        if config.isShowBottomLine{
            bottomLine.frame.size.width =  deltaWidth * progress + sourceLabel.frame.size.width
            bottomLine.frame.origin.x =  deltaX * progress + sourceLabel.frame.origin.x
        }
        //缩放变化
        if config.isNeedScale{
            let detaScale = config.maxScale - 1.0
            sourceLabel.transform = CGAffineTransform.init(scaleX: config.maxScale - detaScale * progress, y: config.maxScale - detaScale * progress)
           targetLabel.transform = CGAffineTransform.init(scaleX: 1.0 + detaScale * progress, y: 1.0 + detaScale * progress)
        }
        //coverView 渐变
        if config.isShowCover{
            coverView.frame.origin.x = config.titleViewIsScrollEnable ? (sourceLabel.frame.origin.x - config.coverViewMargin + deltaX * progress ) : (sourceLabel.frame.origin.x + deltaX * progress)
            coverView.frame.size.width = config.titleViewIsScrollEnable ? (sourceLabel.frame.width + config.coverViewMargin*2 + deltaWidth * progress ) : (sourceLabel.frame.size.width + deltaWidth * progress)
        }
        
    }
}
