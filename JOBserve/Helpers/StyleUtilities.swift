//
//  RoundedButton.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 12/05/2022.
//

import Foundation
import UIKit

class StyleUtilities{
    
    static func sign(_ button: UIButton){
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10.0
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    static func roundView(_ view: UIView){
        view.layer.cornerRadius = 35
    }
    
    static func textField(_ textfield: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.white.cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    static func borderColor(_ textView:UITextView ){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textView.frame.height - 2, width: textView.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.white.cgColor
        textView.layer.addSublayer(bottomLine)
    }
    /* sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

         UIView.animate(withDuration: 2.0,
                                    delay: 0,
                                    usingSpringWithDamping: CGFloat(0.20),
                                    initialSpringVelocity: CGFloat(6.0),
                                    options: UIView.AnimationOptions.allowUserInteraction,
                                    animations: {
                                     sender.transform = CGAffineTransform.identity
             },
                                    completion: { Void in()  }
         )*/
    
    
    
}
