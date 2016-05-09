//
//  ExhibitionsDetailViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/10.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation

class ExhibitionsDetailViewController: StandardDetailsViewController<Exhibition, ExhibitionsViewController> {
    
    init(exhibitionId: UInt, title: String?) {
        super.init(endpointModel: HokutosaiApi.Exhibitions.One(exhibitionId: exhibitionId),
                   endpointLikes: HokutosaiApi.Exhibitions.Likes(exhibitionId: exhibitionId),
                   endpointAssessmentList: HokutosaiApi.Exhibitions.Assessments(exhibitionId: exhibitionId),
                   endpointAssessment: HokutosaiApi.Exhibitions.Assessment(exhibitionId: exhibitionId),
                   title: title
        )
    }
    
    init(exhibition: Exhibition, exhibitionViewController: ExhibitionsViewController) {
        let exhibitionId = exhibition.exhibitionId!
        super.init(endpointModel: HokutosaiApi.Exhibitions.One(exhibitionId: exhibitionId),
                   endpointLikes: HokutosaiApi.Exhibitions.Likes(exhibitionId: exhibitionId),
                   endpointAssessmentList: HokutosaiApi.Exhibitions.Assessments(exhibitionId: exhibitionId),
                   endpointAssessment: HokutosaiApi.Exhibitions.Assessment(exhibitionId: exhibitionId),
                   model: exhibition,
                   tableViewController: exhibitionViewController
        )
    }
    
    override func generateContents(model: Exhibition) {
        super.generateContents(model)
    }
    
}