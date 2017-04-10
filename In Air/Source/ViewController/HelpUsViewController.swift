//
//  HelpUsViewController.swift
//  In Air
//
//  Created by Omar Allaham on 4/10/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

class HelpUsViewController: UIViewController {

   @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

      title = "Help us"

        label.text = "This app will always be free and without ads.\nBut to keep going we need your help"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
