//
//  ApplicationMaterial.swift
//  iOS-GoodCodeExerciseSample
//
//  Created by Tomoki Takasawa on 11/5/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

enum ApplicationMaterial: String, Codable, ColorStyles {
    case resume
    case github
    case linkedin
    case transcript
    case coverLetter
    case website
    case appStore
    case media
    
    var iconImage: UIImage {
        switch self {
        case .github:
            return UIImage(named: "githubLogo")!
        case .resume:
            return UIImage(named: "resumeLogo")!
        case .linkedin:
            return UIImage(named: "linkedinLogo")!
        case .appStore:
            return UIImage(named: "appleLogo")!
        case .media:
            return UIImage(named: "mediaLogo")!
        case .transcript:
            return UIImage(named: "diplomaLogo")!
        default:
            return UIImage(named: "githubLogo")!
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .github:
            return self.getPurple()
        case .resume:
            return self.getRed()
        case .linkedin:
            return self.getLightBlue()
        case .appStore:
            return self.getDarkBlue()
        case .media:
            return self.getOrange()
        case .transcript:
            return self.getDarkGray()
        default:
            return .black
        }
    }
    
}
