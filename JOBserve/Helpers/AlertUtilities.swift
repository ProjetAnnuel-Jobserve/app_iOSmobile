//
//  AlertUtilities.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 12/05/2022.
//

import Foundation
import UIKit

class AlertUtilities{
    
    static func displayAlert(_ title: String,_ message: String,VC: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        VC.present(alert, animated: true, completion: nil)
    }
    
}
