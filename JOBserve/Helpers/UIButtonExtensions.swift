//
//  UIButtonExtensions.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 12/05/2022.
//

import UIKit

class UIButtonExtensions: UIButton {

    func flash() {
    let flash = CABasicAnimation(keyPath: "backgroundColor")
    flash.duration = 0.2
    flash.toValue = UIColor(white: 1, alpha: 0.5).cgColor
    flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    flash.autoreverses = true
    layer.add(flash, forKey: nil)
    }
    
    func pulsate() {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.4
    pulse.fromValue = 0.98
    pulse.toValue = 1.0
    pulse.autoreverses = true
    pulse.repeatCount = 1
    pulse.initialVelocity = 0.5
    pulse.damping = 1.0
    layer.add(pulse, forKey: nil)
    }

}
