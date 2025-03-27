//
//  NoticeView.swift
//  matchNow
//
//  Created by hyunMac on 3/27/25.
//

import SwiftUI

struct NoticeView: View {
    var notice: String
    var body: some View {
        Rectangle()
            .cornerRadius(4)
            .frame(maxWidth: .infinity, maxHeight: 34)
            .foregroundStyle(.gray)
            .opacity(0.1)
            .overlay {
                HStack {
                    Image(systemName: "volume.1.fill")
                        .padding(.leading, 24)
                    
                    Text(notice)
                        .font(.subheadline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                }
            }
    }
}

#Preview {
    NoticeView(notice: "바나나 투척, \"망할원숭이\"조롱...")
}
