//
//  AudioEqualizer.swift
//  In Air
//
//  Created by Omar Allaham on 3/26/17.
//  Copyright © 2017 Bemaxnet. All rights reserved.
//

import UIKit

class AudioEqualizer: UIView {

    @IBInspectable public var padding: CGFloat = 0

    @IBInspectable public var color: UIColor = UIColor.green

    @IBInspectable public var barCount: Int = 4

    @IBInspectable public var spacing: Int = 10

    @IBInspectable public var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                layer.speed = 1
                var animationRect = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(padding, padding, padding, padding))
                let minEdge = min(animationRect.width, animationRect.height)

                layer.sublayers = nil
                animationRect.size = CGSize(width: minEdge, height: minEdge)
                setUpAnimation(in: layer, size: animationRect.size, color: color)
                isHidden = false
            } else {
                isHidden = true
                layer.sublayers?.removeAll()
            }
        }
    }

    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let lineSize = size.width / CGFloat(barCount + 1)
        let x = (layer.bounds.size.width - lineSize * CGFloat(barCount)) / 2
        let y = (layer.bounds.size.height - size.height) / 2
        let duration: [CFTimeInterval] = [4.3, 2.5, 1.7, 3.1]
        let values = [0, 0.7, 0.4, 0.05, 0.95, 0.3, 0.9, 0.4, 0.15, 0.18, 0.75, 0.01]

        // Draw lines
        for i in 0 ..< barCount {
            let animation = CAKeyframeAnimation()

            animation.keyPath = "path"
            animation.isAdditive = true
            animation.values = []

            for j in 0 ..< values.count {
                let heightFactor = values[j]
                let height = size.height * CGFloat(heightFactor)
                let point = CGPoint(x: 0, y: size.height - height)
                let path = UIBezierPath(rect: CGRect(origin: point, size: CGSize(width: lineSize, height: height)))

                animation.values?.append(path.cgPath)
            }
            animation.duration = duration[i]
            animation.repeatCount = HUGE
            animation.isRemovedOnCompletion = false

            let pathSize = CGSize(width: lineSize, height: size.height)
            let line: CAShapeLayer = CAShapeLayer()

            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: pathSize.width, height: pathSize.height),
                                    cornerRadius: size.width / 2)

            line.fillColor = color.cgColor

            line.backgroundColor = nil
            line.path = path.cgPath
            line.frame = CGRect(x: 0, y: 0, width: pathSize.width, height: pathSize.height)

            let frame = CGRect(x: x + lineSize * CGFloat(i),
                               y: y,
                               width: lineSize,
                               height: size.height)

            line.frame = frame
            line.add(animation, forKey: "animation")
            layer.addSublayer(line)
        }
    }
}
