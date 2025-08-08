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


// FANTOO Color Style
extension Color {
    //static let white = Color(red: 216/255.0, green: 216/255.0, blue: 216/255.0, opacity: 1)
    static let whiteTwo = Color(red: 219/255.0, green: 219/255.0, blue: 219/255.0, opacity: 1)
    static let white249 = Color(red: 249/255.0, green: 249/255.0, blue: 251/255.0, opacity: 1)
    static let primary100 = Color(red: 240/255.0, green: 240/255.0, blue: 254/255.0, opacity: 1)
    static let primary300 = Color(red: 153/255.0, green: 151/255.0, blue: 255/255.0, opacity: 1)
    //static let primaryDefault = Color(red: 49/255.0, green: 70/255.0, blue: 177/255.0, opacity: 1)
    //static let primaryDefault = Color(red: 134/255.0, green: 126/255.0, blue: 255/255.0, opacity: 1)
    //static let primary500 = Color(red: 109/255.0, green: 101/255.0, blue: 240/255.0, opacity: 1)
    static let primary500 = Color(red: 255/255.0, green: 170/255.0, blue: 170/255.0, opacity: 1)
    static let primary600 = Color(red: 80/255.0, green: 73/255.0, blue: 206/255.0, opacity: 1)
    //static let secondaryDefault = Color(red: 254/255.0, green: 158/255.0, blue: 158/255.0, opacity: 1)
    //static let secondaryLight = Color(red: 255/255.0, green: 208/255.0, blue: 213/255.0, opacity: 1)
    //static let secondaryDark = Color(red: 227/255.0, green: 149/255.0, blue: 149/255.0, opacity: 1)
    static let secondaryDeep = Color(red: 184/255.0, green: 69/255.0, blue: 90/255.0, opacity: 1)
    static let stateEnableGray900 = Color(red: 6/255.0, green: 9/255.0, blue: 36/255.0, opacity: 1)
    static let stateEnableGray400 = Color(red: 161/255.0, green: 163/255.0, blue: 179/255.0, opacity: 1)
    static let stateEnableGray200 = Color(red: 208/255.0, green: 209/255.0, blue: 217/255.0, opacity: 1)
    static let stateEnableGray25 = Color(red: 255/255.0, green: 255/255.0, blue: 255/255.0, opacity: 1)
    //static let stateEnablePrimaryDefault = Color(red: 134/255.0, green: 126/255.0, blue: 255/255.0, opacity: 1)
    static let stateEnablePrimaryDefault = Color(red: 67/255.0, green: 98/255.0, blue: 255/255.0, opacity: 1)
    static let stateEnablePrimary100 = Color(red: 240/255.0, green: 240/255.0, blue: 254/255.0, opacity: 1)
    static let stateEnableSecondaryDefault = Color(red: 254/255.0, green: 158/255.0, blue: 158/255.0, opacity: 1)
    static let stateEnableSecondaryLight = Color(red: 255/255.0, green: 208/255.0, blue: 213/255.0, opacity: 1)
    static let stateActiveGray900 = Color(red: 6/255.0, green: 9/255.0, blue: 36/255.0, opacity: 1)
    static let stateActiveGray700 = Color(red: 91/255.0, green: 93/255.0, blue: 123/255.0, opacity: 1)
    static let stateActiveGray25 = Color(red: 255/255.0, green: 255/255.0, blue: 255/255.0, opacity: 1)
    
    //static let stateActivePrimaryDefault = Color(red: 134/255.0, green: 126/255.0, blue: 255/255.0, opacity: 1)
    static let stateActivePrimaryDefault = Color(red: 102/255.0, green: 128/255.0, blue: 255/255.0, opacity: 1)
    
    //static let stateActiveSecondaryDefault = Color(red: 254/255.0, green: 158/255.0, blue: 158/255.0, opacity: 1)
    static let stateActiveSecondaryDefault = Color(red: 70/255.0, green: 157/255.0, blue: 219/255.0, opacity: 1)
    
