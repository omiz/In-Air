//
//  PlayerView.swift
//  In Air
//
//  Created by Omar Allaham on 3/26/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

class PlayerView: UIView {

    static var shared: PlayerView = UINib(nibName: "PlayerView", bundle: nil)
        .instantiate(withOwner: nil, options: nil)[0] as! PlayerView

    @IBOutlet weak var equalizer: AudioEqualizer!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    var height: CGFloat {
        return 75
    }

    var padding: CGFloat {
        return 8
    }

    var isPlaying:Bool = false {
        didSet {
            let image = UIImage(named: isPlaying ? "pause" : "play")?.with(color: UIColor.imageTint)
            button.setImage(image, for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        UIApplication.shared.delegate?.window??.addSubview(self)

        let inset = UIEdgeInsets.init(top: padding, left: padding, bottom: padding, right: padding)

        let frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - height, width: UIScreen.main.bounds.width, height: height)

        self.frame = UIEdgeInsetsInsetRect(frame, inset)

        layoutIfNeeded()

        layer.cornerRadius = 6

        backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)

        label.textColor = .white
        button.tintColor = .white

        equalizer.color = .white
        equalizer.isAnimating = true

        isPlaying = Player.shared.isPlaying
    }

    @IBAction func playToggle(_ sender: UIButton) {

        Player.shared.togglePlay()

        setPlaying(Player.shared.isPlaying)
    }

    func setPlaying(_ isPlaying: Bool) {
        self.isPlaying = isPlaying
        self.equalizer.isAnimating = isPlaying
    }

    func setup(_ airport: Airport) {
        label.text = airport.title
    }
}
