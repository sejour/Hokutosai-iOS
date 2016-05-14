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
