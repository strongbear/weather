//
//  MaterialImageView.swift
//  Weather
//
//  Created by Casey Lyman on 5/5/16.
//  Copyright © 2016 bearcode. All rights reserved.
//

import UIKit

class MaterialImageView: UIImageView {

    override func awakeFromNib() {
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
//        layer.shadowColor = UIColor.purpleColor().CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 0.0
        layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.clipsToBounds = false
    }

}
