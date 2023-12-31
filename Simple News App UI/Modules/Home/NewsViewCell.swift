//
//  NewsViewCell.swift
//  Simple News App UI
//
//  Created by Erlangga Ardiansyah on 21/06/23.
//

import UIKit

class NewsViewCell: UITableViewCell {

    @IBOutlet weak var titleLabelNews: UILabel!
    @IBOutlet weak var tagLabelNews: UILabel!
    @IBOutlet weak var thumbImages: UIImageView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
