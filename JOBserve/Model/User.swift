//
//  User.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 28/06/2022.
//

import Foundation
import UIKit

struct User : Codable{
    var firstname:String
    var lastname: String
    var address: String
    var city:String
    var zipcode: String
    var email:String
    var phoneNumber:String
}
