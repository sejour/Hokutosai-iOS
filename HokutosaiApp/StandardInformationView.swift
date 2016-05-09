//
//  StandardInformationView.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/09.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class StandardInformationView: UIView {
    
    static let defaultImageWidth: CGFloat = 140.0
    
    private static let imageLeftMargin: CGFloat = 20.0
    private static let informationViewVerticalMargin = 5.0
    
    convenience init(width: CGFloat, data: StandardContentsData, imageWidth: CGFloat = StandardInformationView.defaultImageWidth) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), imageUrl: data.dataImageUrl, organizer: data.dataOrganizer, description: data.dataDescription, place: data.dataPlace, imageWidth: imageWidth)
    }
    
    convenience init(width: CGFloat, imageUrl: String?, organizer: String?, description: String?, place: Place?, imageWidth: CGFloat = StandardInformationView.defaultImageWidth) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), imageUrl: imageUrl, organizer: organizer, description: description, place: place, imageWidth: imageWidth)
    }
    
    init(frame: CGRect, imageUrl: String?, organizer: String?, description: String?, place: Place?, imageWidth: CGFloat = StandardInformationView.defaultImageWidth) {
        super.init(frame: frame)
        
        // ImageView
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        self.addSubview(imageView)
        imageView.snp_makeConstraints { make in
            make.width.height.equalTo(imageWidth)
            make.top.equalTo(self)
            make.left.equalTo(self).offset(StandardInformationView.imageLeftMargin)
        }
        if let imageUrl = imageUrl, let url = NSURL(string: imageUrl) {
            imageView.af_setImageWithURL(url, placeholderImage: SharedImage.noImage)
        }
        else {
            imageView.image = SharedImage.noImage
        }
        
        let informationViewWidth = self.width - imageWidth - StandardInformationView.imageLeftMargin
        let informationViewOrigin = imageView.snp_right
        
        // Organization
        let organizationLabel = InformationLabel(width: informationViewWidth, icon: SharedImage.organizerIcon, text: organizer)
        self.addSubview(organizationLabel)
        organizationLabel.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(informationViewOrigin)
        }
        
        // Description
        let descriptionLabel = InformationLabel(width: informationViewWidth, icon: nil, text: description)
        self.addSubview(descriptionLabel)
        descriptionLabel.snp_makeConstraints { make in
            make.top.equalTo(organizationLabel.snp_bottom).offset(StandardInformationView.informationViewVerticalMargin)
            make.left.equalTo(informationViewOrigin)
        }
        
        // Place
        let placeLabel = InformationLabel(width: informationViewWidth, icon: SharedImage.placeIcon, text: place?.name)
        self.addSubview(placeLabel)
        placeLabel.snp_makeConstraints { make in
            make.top.equalTo(placeLabel.snp_bottom).offset(StandardInformationView.informationViewVerticalMargin)
            make.left.equalTo(informationViewOrigin)
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        self.snp_makeConstraints { make in
            make.width.equalTo(self.width)
            // 高い方を高さに設定
            make.height.equalTo(placeLabel.bottom < imageView.bottom ? imageView.bottom : placeLabel.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
