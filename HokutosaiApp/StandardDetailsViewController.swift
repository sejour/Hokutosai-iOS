//
//  StandardDetailsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/26.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

protocol StandardTableViewController: MutableContentsController {
    
    func reloadData()

}

class StandardDetailsViewController<ModelType: StandardContentsData, TableViewController: StandardTableViewController>: ContentsViewController {

    private var model: ModelType?
    
    private var likesCountLabel: InformationLabel!
    private var likeIcon: InteractiveIcon!
    
    private weak var tableViewController: TableViewController?
    
    private var endpointDetails: HokutosaiApiEndpoint<ObjectResource<ModelType>>!
    private var endpointLikes: HokutosaiApiEndpoint<ObjectResource<LikeResult>>!
    
    init(endpointDetails: HokutosaiApiEndpoint<ObjectResource<ModelType>>, endpointLikes: HokutosaiApiEndpoint<ObjectResource<LikeResult>>, modelId: UInt, title: String?) {
        super.init(title: title)
        self.endpointDetails = endpointDetails
        self.endpointLikes = endpointLikes
    }
    
    init(endpointDetails: HokutosaiApiEndpoint<ObjectResource<ModelType>>, endpointLikes: HokutosaiApiEndpoint<ObjectResource<LikeResult>>, model: ModelType, tableViewController: TableViewController) {
        super.init(title: model.dataTitle)
        self.endpointDetails = endpointDetails
        self.endpointLikes = endpointLikes
        self.model = model
        self.tableViewController = tableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let model = self.model {
            self.generateContents(model)
            self.updateLike()
        }
        else {
            self.fetchContents()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchContents() {
        let loadingView = SimpleLoadingView(frame: self.view.frame, backgroundColor: UIColor.whiteColor())
        self.view.addSubview(loadingView)
        
        HokutosaiApi.GET(self.endpointDetails) { response in
            guard response.isSuccess, let data = response.model else {
                self.presentViewController(ErrorAlert.Server.failureGet { action in
                    loadingView.removeFromSuperview()
                    self.navigationController?.popViewControllerAnimated(true)
                    }, animated: true, completion: nil)
                return
            }
            
            self.model = data
            self.generateContents(data)
            self.updateContentViews()
            loadingView.removeFromSuperview()
        }
    }
    
    func generateContents(mode: ModelType) {
        
    }
    
    func like() {
        
    }
    
    func updateLikes(like: LikeResult?) {
        
    }
    
    func updateLike() {
        
    }
    
    func share() {
        
    }

}
