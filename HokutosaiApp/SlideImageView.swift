//
//  SlideImageView.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/11.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class SlideImageView: UIView {
    
    var slidePageViewController: SlidePageViewController!

    convenience init(height: CGFloat, targetViewController: UIViewController, medias: [Media]) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: targetViewController.view.width, height: height), targetViewController: targetViewController, medias: medias)
    }
    
    private init(frame: CGRect, targetViewController: UIViewController, medias: [Media]) {
        super.init(frame: frame)
        
        self.slidePageViewController = SlidePageViewController(navigationOrientation: .Horizontal)
        targetViewController.addChildViewController(self.slidePageViewController)
        self.addSubview(self.slidePageViewController.view)
        targetViewController.didMoveToParentViewController(targetViewController)
        
        targetViewController.view.origin = CGPointZero
        targetViewController.view.size = self.size
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
