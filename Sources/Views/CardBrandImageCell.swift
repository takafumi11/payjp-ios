//
//  CardBrandImageCell.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/21.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

class CardBrandImageCell: UICollectionViewCell {
    
    @IBOutlet weak var brandImage: UIImageView!
    
    func setup(brand: CardBrand) {
        brandImage.image = brand.logoResourceName.image
    }
}
