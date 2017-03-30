//
//  UserDefaults.swift
//  In Air
//
//  Created by Omar Allaham on 3/30/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import Foundation

extension UserDefaults {

   var isFirstStart: Bool {
      get {
         guard !bool(forKey: "hasBeenLaunched") else {
            return false
         }

         set(true, forKey: "hasBeenLaunched")
         synchronize()

         return true
      }
   }

   func object<T: NSCoding>(forKey defaultName: String, type: T.Type = T.self) -> T? {
      return object(forKey: defaultName) as? T
   }

}
