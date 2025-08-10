//
//  MemberRegistView.swift
//  matchNow
//
//  Created by kimhongpil on 8/3/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct MemberRegistReducer {
    
    @ObservableState
    struct State: Equatable, Identifiable {
        var id = UUID()
        var isShowLiveScoreAccountCreate: Bool = false
        var isLoading = false
        var inputNickName: String = ""
        
        var aniBtnState = NickNameCheckAniReducer.State()
        var isCheckNickName = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case onBackButtonTaped
        case editingNickName(String)
        case aniBtnAction(NickNameCheckAniReducer.Action)
        case nickNameCheckResponse(Result<CommonDataResponse, LSError>)
        case authButtontaped
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.aniBtnState, action: \.aniBtnAction) {
            NickNameCheckAniReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .onBackButtonTaped:
                //NaviRouter.shared.memberPop()
                NaviRouter.shared.popRoot()
                return .none
            case .editingNickName(let value):
                state.inputNickName = value
                state.isCheckNickName = false
                if value.isEmpty {
                    return .run {send in
                        await send(.aniBtnAction(.stopTimer))
                        await send(.aniBtnAction(.valid(false)))
                    }
                }
                else {
                    return .run { send in
                        await send(.aniBtnAction(.startTimer))
                    }
                }
            case .aniBtnAction(.buttonTaped):
                if state.inputNickName.isEmpty {
                    ToastItem(message: NSLocalizedString("UserIdWriteViewControllerMsg2", comment: "대화명을 등록해 주세요."), alignment: .top).show()
                    return .none
                }
                else {
                    state.isLoading = true
                    let nickName = state.inputNickName
//                    return .run { send in
//                        await send(.nickNameCheckResponse (
//                            try await apiClient.apiRequest(.user(.userIdCheck(userId: nickName)), as: CommonDataResponse.self)
//                        ))
//                    }
                    return .none
                }
            //MARK:  - 닉네임 체크 응답
            case .nickNameCheckResponse(let result):
                state.isLoading = false
                switch result {
                case .success(let res):
                    if res.result == "1" {
                        state.isCheckNickName = true
                        
                        return .run { send in
                            await send(.aniBtnAction(.stopTimer))
                            await send(.aniBtnAction(.valid(true)))
                        }
                    }
                    else {
                        ToastItem(message: res.msg, alignment: .top).show()
                        return .none
                    }
                case .failure(let error):
                    ToastItem(message: error.errorDescription, alignment: .top).show()
                    return .none
                }
            case .authButtontaped:
                if state.inputNickName.isEmpty {
                    ToastItem(message: NSLocalizedString("UserIdWriteViewControllerMsg2", comment: "대화명을 등록해 주세요."), alignment: .top).show()
                    return .none
                }
                
                if state.isCheckNickName == false {
                    return .none
                }
                return .none
            case .binding(let action):
                print("binding action: action: \(action)")
                return .none
            default:
                return .none
            }
        }
    }
    
}

struct MemberRegistView: View {
    @Bindable var store: StoreOf<MemberRegistReducer> // @Bindable 사용
    @State private var phoneNumber = ""
    @FocusState var focus: FocusField.Member?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
//            CNavigationBar(style: viewStore.isKorean ? .darkBack : .darkBackConfirm, title: Text("RegistMember", comment: "회원가입")) { action in
//                switch action {
//                case .confirm:
//                    viewStore.send(.memberRegistRequest)
//                default:
//                    viewStore.send(.onBackButtonTaped)
//                }
//            }
            
            // 커스텀 네비게이션 바
            HStack {
                Button(action: {
                    store.send(.onBackButtonTaped)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.title2)
                        Text("뒤로")
                            .foregroundColor(.black)
                            .font(.body)
                    }
                }
                .padding(.leading, 16)
                
                Spacer()
                
                Text("회원가입")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                // 오른쪽 여백을 위한 투명 영역
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.clear)
                        .font(.title2)
                    Text("뒤로")
                        .foregroundColor(.clear)
                        .font(.body)
                }
                .padding(.trailing, 16)
            }
            .frame(height: 44)
            .background(Color.white)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Nickname", comment: "대화명")
                        .font(.custom(.body2))
                        .foregroundColor(.black)
                    
                    HStack {
                        let placeholder = NSLocalizedString("UserIdWriteViewControllerInputMsg", comment: "대화명 입력(한글/영문 8자 이내)")
                        TextField(placeholder, text: $store.inputNickName) // 직접 바인딩 사용
                            .onChange(of: store.inputNickName) { oldValue, newValue in
                                if newValue.count > 8 {
                                    store.inputNickName = String(newValue.prefix(8))
                                    return
                                }
                                store.send(.editingNickName(newValue))
                            }
                            .font(.custom(.body1))
                            .focused($focus, equals: FocusField.Member.nickname)
                            .foregroundColor(.black)
                            .disableAutocorrection(true)
                            .autocorrectionDisabled()
                            .padding(.horizontal, 8)
                            .frame(minHeight: 35)
                            .background {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.blue, lineWidth: 1)
                            }
                        
                        NickNameCheckAniView(
                            store: self.store.scope(
                                state: \.aniBtnState,
                                action: \.aniBtnAction
                            )
                        )
                        
                    }
                    .padding(.top, 8)
                }
                .padding(20)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        //.navigationBarHidden(true)
        //.navigationBarHidden(true)
//        .gesture(
//            // swipe back 제스처 추가
//            DragGesture()
//                .onEnded { value in
//                    if value.translation.width > 100 && abs(value.translation.height) < 50 {
//                        store.send(.onBackButtonTaped)
//                    }
//                }
//        )
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    MemberRegistView(store: Store(initialState: MemberRegistReducer.State(), reducer: {
        MemberRegistReducer()
    }))
}
