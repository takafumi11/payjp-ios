//
//  CardFormView.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/17.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import UIKit

@IBDesignable
public class CardFormView: UIView {
    
    private var contentView: UIView!
    
    // MARK: Lifecycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DescriptionFooterView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        
        if let view = view {
            contentView = view
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
        
        backgroundColor = .clear
    }
    
    override public var intrinsicContentSize: CGSize {
        return contentView.intrinsicContentSize
    }
}
