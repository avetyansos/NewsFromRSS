//
//  ArchivedNewsTableViewCell.swift
//  SmartClickAITest
//
//  Created by Sos Avetyan on 5/22/20.
//  Copyright © 2020 Sos Avetyan. All rights reserved.
//

import UIKit

class ArchivedNewsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var news: News? {
        didSet {
            self.titleLabel.text = news?.title
            guard let path = news?.localImageURL else {return}
            self.newsImageView.image = path.makeUIImage()
            guard let imageURL = path.imageURL() else {self.sizeLabel.text = "0 KB"; return }
            self.sizeLabel.text = "\((Double(imageURL.fileSize) / 1000.00).rounded()) KB"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
