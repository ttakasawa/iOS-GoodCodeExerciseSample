//
//  FontStyles.swift
//  iOS-GoodCodeExerciseSample
//
//  Created by Tomoki Takasawa on 11/5/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

protocol FontStyles {
    func getTitleFont() -> UIFont
    func getDescriptionFont() -> UIFont
}

extension FontStyles {
    
    func getTitleFont() -> UIFont{
        return UIFont.boldSystemFont(ofSize: 20)
    }
    
    func getDescriptionFont() -> UIFont{
        return UIFont.systemFont(ofSize: 20)
    }
}
