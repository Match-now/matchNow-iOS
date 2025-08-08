//
//  Typhography.swift
//  matchNow
//
//  Created by kimhongpil on 8/3/25.
//

import SwiftUI

enum Typhography: CaseIterable {
    case hero
    case title
    case title2
    case title3
    case subheading
    case subheading2
    case body1
    case body2
    case body3
    case caption
    case caption2
}

extension Typhography {
    var size: CGFloat {
        switch self {
        case .hero:
            return 28
        case .title:
            return 24
        case .title2:
            return 22
        case .title3:
            return 18
        case .subheading:
            return 20
        case .subheading2:
            return 14
        case .body1:
            return 16
        case .body2:
            return 14
        case .body3:
            return 12
        case .caption:
            return 10
        case .caption2:
            return 11
        }
    }
}
extension Font {
    static func custom(_ style: Typhography, weight: Font.Weight = .regular) -> Font {
        return .system(size: style.size, weight: weight)
    }
    static func custom(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .system(size: size, weight: weight)
    }
}
