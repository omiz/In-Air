//
//  Player.swift
//  Clouds
//
//  Created by Omar Allaham on 3/17/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import Foundation
import AVFoundation

protocol PlayerDelegate {

   func player(stateChanged state: PlayerState)
}

enum PlayerState: Int {
   case playing = 0
   case paused
   case stopped
}

class Player: NSObject {

   enum Notifications: String, NotificationName {
      case stateChanged

      case airportChanged
      case musicChanged
   }

   static var shared = Player()

   var airportPlayer: AVPlayer
   var musicplayer: AVPlayer

   //TODO: move the airport base link to the server
   let airportUrl = "http://mtl2.liveatc.net/"

   let session = AVAudioSession.sharedInstance()

   var state: PlayerState = .stopped {
      didSet {
         delegate?.player(stateChanged: state)

         if state != oldValue {
            NotificationCenter.default.post(name: Notifications.stateChanged.name, object: state)
         }
      }
   }

   var isMusicEnabled = Settings.shared.playMusic {
      didSet {
         guard !isMusicEnabled else {
            return
         }

         pauseMusic()
      }
   }

   var delegate: PlayerDelegate?

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
      return airportPlayer.isPlaying || musicplayer.isPlaying
   }

   var shouldPlayInBackground: Bool {
      get {
         return UserDefaults.standard.bool(forKey: #keyPath(shouldPlayInBackground))
      }
      set {
         UserDefaults.standard.set(newValue, forKey: #keyPath(shouldPlayInBackground))
         UserDefaults.standard.synchronize()
      }
   }

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

      airportPlayer.volume = Settings.shared.airportVolume
      musicplayer.volume = Settings.shared.musicVolume

      setupGeneralObserver()
   }

   override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

      guard keyPath == #keyPath(AVPlayer.rate) else { return }

      guard context == &airportPlayer || context == &musicplayer else { return }

      print(airportPlayer.error ?? "")
      print(musicplayer.error ?? "")

      state = isPlaying ? .playing : .paused
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

   func setupGeneralObserver() {
      NotificationCenter.default.addObserver(forName: NSNotification.Name.airportVolumeChanged, object: nil, queue: .current) {
         self.airportPlayer.volume = $0.object as? Float ?? 0.5
      }

      NotificationCenter.default.addObserver(forName: NSNotification.Name.musicVolumeChanged, object: nil, queue: .current) {
         self.musicplayer.volume = $0.object as? Float ?? 0.5
      }

      NotificationCenter.default.addObserver(forName: NSNotification.Name.playMusicChanged, object: nil, queue: .current) {
         self.isMusicEnabled = $0.object as? Bool ?? true


      }
   }

   func play() {
      pause()
      let category = shouldPlayInBackground ? AVAudioSessionCategoryPlayback : AVAudioSessionCategorySoloAmbient
      try? session.setCategory(category, with: .mixWithOthers)
      try? session.setActive(true)

      playAirport()
      playMusic()
   }

   func playAirport() {
      setupAirport()
      airportPlayer.play()
   }

   func playMusic() {
      guard isMusicEnabled else {
         return
      }

      setupMusic()
      musicplayer.play()
   }

   func pause() {
      guard isPlaying else {
         return
      }
      
      pauseAirport()
      pauseMusic()

      try? session.setActive(false, with: .notifyOthersOnDeactivation)
   }

   func pauseAirport() {
      guard airportPlayer.isPlaying else {
         return
      }

      airportPlayer.pause()
      airportPlayer.replaceCurrentItem(with: nil)
   }

   func pauseMusic() {
      guard musicplayer.isPlaying else {
         return
      }

      musicplayer.pause()
      musicplayer.replaceCurrentItem(with: nil)
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
