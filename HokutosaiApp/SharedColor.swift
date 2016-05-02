//
//  SharedColor.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/28.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

final class SharedColor {

    static let themeColor = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
    static let lightThemeColor = UIColor.trueColor(250, green: 200, blue: 150)
    
    static let likesCountGray = UIColor.grayscale(127)
    static let likesCountRed = UIColor.trueColor(220, green: 20, blue: 60)
    
    class EventState {
        
        static let blue = UIColor.trueColor(150, green: 212, blue: 250)
        static let green = UIColor.trueColor(200, green: 250, blue: 150)
        static let yellow = UIColor.trueColor(250, green: 250, blue: 150)
        static let orange = UIColor.trueColor(250, green: 200, blue: 150)
        static let red = UIColor.trueColor(250, green: 150, blue: 150)
        static let gray = UIColor.grayscale(200)
        
    }
    
    private init () {}
    
}