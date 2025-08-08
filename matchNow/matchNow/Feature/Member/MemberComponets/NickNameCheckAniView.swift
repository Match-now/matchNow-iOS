//
//  NickNameCheckAniView.swift
//  matchNow
//
//  Created by kimhongpil on 8/4/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct NickNameCheckAniReducer {
    @ObservableState
    struct State: Equatable {
        var timeCount: Int = 0
        var selColor: Color = Color.blue
        var isValid: Bool = false
        var isStartRunning = false
    }
    
    enum Action {
        case buttonTaped
        case startTimer, stopTimer, timerTick
        case valid(Bool)
//        case onDisappear
    }
    
    enum CancelID { case timer }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startTimer:
                if state.isStartRunning == false {
                    state.isStartRunning = true
                    return .run { send in
                        while true {
                            try await Task.sleep(nanoseconds: 500_000_000)
                            await send(.timerTick)
                        }
                    }
                    .cancellable(id: CancelID.timer)
                }
                else {
                    return .none
                }
            case .timerTick:
                state.timeCount += 1
                state.selColor = state.timeCount%2 == 0 ? Color.blue : Color.orange
                return .none
            case .stopTimer:
                state.isStartRunning = false
                return .cancel(id: CancelID.timer)
            case .valid(let value):
                state.isValid = value
                state.selColor = value ?  Color.green : Color.blue
                return .none
//            case .onDisappear:
//                return .run { send in
//                    await send(.stopTimer)
//                }
            default:
                return .none
            }
        }
       
    }
}

struct NickNameCheckAniView:  View {
    var store: StoreOf<NickNameCheckAniReducer>
    
    var body: some View {
        Button {
            store.send(.buttonTaped)
        } label: {
            Text(store.isValid ? "사용가능" : "중복확인")
                .font(.custom(.body1))
                .foregroundColor(Color.black)
                .frame(minHeight: 35)
                .padding(.horizontal, 16)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(store.selColor)
                }
        }
        .onDisappear {
//                viewStore.send(.onDisappear)
        }
    }
}



#Preview {
    NickNameCheckAniView(store: Store(initialState: NickNameCheckAniReducer.State(), reducer: {
        NickNameCheckAniReducer()
    }))
}
