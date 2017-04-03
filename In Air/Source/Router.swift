//
//  Router.swift
//  In Air
//
//  Created by Omar Allaham on 3/30/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

class Router {

   static func launch(in window: UIWindow?, with options: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

      //if an animation needed check window.rootViewController

//      let firstStart = UserDefaults.standard.isFirstStart

//      let controller = firstStart ? IntroViewController.instance : MainViewController.instance

      set(UINavigationController(rootViewController: MainViewController.instance))

      PlayerView.shared.prepare()

      return true
   }

   static func set(_ distination: UIViewController,
                       with sourceViewContoller: UIViewController? = nil,
                       in window: UIWindow? = nil) {

      let window = window ?? AppDelegate.shared.window

      let sourceViewContoller = sourceViewContoller ?? window?.rootViewController

      distination.view.alpha = 0

      UIView.animate(withDuration: 0.2) {
         sourceViewContoller?.view.alpha = 0
         distination.view.alpha = 1
         window?.rootViewController = distination
         window?.makeKeyAndVisible()
      }
   }
}
