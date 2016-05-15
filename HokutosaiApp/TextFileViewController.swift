//
//  TextFileViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/15.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class TextFileViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var fileName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.editable = false

        if let name = self.fileName {
            let path = NSBundle.mainBundle().pathForResource(name, ofType: "txt")!
            if let data = NSData(contentsOfFile: path){
                self.textView.text = String(NSString(data: data, encoding: NSUTF8StringEncoding)!)
            }
        }
        
        self.textView.contentOffset = CGPoint(x: 0.0, y: self.appearOriginY)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
