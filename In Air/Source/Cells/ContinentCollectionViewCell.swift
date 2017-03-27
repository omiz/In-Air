//
//  ContinentCollectionViewCell.swift
//  In Air
//
//  Created by Omar Allaham on 3/27/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

class ContinentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        label.textColor = .white
        backgroundColor = .clear
    }

    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? .black : .white
        }
    }
}
