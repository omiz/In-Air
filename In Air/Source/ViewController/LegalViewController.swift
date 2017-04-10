//
//  LegalViewController.swift
//  In Air
//
//  Created by Omar Allaham on 4/10/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

class LegalViewController: UIViewController {

   @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Legal"

      textView.attributedText = loadRTF(from: "Legal")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func loadRTF(from resource: String) -> NSAttributedString? {
      guard let url = Bundle.main.url(forResource: resource, withExtension: "rtf") else { return nil }

      guard let data = try? Data(contentsOf: url) else { return nil }

      return try? NSAttributedString(data: data,
                                     options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType],
                                     documentAttributes: nil)
   }
}
