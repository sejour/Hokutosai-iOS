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
    
    final class Server {
        
        static let defaultMessage = "しばらくしてからもう一度アクセスし直してください。"
        
        class func failure(message: String = defaultMessage, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
            return UIAlertController.notificationAlertController("サーバにアクセスできません。", message: message, closeButtonTitle: "OK", handler: handler)
        }

        class func failureGet(message: String = defaultMessage, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
            return UIAlertController.notificationAlertController("データを取得できません。", message: message, closeButtonTitle: "OK", handler: handler)
        }
        
        class func failureSendRequest(message: String = defaultMessage, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
            return UIAlertController.notificationAlertController("リクエストを送信できません。", message: message, closeButtonTitle: "OK", handler: handler)
        }
        
        class func accessDenyed(message: String = defaultMessage, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
            return UIAlertController.notificationAlertController("アクセスが拒否されました。", message: message, closeButtonTitle: "OK", handler: handler)
        }
        
        private init () {}

    }
    
    private init () {}
    
}

