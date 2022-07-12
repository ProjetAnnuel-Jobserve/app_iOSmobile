//
//  AvisTableViewCell.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 11/07/2022.
//

import UIKit

class AvisTableViewCell: UITableViewCell {

    @IBOutlet weak var avisView: UIView!
    @IBOutlet weak var avislabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupV()
    }
    func setupV(){
        
        avisView.layer.shadowRadius = 5
        avisView.layer.shadowOpacity = 0.30
        avisView.layer.cornerRadius = 16
    }
    
}