    static let stateDisabledGray200 = Color(red: 208/255.0, green: 209/255.0, blue: 217/255.0, opacity: 1)
    static let stateDisabledGray50 = Color(red: 246/255.0, green: 246/255.0, blue: 250/255.0, opacity: 1)
    static let stateDanger = Color(red: 235/255.0, green: 87/255.0, blue: 87/255.0, opacity: 1)
    static let bgLightGray50 = Color(red: 244/255.0, green: 246/255.0, blue: 252/255.0, opacity: 1)
    static let bgMainPrimary300 = Color(red: 153/255.0, green: 151/255.0, blue: 255/255.0, opacity: 1)
    static let gray900 = Color(red: 6/255.0, green: 9/255.0, blue: 36/255.0, opacity: 1)
    static let gray870 = Color(red: 21/255.0, green: 24/255.0, blue: 66/255.0, opacity: 1)
    static let gray850 = Color(red: 44/255.0, green: 47/255.0, blue: 85/255.0, opacity: 1)
    static let gray800 = Color(red: 68/255.0, green: 70/255.0, blue: 104/255.0, opacity: 1)
    static let gray700 = Color(red: 91/255.0, green: 93/255.0, blue: 123/255.0, opacity: 1)
    static let gray600 = Color(red: 115/255.0, green: 116/255.0, blue: 142/255.0, opacity: 1)
    static let gray500 = Color(red: 138/255.0, green: 139/255.0, blue: 160/255.0, opacity: 1)
    static let gray400 = Color(red: 161/255.0, green: 163/255.0, blue: 179/255.0, opacity: 1)
    static let gray300 = Color(red: 185/255.0, green: 186/255.0, blue: 198/255.0, opacity: 1)
    static let gray199 = Color(red: 199/255.0, green: 198/255.0, blue: 217/255.0, opacity: 1)
    static let gray200 = Color(red: 208/255.0, green: 209/255.0, blue: 217/255.0, opacity: 1)
    static let gray224 = Color(red: 224/255.0, green: 226/255.0, blue: 241/255.0, opacity: 1)
    static let gray208 = Color(red: 208/255.0, green: 208/255.0, blue: 208/255.0, opacity: 1)
    static let gray100 = Color(red: 232/255.0, green: 232/255.0, blue: 236/255.0, opacity: 1)
    static let gray60 = Color(red: 248/255.0, green: 246/255.0, blue: 247/255.0, opacity: 1)
    static let gray50 = Color(red: 246/255.0, green: 246/255.0, blue: 250/255.0, opacity: 1)
    static let gray40 = Color(red: 244/255.0, green: 246/255.0, blue: 253/255.0, opacity: 1)
    static let gray25 = Color(red: 255/255.0, green: 255/255.0, blue: 255/255.0, opacity: 1)
    static let fillClear = Color(red: 255/255.0, green: 255/255.0, blue: 255/255.0, opacity: 0)
    static let plusPrimaryDefault = Color(red: 134/255.0, green: 126/255.0, blue: 255/255.0, opacity: 1)
    static let minusGray800 = Color(red: 68/255.0, green: 70/255.0, blue: 104/255.0, opacity: 1)
    static let dimGray900 = Color(red: 0/255.0, green: 0/255.0, blue: 0/255.0, opacity: 0.4000000059604645)
    static let popupBg = Color(red: 33/255.0, green: 33/255.0, blue: 33/255.0, opacity: 1)
    static let shadowColor = Color(red: 73/255.0, green: 60/255.0, blue: 151/255.0, opacity: 0.14)
    static let fanitBgColor = Color(red: 91/255.0, green: 194/255.0, blue: 82/255.0)
    static let fanitTextColor = Color(red: 176/255.0, green: 246/255.0, blue: 170/255.0)
    static let fanitBorderColor = Color(red: 215/255.0, green: 216/255.0, blue: 223/255.0)
    static let fanitShadowColor = Color(red: 10/255.0, green: 17/255.0, blue: 51/255.0, opacity: 0.1)
    static let pinkDefaultColor = Color(red: 255/255.0, green: 140/255.0, blue: 140/255.0, opacity: 1)
}


//MARK: - 디자인가이드에 없는 경우 요청하시고, 그외에 케이스는 여기다가 정의해서 사용하세요.
extension Color {
    
}

// 다크모드
extension Color {
    static func darkModeColor(scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return .white
        case .dark:
            return .black
        @unknown default:
            return .white
        }
    }
}
