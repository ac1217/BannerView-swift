//
//  BannerExtension.swift
//  BannerViewDemo
//
//  Created by zhangweiwei on 2017/1/7.
//  Copyright © 2017年 pmec. All rights reserved.
//

import Foundation

extension Timer {
    
    convenience init(timeInterval ti: TimeInterval, closure c: @escaping (_ timer: Timer) -> (), repeats yesOrNo: Bool){
        
        self.init()
        
        self.init(timeInterval:ti, target:self, selector:#selector(Timer.excuteClosure), userInfo: c, repeats:yesOrNo)
        
    }
    
    func excuteClosure(){
        
        let c = userInfo as? ((_ timer: Timer) -> ())
        
        c?(self)
        
    }
    
}
