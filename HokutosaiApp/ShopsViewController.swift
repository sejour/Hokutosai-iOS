//
//  ShopsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/21.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class ShopsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LikeableTableViewCellDelegate, TabBarIntaractiveController, StandardTableViewController {

    private var shops: [Shop]?
    
    private var tableView: UITableView!
    private let cellIdentifier = "Shops"
    
    private var updatingContents: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "模擬店"
        
        self.generateTableView()
        
        let loadingView = SimpleLoadingView(frame: self.view.frame)
        self.view.addSubview(loadingView)
        self.updateContents {
            loadingView.removeFromSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func generateTableView() {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let nib = UINib(nibName: "StandardTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
        
        self.tableView.rowHeight = StandardTableViewCell.rowHeight
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ShopsViewController.onRefresh(_:)), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.view.addSubview(self.tableView)
    }
    
    func onRefresh(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        
        self.updateContents() {
            refreshControl.endRefreshing()
        }
    }
    
    private func updateContents(completion: (() -> Void)?) {
        guard !self.updatingContents else { return }
        self.updatingContents = true
        
        HokutosaiApi.GET(HokutosaiApi.Shops.All()) { response in
            guard response.isSuccess, let data = response.model else {
                self.updatingContents = false
                completion?()
                return
            }
            
            self.shops = data
            self.tableView.reloadData()
            self.updatingContents = false
            completion?()
        }
    }
    
    func updateContents() {
        guard self.tableView != nil else { return }
        self.updateContents(nil)
    }
    
    var requiredToUpdateWhenDidChengeTab: Bool { return true }
    var requiredToUpdateWhenWillEnterForeground: Bool { return true }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let shops = self.shops else { return }
        let shop = shops[indexPath.row]
        guard shop.shopId != nil else { return }
        
        let detailView = ShopsDetailViewController(shop: shop, shopViewController: self)
        self.navigationController?.pushViewController(detailView, animated: true)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let shops = self.shops else {
            return 0
        }
        
        return shops.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return StandardTableViewCell.rowHeight
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StandardTableViewCell
        
        cell.changeData(indexPath.row, data: self.shops![indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func like(index: Int, cell: LikeableTableViewCell) {
        guard self.shops != nil else { return }
        
        let shopId = self.shops![index].shopId!
        HokutosaiApi.POST(HokutosaiApi.Shops.Likes(shopId: shopId)) { response in
            guard let result = response.model else {
                self.presentViewController(ErrorAlert.Server.failureSendRequest(), animated: true, completion: nil)
                cell.updateLikes(shopId)
                return
            }

            self.shops![index].liked = result.liked
            self.shops![index].likesCount = result.likesCount
            cell.updateLikes(shopId)
        }
    }
    
    func dislike(index: Int, cell: LikeableTableViewCell) {
        guard self.shops != nil else { return }
        
        let shopId = self.shops![index].shopId!
        HokutosaiApi.DELETE(HokutosaiApi.Shops.Likes(shopId: shopId)) { response in
            guard let result = response.model else {
                self.presentViewController(ErrorAlert.Server.failureSendRequest(), animated: true, completion: nil)
                cell.updateLikes(shopId)
                return
            }

            self.shops![index].liked = result.liked
            self.shops![index].likesCount = result.likesCount
            cell.updateLikes(shopId)
        }
    }

    func tabBarIconTapped() {
        self.tableView?.setContentOffset(CGPoint(x: 0.0, y: -self.appearOriginY), animated: true)
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
}
