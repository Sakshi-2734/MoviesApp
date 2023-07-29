//
//  SearchTableViewCell.swift
//  MoviesApp
//
//  Created by Sakshi Sharma on 2023-07-29.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var moviePoster: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imdbRatingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
