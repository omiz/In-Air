//
//  UIColor.swift
//  In Air
//
//  Created by Omar Allaham on 3/30/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

extension UIColor {

   var coreImageColor: CIColor {
      return CIColor(color: self)
   }
   var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
      let coreImageColor = self.coreImageColor
      return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
   }

   convenience init(hexString:String) {
      let hexString:String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
      let scanner            = Scanner(string: hexString)

      if (hexString.hasPrefix("#")) {
         scanner.scanLocation = 1
      }

      var color:UInt32 = 0
      scanner.scanHexInt32(&color)

      let mask = 0x000000FF
      let r = Int(color >> 16) & mask
      let g = Int(color >> 8) & mask
      let b = Int(color) & mask

      let red   = CGFloat(r) / 255.0
      let green = CGFloat(g) / 255.0
      let blue  = CGFloat(b) / 255.0

      self.init(red:red, green:green, blue:blue, alpha:1)
   }

   static func between(first: UIColor, second: UIColor, percent: CGFloat) -> UIColor {

      let firstComponents = first.components
      let secondComponents = second.components

      let red = (secondComponents.red - firstComponents.red) * percent + firstComponents.red
      let green = (secondComponents.green - firstComponents.green) * percent + firstComponents.green
      let blue = (secondComponents.blue - firstComponents.blue) * percent + firstComponents.blue
      let alpha = (secondComponents.alpha - firstComponents.alpha) * percent + firstComponents.alpha

      return self.init(red:red, green:green, blue:blue, alpha:alpha)
   }
}
