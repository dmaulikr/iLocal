//
//  Button.swift
//  iLocal
//
//  Created by Frazy Nondo on 2016-11-25.
//  Copyright © 2016 Frazy Nondo. All rights reserved.
//

import UIKit

class Button: UIButton {

        
        override func awakeFromNib() {
            
//            layer.cornerRadius = 23.0
            
            layer.cornerRadius = 20.0
            
//            layer.borderColor = UIColor(red: 255/255, green: 128/255, blue:0/255, alpha: 1.0).CGColor
            
            layer.borderColor = UIColor.whiteColor().CGColor
            layer.borderWidth = 1.0
        }


}
