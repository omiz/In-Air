//
//  Continent.swift
//  Clouds
//
//  Created by Omar Allaham on 3/16/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

class Continent: Group {

   var id: Int = -1

   var title: String = "North America"

   var description: String = ""

    init(_ id: Int, title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }

    convenience init() {
        self.init(0, title: "", description: "")
    }
}
