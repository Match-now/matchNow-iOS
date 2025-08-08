//
//  CToastView.swift
//  matchNow
//
//  Created by kimhongpil on 8/4/25.
//

import SwiftUI
import Popovers

struct ToastItem: Identifiable, Equatable, Hashable {
    var id: String { message }
    var message: String
    var alignment: Popover.Attributes.Position.Anchor = .center
    init(message: String, alignment: Popover.Attributes.Position.Anchor = .center) {
        self.message = message
        self.alignment = alignment
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(message)
    }
    static func ==(lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    
    var toVerticalAlignment: Alignment {
        switch alignment {
        case .topLeft, .top, .topRight:
            return .top
        case .right, .left, .center:
            return .center
        case .bottomRight, .bottom, .bottomLeft:
            return .bottom
        @unknown default:
            return .top
        }
    }
    func show() {
        DispatchQueue.main.async {
            UIApplication.shared.showToast(self)
        }
    }
}

struct CToastView<Item, CToast>: ViewModifier where Item: Identifiable, CToast: View {
    @Binding var item: Item?
    var alignment: Alignment
    var innerContent: (Item) -> CToast
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: alignment, content: {
                if let item = item {
                    innerContent(item)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.item = nil
                            }
                        }
                }
            })
        
    }
    
}

extension View {
    public func cToast<Item, CToast>(item: Binding<Item?>, alignment: Alignment? = .center, @ViewBuilder content: @escaping (Item) -> CToast) -> some View where Item: Identifiable, CToast: View {
        self.modifier(CToastView(item: item, alignment: alignment ?? .center, innerContent: content))
    }
}


struct LSToastUIView: View {
    var item: ToastItem
    var body: some View {
        HStack {
            Text(item.message)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.black.opacity(0.9))
                }
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: item.toVerticalAlignment)
    }
}
