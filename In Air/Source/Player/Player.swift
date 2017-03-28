//
//  Player.swift
//  Clouds
//
//  Created by Omar Allaham on 3/17/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import Foundation
import AVFoundation

enum PlayerType {
   case airport
   case music
   case all
}

protocol PlayerDelegate {

   func player(stateChanged state: PlayerState)
}

enum PlayerState: Int {
   case playing = 0
   case paused
   case stopped
}

class Player: NSObject {

   //TODO: move the airport base link to the server
   let airportUrl = "http://mtl2.liveatc.net/"

   let session = AVAudioSession.sharedInstance()

   var state: PlayerState = .stopped {
      didSet {
         delegate?.player(stateChanged: state)

         if state != oldValue {
            NotificationCenter.default.post(name: Notifications.stateChanged.name, object: state)
         }

         if state == .stopped {
            try? session.setActive(false)
         }
      }
   }

   var airportVolume: Float{
      get {
         return airportPlayer.volume
      }
      set {
         airportPlayer.volume = newValue
      }
   }

   var musicVolume: Float {
      get {
         return musicplayer.volume
      }
      set {
         musicplayer.volume = newValue
      }
   }

   enum Notifications: String, NotificationName {
      case stateChanged

      case airportChanged
      case musicChanged
   }

   var airportPlayer: AVPlayer
   var musicplayer: AVPlayer

   var delegate: PlayerDelegate?

   override init() {
      airportPlayer = AVPlayer()
      musicplayer = AVPlayer()

      super.init()

      commonInit()
   }

   func commonInit() {
      airportPlayer.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: .new, context: &airportPlayer)
      airportPlayer.addObserver(self, forKeyPath: #keyPath(AVPlayer.error), options: .new, context: &airportPlayer)
      musicplayer.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: .new, context: &musicplayer)

      //TODO: load music from the server as a list
      music = Music()

      airportVolume = 0.7
      musicVolume = 1
   }

   override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

      guard keyPath == #keyPath(AVPlayer.rate) else { return }

      guard context == &airportPlayer || context == &musicplayer else { return }

      print(airportPlayer.error ?? "")
      print(musicplayer.error ?? "")

      let airPlaying = airportPlayer.isPlaying

      let musicPlaying = musicplayer.isPlaying

      state = airPlaying || musicPlaying ? .playing : .paused
   }

   class var shared : Player {
      struct Static {
         static let instance : Player = Player()
      }
      return Static.instance
   }

   var airport: Airport? {
      didSet {
         if airport != oldValue {
            setupAirport()
            NotificationCenter.default.post(name: Notifications.airportChanged.name, object: airport)
         }
      }
   }

   //TODO: convert music object to a list
   var music: Music? {
      didSet {
         if music != oldValue {
            setupMusic()
            NotificationCenter.default.post(name: Notifications.musicChanged.name, object: music)
         }
      }
   }

   var isPlaying: Bool {
      return airportPlayer.rate != 0 || musicplayer.rate != 0
   }

   func setupAirport() {
      guard let value = airport else { return }
      guard let url = URL(string: airportUrl + value.url) else { return }

      let airportItem = AVPlayerItem(url: url)
      airportPlayer.replaceCurrentItem(with: airportItem)
   }

   func setupMusic() {
      guard let value = music else { return }
      guard let url = URL(string: value.url) else { return }

      let airportItem = AVPlayerItem(url: url)

      NotificationCenter.default.addObserver(
         self,
         selector: #selector(musicDidFinishPlaying(_:)),
         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
         object: airportItem)

      musicplayer.replaceCurrentItem(with: airportItem)
   }

   func play(_ type: PlayerType = .all) {
      pause()
      try? session.setCategory(AVAudioSessionCategoryAmbient)
      try? session.setActive(true, with: .notifyOthersOnDeactivation)

      switch type {
      case .airport:
         setupAirport()
         airportPlayer.play()
      case .music:
         setupMusic()
         musicplayer.play()
      default:
         setupAirport()
         setupMusic()
         musicplayer.play()
         airportPlayer.play()
      }
   }

   func pause(_ type: PlayerType = .all) {
      switch type {
      case .airport:
         airportPlayer.pause()
         airportPlayer.replaceCurrentItem(with: nil)
      case .music:
         musicplayer.pause()
         musicplayer.replaceCurrentItem(with: nil)
      default:
         airportPlayer.pause()
         musicplayer.pause()

         airportPlayer.replaceCurrentItem(with: nil)
         musicplayer.replaceCurrentItem(with: nil)
      }

      try? session.setActive(false)
   }

   func togglePlay() {
      if isPlaying {
         pause()
      } else {
         play()
      }
   }

   func musicDidFinishPlaying(_ notification: Notification) {
      musicplayer.seek(to: kCMTimeZero)
      musicplayer.play()
   }

   deinit {
      NotificationCenter.default.removeObserver(self)
      NotificationCenter.default.removeObserver(musicplayer)
   }
}

extension AVPlayer {
   var isPlaying: Bool {
      return rate != 0 && error == nil
   }
}
