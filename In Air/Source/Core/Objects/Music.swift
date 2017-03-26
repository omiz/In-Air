//
//  Music.swift
//  Clouds
//
//  Created by Omar Allaham on 3/16/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

class Music {

   var id: Int = -1

   var title: String = ""

   var description: String = ""

   var url: String = "https://freemusicarchive.org/music/download/31711f77f3682a5c1f426284df9796c718134d5a"
}

func ==(lhs: Music, rhs: Music) -> Bool {
    return lhs.id == rhs.id
}

func ==(lhs: Music?, rhs: Music?) -> Bool {
    return lhs?.id == rhs?.id
}

func !=(lhs: Music, rhs: Music) -> Bool {
    return !(lhs.id == rhs.id)
}

func !=(lhs: Music?, rhs: Music?) -> Bool {
    return !(lhs?.id == rhs?.id)
}
