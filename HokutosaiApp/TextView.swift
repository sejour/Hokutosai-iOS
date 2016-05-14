//
//  TextView.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/14.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class TextView: UIView, UITextViewDelegate {

    class Property {
        var defaultText: String?
        var placeholder: String?
        var font: UIFont = UIFont.systemFontOfSize(20.0)
        var textColor: UIColor = UIColor.blackColor()
        var placeholderColor: UIColor = UIColor.grayscale(200)
        var alignment: NSTextAlignment = .Left
        var characterLimit: UInt?
    }
    
    private static let minHeight: CGFloat = 30.0
    
    private var _textView: UITextView!
    private var characterLimit: UInt?
    
    convenience init(width: CGFloat, property: Property = Property()) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), property: property)
    }
    
    init(frame: CGRect, property: Property = Property()) {
        super.init(frame: frame)
        
        self.characterLimit = property.characterLimit
        
        self._textView = UITextView()
        self._textView.font = property.font
        self._textView.textColor = property.textColor
        self._textView.textAlignment = property.alignment
        self._textView.text = property.defaultText
        self._textView.placeholder = property.placeholder
        self._textView.placeholderColor = property.placeholderColor
        self._textView.delegate = self
        
        self.addSubview(self._textView)
        self._textView.snp_makeConstraints { make in
            make.left.equalTo(self).offset(20.0)
            make.right.equalTo(self).offset(-20.0)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        self.snp_makeConstraints { make in
            make.width.equalTo(self.width)
            make.height.greaterThanOrEqualTo(TextView.minHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var text: String? {
        get { return self._textView.text }
        set { self._textView.text = newValue }
    }
    
    private var previousText = ""
    private var lastReplaceRange: NSRange!
    private var lastReplacementString = ""
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        self.previousText = textView.text
        self.lastReplaceRange = range
        self.lastReplacementString = text
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        guard let characterLimit = self.characterLimit where textView.markedTextRange == nil else {
            return
        }
        
        let maxLength = Int(characterLimit)
        
        if textView.text.characters.count > maxLength {
            let offset = maxLength - textView.text.characters.count
            let replacementString = (self.lastReplacementString as NSString).substringToIndex(self.lastReplacementString.characters.count + offset)
            let text = (previousText as NSString).stringByReplacingCharactersInRange(lastReplaceRange, withString: replacementString)
            let position = textView.positionFromPosition(textView.selectedTextRange!.start, offset: offset)!
            let selectedTextRange = textView.textRangeFromPosition(position, toPosition: position)
            
            textView.text = text
            textView.selectedTextRange = selectedTextRange
        }
        
        return
    }
    
}
