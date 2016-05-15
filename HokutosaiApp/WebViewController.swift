//
//  WebViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/15.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    private var webView: UIWebView!
    private var url: NSURL!
    
    init(url: NSURL) {
        super.init(nibName: nil, bundle: NSBundle.mainBundle())
        self.url = url
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView = UIWebView(frame: self.view.frame)
        self.webView.delegate = self
        self.view.addSubview(self.webView)
        
        let urlRequest = NSURLRequest(URL: self.url)
        self.webView.loadRequest(urlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }

}
