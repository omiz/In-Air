//
//  Colors.swift
//  Clouds
//
//  Created by Omar Allaham on 3/16/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

class Colors: NSObject {

   var dict: NSDictionary

   class var colorKey : String {
      get {
         var key: String
         if let stored = UserDefaults.standard.string(forKey: "colorKey"){
            key = stored
         } else {
            key = "default"
         }
         return key
      }
      set(value) {
         UserDefaults.standard.set(value, forKey: "colorKey")
      }
   }

   override init() {
      let path = Bundle.main.path(forResource: "Colors", ofType: "plist")

      assert(path != nil, "Colors file is missing. Please provide 'Colors.plist'")

      let temp = NSDictionary(contentsOfFile: path!)!
      dict = temp[Colors.colorKey] as! NSDictionary
   }

   class var main : Colors {
      struct Static {
         static let instance : Colors = Colors()
      }
      return Static.instance
   }
}


extension UIColor {
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
}

extension UIColor {
   class var primary: UIColor  {
      return UIColor(hexString: Colors.main.dict["primary"] as! String)
   }

   class var primaryDark: UIColor  {
      return UIColor(hexString: Colors.main.dict["primaryDark"] as! String)
   }

   class var accent: UIColor  {
      return UIColor(hexString: Colors.main.dict["accent"] as! String)
   }

   class var text: UIColor  {
      return UIColor(hexString: Colors.main.dict["text"] as! String)
   }

   class var imageTint: UIColor  {
      return UIColor(hexString: Colors.main.dict["imageTint"] as! String)
   }

   class var background: UIColor  {
      return UIColor(hexString: Colors.main.dict["background"] as! String)
   }
}
