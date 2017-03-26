//
//  UIImage.swift
//  Clouds
//
//  Created by Omar Allaham on 3/19/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {

   func with(color: UIColor) -> UIImage {
      guard let cgImage = self.cgImage else {
         return self
      }
      UIGraphicsBeginImageContextWithOptions(size, false, scale)
      let context = UIGraphicsGetCurrentContext()!
      context.translateBy(x: 0, y: size.height)
      context.scaleBy(x: 1.0, y: -1.0)
      context.setBlendMode(.normal)
      let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
      context.clip(to: imageRect, mask: cgImage)
      color.setFill()
      context.fill(imageRect)
      let newImage = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext();
      return newImage
   }
}
