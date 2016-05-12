//
//  SharedImage.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/26.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

final class SharedImage {
    
    static let noImage = UIImage(named: "NoImage")
    static let noImageWide = UIImage(named: "NoImageWide")
    
    static let grayHertIcon = UIImage(named: "GrayHertIcon")
    static let redHertIcon = UIImage(named: "RedHertIcon")
    static let featureIcon = UIImage(named: "FeatureIcon")
    static let topicIcon = UIImage(named: "TopicIcon")
    static let starRibbonIcon = UIImage(named: "StarRibbonIcon")
    
    static var organizerIcon: UIImage? { return UIImage(named: "OrganizerIcon") }
    static var placeIcon: UIImage? { return UIImage(named: "PlaceIcon") }
    static var clockIcon: UIImage? { return UIImage(named: "ClockIcon") }
    static var descriptionIcon: UIImage? { return UIImage(named: "DescriptionIcon") }
    static var bookIcon: UIImage? { return UIImage(named: "BookIcon") }
    static var introductionIcon: UIImage? { return UIImage(named: "IntroductionIcon") }
    static var messageIcon: UIImage? { return UIImage(named: "MessageIcon") }
    
    static var remindOffIcon: UIImage? { return UIImage(named: "RemindOffIcon") }
    static var remindOnIcon: UIImage? { return UIImage(named: "RemindOnIcon") }
    static var largeGrayHertIcon: UIImage? { return UIImage(named: "LargeGrayHertIcon") }
    static var largeRedHertIcon: UIImage? { return UIImage(named: "LargeRedHertIcon") }
    static var shareIcon: UIImage? { return UIImage(named: "ShareIcon") }
    static var blackHertIcon: UIImage? { return UIImage(named: "BlackHertIcon") }
    
    static var hokutosaiTopImage: UIImage? { return UIImage(named: "TopImage") }
    static var hokutosaiThemaImage: UIImage? { return UIImage(named: "ThemaImage") }
    
    static var placeholderImage: UIImage? { return UIImage(named: "PlaceholderImage") }
    static let placeholderImageMini = UIImage(named: "PlaceholderImageMini")
    
    static var layoutMap: UIImage? { return UIImage(named: "LayoutMap") }
    
    private init () {}
    
}