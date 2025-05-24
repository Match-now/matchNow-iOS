//
//  Screen.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import Foundation
import ComposableArchitecture

typealias Dest = Destination

enum Screen: Hashable, Identifiable, Equatable {
    
    // 커뮤니티 상세
    case communityDetail(boardId: Int)
    

    var id: String {
//        return UUID()
        switch self {

        case .communityDetail:
            return "communityDetail"
        default:
            return ""
        }
    }
    
    // Hashable 프로토콜 준수를 위한 함수
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

struct StackScreen: Hashable, Equatable, Identifiable {
    var id: UUID { UUID() }
    var screen: Screen
    var store: AnyObject
    
    static func ==(lhs:Self, rhs: Self) -> Bool { lhs.screen == rhs.screen }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(screen: Screen) {
        self.screen = screen
        
        switch screen {
        case .communityDetail:
            self.store = Store(initialState: BlankReducer.State(), reducer: {
                BlankReducer()
            })
        default:
            self.store = Store(initialState: BlankReducer.State(), reducer: {
                BlankReducer()
            })
        }
    }
}
