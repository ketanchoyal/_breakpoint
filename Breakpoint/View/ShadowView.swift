//
//  ShadowView.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 15/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowView: UIView {

    override func awakeFromNib() {
        layer.shadowOpacity = 0.75
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        
        super.awakeFromNib()
    }

}
