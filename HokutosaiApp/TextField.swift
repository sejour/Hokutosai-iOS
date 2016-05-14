//
//  TextField.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/14.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

protocol TextFieldDelegate: class {
    
    func textDidChange(text: String?, lenght: Int?)
    
}

class TextField: UIView, UITextFieldDelegate {
    
    class Property {
        var defaultText: String?
        var placeholder: String?
        var font: UIFont = UIFont.systemFontOfSize(20.0)
        var textColor: UIColor = UIColor.blackColor()
        var alignment: NSTextAlignment = .Left
        var characterLimit: UInt?
    }
    
    private static let viewHeight: CGFloat = 22.0
    
    private var _textField: UITextField!
    private var characterLimit: UInt?

    weak var delegate: TextFieldDelegate?
    
    convenience init(width: CGFloat, property: Property = Property()) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), property: property)
    }
    
    init(frame: CGRect, property: Property = Property()) {
        super.init(frame: frame)
        
        self.characterLimit = property.characterLimit
        
        self._textField = UITextField()
        self._textField.font = property.font
        self._textField.textColor = property.textColor
        self._textField.textAlignment = property.alignment
        self._textField.text = property.defaultText
        self._textField.placeholder = property.placeholder
        self._textField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TextField.textFieldDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: self._textField)
        
        self.addSubview(self._textField)
        self._textField.snp_makeConstraints { make in
            make.left.equalTo(self).offset(20.0)
            make.right.equalTo(self).offset(-20.0)
            make.top.equalTo(self)
            make.height.equalTo(TextField.viewHeight)
        }
        
        self.snp_makeConstraints { make in
            make.width.equalTo(self.width)
            make.height.equalTo(TextField.viewHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var text: String? {
        get { return self._textField.text }
        set { self._textField.text = newValue }
    }
    
    private var previousText = ""
    private var lastReplaceRange: NSRange!
    private var lastReplacementString = ""
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.previousText = textField.text!
        self.lastReplaceRange = range
        self.lastReplacementString = string
        
        return true
    }
    
    func textFieldDidChange(notification: NSNotification) {
        guard let textField = notification.object as? UITextField else { return }
        
        guard let characterLimit = self.characterLimit where textField.markedTextRange == nil else {
            self.delegate?.textDidChange(textField.text, lenght: textField.text?.characters.count)
            return
        }
        
        let maxLength = Int(characterLimit)
        
        if textField.text!.characters.count > maxLength {
            let offset = maxLength - textField.text!.characters.count
            let replacementString = (self.lastReplacementString as NSString).substringToIndex(self.lastReplacementString.characters.count + offset)
            let text = (previousText as NSString).stringByReplacingCharactersInRange(lastReplaceRange, withString: replacementString)
            let position = textField.positionFromPosition(textField.selectedTextRange!.start, offset: offset)!
            let selectedTextRange = textField.textRangeFromPosition(position, toPosition: position)
            
            textField.text = text
            textField.selectedTextRange = selectedTextRange
        }
        
        self.delegate?.textDidChange(textField.text, lenght: textField.text?.characters.count)
        
        return
    }

}
