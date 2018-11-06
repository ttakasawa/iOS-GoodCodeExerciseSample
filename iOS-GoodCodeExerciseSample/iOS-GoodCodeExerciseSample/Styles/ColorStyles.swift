//
//  ColorStyles.swift
//  iOS-GoodCodeExerciseSample
//
//  Created by Tomoki Takasawa on 11/5/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

protocol ColorStyles {
    
    func getMainColor() -> UIColor
    func getSecondaryColor() -> UIColor
    
    func getPurple() -> UIColor
    func getLightBlue() -> UIColor
    func getDarkBlue() -> UIColor
    func getRed() -> UIColor
    func getOrange() -> UIColor
    func getPink() -> UIColor
    func getDarkGray() -> UIColor
}

extension ColorStyles {
    func getMainColor() -> UIColor {
        return UIColor.white
    }
    func getSecondaryColor() -> UIColor{
        return UIColor.white
    }
    
    
    func getPurple() -> UIColor{
        return UIColor.purple
    }
    func getLightBlue() -> UIColor{
        return UIColor(red: 80.0 / 255.0, green: 168.0 / 255.0, blue: 228.0 / 255.0, alpha: 1.0)
    }
    func getDarkBlue() -> UIColor{
        return UIColor(red: 18.0 / 255.0, green: 86.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0)
    }
    func getRed() -> UIColor{
        return UIColor(red: 191.0 / 255.0, green: 37.0 / 255.0, blue: 99.0 / 255.0, alpha: 1.0)
    }
    func getOrange() -> UIColor{
        return UIColor(red: 241.0 / 255.0, green: 101.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
    }
    
    func getPink() -> UIColor {
        return UIColor(red:1, green:0.2, blue:0.4, alpha:1)
    }
    
    func getDarkGray() -> UIColor {
        return UIColor.darkGray
    }
}
