//
//  TappableViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/29.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

protocol TappableViewControllerDelegate : class {

    func tappedView(sender: TappableViewController, gesture: UITapGestureRecognizer, tag: Int)
    
}

class TappableViewController: UIViewController {
    
    weak var delegate: TappableViewControllerDelegate?
    
    var tag: Int {
        get { return self.view.tag }
        set { self.view.tag = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TappableViewController.tapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapped(sender: UITapGestureRecognizer) {
        self.delegate?.tappedView(self, gesture: sender, tag: tag)
    }

}