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

final class ErrorAlert {
    
    class func failureServerData() -> UIAlertController {
        return UIAlertController.notificationAlertController("データを取得できません。", message: "しばらくしてからもう一度アクセスし直してください。", closeButtonTitle: "OK")
    }
    
    private init () {}
    
}

