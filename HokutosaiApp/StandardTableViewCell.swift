//
//  StandardTableViewCell.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/25.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit
import SnapKit

class StandardTableViewCell: UITableViewCell {

    private var id: UInt!
    var dataId: UInt { return self.id }
    
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsZero
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subTitleLabel)
        self.contentView.addSubview(self.descriptionLabel)
        
        self.titleLabel.backgroundColor = UIColor.orangeColor()
        self.titleLabel.textColor = UIColor.blackColor()
        self.titleLabel.font = UIFont.boldSystemFontOfSize(18.0)
        self.titleLabel.snp_makeConstraints { make in
            make.left.equalTo(self.contentView).offset(10.0)
            make.right.equalTo(self.contentView).offset(-10.0)
            make.top.equalTo(self.contentView).offset(10.0)
            make.height.equalTo(20.0)
        }
        
        self.subTitleLabel.backgroundColor = UIColor.greenColor()
        self.subTitleLabel.textColor = UIColor.blackColor()
        self.subTitleLabel.font = UIFont.systemFontOfSize(14.0)
        self.subTitleLabel.snp_makeConstraints { make in
            make.left.equalTo(self.contentView.snp_left).offset(10.0)
            make.right.equalTo(self.contentView.snp_right).offset(-10.0)
            make.top.equalTo(self.titleLabel.snp_bottom).offset(5.0)
            make.height.equalTo(20.0)

        }
        
        self.descriptionLabel.backgroundColor = UIColor.yellowColor()
        self.descriptionLabel.textColor = UIColor.blackColor()
        self.descriptionLabel.font = UIFont.systemFontOfSize(14.0)
        self.descriptionLabel.snp_makeConstraints { make in
            make.left.equalTo(self.contentView.snp_left).offset(10.0)
            make.right.equalTo(self.contentView.snp_right).offset(-10.0)
            make.top.equalTo(self.subTitleLabel.snp_bottom).offset(5.0)
            make.height.equalTo(20.0)
        }
        
        self.contentView.snp_makeConstraints { make in
            make.left.equalTo(self).offset(0.0)
            make.right.equalTo(self).offset(0.0)
            make.bottom.equalTo(self.descriptionLabel.snp_bottom).offset(10.0)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(data: StandardTableViewCellData) {
        self.id = data.dataId
        self.titleLabel.text = data.dataTitle
        self.subTitleLabel.text = data.dataSubTitle
        self.descriptionLabel.text = data.dataDescription
    }
    
}
