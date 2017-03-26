//
//  Airport.swift
//  Clouds
//
//  Created by Omar Allaham on 3/16/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit
import ObjectMapper

class Airport: Mappable {

   var id: Int = -1

   var title: String = "Los Angeles"

   var detail: String = "DCA"

   var url: String = "http://mtl2.liveatc.net/DCA"

   var isOnline: Bool = true

   init() {}
   
   required init?(map: Map){

   }

   func mapping(map: Map) {
      id <- map["id"]
      title <- map["title"]
      detail <- map["detail"]
      url <- map["url"]
   }
}


func ==(lhs: Airport, rhs: Airport) -> Bool {
   return lhs.id == rhs.id
}
