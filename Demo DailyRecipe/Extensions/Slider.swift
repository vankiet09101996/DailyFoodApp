//
//  Slider.swift
//  Demo DailyRecipe
//
//  Created by NEM on 23/06/2021.
//

import UIKit
@IBDesignable
class Slider: UISlider {

    @IBInspectable var thumbImage : UIImage? {
        didSet{
            setThumbImage(thumbImage, for: .normal)
        }
    }
}
