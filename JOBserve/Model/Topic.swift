//
//  Topics.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 12/05/2022.
//

import Foundation
import UIKit

struct Topic : Codable{
 
    var _id: String
    var name: String
    var image: String
    var description: String
    var dateEnded: String
    var status: String
    var userVoters: [String]
    var numberVoteNo: Int
    var numberVoteYes: Int
    var fk_userid:String?
}
