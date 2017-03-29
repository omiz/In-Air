//
//  UIViewController.swift
//  Clouds
//
//  Created by Omar Allaham on 3/19/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit
import TextAttributes

extension UIViewController {

   func setAttributedTitle(_ title: String?) {
      let label = UILabel()

      let title = title?.uppercased()

      label.attributedText = NSAttributedString(string: title ?? "", attributes: titleAttribute)

      label.sizeToFit()

      navigationItem.titleView = label
   }

   var titleAttribute: TextAttributes {
      return TextAttributes()
         .font(name: "Modern Sans", size: 20)
         .foregroundColor(Color.white)
//         .lineHeightMultiple(1.5)
   }
}
