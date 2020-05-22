//
//  NewsTableViewCell.swift
//  SmartClickAITest
//
//  Created by Sos Avetyan on 5/21/20.
//  Copyright © 2020 Sos Avetyan. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdAtLabl: UILabel!
    
    var news:News! {
        didSet {
            newsImage.downloaded(from: news.StoryImage)
            self.titleLabel.text = news.title
            self.createdAtLabl.text = news.updatedAt
        }
    }
    
    func highLightBackground() {
        self.backgroundView?.backgroundColor = UIColor.lightGray
    }
    
    func removeHighlight() {
        self.backgroundView?.backgroundColor = UIColor.white
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
