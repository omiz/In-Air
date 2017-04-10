//
//  SettingsViewController.swift
//  In Air
//
//  Created by Omar Allaham on 4/5/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

   @IBOutlet weak var cellularData: UISwitch!
   @IBOutlet weak var airportVolume: ZSlider!
   @IBOutlet weak var stopIfOffline: UISwitch!
   @IBOutlet weak var showNearest: UISwitch!
   @IBOutlet weak var musicVolume: ZSlider!
   @IBOutlet weak var automaticalyDownload: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

      title = "Settings"

      prepare()
    }

   func prepare() {
      cellularData.isOn = Settings.shared.cellularData
      airportVolume.value = Settings.shared.airportVolume
      stopIfOffline.isOn = Settings.shared.stopIfOffline
      showNearest.isOn = Settings.shared.showNearest
      musicVolume.value = Settings.shared.musicVolume
      automaticalyDownload.isOn = Settings.shared.automaticalyDownload
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   @IBAction func cellularDataChanged(_ sender: UISwitch) {
      Settings.shared.cellularData = sender.isOn
   }

   @IBAction func airportVolumeChanged(_ sender: ZSlider) {
      Settings.shared.airportVolume = sender.value
   }

   @IBAction func stopIfOfflineChanged(_ sender: UISwitch) {
      Settings.shared.stopIfOffline = sender.isOn
   }

   @IBAction func showNearestChanged(_ sender: UISwitch) {
      Settings.shared.showNearest = sender.isOn
   }

   @IBAction func musicVolumeChanged(_ sender: ZSlider) {
      Settings.shared.musicVolume = sender.value
   }

   @IBAction func automaticallyDownloadChanged(_ sender: UISwitch) {
      Settings.shared.automaticalyDownload = sender.isOn
   }



}
