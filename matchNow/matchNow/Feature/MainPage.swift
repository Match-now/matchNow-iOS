//
//  MainPage.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct MainReducer {
    enum Tab: String, CaseIterable/*, Equatable*/ {
        case live, community, news, interestGame, moreMenu
        
        var title: String {
            switch self {
            case .live:
                return "라이브"
            case .community:
                return "커뮤니티"
            case .news:
                return "뉴스"
            case .interestGame:
                return "관심경기"
            case .moreMenu:
                return "더보기"
            }
        }
        
        var imageOn: String {
            switch self {
            case .live:
                return "liveTab_on"
            case .community:
                return "communityTab_on"
            case .news:
                return "newsTab_on"
            case .interestGame:
                return "interestGameTab_on"
            case .moreMenu:
                return "moreMenuTab_on"
            }
        }
        
        var imageOff: String {
            switch self {
            case .live:
                return "liveTab_off"
            case .community:
                return "communityTab_off"
            case .news:
                return "newsTab_off"
            case .interestGame:
                return "interestGameTab_off"
            case .moreMenu:
                return "moreMenuTab_off"
            }
        }
    }
    
    
    @ObservableState
    struct State: Equatable {
        var id = UUID()
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        var selectedTab: Tab
        
        var live: LiveReducer.State = .initialState
        var community: CommunityReducer.State = .initialState
        var news: NewsReducer.State = .initialState
        var interestGame: InterestGameReducer.State = .initialState
        var moreMenu: MoreMenuReducer.State = .initialState
        
        static let initialState = State(
            selectedTab: .live,
            live: .initialState,
            community: .initialState,
            news: .initialState,
            interestGame: .initialState,
            moreMenu: .initialState
        )
    }
    
    enum Action {
        enum ViewAction {
            case onLoad
            case onAppear
        }
        enum InternalAction {
            
        }
        case view(ViewAction)
        case inter(InternalAction)
        
        case live(LiveReducer.Action)
        case community(CommunityReducer.Action)
        case news(NewsReducer.Action)
        case interestGame(InterestGameReducer.Action)
        case moreMenu(MoreMenuReducer.Action)
        
        case changeMainMenu(MainReducer.Tab)
    }
    
    var body: some Reducer<State, Action> {
        
        Scope(state: \.live, action: \.live) {
            LiveReducer()
        }
        Scope(state: \.community, action: \.community) {
            CommunityReducer()
        }
        Scope(state: \.news, action: \.news) {
            NewsReducer()
        }
        Scope(state: \.interestGame, action: \.interestGame) {
            InterestGameReducer()
        }
        Scope(state: \.moreMenu, action: \.moreMenu) {
            MoreMenuReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none
            case .view(.onLoad):
                return .none
            case .changeMainMenu(let tab):
                state.selectedTab = tab
                return .none
            default:
                return .none
            }
        }
    }
}

struct MainPage: View {
    let store: StoreOf<MainReducer>
    private let tabCount = CGFloat(MainReducer.Tab.allCases.count)
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                switch store.selectedTab {
                case .live:
                    LivePage(
                        store: self.store.scope(
                            state: \.live,
                            action: \.live
                        )
                    )
                case .community:
                    CommunityPage(
                        store: self.store.scope(
                            state: \.community,
                            action: \.community
                        )
                    )
                case .news:
                    NewsPage(
                        store: self.store.scope(
                            state: \.news,
                            action: \.news
                        )
                    )
                case .interestGame:
                    InterestGamePage(
                        store: self.store.scope(
                            state: \.interestGame,
                            action: \.interestGame
                        )
                    )
                case .moreMenu:
                    MoreMenuPage(
                        store: self.store.scope(
                            state: \.moreMenu,
                            action: \.moreMenu
                        )
                    )
                }
                
                //MARK: - 하단 탭 메뉴
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color.gray)
                    
                    HStack(spacing: 0) {
                        ForEach(MainReducer.Tab.allCases, id: \.self) { menu in
                            Button {
                                store.send(.changeMainMenu(menu))
                            } label: {
                                VStack(spacing: 6) {
                                    Image(store.selectedTab == menu ? menu.imageOn : menu.imageOff)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 20)
                                    
                                    Text(menu.title)
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(store.selectedTab == menu ? Color.mainTabOn : Color.mainTabOff)
                                }
                                .frame(width: geometry.size.width / tabCount)
                                .padding(EdgeInsets(top: 15, leading: 0, bottom: 5, trailing: 0))
                                .background(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(width: geometry.size.width)
                }
            }
        }
    }
}

#Preview {
    MainPage(
        store: Store(initialState: .initialState) {
            MainReducer()
        }
    )
}
