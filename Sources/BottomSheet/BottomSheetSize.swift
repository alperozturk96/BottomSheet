//
//  BottomSheetSize.swift
//
//
//  Created by Alper Ozturk on 6.7.23..
//

import Foundation
import UIKit

public enum BottomSheetSize {
    case small
    case medium
    case large
    
    var height: CGFloat {
        switch self {
        case .small:
            return UIScreen.height * 0.33
        case .medium:
            return UIScreen.height * 0.5
        case .large:
            return UIScreen.height * 0.75
        }
    }
}
