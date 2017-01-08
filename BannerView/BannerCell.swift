//
//  BannerCell.swift
//  BannerViewDemo
//
//  Created by zhangweiwei on 2017/1/7.
//  Copyright © 2017年 pmec. All rights reserved.
//

import UIKit
import Kingfisher

let kBannerCellReuseID = "BannerCell"
class BannerCell: UICollectionViewCell {
    
    var banner: BannerResource? {
        didSet{
            
            guard let banner = banner else {
                return
            }
            
            var placeholderImage: UIImage?
            if let placeholderResource = banner.placeholderResource {
                
                if placeholderResource is String {
                    placeholderImage = UIImage(named: placeholderResource as! String)
                }else {
                    
                    placeholderImage = banner.placeholderResource as? UIImage
                }
                
            }
            
            
                
            if let imageResource = banner.imageResource as? UIImage {
                
                imageView.image = imageResource
                
            }else if let imageResource = banner.imageResource as? URL {
                
                imageView.kf.setImage(with: imageResource, placeholder: placeholderImage, options: [KingfisherOptionsInfoItem.transition(.fade(0.25))], progressBlock: nil, completionHandler: nil)
                
            }else if let imageResource = banner.imageResource as? String {
                
                
                
                if imageResource.hasPrefix("http") {
                    
                    imageView.kf.setImage(with: URL(string: imageResource), placeholder: placeholderImage, options: [KingfisherOptionsInfoItem.transition(.fade(0.25))], progressBlock: nil, completionHandler: nil)
                }else {
                    imageView.image = UIImage(named: imageResource)
                }
                
                
            }else {
                imageView.image = nil
            }
                
        
            
            
        }
    }
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BannerCell.bannerViewContentOffsetYDidChangeNotification(_:)), name: NSNotification.Name(rawValue: kBannerViewContentOffsetYDidChangeNotification), object: nil)
        
    }
    
    func bannerViewContentOffsetYDidChangeNotification(_ noti: Notification) {
        
        guard let frame = noti.object as? CGRect else { return }
        
        imageView.frame = frame
        
//        self.imageView.frame = frame;
//        CGRect labelF = self.titleLabel.frame;
//        labelF.origin.y = self.imageView.frame.origin.y;
//        self.titleLabel.frame = labelF;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        
    }
    
    
}
