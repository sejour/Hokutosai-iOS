//
//  ContentsStackViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/14.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class ContentsStackViewController: UIViewController {

    var defaultSeparatorColor = UIColor.lightGrayColor()
    var defaultSeparatorWidth: CGFloat = 0.5
    
    var bottomOfLastView: CGFloat!
    
    init (title: String? = nil) {
        super.init(nibName: nil, bundle: NSBundle.mainBundle())
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomOfLastView = self.appearOriginY
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addContentView(contentView: UIView) {
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        self.view.addSubview(contentView)
        contentView.snp_makeConstraints { make in
            make.left.equalTo(self.view)
            make.top.equalTo(self.bottomOfLastView)
        }
        
        self.bottomOfLastView = self.bottomOfLastView + contentView.height
    }
    
    func insertSpace(height: CGFloat) {
        let spaceView = UIView()
        self.view.addSubview(spaceView)
        spaceView.snp_makeConstraints { make in
            make.left.equalTo(self.view)
            make.top.equalTo(self.bottomOfLastView)
            make.right.equalTo(self.view)
            make.height.equalTo(height)
        }
        
        self.bottomOfLastView = self.bottomOfLastView + height
    }
    
    func insertSeparator(color: UIColor? = nil, width: CGFloat? = nil) {
        self.insertSeparator(0.0, rightInset: 0.0, color: color, width: width)
    }
    
    func insertSeparator(inset: CGFloat, color: UIColor? = nil, width: CGFloat? = nil) {
        self.insertSeparator(inset, rightInset: inset, color: color, width: width)
    }
    
    func insertSeparator(leftInset: CGFloat, rightInset: CGFloat, color: UIColor? = nil, width: CGFloat? = nil) {
        let height = width ?? self.defaultSeparatorWidth
        
        let separator = UIView()
        separator.backgroundColor = color ?? self.defaultSeparatorColor
        self.view.addSubview(separator)
        separator.snp_makeConstraints { make in
            make.left.equalTo(self.view).offset(leftInset)
            make.top.equalTo(self.bottomOfLastView)
            make.right.equalTo(self.view).offset(-rightInset)
            make.height.equalTo(height)
        }
        
        self.bottomOfLastView = self.bottomOfLastView + height
    }

}
