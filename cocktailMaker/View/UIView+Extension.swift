//
//  UIView+Extension.swift
//  cocktailMaker
//
//  Created by Claudia Contreras on 3/27/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    //For Gradient
    func setGradientBackground2Colors(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        //gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
       // gradientLayer.endPoint = CGPoint(x: 1, y: 1) // Bottom right corner.
        gradientLayer.locations = [0.0, 1.0]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func setGradientBackground3Colors(colorOne: UIColor, colorTwo: UIColor, colorThree: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor, colorThree.cgColor]
        //gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
        //gradientLayer.endPoint = CGPoint(x: 1, y: 1) // Bottom right corner.
        gradientLayer.locations = [0.0, 0.5, 1.0]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
