//
//  StandardInformationView.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/09.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class StandardInformationView: UIView {
    
    private static let imageWidthRatio: CGFloat = 0.38
    private static let imageLeftMargin: CGFloat = 20.0
    private static let informationViewVerticalMargin = 5.0
    
    convenience init(width: CGFloat, data: StandardContentsData) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), imageUrl: data.dataImageUrl, organizer: data.dataOrganizer, description: data.dataDescription, place: data.dataPlace)
    }
    
    convenience init(width: CGFloat, imageUrl: String?, organizer: String?, description: String?, place: Place?) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), imageUrl: imageUrl, organizer: organizer, description: description, place: place)
    }
    
    init(frame: CGRect, imageUrl: String?, organizer: String?, description: String?, place: Place?) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let imageWidth = self.width * StandardInformationView.imageWidthRatio
        
        // ImageView
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        organizationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(organizationLabel)
        organizationLabel.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(informationViewOrigin)
        }
        
        // Description
        let descriptionLabel = InformationLabel(width: informationViewWidth, icon: nil, text: description)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(descriptionLabel)
        descriptionLabel.snp_makeConstraints { make in
            make.top.equalTo(organizationLabel.snp_bottom).offset(StandardInformationView.informationViewVerticalMargin)
            make.left.equalTo(informationViewOrigin)
        }
        
        // Place
        let placeLabel = InformationLabel(width: informationViewWidth, icon: SharedImage.placeIcon, text: place?.name)
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(placeLabel)
        placeLabel.snp_makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(StandardInformationView.informationViewVerticalMargin)
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
