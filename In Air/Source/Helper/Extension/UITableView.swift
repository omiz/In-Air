//
//  UITableView.swift
//  In Air
//
//  Created by Omar Allaham on 3/26/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

extension UITableView {

   func dynamicHeight() {
      self.rowHeight = UITableViewAutomaticDimension
      self.estimatedRowHeight = 44

      self.tableFooterView = UIView()
   }

   func dynamicHeader() {
      self.sectionHeaderHeight = UITableViewAutomaticDimension
      self.estimatedSectionHeaderHeight = 44
   }

   func dynamicFooter() {
      self.sectionFooterHeight = UITableViewAutomaticDimension
      self.estimatedSectionFooterHeight = 44
   }

   func register(_ type: UITableViewCell.Type) {
      let nib = UINib.init(nibName: "\(type.self)", bundle: nil)
      register(nib, forCellReuseIdentifier: "\(type.self)")
   }

   func cell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
      return dequeueReusableCell(withIdentifier: "\(type.self)", for: indexPath) as! T
   }
}
