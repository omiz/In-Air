//
//  ThemeManager.swift
//  Clouds
//
//  Created by Omar Allaham on 3/17/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

struct ThemeManager {

   static func apply() {

      let sharedApplication = UIApplication.shared
      sharedApplication.delegate?.window??.tintColor = UIColor.primary

      UINavigationBar.appearance().barTintColor = UIColor.background
      UINavigationBar.appearance().tintColor = UIColor.white
      UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.accent]
      UINavigationBar.appearance().isTranslucent = false

      UISwitch.appearance().onTintColor = UIColor.primary.withAlphaComponent(0.3)
      UISwitch.appearance().thumbTintColor = UIColor.primary

      UITableViewCell.appearance().tintColor = UIColor.primary
      let bgColorView = UIView()
      bgColorView.backgroundColor = UIColor.primary.withAlphaComponent(0.6)
      UITableViewCell.appearance().selectedBackgroundView = bgColorView

      UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -80.0), for: .default)

//      UIView.appearance().backgroundColor = .clear

      UITableView.appearance().backgroundColor = .clear

      UITableViewCell.appearance().backgroundColor = .clear

      UICollectionViewCell.appearance().backgroundColor = .clear

      UICollectionView.appearance().backgroundColor = .clear

//      UILabel.appearance().textColor = .text
   }
}
