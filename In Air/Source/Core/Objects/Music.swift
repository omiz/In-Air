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

   var url: String = "http://media.dartmouth.edu/~healthed/metallophone_peace.mp3"
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
