//
//  Event.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 28/06/2022.
//

import Foundation
import UIKit

struct Event:Codable{
    var name: String
    var type: String
    var description: String
    var dateEnded: String
    var dateInscription:String
    var status: String
    // ajouter review
    var review: [String]
    var image:String
}
    /*
     const EventSchema = new mongoose.Schema(
         {
             name: {
                 type: String,
             },
             type: {
                 type: String,
             },
             description: {
                 type: String,
             },
             dateEnded: {
                 type: Date,
             },
             status: {
                 type: String,
             },
             participant: {
                 type: Array
             },
             review: {
                 type: Array
             },
             image: {
                 type: String,
             },
         }
     );
     */
