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
    
    //회원가입
    case memReAuth
    case memRegist
    case memRestore
    

//    var id: String {
////        return UUID()
//        switch self {
//
//        case .communityDetail:
//            return "communityDetail"
//        default:
//            return ""
//        }
//    }
    var id: Int { hashValue }
    
    // Hashable 프로토콜 준수를 위한 함수
    func hash(into hasher: inout Hasher) {
        switch self {
        case .memReAuth:  hasher.combine("memReAuth")
        case .memRegist:  hasher.combine("memRegist")
        case .memRestore:  hasher.combine("memRestore")
        }
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
            //회원가입
        case .memReAuth:
//            self.store =  Store(initialState: MemberReAuthReducer.State(), reducer: {
//                MemberReAuthReducer()
//            })
            self.store = Store(initialState: BlankReducer.State(), reducer: {
                BlankReducer()
            })
        case .memRegist:
            self.store = Store(initialState:  MemberRegistReducer.State(), reducer: {
                MemberRegistReducer()
            })
        case .memRestore:
//            self.store = Store(initialState: MemberRestoreReducer.State(), reducer: {
//                MemberRestoreReducer()
//            })
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
