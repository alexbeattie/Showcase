//
//  MaterialView.swift
//  showcase-dev
//
//  Created by Alex Beattie on 11/6/15.
//  Copyright © 2015 Alex Beattie. All rights reserved.
//

import UIKit
class MaterialView: UIView {

    override func awakeFromNib() {
        
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
        
    }

}
