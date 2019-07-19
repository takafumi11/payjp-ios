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
    
    @IBOutlet private weak var cardNumberTitleLabel: UILabel!
    @IBOutlet private weak var expirationTitleLabel: UILabel!
    @IBOutlet private weak var cvcTitleLabel: UILabel!
    @IBOutlet private weak var cardHolderTitleLabel: UILabel!
    
    @IBOutlet private weak var cardNumberTextField: UITextField!
    @IBOutlet private weak var expirationTextField: UITextField!
    @IBOutlet private weak var cvcTextField: UITextField!
    @IBOutlet private weak var cardHolderTextField: UITextField!
    
    @IBOutlet private weak var ocrButton: UIButton!
    @IBOutlet private weak var cvcInformationButton: UIButton!
    
    private var contentView: UIView!
    
    // MARK:
    
    private let viewModel: CardFormViewViewModelType = CardFormViewViewModel()
    
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
        let bundle = Bundle(for: CardFormView.self)
        let nib = UINib(nibName: "CardFormView", bundle: bundle)
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
    
    // MARK: - Out bound actions
    
    var isValid: Bool = false
    func createToken(tenantId: String? = nil, completion: (Result<String, Error>) -> Void) {
        // TODO: ask the view model
    }
}
