//
//  Settings.swift
//  In Air
//
//  Created by Omar Allaham on 4/5/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import Foundation

class Settings {

   static let shared = Settings()

   var cellularData: Bool {
      get {
         return UserDefaults.standard.bool(forKey: "cellularData")
      }
      set {
         UserDefaults.standard.set(newValue, forKey: "cellularData")
         UserDefaults.standard.synchronize()
         NotificationCenter.default.post(name: Notification.Name.cellularDataChanged, object: cellularData)
      }
   }

   var airportVolume: Float {
      get {
         return UserDefaults.standard.float(forKey: "airportVolume")
      }
      set {
         UserDefaults.standard.set(newValue, forKey: "airportVolume")
         UserDefaults.standard.synchronize()
         NotificationCenter.default.post(name: Notification.Name.airportVolumeChanged, object: airportVolume)
      }
   }

   var stopIfOffline: Bool {
      get {
         return UserDefaults.standard.bool(forKey: "stopIfOffline")
      }
      set {
         UserDefaults.standard.set(newValue, forKey: "stopIfOffline")
         UserDefaults.standard.synchronize()
         NotificationCenter.default.post(name: Notification.Name.stopIfOfflineChanged, object: airportVolume)
      }
   }

   var showNearest: Bool {
      get {
         return UserDefaults.standard.bool(forKey: "showNearest")
      }
      set {
         UserDefaults.standard.set(newValue, forKey: "showNearest")
         UserDefaults.standard.synchronize()
         NotificationCenter.default.post(name: Notification.Name.showNearestChanged, object: showNearest)
      }
   }

   var musicVolume: Float {
      get {
         return UserDefaults.standard.float(forKey: "musicVolume")
      }
      set {
         UserDefaults.standard.set(newValue, forKey: "musicVolume")
         UserDefaults.standard.synchronize()
         NotificationCenter.default.post(name: Notification.Name.musicVolumeChanged, object: musicVolume)
      }
   }

   var automaticalyDownload: Bool {
      get {
         return UserDefaults.standard.bool(forKey: "automaticalyDownload")
      }
      set {
         UserDefaults.standard.set(newValue, forKey: "automaticalyDownload")
         UserDefaults.standard.synchronize()
         NotificationCenter.default.post(name: Notification.Name.automaticalyDownloadChanged, object: automaticalyDownload)
      }
   }
}

extension Notification.Name {
   static let cellularDataChanged = Notification.Name("cellularDataChanged")
   static let airportVolumeChanged = Notification.Name("airportVolumeChanged")
   static let stopIfOfflineChanged = Notification.Name("stopIfOfflineChanged")
   static let showNearestChanged = Notification.Name("showNearestChanged")
   static let musicVolumeChanged = Notification.Name("musicVolumeChanged")
   static let automaticalyDownloadChanged = Notification.Name("automaticalyDownloadChanged")
}
