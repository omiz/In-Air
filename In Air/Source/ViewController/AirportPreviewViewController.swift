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

   var airport: Airport?

   class var instance: AirportPreviewViewController {
      return AirportPreviewViewController(nibName: "AirportPreviewViewController", bundle: nil)
   }

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = airport?.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

      let isPlaying = Player.shared.airport == airport && Player.shared.isPlaying
      let likeAction = UIPreviewAction(title: isPlaying ? "Stop" : "Play", style: .default) { (action, viewController) -> Void in
         if isPlaying {
            Player.shared.pause()
         } else {
            Player.shared.airport = self.airport
            Player.shared.play()
         }
      }

      let deleteAction = UIPreviewAction(title: "Delete", style: .destructive) { (action, viewController) -> Void in
         print("You deleted the photo")
      }

      return [likeAction, deleteAction]
   }
}
