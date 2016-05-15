//
//  StandardInformationView.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/09.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

protocol StandardInformationViewDelegate: class {
    
    func tappedImage(image: UIImage?)
    
}

class StandardInformationView: UIView {
    
    private static let imageWidthRatio: CGFloat = 0.38
    private static let imageLeftMargin: CGFloat = 20.0
    private static let informationViewVerticalMargin = 5.0
    
    weak var delegate: StandardInformationViewDelegate?
    private var imageView: UIImageView!
    
    convenience init(width: CGFloat, data: StandardContentsData, placeLinkTarget: AnyObject?, placeLinkAction: Selector) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), imageUrl: data.dataImageUrl, organizer: data.dataOrganizer, description: data.dataDescription, place: data.dataPlace, placeLinkTarget: placeLinkTarget, placeLinkAction: placeLinkAction)
    }
    
    convenience init(width: CGFloat, imageUrl: String?, organizer: String?, description: String?, place: Place?, placeLinkTarget: AnyObject?, placeLinkAction: Selector) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), imageUrl: imageUrl, organizer: organizer, description: description, place: place, placeLinkTarget: placeLinkTarget, placeLinkAction: placeLinkAction)
    }
    
    init(frame: CGRect, imageUrl: String?, organizer: String?, description: String?, place: Place?, placeLinkTarget: AnyObject?, placeLinkAction: Selector) {
        super.init(frame: frame)
        
        let imageWidth = self.width * StandardInformationView.imageWidthRatio
        
        // ImageView
        self.imageView = UIImageView()
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.userInteractionEnabled = true
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(StandardInformationView.tappedImage(_:))))
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
        self.imageView.snp_makeConstraints { make in
            make.width.height.equalTo(imageWidth)
            make.top.equalTo(self)
            make.left.equalTo(self).offset(StandardInformationView.imageLeftMargin)
        }
        if let imageUrl = imageUrl, let url = NSURL(string: imageUrl) {
            self.imageView.af_setImageWithURL(url, placeholderImage: SharedImage.noImage)
        }
        else {
            self.imageView.image = SharedImage.noImage
        }
        
        let informationViewWidth = self.width - imageWidth - StandardInformationView.imageLeftMargin
        let informationViewOrigin = self.imageView.snp_right
        
        // Organization
        let organizationLabel = InformationLabel(width: informationViewWidth, icon: SharedImage.organizerIcon, text: organizer)
        organizationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(organizationLabel)
        organizationLabel.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(informationViewOrigin)
        }
        
        // Description
        let descriptionLabel = InformationLabel(width: informationViewWidth, icon: SharedImage.descriptionIcon, text: description)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(descriptionLabel)
        descriptionLabel.snp_makeConstraints { make in
            make.top.equalTo(organizationLabel.snp_bottom).offset(StandardInformationView.informationViewVerticalMargin)
            make.left.equalTo(informationViewOrigin)
        }
        
        // Place
        let placeLabel = LinkedInformationLabel(width: informationViewWidth, icon: SharedImage.placeIcon, text: place?.name, target: placeLinkTarget, action: placeLinkAction)
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
    
    func tappedImage(gesture: UITapGestureRecognizer) {
        self.delegate?.tappedImage(self.imageView.image)
    }
    
}
