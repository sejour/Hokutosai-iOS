//
//  SlideImageView.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/11.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

protocol SlideImageViewDelegate: class {
    
    func tappedImage(gesture: UIGestureRecognizer, index: Int)
    
}

class SlideImageView: UIView, TappableViewControllerDelegate {
    
    private var slidePageViewController: SlidePageViewController!
    private var items: [Item]!
    
    weak var delegate: SlideImageViewDelegate?

    convenience init(height: CGFloat, targetViewController: UIViewController, medias: [Media]) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: targetViewController.view.width, height: height), targetViewController: targetViewController, medias: medias)
    }
    
    private init(frame: CGRect, targetViewController: UIViewController, medias: [Media]) {
        super.init(frame: frame)
        
        self.snp_makeConstraints { make in
            make.width.equalTo(self.width)
            make.height.equalTo(self.height)
        }
        
        self.slidePageViewController = SlidePageViewController()
        targetViewController.addChildViewController(self.slidePageViewController)
        self.addSubview(self.slidePageViewController.view)
        targetViewController.didMoveToParentViewController(targetViewController)
        
        self.slidePageViewController.view.snp_makeConstraints { make in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        self.items = [Item]()
        for i in 0 ..< medias.count {
            guard let url = medias[i].url else { continue }
            let item = Item()
            item.tag = i
            item.delegate = self
            item.view.frame = CGRect(x: 0.0, y: 0.0, width: self.width, height: self.height)
            item.setImageUrl(url)
            self.items.append(item)
        }
        self.slidePageViewController.pages = self.items
        
        if items.count > 1 {
            let pageControl = UIPageControl()
            pageControl.numberOfPages = self.items.count
            pageControl.currentPage = 0
            self.slidePageViewController.pageControl = pageControl
            self.addSubview(pageControl)
            pageControl.snp_makeConstraints { make in
                make.centerX.equalTo(self)
                make.bottom.equalTo(self).offset(-8.0)
                make.height.equalTo(8.0)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tappedView(sender: TappableViewController, gesture: UITapGestureRecognizer, tag: Int) {
        self.delegate?.tappedImage(gesture, index: tag)
    }
    
    var currentPageImage: UIImage? {
        guard let currentPage = self.slidePageViewController.currentPageNumber else { return nil }
        return self.items[currentPage].image
    }

    class Item: TappableViewController {
        
        private var imageView: UIImageView!
        
        var image: UIImage? {
            return self.imageView.image
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.view.backgroundColor = UIColor.whiteColor()
            
            self.imageView = UIImageView()
            self.imageView.image = SharedImage.placeholderImage
            self.view.addSubview(self.imageView)
            self.imageView.snp_makeConstraints { make in
                make.left.equalTo(self.view)
                make.top.equalTo(self.view)
                make.right.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
            
            self.imageView.contentMode = .ScaleAspectFit
            self.imageView.clipsToBounds = true
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func setImageUrl(url: String) {
            guard let imageUrl = NSURL(string: url) else { return }
            
            self.imageView.af_setImageWithURL(imageUrl, placeholderImage: SharedImage.placeholderImage)
        }
        
    }
    
}
