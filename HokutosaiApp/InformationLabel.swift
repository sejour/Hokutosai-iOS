//
//  InformationLabel.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/05.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class InformationLabel: UIView {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    convenience init(frame: CGRect, icon: UIImage, text: String) {
        self.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "InformationLabel", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
            options:NSLayoutFormatOptions(rawValue: 0),
            metrics:nil,
            views: bindings))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
            options:NSLayoutFormatOptions(rawValue: 0),
            metrics:nil,
            views: bindings))
    }

}
