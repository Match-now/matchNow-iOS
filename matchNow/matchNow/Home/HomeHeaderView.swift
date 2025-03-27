//
//  HomeHeaderView.swift
//  matchNow
//
//  Created by hyunMac on 3/25/25.
//

import SwiftUI

struct HomeHeaderView: View {
    var profileTap: () -> Void
    var calendarTap: () -> Void
    
    var body: some View {
        HStack {
            Text("Match Now")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.blue)
            
            Spacer()
            
            Button(action: profileTap) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 22, height: 22)
            }
//            .frame(minWidth: 44, minHeight: 44)
            // HIG 맞춰야하면 추가

            
            Button(action: calendarTap) {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 22, height: 22)
            }
//            .frame(minWidth: 44, minHeight: 44)
            // HIG 맞춰야하면 추가

        }
        .padding(.horizontal)
    }
}

#Preview {
    HomeHeaderView(profileTap: {}, calendarTap: {})
}
