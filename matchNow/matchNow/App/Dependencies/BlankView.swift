//
//  BlankView.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct BlankReducer {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id = UUID()
    }
    
    enum Action {}

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}

struct BlankView: View {
    let store: StoreOf<BlankReducer>
    
    var body: some View {
        Color.white
    }
}
