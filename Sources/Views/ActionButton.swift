//
//  ActionButton.swift
//  PAYJP
//
//  Created by TADASHI on 2019/12/03.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import UIKit

@IBDesignable
class ActionButton: UIButton {
    
    @IBInspectable var normalBackgroundColor: UIColor = Style.Color.blue {
        didSet {
            if isEnabled {
                self.backgroundColor = normalBackgroundColor
            }
        }
    }
    @IBInspectable var disableBackgroundColor: UIColor = Style.Color.lightGray {
        didSet {
            if !isEnabled {
                self.backgroundColor = disableBackgroundColor
            }
        }
    }
    
    // MARK: - Super Class
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        initialize()
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = self.normalBackgroundColor
            } else {
                self.backgroundColor = self.disableBackgroundColor
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func initialize() {
        self.layer.cornerRadius = Style.Radius.large
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.white, for: .disabled)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        self.backgroundColor = (self.isEnabled) ? self.normalBackgroundColor : self.disableBackgroundColor
    }
}
