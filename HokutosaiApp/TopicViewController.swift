//
//  TopicViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/30.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class TopicViewController: TappableViewController {

    private var topic: TopicContentData?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTopicContentData(index: Int, data: TopicContentData, priorityToImage: Bool = false) {
        self.tag = index
        self.topic = data

        self.titleLable.hidden = false
        self.titleLable.text = data.dataTitle
        
        if let imageUrl = data.dataImageUrl, let url = NSURL(string: imageUrl) {
            guard url != "hokutosai:2016/top" else {
                return
            }
            
            self.imageView.af_setImageWithURL(url) { response in
                if response.result.isSuccess {
                    if priorityToImage  { self.titleLable.hidden = true }
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
