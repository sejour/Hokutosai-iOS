//
//  ShopsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/21.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class ShopsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var shops: [Shop]!
    
    private var tableView: UITableView!
    private let cellIdentifier = "Shops"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "模擬店"
        
        self.generateTableView()
        
        HokutosaiApi.GET(HokutosaiApi.Shops.Shops()) { response in
            guard response.isSuccess else {
                self.presentViewController(ErrorAlert.failureServerData(), animated: true, completion: nil)
                return
            }
            
            self.shops = response.model
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func generateTableView() {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(self.tableView)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("index: \(indexPath.row)")
        print("name: \(self.shops[indexPath.row].name!)")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let shops = self.shops else {
            return 0
        }
        
        return shops.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel!.text = "\(self.shops[indexPath.row].name!)"
        
        return cell
    }

}
