//
//  MaterialView.swift
//  Weather
//
//  Created by Casey Lyman on 5/8/16.
//  Copyright © 2016 bearcode. All rights reserved.
//

import UIKit

class MaterialView: UIView {
    
    override func awakeFromNib() {
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.9).CGColor
 //       layer.shadowColor = UIColor.purpleColor().CGColor
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
        layer.cornerRadius = 2.0
        self.clipsToBounds = false
    }


    
}
