//
//  ColorExtensions.swift
//  
//
//  Created by Alper Ozturk on 31.5.23..
//

import SwiftUI

extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

public extension Color {
    /// Color Hex Code is #C7C7C7
    static let Gray = Color(0xFFC7C7C7)
    
    /// Color Hex Code is #F7F7F7
    static let LightGray = Color(0xFFF7F7F7)
}
