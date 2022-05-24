//
//  topicCVC.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 12/05/2022.
//

import UIKit

class topicCVC: UICollectionViewCell {

    @IBOutlet weak var topicTitleLabel: UILabel!
    @IBOutlet weak var topicImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
        // Initialization code
    }
    
    func setUp(){
        //topicTitleLabel.text.layer.borderColor = UIColor.black.cgColor
    }
}
