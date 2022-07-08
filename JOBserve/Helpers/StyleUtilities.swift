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
    
    static func buttonStyleNoPaticipation(_ button: UIButton){
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10.0
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 252/255, green: 80/255, blue: 110/255, alpha: 255/255).cgColor
        button.setTitle("JE NE PARTICIPE PLUS!", for: .normal)
        button.tintColor = UIColor(red: 252/255, green: 80/255, blue: 110/255, alpha: 255/255)
    }
    
    static func buttonStyleDisable(_ button: UIButton){
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10.0
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.setTitle("TERMINÉ", for: .normal)
        button.tintColor = UIColor.black
    }
    static func buttonStylePaticipation(_ button: UIButton){
        button.backgroundColor = UIColor(red: 252/255, green: 80/255, blue: 110/255, alpha: 255/255)
        button.layer.cornerRadius = 10.0
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 252/255, green: 80/255, blue: 110/255, alpha: 255/255).cgColor
        button.tintColor = .white
        button.setTitle("JE PARTICIPE !", for: .normal)
        button.tintColor = .white
    }
    static func roundView(_ view: UIView){
        view.layer.cornerRadius = 35
    }
    static func roundButton(_ button: UIButton){
        button.layer.cornerRadius = 25
    }
    static func circleButton(_ button: UIButton){
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
    }
    
    static func textField(_ textfield: UITextField,color: CGColor,placeholderColor:UIColor? = UIColor.white){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = color
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor!])
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
