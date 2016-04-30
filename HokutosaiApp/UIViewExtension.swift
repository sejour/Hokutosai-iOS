//
//  UIViewExtension.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/01.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

extension UIView {
    
    var origin: CGPoint {
        return self.frame.origin
    }
    
    var originX: CGFloat {
        return self.frame.origin.x
    }
    
    var originY: CGFloat {
        return self.frame.origin.y
    }
    
    var size: CGSize {
        return self.frame.size
    }
    
    var width: CGFloat {
        return self.frame.size.width
    }
    
    var height: CGFloat {
        return self.frame.size.height
    }
    
    var left: CGFloat {
        return self.frame.origin.x
    }
    
    var top: CGFloat {
        return self.frame.origin.y
    }
    
    var right: CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    var bottom: CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
}