//
//  topicsSendedTableViewCell.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 14/07/2022.
//

import UIKit

class topicsSendedTableViewCell: UITableViewCell {

    @IBOutlet weak var topicView: UIView!
    @IBOutlet weak var titleTopicLbl: UILabel!
    @IBOutlet weak var statutLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupV()
        // Configure the view for the selected state
    }
    
    func setupV(){
        
        topicView.layer.shadowRadius = 5
        topicView.layer.shadowOpacity = 0.30
        topicView.layer.cornerRadius = 16
    }
}
