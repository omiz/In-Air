//
//  SliderTableViewCell.swift
//  In Air
//
//  Created by Omar Allaham on 4/10/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

class SliderTableViewCell: UITableViewCell {

   @IBOutlet weak var slider: UISlider!

    override func awakeFromNib() {
        super.awakeFromNib()
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
