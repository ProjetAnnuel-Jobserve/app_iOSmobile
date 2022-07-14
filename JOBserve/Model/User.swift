//
//  User.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 28/06/2022.
//

import Foundation
import UIKit

struct User : Codable{
    var _id: String
    var firstname:String
    var lastname: String
    var location: String
    var birthDate: String
    var email:String
    var phoneNumber:String
    var job: String
    var permission: String
    var idFirebase:String
    var fk_company:String
}
