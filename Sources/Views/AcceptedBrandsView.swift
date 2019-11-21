//
//  AcceptedBrandsView.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/21.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

//@objc(PAYAcceptedBrandsView)
class AcceptedBrandsView: UIView {
    
    @IBOutlet weak var brandsView: UICollectionView!
    
    private var contentView: UIView!
    
//    public var cardBrands: [CardBrand]? = nil {
//        didSet {
//            brandsView.reloadData()
//        }
//    }
    
    public var cardBrands: [CardBrand]?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override public var intrinsicContentSize: CGSize {
        return contentView.intrinsicContentSize
    }

    private func initialize() {
        let bundle = Bundle(for: AcceptedBrandsView.self)
        print(bundle)
        let nib = UINib(nibName: "AcceptedBrandsView", bundle: bundle)
        print(nib)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView

        if let view = view {
            contentView = view
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }

        brandsView.dataSource = self
        brandsView.register(UINib(nibName: "CardBrandImageCell", bundle: nil), forCellWithReuseIdentifier: "CardBrandImageCell")
    }
}

extension AcceptedBrandsView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cardBrands?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardBrandImageCell", for: indexPath)
        
        if let cell = cell as? CardBrandImageCell {
            if let brand = cardBrands?[indexPath.row] {
                cell.setup(brand: brand)
            }
        }
        return cell
    }
}
