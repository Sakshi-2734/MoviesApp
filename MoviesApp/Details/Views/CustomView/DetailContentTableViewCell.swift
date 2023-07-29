//
//  DetailContentTableViewCell.swift
//  MoviesApp
//
//  Created by Sakshi Sharma on 2023-07-29.
//

import UIKit

class DetailContentTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
