//
//  UIView.swift
//  Clouds
//
//  Created by Omar Allaham on 3/19/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

extension UIView {

    class func load(fromNib nib: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nib,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }

   enum ShadowDirection: Int {
      case horizontal
      case vertical
   }

   func addShadow(_ direction: ShadowDirection = .vertical) {
      layer.shadowColor = UIColor.darkGray.cgColor
      layer.shadowOffset = CGSize(width: direction == .vertical ? 0 : -0.5, height: 0.5)
      layer.shadowOpacity = 0.2
      layer.shouldRasterize = false
      clipsToBounds = false
      layer.masksToBounds = false
   }
}
