//
//  ExhibitionsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/21.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class ExhibitionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LikeableTableViewCellDelegate, TabBarIntaractiveController {

    private var exhibitions: [Exhibition]!
    
    private var tableView: UITableView!
    private let cellIdentifier = "Exhibitions"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "展示"
        
        self.generateTableView()
        
        let loadingView = SimpleLoadingView(frame: self.view.frame)
        self.view.addSubview(loadingView)
        HokutosaiApi.GET(HokutosaiApi.Exhibitions.Exhibitions()) { response in
            guard response.isSuccess else {
                print(response.statusCode)
                self.presentViewController(ErrorAlert.Server.failureGet(), animated: true, completion: nil)
                loadingView.removeFromSuperview()
                return
            }
            
            self.exhibitions = response.model
            self.tableView.reloadData()
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
        
        self.view.addSubview(self.tableView)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsView = StandardDetailsViewController()
        detailsView.title = self.exhibitions[indexPath.row].title!
        self.navigationController?.pushViewController(detailsView, animated: true)
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
        
        cell.changeData(indexPath.row, data: self.exhibitions[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func like(index: Int, cell: LikeableTableViewCell) {
        let exhibitionId = self.exhibitions[index].exhibitionId!
        HokutosaiApi.POST(HokutosaiApi.Exhibitions.Likes(exhibitionId: exhibitionId)) { response in
            guard let result = response.model else {
                self.presentViewController(ErrorAlert.Server.failureSendRequest(), animated: true, completion: nil)
                cell.updateLikes(exhibitionId)
                return
            }
            
            self.exhibitions[index].liked = result.liked
            self.exhibitions[index].likesCount = result.likesCount
            cell.updateLikes(exhibitionId)
        }
    }
    
    func dislike(index: Int, cell: LikeableTableViewCell) {
        let exhibitionId = self.exhibitions[index].exhibitionId!
        HokutosaiApi.DELETE(HokutosaiApi.Exhibitions.Likes(exhibitionId: exhibitionId)) { response in
            guard let result = response.model else {
                self.presentViewController(ErrorAlert.Server.failureSendRequest(), animated: true, completion: nil)
                cell.updateLikes(exhibitionId)
                return
            }
            
            self.exhibitions[index].liked = result.liked
            self.exhibitions[index].likesCount = result.likesCount
            cell.updateLikes(exhibitionId)
        }
    }
    
    func tabBarIconTapped() {
        self.tableView?.setContentOffset(CGPoint(x: 0.0, y: -self.appearOriginY), animated: true)
    }
    
}
