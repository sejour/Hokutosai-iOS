//
//  MediaImageViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/11.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class MediaImageViewController: SlidePageViewController {
    
    private var medias: [Media]!
    private var initialPage: Int = 0
    
    init(title: String?, medias: [Media], initialPage: Int) {
        super.init()
        self.title = title
        self.medias = medias
        self.initialPage = initialPage
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        var items = [Item]()
        for media in self.medias {
            guard let url = media.url else { continue }
            let item = Item()
            item.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.width, height: self.view.height)
            item.setImageUrl(url)
            items.append(item)
        }
        self.pages = items
        
        // 初期ページの設定
        if self.pages.count > 0 && self.initialPage >= 0 && self.initialPage < self.pages.count {
            self.setViewControllers([self.pages[self.initialPage]], direction: .Forward, animated: false, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class Item: UIViewController, UIScrollViewDelegate {
        
        private var imageView: UIImageView!
        private var scrollView: UIScrollView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.view.backgroundColor = UIColor.blackColor()
            
            // ScrollView
            self.scrollView = UIScrollView()
            self.scrollView.delegate = self
            self.scrollView.minimumZoomScale = 1.0
            self.scrollView.maximumZoomScale = 4.0
            self.scrollView.scrollEnabled = true
            self.scrollView.showsHorizontalScrollIndicator = true
            self.scrollView.showsVerticalScrollIndicator = true
            self.view.addSubview(self.scrollView)
            self.scrollView.snp_makeConstraints { make in
                make.left.equalTo(self.view)
                make.top.equalTo(self.view)
                make.right.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
            
            // ImageView
            self.imageView = UIImageView()
            self.imageView.image = SharedImage.placeholderImage
            self.scrollView.addSubview(self.imageView)
            self.imageView.snp_makeConstraints { make in
                make.left.equalTo(self.scrollView)
                make.top.equalTo(self.scrollView)
                make.width.equalTo(self.scrollView)
                make.height.equalTo(self.scrollView)
            }
            
            self.imageView.contentMode = .ScaleAspectFit
            self.imageView.clipsToBounds = true
            
            self.imageView.userInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Item.tapped(_:)))
            self.imageView.addGestureRecognizer(tapGesture)
            
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(Item.doubleTapped(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            self.imageView.addGestureRecognizer(doubleTapGesture)
            
            // ダブルタップによる拡大を優先する
            tapGesture.requireGestureRecognizerToFail(doubleTapGesture)
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(Item.longPress(_:)))
            self.imageView.addGestureRecognizer(longPressGesture)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func setImageUrl(url: String) {
            guard let imageUrl = NSURL(string: url) else { return }
            self.imageView.af_setImageWithURL(imageUrl, placeholderImage: SharedImage.placeholderImage)
        }
        
        func setImage(image: UIImage?) {
            guard image != nil else {
                self.imageView.image = SharedImage.placeholderImage
                return
            }
            
            self.imageView.image = image
        }
        
        func longPress(gesture: UILongPressGestureRecognizer) {
            guard let image = self.imageView.image where gesture.state == .Began else { return }
            
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        
        func tapped(sender: UITapGestureRecognizer) {
            self.switchTopBarVisible(true)
        }
        
        func doubleTapped(gesture: UITapGestureRecognizer) {
            if self.scrollView.zoomScale <= self.scrollView.minimumZoomScale {
                self.hiddenTopBar(true, animated: true)
                let rect = self.zoomRectForScale(self.scrollView.maximumZoomScale, center: gesture.locationInView(gesture.view))
                self.scrollView.zoomToRect(rect, animated: true)
            }
            else {
                self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
            }
        }
        
        func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
            return self.imageView
        }
        
        func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
            // scale倍拡大する = 表示領域を1/scaleにする
            let width = self.scrollView.width / scale
            let height = self.scrollView.height / scale
            
            // 拡大領域の原点を求める
            let x = center.x - (width / 2.0)
            let y = center.y - (height / 2.0)
        
            return CGRect(x: x, y: y, width: width, height: height)
        }
        
    }

}
