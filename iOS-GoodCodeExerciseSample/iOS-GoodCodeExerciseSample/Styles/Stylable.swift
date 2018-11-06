//
//  Stylable.swift
//  iOS-GoodCodeExerciseSample
//
//  Created by Tomoki Takasawa on 11/5/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

protocol Stylable: ColorStyles, FontStyles { }


extension Stylable where Self: DetailViewController {

    func getMainColor() -> UIColor {
        return UIColor.white
    }

}
