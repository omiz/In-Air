//
//  UINavigationBar.swift
//  In Air
//
//  Created by Omar Allaham on 3/28/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

extension UINavigationBar {

   var shadowImageView: UIImageView? {
      return findShadowImage(under: self)
   }

   private func findShadowImage(under view: UIView) -> UIImageView? {
      if view is UIImageView && view.bounds.size.height <= 1 {
         return view as? UIImageView
      }

      for subview in view.subviews {
         if let imageView = findShadowImage(under: subview) {
            return imageView
         }
      }
      return nil
   }
}
