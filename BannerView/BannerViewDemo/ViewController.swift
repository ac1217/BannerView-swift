//
//  ViewController.swift
//  BannerViewDemo
//
//  Created by zhangweiwei on 2017/1/7.
//  Copyright © 2017年 pmec. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BannerViewDataSource, BannerViewDelegate {
    
    func numberOfBanners(in bannerView: BannerView) -> Int {
        return banners.count
    }
    
    func bannerView(_ bannerView: BannerView, bannerFor Index: Int) -> BannerResource {
        
        return banners[Index]
    }
    
    func bannerView(_ bannerView: BannerView, didSelectBannerAt index: Int) {
        
    }
    
    let banners: [BannerModel] = [
        
        
        BannerModel(imageResource: "http://pic29.nipic.com/20130530/6434097_113007064309_2.jpg"),
        BannerModel(imageResource: "http://pic50.nipic.com/file/20141010/19650248_153632125000_2.jpg")
    
    ]
    
    lazy var scrollView = UIScrollView()
    
    lazy var bannerView: BannerView = {
        let b = BannerView()
        b.dataSource = self
        b.delegate = self
        
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        scrollView.addSubview(bannerView)
        
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        bannerView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 150)
    }


}

extension ViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bannerView.contentOffsetY = scrollView.contentOffset.y
    }
    
}

