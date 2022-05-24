//
//  Topics.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 12/05/2022.
//

import Foundation
import UIKit

/*struct Topic : Codable{
 
    var _id: String
    var title: String
    //var image: UIImage
    var description: String
    
}*/
class Topic{
    
    var _id: String
    var title: String
    var image: UIImage
    
    var description: String
    
    init(id: String, title: String, description: String, image:UIImage){
        self._id = id
        self.title = title
        self.description = description
        self.image = image
    }
    
}
