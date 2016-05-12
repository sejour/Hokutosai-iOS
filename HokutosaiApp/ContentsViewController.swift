//
//  ContentsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/05.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    func changeContentView(contentView: UIView) {
        let subviews = self.contentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        self.contentView.addSubview(contentView)
    }
    
}

protocol CellContent: class {
    
    var rowHeight: CGFloat { get }
    
}

protocol SelectableCellContent: class {
    
    var selected: (() -> Void) { get }
    
}

class ContentsViewController: UITableViewController {
    
    var contentViews: [UIView] = []
    let cellIdentifier = "Contents"
    
    var defaultSeparatorColor = UIColor.lightGrayColor()
    var defaultSeparatorWidth: CGFloat = 0.5
    
    init (title: String? = nil) {
        super.init(nibName: nil, bundle: NSBundle.mainBundle())
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.separatorStyle = .None
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addContentView(view: UIView) {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        self.contentViews.append(view)
    }
    
    func insertSpace(height: CGFloat) {
        self.contentViews.append(UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.width, height: height)))
    }
    
    func insertSeparator(color: UIColor? = nil, width: CGFloat? = nil) -> SeparatorView {
        return self.insertSeparator(0.0, rightInset: 0.0, color: color, width: width)
    }
    
    func insertSeparator(inset: CGFloat, color: UIColor? = nil, width: CGFloat? = nil) -> SeparatorView {
        return self.insertSeparator(inset, rightInset: inset, color: color, width: width)
    }
    
    func insertSeparator(leftInset: CGFloat, rightInset: CGFloat, color: UIColor? = nil, width: CGFloat? = nil) -> SeparatorView {
        let length = self.view.width - leftInset - rightInset
        let separator = SeparatorView(origin: leftInset, length: length, color: color ?? self.defaultSeparatorColor, width: width ?? self.defaultSeparatorWidth)
        self.contentViews.append(separator)
        
        return separator
    }
    
    func updateContentViews() {
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentViews.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let view = self.contentViews[indexPath.row]
        if let content = view as? CellContent {
            return content.rowHeight
        }
        
        return view.height
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let view = self.contentViews[indexPath.row]
        
        cell.selectionStyle = view is SelectableCellContent ? .Default : .None
        
        cell.changeContentView(view)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let content = self.contentViews[indexPath.row] as? SelectableCellContent {
            content.selected()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
