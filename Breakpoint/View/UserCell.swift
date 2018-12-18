//
//  UserCell.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 17/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    var showing : Bool = false

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmaillabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    public private(set) var userId: String!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            showing = !showing
            checkImage.isHidden = !showing
//            if !showing {
//                checkImage.isHidden = false
//                showing = true
//            } else {
//                checkImage.isHidden = true
//                showing = false
//            }
        }
        
    }
    
    func configureCell(profileImage image : UIImage, email : String, key : String, isChecked : Bool) {
        //showing = isChecked
        userImage.image = image
        userEmaillabel.text = email
        checkImage.isHidden = !isChecked
        userId = key
    }

}
