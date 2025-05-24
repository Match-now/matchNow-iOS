//
//  Color+Extension.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import SwiftUI

extension Color {
    static let primaryDefault = Color(red: 28/255.0, green: 103/255.0, blue: 255/255.0, opacity: 1)
    static let primaryLight = Color(red: 134/255.0, green: 126/255.0, blue: 255/255.0, opacity: 1)
    static let primaryDark = Color(red: 134/255.0, green: 126/255.0, blue: 255/255.0, opacity: 1)
    static let secondaryDefault = Color(red: 254/255.0, green: 158/255.0, blue: 158/255.0, opacity: 1)
    static let secondaryLight = Color(red: 255/255.0, green: 208/255.0, blue: 213/255.0, opacity: 1)
    static let secondaryDark = Color(red: 227/255.0, green: 149/255.0, blue: 149/255.0, opacity: 1)
    static let mainTabOn = Color(red: 28/255.0, green: 103/255.0, blue: 255/255.0, opacity: 1)
    static let mainTabOff = Color(red: 209/255.0, green: 209/255.0, blue: 209/255.0, opacity: 1)
}


/// 색상 Hex 문자열을 Color타입으로 변환
///
/// ```
/// let redColor = Color(hex: "#ff0000")
/// let transparentBlue = Color(hex: "#0000ff88")
/// let blueColor = Color(hex: "0000ff")
/// ```
extension Color {
    init(hex: String, defaultColor: Color = .black) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
//            (a, r, g, b) = (255, 0, 0, 0)
            self = defaultColor
            
            return
        }

        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
    }
}
