//
//  MemberRegistAlertContentView.swift
//  matchNow
//
//  Created by kimhongpil on 8/3/25.
//

import SwiftUI
import ComposableArchitecture

extension MemberRegistAlertContentView {
    enum Action: CaseIterable {
        case restore, regist, linkInfo, linkHow, linkFind, cancel
    }
}


struct MemberRegistAlertContentView: View {
    var action: ((_ action: MemberRegistAlertContentView.Action) -> Void)?
   
    init(action: ((MemberRegistAlertContentView.Action) -> Void)? = nil) {
        self.action = action
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image("ic_warning")
                Text("Notice1", comment: "안내")
                    .font(.custom(.title2, weight: .semibold))
            }
            
            Text("NoticeRegist7", comment: "해당기능을 사용하기 위해서는\n대화명 설정(회원가입)이 필요합니다.")
                .font(.custom(.body1))

            HStack(alignment: .top, spacing: 20) {
                Button {
                    self.action?(.restore)
                } label: {
                    Text("AccountRestore", comment: "기존회원 아이디복원")
                        .font(.custom(.body1))
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 86)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        }
                }
                .contentShape(Rectangle())
                
                Button {
                    self.action?(.regist)
                } label: {
                    Text("RegistMember", comment: "회원가입")
                        .font(.custom(.body1))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 86)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        }
                }
                .contentShape(Rectangle())
            }
            .padding(.vertical, 20)
            
            HStack(alignment: .top) {
                Text("※")
                    .font(.custom(.body2))
                
                Text("UserRestorationGuideMsg", comment: "기존회원 아이디복원이란?")
                    .font(.custom(.body1))
                    .underline()
            }
            .onTapGesture {
                self.action?(.linkInfo)
            }
            
            HStack(alignment: .top) {
                Text("※")
                    .font(.custom(.body2))
                
                Text("UserRestorationGuideMsg2", comment: "기존회원 아이디복원을 하는 방법은 무엇인가요?")
                    .font(.custom(.body1))
                    .underline()
            }
            .onTapGesture {
                self.action?(.linkHow)
            }
            
            HStack(alignment: .top) {
                Text("※")
                    .font(.custom(.body2))
                
                Text("UserRestorationGuideMsg3", comment: "사용하던 아이디(이메일)를 찾는 방법은?")
                    .font(.custom(.body1))
                    .underline()
            }
            .onTapGesture {
                self.action?(.linkFind)
            }
            
            HStack {
                Spacer()
                Button {
                    self.action?(.cancel)
                } label: {
                    Text("Cancel", comment: "취소")
                        .font(.custom(.title3))
                        .padding()
                }
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 8)
        }
        
    }
}

#Preview {
    MemberRegistAlertContentView()
}
