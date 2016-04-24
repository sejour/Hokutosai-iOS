//
//  ShopsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/21.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class ShopsViewController: UIViewController {

    var shops: [Shop]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "模擬店"
        
        HokutosaiApi.GET(HokutosaiApi.Shops.Shops()) { response in
            guard response.isSuccess else {
                self.presentViewController(ErrorAlert.failureServerData(), animated: true, completion: nil)
                return
            }
            
            self.shops = response.model
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
