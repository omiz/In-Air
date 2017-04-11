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

   @objc var cellularData: Bool {
      get {
         guard let _ = UserDefaults.standard.object(forKey: #keyPath(cellularData)) else { return false }

         return UserDefaults.standard.bool(forKey: #keyPath(cellularData))
      }
      set {
         UserDefaults.standard.set(newValue, forKey: #keyPath(cellularData))
         UserDefaults.standard.synchronize()
         NotificationCenter.default.post(name: Notification.Name.cellularDataChanged, object: cellularData)
      }
   }

   @objc var airportVolume: Float {
      get {
         guard let _ = UserDefaults.standard.object(forKey: #keyPath(airportVolume)) else { return 0.4 }

         return UserDefaults.standard.float(forKey: #keyPath(airportVolume))
      }
      set {
         UserDefaults.standard.set(newValue, forKey: #keyPath(airportVolume))
         UserDefaults.standard.synchronize()
         NotificationCenter.default.post(name: Notification.Name.airportVolumeChanged, object: airportVolume)
      }
   }

   @objc var stopIfOffline: Bool {
      get {
         guard let _ = UserDefaults.standard.object(forKey: #keyPath(stopIfOffline)) else { return false }

         return UserDefaults.standard.bool(forKey: #keyPath(stopIfOffline))
      }
      set {
         UserDefaults.standard.set(newValue, forKey: #keyPath(stopIfOffline))
         UserDefaults.standard.synchronize()
         NotificationCenter.default.post(name: Notification.Name.stopIfOfflineChanged, object: stopIfOffline)
      }
   }

   @objc var showNearest: Bool {
      get {
         guard let _ = UserDefaults.standard.object(forKey: #keyPath(showNearest)) else { return true }

         return UserDefaults.standard.bool(forKey: #keyPath(showNearest))
      }
      set {
         UserDefaults.standard.set(newValue, forKey: #keyPath(showNearest))
         UserDefaults.standard.synchronize()
         NotificationCenter.default.post(name: Notification.Name.showNearestChanged, object: showNearest)
      }
   }

   @objc var musicVolume: Float {
      get {
         guard let _ = UserDefaults.standard.object(forKey: #keyPath(musicVolume)) else { return 0.4 }

         return UserDefaults.standard.float(forKey: #keyPath(musicVolume))
      }
      set {
         UserDefaults.standard.set(newValue, forKey: #keyPath(musicVolume))
         UserDefaults.standard.synchronize()
         NotificationCenter.default.post(name: Notification.Name.musicVolumeChanged, object: musicVolume)
      }
   }

   @objc var playMusic: Bool {
      get {
         guard let _ = UserDefaults.standard.object(forKey: #keyPath(playMusic)) else { return true }

         return UserDefaults.standard.bool(forKey: #keyPath(playMusic))
      }
      set {
         UserDefaults.standard.set(newValue, forKey: #keyPath(playMusic))
         UserDefaults.standard.synchronize()
         NotificationCenter.default.post(name: Notification.Name.playMusicChanged, object: playMusic)
      }
   }

   @objc var automaticalyDownload: Bool {
      get {
         guard let _ = UserDefaults.standard.object(forKey: #keyPath(automaticalyDownload)) else { return false }

         return UserDefaults.standard.bool(forKey: #keyPath(automaticalyDownload))
      }
      set {
         UserDefaults.standard.set(newValue, forKey: #keyPath(automaticalyDownload))
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
   static let playMusicChanged = Notification.Name("playMusicChanged")
   static let automaticalyDownloadChanged = Notification.Name("automaticalyDownloadChanged")
}
