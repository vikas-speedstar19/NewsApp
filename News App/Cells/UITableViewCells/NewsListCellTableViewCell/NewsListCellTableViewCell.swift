//
//  NewsListCellTableViewCell.swift
//  News App
//
//  Created by monty on 27/02/21.
//

import UIKit

class NewsListCellTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var newsCoverImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    @IBOutlet weak var newsPublishLabel: UILabel!

    // MARK: - Cell Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
