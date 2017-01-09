//
//  BannerView.swift
//  BannerViewDemo
//
//  Created by zhangweiwei on 2017/1/7.
//  Copyright © 2017年 pmec. All rights reserved.
//

import UIKit

private let kNumberRatio = 100

let kBannerViewContentOffsetYDidChangeNotification = "kBannerViewContentOffsetYDidChangeNotification"

open class BannerView: UIView {

    public lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.hidesForSinglePage = true
        return pc
    }()
    
    
    public weak var delegate: BannerViewDelegate?
    public weak var dataSource: BannerViewDataSource?{
        didSet{
            if dataSource != nil {
                reloadData()
            }
        }
    }
    
    public var timeInterval: TimeInterval = 3
    
    public var isRepeat: Bool = true
    
    public var scrollDirection = UICollectionViewScrollDirection.horizontal {
        didSet {
            layout.scrollDirection = scrollDirection
        }
    }

    public var pageControlPosition = BannerViewPageControlPosition.right
    
    public func reloadData() {
        
        guard let dataSource = dataSource else {
            return
        }
        
        let previousNumber = pageControl.numberOfPages
        
        pageControl.numberOfPages = dataSource.numberOfBanners(in: self)
        setNeedsLayout()
        collectionView.reloadData()
        
        collectionView.isScrollEnabled = pageControl.numberOfPages > 1
        
        start()
        
        if previousNumber == pageControl.numberOfPages {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            
            let indexPath = IndexPath(item: kNumberRatio * self.pageControl.numberOfPages / 2, section: 0)
            
            if (self.layout.scrollDirection == .horizontal) {
                
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                
                
            }else {
                
                self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            }
            
        }

        
    }
    
    
    public var contentOffsetY: CGFloat = 0 {
        didSet{
            
            if (contentOffsetY >= 0)
            {
                var frame = changeFrame
                frame.origin.y = 0
                changeFrame = frame
                collectionView.clipsToBounds = true
                
            }else {
                
                var rect = bounds
                let delta = fabs(min(0.0, contentOffsetY))
                rect.origin.y -= delta
                rect.size.height += delta
                changeFrame = rect
                collectionView.clipsToBounds = false
                
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kBannerViewContentOffsetYDidChangeNotification), object: changeFrame)
            
        }
    }
    
    
    public func start() {
        
        if !isRepeat || pageControl.numberOfPages < 2 {
            return
        }
        
        if self.timer != nil {
            stop()
        }
        
        
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        
        timer.setEventHandler { [unowned self] in
            
            self.nextPage()
            
        }
        
        timer.scheduleRepeating(deadline: DispatchTime.now() + timeInterval, interval: timeInterval)
        
        timer.resume()
        
        self.timer = timer
        
        
    }
    
    public func stop() {
        
        timer?.cancel()
        timer = nil
        
    }
    
    
    fileprivate lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = self.scrollDirection
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let c = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        c.dataSource = self
        c.delegate = self
        c.register(BannerCell.self, forCellWithReuseIdentifier: kBannerCellReuseID)
        c.backgroundColor = UIColor.clear
        c.showsHorizontalScrollIndicator = false;
        c.showsVerticalScrollIndicator = false;
        c.isPagingEnabled = true
        
        return c
    }()
    
    
    
    fileprivate var changeFrame = CGRect.zero
    
    
    
    fileprivate var timer: DispatchSourceTimer?
    
    fileprivate func nextPage() {
        
        guard let indexPath = collectionView.indexPathsForVisibleItems.last else { return }
        let number = pageControl.numberOfPages
        let item = kNumberRatio * number / 2 + indexPath.item % number
        
        let currentIndexPath = IndexPath(item: item, section: 0)
        let nextIndexPath = IndexPath(item: item + 1, section: 0)
        
        let scrollPosition = (layout.scrollDirection == .horizontal) ? UICollectionViewScrollPosition.centeredHorizontally : UICollectionViewScrollPosition.centeredVertically
        
        collectionView.scrollToItem(at: currentIndexPath, at: scrollPosition, animated: false)
        collectionView.scrollToItem(at: nextIndexPath, at: scrollPosition, animated: true)
        
    }
    
    
    deinit {
        stop()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        
        addSubview(collectionView)
        addSubview(pageControl)
        
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
        
        let margin: CGFloat = 15;
        
        var pageControlSize = pageControl.size(forNumberOfPages: pageControl.numberOfPages)
        pageControlSize.height -= margin
        
        var pageControlX: CGFloat = 0
        let pageControlY = frame.height - pageControlSize.height
        
        switch pageControlPosition {
        case .right:
            
            pageControlX = frame.width - margin - pageControlSize.width
        case .left:
            
            pageControlX = margin
        case .center:
            
            pageControlX = (frame.width - pageControlSize.width) * 0.5;
        }
        
        pageControl.frame = CGRect(origin: CGPoint(x: pageControlX, y: pageControlY), size: pageControlSize)
        
        
    }
    
    
}

extension BannerView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let number = pageControl.numberOfPages
        
        return number * kNumberRatio
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBannerCellReuseID, for: indexPath) as! BannerCell
        
        cell.banner = dataSource!.bannerView(self, bannerFor: indexPath.item % pageControl.numberOfPages)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.bannerView(self, didSelectBannerAt: indexPath.item % pageControl.numberOfPages)
        
    }
    
}

extension BannerView: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        stop()
        
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        start()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let number = pageControl.numberOfPages
        
        if number == 0 { return }
        
        var currentPage = 0
        
        switch layout.scrollDirection {
        case .horizontal:
            
            currentPage = Int((scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5)) % number;
            
        default:
            
            currentPage = Int((scrollView.contentOffset.y / scrollView.bounds.size.height + 0.5)) % number;
        }
        
        pageControl.currentPage = currentPage
        
    }
    
}
