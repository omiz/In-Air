//
//  Notification.swift
//  In Air
//
//  Created by Omar Allaham on 3/27/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import Foundation

protocol NotificationName {
    var name: Notification.Name { get }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}
