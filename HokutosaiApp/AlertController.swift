//
//  AlertViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/25.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

enum LR {
    case Left
    case Right
}

extension UIAlertController {
    
    class func notificationAlertController(title: String?, message: String?, closeButtonTitle: String, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: closeButtonTitle, style: .Default, handler: handler))
        return alert
    }
    
}

