//
//  OthersViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/15.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class OthersViewController: UITableViewController {

    private let cellIdentifier = "Others"
    
    private var others: [String: [OthersItem]] = [
        "": [
            OthersItem(title: "バージョン", url: "hokutosai:2016/ios-app/version")
        ],
        "北斗祭に関する情報": [
            OthersItem(title: "北斗祭公式ホームページ", url: "http://www.nc-toyama.ac.jp/c5/index.php/mcon/ca_life/%E3%82%AD%E3%83%A3%E3%83%B3%E3%83%91%E3%82%B9%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88/%E9%AB%98%E5%B0%82%E7%A5%AD/kousensaih008/"),
            OthersItem(title: "北斗祭公式Twitter", url: "https://mobile.twitter.com/hokutosai2016"),
            OthersItem(title: "スクールバス時刻表", url: "https://www.hokutosai.tech/schoolbus")
        ],
        "アプリに関する情報": [
            OthersItem(title: "アプリについて", url: "https://www.hokutosai.tech/"),
            OthersItem(title: "北斗祭アプリ公式Twitter", url: "https://mobile.twitter.com/hokutosai_app"),
            OthersItem(title: "著作権情報", url: "hokutosai:2016/ios-app/copyright")
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "その他"
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(OthersViewController.tappedExit))]
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    
    func tappedExit() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
