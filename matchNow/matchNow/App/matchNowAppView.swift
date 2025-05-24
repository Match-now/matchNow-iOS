//
//  matchNowAppView.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import SwiftUI
import ComposableArchitecture

struct matchNowAppView: View {
    @State var store: StoreOf<matchNowAppReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            IfLetStore(self.store.scope(state: \.intro, action: \.introAction)) { introStore in
                IntroPage(store: introStore)
            } else: {
                MainNaviView(store: self.store.scope(state: \.mainNaviState, action: \.mainNaviAction))
            }
            .onAppear {
                viewStore.send(.onLoad)
                viewStore.send(.onAppear)
            }
        }
    }
}
