//
//  ApplicationDisplayable.swift
//  iOS-GoodCodeExerciseSample
//
//  Created by Tomoki Takasawa on 11/5/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

protocol ApplicationDisplayable {
    var name: String { get }
    var url: String { get }
    var icon: UIImage { get }
    var themeColor: UIColor { get }
}


extension UserApplicationData: ApplicationDisplayable {
    var icon: UIImage {
        return self.material.iconImage
    }
    
    var themeColor: UIColor {
        return self.material.backgroundColor
    }
}
