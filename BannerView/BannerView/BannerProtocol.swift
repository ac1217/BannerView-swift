//
//  BannerProtocol.swift
//  BannerViewDemo
//
//  Created by zhangweiwei on 2017/1/7.
//  Copyright © 2017年 pmec. All rights reserved.
//

import Foundation



public protocol BannerViewDataSource: NSObjectProtocol {
    
    func numberOfBanners(in bannerView: BannerView) -> Int
    
    func bannerView(_ bannerView: BannerView, bannerFor index: Int) -> BannerResource
    
}

public protocol BannerViewDelegate: NSObjectProtocol {
    
     func bannerView(_ bannerView: BannerView, didSelectBannerAt index: Int)
    
}

extension BannerViewDelegate {
    
    func bannerView(_ bannerView: BannerView, didSelectBannerAt index: Int){
        
        
    }
}

public protocol BannerResource {
    
    var imageResource: Any { get }
    
    var placeholderResource: Any? { get }
    
}

extension BannerResource {

    var placeholderResource: Any? { return nil }
    
}
