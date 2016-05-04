//
//  EventsDetailViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/04.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class EventsDetailViewController: ContentsViewController {

    var event: Event!
    
    init (event: Event) {
        super.init(title: event.title)
        self.event = event
        self.title = event.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
