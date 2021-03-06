//
//  EventsTimetableViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/02.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class EventsTimetableViewController: UITableViewController, LikeableTableViewCellDelegate {

    let cellIdentifier = "Events"
    
    var timetable: [Event]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    weak var eventsViewController: EventsViewController?
    
    init (title: String?, eventsViewController: EventsViewController) {
        super.init(nibName: nil, bundle: NSBundle.mainBundle())
        self.title = title
        self.eventsViewController = eventsViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "EventsTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: self.cellIdentifier)
        
        self.tableView.rowHeight = StandardTableViewCell.rowHeight
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        self.tableView.setContentAndScrollInsets(UIEdgeInsets(top: 0.0, left: 0.0, bottom: MainTabViewController.mainController.tabBar.height, right: 0.0))
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(EventsTimetableViewController.onRefresh(_:)), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRefresh(refreshControl: UIRefreshControl) {
        self.eventsViewController?.onRefresh(refreshControl)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let events = self.timetable else { return }
        
        let detailView = EventsDetailViewController(event: events[indexPath.row], timetableViewController: self)
        self.navigationController?.pushViewController(detailView, animated: true)
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let timetable = self.timetable else {
            return 0
        }
        
        return timetable.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return EventsTableViewCell.rowHeight
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return EventsTableViewCell.rowHeight
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! EventsTableViewCell

        cell.delegate = self
        cell.changeData(indexPath.row, data: self.timetable![indexPath.row])

        return cell
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func like(index: Int, cell: LikeableTableViewCell) {
        guard self.timetable != nil else { return }
        
        let eventId = self.timetable![index].eventId!
        HokutosaiApi.POST(HokutosaiApi.Events.Likes(eventId: eventId)) { response in
            guard let result = response.model else {
                self.presentViewController(ErrorAlert.Server.failureSendRequest(), animated: true, completion: nil)
                cell.updateLikes(eventId)
                return
            }
            
            self.timetable![index].liked = result.liked
            self.timetable![index].likesCount = result.likesCount
            cell.updateLikes(eventId)
        }
    }
    
    func dislike(index: Int, cell: LikeableTableViewCell) {
        guard self.timetable != nil else { return }
        
        let eventId = self.timetable![index].eventId!
        HokutosaiApi.DELETE(HokutosaiApi.Events.Likes(eventId: eventId)) { response in
            guard let result = response.model else {
                self.presentViewController(ErrorAlert.Server.failureSendRequest(), animated: true, completion: nil)
                cell.updateLikes(eventId)
                return
            }
            
            self.timetable![index].liked = result.liked
            self.timetable![index].likesCount = result.likesCount
            cell.updateLikes(eventId)
        }
    }
    
    func scrollToTop(animated: Bool = true) {
        self.tableView.setContentOffset(CGPointZero, animated: animated)
    }

}
