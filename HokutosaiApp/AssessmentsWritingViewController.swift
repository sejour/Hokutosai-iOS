//
//  AssessmentsWritingViewController.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/13.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

protocol AssessmentsWritingViewControllerDelegate: class {
    
    var myAssessment: Assessment? { get }
    func updateMyAssessment(newMyAssessment: MyAssessment)
    
}

class AssessmentsWritingViewController: ContentsStackViewController, StarScoreFieldDelegate, TextViewDelegate {
    
    private var assessmentEndpoint: HokutosaiApiEndpoint<ObjectResource<MyAssessment>>!
    
    private var topOfTextView: CGFloat!
    private var textView: TextView!
    private var userNameTextField: TextField!
    
    private var sendButton: UIBarButtonItem!
    
    private var currentScore: UInt?
    
    private weak var delegate: AssessmentsWritingViewControllerDelegate?
    
    init (assessmentEndpoint: HokutosaiApiEndpoint<ObjectResource<MyAssessment>>, delegate: AssessmentsWritingViewControllerDelegate?) {
        super.init()
        self.assessmentEndpoint = assessmentEndpoint
        self.delegate = delegate
        
        self.title = self.delegate?.myAssessment?.assessmentId == nil ? "評価の投稿" : "評価の編集"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "キャンセル", style: .Plain, target: self, action: #selector(AssessmentsWritingViewController.cancel))]
        self.sendButton = UIBarButtonItem(title: "送信", style: .Done, target: self, action: #selector(AssessmentsWritingViewController.send))
        self.sendButton.enabled = false
        self.navigationItem.rightBarButtonItems = [sendButton]
        
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
        userNameTextProperty.placeholder = "ニックネーム (任意)"
        userNameTextProperty.defaultText = AccountManager.sharedManager.account?.userName
        userNameTextProperty.characterLimit = 255
        userNameTextProperty.font = UIFont.systemFontOfSize(18.0)
        self.userNameTextField = TextField(width: self.view.width, property: userNameTextProperty)
        self.userNameTextField.delegate = self
        self.addContentView(self.userNameTextField)
        
        // ---
        self.insertSpace(8.0)
        self.insertSeparator(18.0, rightInset: 0.0)
        self.insertSpace(8.0)
        // ---
        
        // Score
        self.currentScore = self.delegate?.myAssessment?.score
        let scoreField = StarScoreField(width: self.view.width, defaultScore: self.currentScore, delegate: self)
        self.addContentView(scoreField)
        
        // ---
        self.insertSpace(8.0)
        self.insertSeparator(18.0, rightInset: 0.0)
        self.insertSpace(8.0)
        // ---
        
        // Text
        let textViewProperty = TextView.Property()
        textViewProperty.placeholder = "感想を入力してください (必須)"
        textViewProperty.defaultText = self.delegate?.myAssessment?.comment
        self.topOfTextView = self.bottomOfLastView
        self.textView = TextView(width: self.view.width, height: self.view.height - self.bottomOfLastView, property: textViewProperty)
        self.textView.delegate = self
        self.addContentView(self.textView)
        
        //
        self.insertSpace(8.0)
        //
    }
    
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func send() {
        guard self.isSendable, let score = self.currentScore, let text = self.textView.text else {
            self.presentViewController(ErrorAlert.Server.failureSendRequest("評価を送信できませんでした。"), animated: true, completion: nil)
            return
        }
        
        var userName = self.userNameTextField.text
        if let name = userName where name.isBlank {
            userName = nil
        }
        AccountManager.sharedManager.setUserName(userName)
        
        let parameters: [String: AnyObject] = ["score": score, "comment": text, "user_name": userName ?? ""]
        HokutosaiApi.POST(self.assessmentEndpoint, parameters: parameters) { response in
            guard response.isSuccess, let data = response.model else {
                self.presentViewController(ErrorAlert.Server.failureSendRequest("評価を送信できませんでした。"), animated: true, completion: nil)
                return
            }
            
            self.delegate?.updateMyAssessment(data)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func changeScore(score: UInt?) {
        self.currentScore = score
        self.sendButton.enabled = self.isSendable
    }
    
    func textDidChange(text: String?, lenght: Int?) {
        self.sendButton.enabled = self.isSendable
    }
    
    private var isSendable: Bool {
        guard let text = self.textView.text else { return false }
        return self.currentScore != nil && !text.isEmpty && !text.isBlank
    }
    
    func didShowKeyboard(notification:NSNotification){
        if let userInfo = notification.userInfo{
            if let keyboard = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue{
                let keyBoardRect = keyboard.CGRectValue()
                
                // キーボードが表示されたらTextViewの高さを調整
                self.textView.snp_updateConstraints { make in
                    let textViewHeight = self.view.height - self.topOfTextView - keyBoardRect.height
                    make.height.equalTo(textViewHeight)
                    self.bottomOfLastView = self.topOfTextView + self.bottomOfLastView
                }
            }
        }
    }
    
}