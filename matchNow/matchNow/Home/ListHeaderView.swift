//
//  ListHeaderView.swift
//  matchNow
//
//  Created by hyunMac on 4/11/25.
//

import SwiftUI

struct ListHeaderView: View {
    let title: String
    var body: some View {
        HStack {
            Image(systemName: "bird.fill")
                .resizable()
                .frame(width: 20,height: 20)
            Text(title)
                .font(.headline)
            Spacer()
        }
        .foregroundStyle(.black)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.15))
    }
}

#Preview {
    ListHeaderView(title: "EPL")
}
