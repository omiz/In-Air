//
//  General.swift
//  In Air
//
//  Created by Omar Allaham on 3/26/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import Foundation

func delay(_ seconds: Double, closure: @escaping () -> Void) {
   let delayTime = DispatchTime.now() + Double(Int64(Double(seconds) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
   DispatchQueue.main.asyncAfter(deadline: delayTime) {
      closure()
   }
}
