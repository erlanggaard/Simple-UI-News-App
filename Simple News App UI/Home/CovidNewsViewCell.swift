//
//  CovidNewsViewCell.swift
//  Simple News App UI
//
//  Created by Erlangga Ardiansyah on 21/06/23.
//

import UIKit

class CovidNewsViewCell: UITableViewCell {

    @IBOutlet weak var covidLabelText: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
    }

}
