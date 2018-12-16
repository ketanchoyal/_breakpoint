//
//  UserCell.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 17/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmaillabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(profileImage image : UIImage, email : String, isChecked : Bool) {
        userImage.image = image
        userEmaillabel.text = email
        checkImage.isHidden = !isChecked
    }

}
