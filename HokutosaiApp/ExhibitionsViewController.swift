//
//  ExhibitionsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/21.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class ExhibitionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LikeableTableViewCellDelegate, TabBarIntaractiveController, StandardTableViewController {

    private var exhibitions: [Exhibition]?
    
    private var tableView: UITableView!
    private let cellIdentifier = "Exhibitions"
    
    private var updatingContents: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "展示"
        
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
        refreshControl.addTarget(self, action: #selector(ExhibitionsViewController.onRefresh(_:)), forControlEvents: .ValueChanged)
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
        
        HokutosaiApi.GET(HokutosaiApi.Exhibitions.All()) { response in
            guard response.isSuccess, let data = response.model else {
                self.updatingContents = false
                completion?()
                return
            }
            
            self.exhibitions = data
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
        //guard let exhibitions = self.exhibitions else { return }
        
        //let detailsView = StandardDetailsViewController()
        //self.navigationController?.pushViewController(detailsView, animated: true)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let exhibitions = self.exhibitions else {
            return 0
        }
        
        return exhibitions.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return StandardTableViewCell.rowHeight
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StandardTableViewCell
        
        cell.changeData(indexPath.row, data: self.exhibitions![indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func like(index: Int, cell: LikeableTableViewCell) {
        guard self.exhibitions != nil else { return }
        
        let exhibitionId = self.exhibitions![index].exhibitionId!
        HokutosaiApi.POST(HokutosaiApi.Exhibitions.Likes(exhibitionId: exhibitionId)) { response in
            guard let result = response.model else {
                self.presentViewController(ErrorAlert.Server.failureSendRequest(), animated: true, completion: nil)
                cell.updateLikes(exhibitionId)
                return
            }
            
            self.exhibitions![index].liked = result.liked
            self.exhibitions![index].likesCount = result.likesCount
            cell.updateLikes(exhibitionId)
        }
    }
    
    func dislike(index: Int, cell: LikeableTableViewCell) {
        guard self.exhibitions != nil else { return }
        
        let exhibitionId = self.exhibitions![index].exhibitionId!
        HokutosaiApi.DELETE(HokutosaiApi.Exhibitions.Likes(exhibitionId: exhibitionId)) { response in
            guard let result = response.model else {
                self.presentViewController(ErrorAlert.Server.failureSendRequest(), animated: true, completion: nil)
                cell.updateLikes(exhibitionId)
                return
            }
            
            self.exhibitions![index].liked = result.liked
            self.exhibitions![index].likesCount = result.likesCount
            cell.updateLikes(exhibitionId)
        }
    }
    
    func tabBarIconTapped() {
        self.tableView?.setContentOffset(CGPoint(x: 0.0, y: -self.appearOriginY), animated: true)
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
}
