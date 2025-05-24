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
    @Published var mainNavi = NavigationPath()
    
    var tmpScreens: [Screen] = []
    
    init() {
    }
    func push(_ screen: Screen) {
        DispatchQueue.main.async {
            self.mainNavi.append(screen)
            self.tmpScreens.append(screen)
            AppState.shared.topScreen = screen
        }
    }
    
    func popRoot() {
        DispatchQueue.main.async {
            self.mainNavi = NavigationPath()
            self.tmpScreens = []
            AppState.shared.topScreen = nil
        }
    }
    
    func pop(_ index: Int = 1) {
        DispatchQueue.main.async {
            if self.mainNavi.count >= index {
                self.mainNavi.removeLast(index)
            } else {
                self.mainNavi = NavigationPath()
            }
            
            if self.tmpScreens.count >= index {
                self.tmpScreens.removeLast(index)
            } else {
                self.tmpScreens.removeAll()
            }
            AppState.shared.topScreen = self.tmpScreens.last
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
