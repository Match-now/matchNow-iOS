//
//  matchNowAppState.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import SwiftUI
import Combine
import ComposableArchitecture

public class NaviRouter: ObservableObject {
    static var shared = NaviRouter()
    var cancelBag = Set<AnyCancellable>()
    var isMemberNaviPresent = false //이용약관 termview 회원가입할때 membernavi, mainnavi 둘다 푸쉬 될수 있음
    @Published var memberPath: [StackScreen] = []
    @Published var mainPath: [StackScreen] = []
    
    init() {
        
    }
    
    func push(_ screen: Screen) {
        DispatchQueue.main.async {
            self.mainPath.append(StackScreen(screen: screen))
            AppState.shared.topScreen = screen
        }
    }
    
    func popRoot() {
        DispatchQueue.main.async {
            self.mainPath = []
        }
    }
    
    func pop(_ index: Int = 1) {
        DispatchQueue.main.async {
            if self.mainPath.count >= index {
                self.mainPath.removeLast(index)
            } else {
                self.mainPath = []
            }
        }
    }
    
    //회원가입 네비
    func memberPush(_ screen: Screen) {
        self.memberPath.append(StackScreen(screen: screen))
    }
    
    func memberPopRoot() {
        //self.memberPath = []//NavigationPath()
        self.memberPath.removeAll()
    }
    
    func memberPop(_ index: Int = 1) {
        if self.memberPath.count >= index {
            self.memberPath.removeLast(index)
        } else {
            //self.memberPath = [] //NavigationPath()
            self.memberPath.removeAll()
        }
    }
}

final class AppState: ObservableObject {
    static let shared = AppState()
    var cancelBag = Set<AnyCancellable>()
    
    @Published var swipeBackActive: Bool = true
    @Published var link: EntryPoint = .empty
    @Published var topScreen: Screen?
    @Published var isShowModal: Bool = false
}
