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
        
        static let blue = UIColor.trueColor(125, green: 208, blue: 250)
        static let green = UIColor.trueColor(167, green: 250, blue: 125)
        static let yellow = UIColor.trueColor(250, green: 250, blue: 125)
        static let orange = UIColor.trueColor(250, green: 167, blue: 125)
        static let red = UIColor.trueColor(250, green: 125, blue: 125)
        static let gray = UIColor.grayscale(128)
        
    }
    
    private init () {}
    
}