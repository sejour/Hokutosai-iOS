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
    
    private static let hokutosaiVersionUrl = "hokutosai:2016/ios-app/version"
    private static let hokutosaiCopyrightUrl = "hokutosai:2016/ios-app/copyrights"
    
    private var others: [OthersSection] = [
        OthersSection(title: nil, items: [
            OthersItem(title: "バージョン", url: OthersViewController.hokutosaiVersionUrl)
        ]),
        OthersSection(title: "北斗祭に関する情報", items: [
            OthersItem(title: "北斗祭公式ホームページ", url: "http://www.nc-toyama.ac.jp/c5/index.php/mcon/ca_life/%E3%82%AD%E3%83%A3%E3%83%B3%E3%83%91%E3%82%B9%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88/%E9%AB%98%E5%B0%82%E7%A5%AD/kousensaih008/"),
            OthersItem(title: "北斗祭公式Twitter", url: "https://mobile.twitter.com/hokutosai2016"),
            OthersItem(title: "スクールバス時刻表", url: "https://www.hokutosai.tech/schoolbus/")
        ]),
        OthersSection(title: "アプリに関する情報", items: [
            OthersItem(title: "アプリについて", url: "https://www.hokutosai.tech/"),
            OthersItem(title: "北斗祭アプリ公式Twitter", url: "https://mobile.twitter.com/hokutosai_app"),
            OthersItem(title: "著作権情報", url: OthersViewController.hokutosaiCopyrightUrl)
        ])
    ]
    
    init() {
        super.init(style: .Grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "その他"
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(OthersViewController.tappedExit))]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.others[indexPath.section].items[indexPath.row]
        guard let urlString = item.url, let url = NSURL(string: urlString) else { return }
        
        if url.scheme == "hokutosai" {
            if url.absoluteString == OthersViewController.hokutosaiCopyrightUrl {
                let textView = TextFileViewController()
                textView.title = "著作権情報"
                textView.fileName = "copyrights"
                self.navigationController?.pushViewController(textView, animated: true)
            }
        }
        else {
            let webView = WebViewController(url: url)
            self.navigationController?.pushViewController(webView, animated: true)
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.others.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.others[section].items.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.others[section].title
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: self.cellIdentifier)
        
        let item = self.others[indexPath.section].items[indexPath.row]

        if item.url == OthersViewController.hokutosaiVersionUrl {
            cell.selectionStyle = .None
            cell.detailTextLabel?.text = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
            cell.detailTextLabel?.textColor = UIColor.grayColor()
        }
        else {
            cell.selectionStyle = .Default
        }
        
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    func tappedExit() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
