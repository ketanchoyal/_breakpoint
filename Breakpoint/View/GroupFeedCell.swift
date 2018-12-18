//
//  GroupFeedCell.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 18/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    public private(set) var messageId: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(profileImage : UIImage, userEmailLabel : String, contentLabel : String, messageId : String!) {
        self.profileImage.image = profileImage
        self.userEmailLabel.text = userEmailLabel
        self.contentLabel.text = contentLabel
        self.messageId = messageId
    }

}
