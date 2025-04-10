//
//  CategoryView.swift
//  matchNow
//
//  Created by hyunMac on 4/9/25.
//

import SwiftUI

enum Categories {
    case All
    case Soccer
}

struct CategoryView: View {
    let categories = [Categories.All,Categories.Soccer]
    let selectedCategory: Categories
    
    let selectCategory: (Categories) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectCategory(category)
                    }) {
                        switch category {
                        case Categories.All:
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 34,height: 34)
                                .foregroundStyle(selectedCategory == category ? .blue : .white)
                                .overlay {
                                    Text("All")
                                        .foregroundStyle(selectedCategory == category ? .white : .black)
                                        .fontWeight(.bold)
                                }
                        case Categories.Soccer:
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 34,height: 34)
                                .foregroundStyle(selectedCategory == category ? .blue : .white)
                                .overlay {
                                    Image(systemName: "soccerball")
                                        .foregroundStyle(selectedCategory == category ? .white : .black)
                                        .fontWeight(.bold)
                                }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    CategoryView(selectedCategory: Categories.All, selectCategory: {_ in })
}
