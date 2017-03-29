//
//  AirportPreviewViewController.swift
//  In Air
//
//  Created by Omar Allaham on 3/29/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

class AirportPreviewViewController: UIViewController {

   @IBOutlet weak var label: UILabel!
   
   @IBOutlet weak var cityLabel: UILabel!
   
   @IBOutlet weak var windDirectionLabel: UILabel!
   @IBOutlet weak var windSpeedLabel: UILabel!
   @IBOutlet weak var pressureLabel: UILabel!
   @IBOutlet weak var visibilityLabel: UILabel!

   var airport: Airport?

   class var instance: AirportPreviewViewController {
      return AirportPreviewViewController(nibName: "AirportPreviewViewController", bundle: nil)
   }

    override func viewDidLoad() {
        super.viewDidLoad()

      setup()

      WeatherManager.shared.forecast(for: airport?.title ?? "") {forecast,error in

         guard let forecast = forecast else {
            return
         }

         self.cityLabel.text = "\(forecast.city ?? ""),\(forecast.region ?? ""),\(forecast.country ?? "")"

         self.windDirectionLabel.text = "wind: \(forecast.windDirection) ˚"
         self.windSpeedLabel.text = "speed: \(forecast.windSpeed) \(forecast.speedUnit ?? "")"
         self.pressureLabel.text = "pressure: \(forecast.pressure) \(forecast.pressureUnit ?? "")"
         self.visibilityLabel.text = "visibility: \(forecast.visibility) \(forecast.distanceUnit ?? "")"
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func setup() {
      label.textColor = .white
      cityLabel.textColor = .white
      windDirectionLabel.textColor = .white
      windSpeedLabel.textColor = .white
      pressureLabel.textColor = .white
      visibilityLabel.textColor = .white
   }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

   @available(iOS 9.0, *)
   override var previewActionItems: [UIPreviewActionItem] {
//
//      let isPlaying = Player.shared.airport == airport && Player.shared.isPlaying
//      let likeAction = UIPreviewAction(title: isPlaying ? "Stop" : "Play", style: .default) { (action, viewController) -> Void in
//         if isPlaying {
//            Player.shared.pause()
//         } else {
//            Player.shared.airport = self.airport
//            Player.shared.play()
//         }
//      }

      let action = UIPreviewAction(title: "Done", style: .default) { (_, _) -> Void in }

      return [action]
   }
}
