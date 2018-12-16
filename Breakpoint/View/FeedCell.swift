//
//  FeedCell.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 16/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(profileImage : UIImage, email : String, content : String) {
        
        self.profileImage.image = profileImage
        emailLabel.text = email
        contentLabel.text = content
        
    }

}
