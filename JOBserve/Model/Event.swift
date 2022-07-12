//
//  Event.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 28/06/2022.
//

import Foundation
import UIKit

struct Event:Codable{
    var _id:String
    var name: String
    var description: String
    var dateEnded: String
    var dateInscription:String
    var location:String
    var status: String
    var review: [String]
    var participant: [String]
    var image:String
}
