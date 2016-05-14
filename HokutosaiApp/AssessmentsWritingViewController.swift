//
//  AssessmentsWritingViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/13.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class AssessmentsWritingViewController: ContentsStackViewController, StarScoreFieldDelegate {
    
    private var myAssessment: Assessment?
    private var assessmentEndpoint: HokutosaiApiEndpoint<ObjectResource<MyAssessment>>!
    
    private var topOfTextView: CGFloat!
    private var textView: TextView!
    
    init (assessmentEndpoint: HokutosaiApiEndpoint<ObjectResource<MyAssessment>>, myAssessment: Assessment?) {
        super.init(title: "評価の投稿")
        self.assessmentEndpoint = assessmentEndpoint
        self.myAssessment = myAssessment
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "キャンセル", style: .Plain, target: self, action: #selector(AssessmentsWritingViewController.cancel))]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "送信", style: .Plain, target: self, action: #selector(AssessmentsWritingViewController.send))]
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(AssessmentsWritingViewController.didShowKeyboard(_:)), name: UIKeyboardDidShowNotification, object: nil)
        
        self.generateContents()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func generateContents() {
        //
        self.insertSpace(15.0)
        //
        
        // User Name
        let userNameTextProperty = TextField.Property()
        userNameTextProperty.placeholder = "ユーザ名 (任意)"
        userNameTextProperty.characterLimit = 255
        let userNameTextField = TextField(width: self.view.width, property: userNameTextProperty)
        self.addContentView(userNameTextField)
        
        // ---
        self.insertSpace(8.0)
        self.insertSeparator(20.0)
        self.insertSpace(8.0)
        // ---
        
        // Score
        let scoreField = StarScoreField(width: self.view.width, defaultScore: 0, delegate: self)
        self.addContentView(scoreField)
        
        // ---
        self.insertSpace(8.0)
        self.insertSeparator(20.0)
        self.insertSpace(8.0)
        // ---
        
        // Text
        let textViewProperty = TextView.Property()
        textViewProperty.placeholder = "感想を入力してください"
        self.topOfTextView = self.bottomOfLastView
        self.textView = TextView(width: self.view.width, height: self.view.height - self.bottomOfLastView, property: textViewProperty)
        self.addContentView(self.textView)
        
        //
        self.insertSpace(8.0)
        //
    }
    
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func send() {
        
    }
    
    func changeScore(score: UInt?) {
        print("\(score)")
    }
    
    func didShowKeyboard(notification:NSNotification){
        if let userInfo = notification.userInfo{
            if let keyboard = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue{
                let keyBoardRect = keyboard.CGRectValue()
                
                // キーボードが表示されたらTextViewの高さを調整
                self.textView.snp_updateConstraints { make in
                    make.height.equalTo(self.view.height - self.topOfTextView - keyBoardRect.height)
                }
            }
        }
    }
    
}