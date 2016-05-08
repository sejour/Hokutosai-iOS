//
//  StandardDetailsViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/26.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

protocol ReloadableViewController: class {
    
    func reload()

}

class StandardDetailsViewController<ModelType: StandardContentsData, TableViewController: ReloadableViewController, MutableContentsController>: ContentsViewController {

    private var modelId: UInt!
    private var model: ModelType?
    
    private var likesCountLabel: InformationLabel!
    private var likeIcon: InteractiveIcon!
    
    private weak var tableViewController: TableViewController?
    
    init(modelId: UInt, title: String?) {
        super.init(title: title)
        self.modelId = modelId
    }
    
    init(model: ModelType, tableViewController: TableViewController) {
        super.init(title: model.dataTitle)
        self.model = model
        self.modelId = model.dataId
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
