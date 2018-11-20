//
//  MainTableViewCell.swift
//  YouTubeWithautAdvertising
//
//  Created by Konstantin Chukhas on 11/18/18.
//  Copyright © 2018 Konstantin Chukhas. All rights reserved.
//

import UIKit
import YouTubePlayer

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var webViewYouTube: YouTubePlayerView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
