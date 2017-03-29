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

            if isPlaying {
                show()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        observeNotification()

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

    func prepare() {
        self.alpha = 0
    }

    func show() {
        if superview == nil {
            UIApplication.shared.delegate?.window??.addSubview(self)
        }

        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.5, animations: { 
            self.alpha = 0
        }) { finished in
            if finished {
                self.removeFromSuperview()
            }
        }
    }

    func observeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(stateChanged(_:)),
            name: Player.Notifications.stateChanged.name,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(airportChanged(_:)),
            name: Player.Notifications.airportChanged.name,
            object: nil)

    }

    func stateChanged(_ notification: Notification) {
        setPlaying(Player.shared.isPlaying)
    }

    func airportChanged(_ notification: Notification) {
        let airport = notification.object as? Airport
        setup(airport)
    }

    @IBAction func playToggle(_ sender: UIButton) {

        Player.shared.togglePlay()
    }

    func setPlaying(_ isPlaying: Bool) {
        self.isPlaying = isPlaying
        self.equalizer.isAnimating = isPlaying
    }

    func setup(_ airport: Airport?) {
        label.text = airport?.title ?? ""
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
