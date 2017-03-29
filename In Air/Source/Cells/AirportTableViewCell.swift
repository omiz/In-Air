//
//  AirportTableViewCell.swift
//  In Air
//
//  Created by Omar Allaham on 3/26/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

class AirportTableViewCell: UITableViewCell {

   @IBOutlet weak var containerView: UIView!
   @IBOutlet weak var titleLable: UILabel!
   @IBOutlet weak var statusLabel: UILabel!

   override func awakeFromNib() {
      super.awakeFromNib()

      setup()
   }

   override var isSelected: Bool {
      didSet {
         containerView.backgroundColor = isSelected ? UIColor.lightGray.withAlphaComponent(0.2) : .clear
      }
   }

   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      containerView.backgroundColor = selected ? UIColor.lightGray.withAlphaComponent(0.2) : .clear
   }

   override func setHighlighted(_ highlighted: Bool, animated: Bool) {
      super.setHighlighted(highlighted, animated: animated)

      containerView.backgroundColor = highlighted ? UIColor.lightGray.withAlphaComponent(0.5) : .clear
   }

   private func setup() {
      containerView.backgroundColor = .clear
      containerView.layer.cornerRadius = 6
      containerView.layer.masksToBounds = true
      titleLable.textColor = .white
      statusLabel.textColor = .gray

      statusLabel.text = ""
   }

   func setup(_ airport: Airport) {
      titleLable.text = airport.title
      statusLabel.text = airport.detail + (airport.isOnline ? "" : "Offline")
   }
}
