//
//  SimpleLoadingView.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/01.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class SimpleLoadingView: UIView {

    var indicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayscale(230)
        
        self.indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.addSubview(self.indicator)
        self.indicator.snp_makeConstraints { make in
            make.center.equalTo(self.snp_center)
        }
        
        self.indicator.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
