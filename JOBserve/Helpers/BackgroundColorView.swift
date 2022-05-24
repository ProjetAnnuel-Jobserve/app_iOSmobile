//
//  BackgroundColorView.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 12/05/2022.
//

import Foundation
import UIKit

class BackgroundColorView: UIView{
    let firstColor = UIColor(red: 249/255, green: 200/255, blue: 35/255, alpha: 255/255).cgColor
    let secondColor = UIColor(red: 252/255, green: 80/255, blue: 110/255, alpha: 255/255).cgColor
    override open class var layerClass: AnyClass {
    return CAGradientLayer.classForCoder()
 }

 required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
     let gradientLayer = layer as! CAGradientLayer
     gradientLayer.colors = [firstColor, secondColor]
 }
}
