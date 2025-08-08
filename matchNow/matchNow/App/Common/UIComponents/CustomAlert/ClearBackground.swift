//
//  ClearBackground.swift
//  matchNow
//
//  Created by kimhongpil on 8/3/25.
//

import SwiftUI

public struct ClearBackground: UIViewRepresentable {
    
    public func makeUIView(context: Context) -> some UIView {
        let view = ClearBackgroundView()

        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }

        return view
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

class ClearBackgroundView: UIView {
    open override func layoutSubviews() {
        guard let parentView = superview?.superview else { return }
        
        parentView.backgroundColor = .clear
    }
}


public struct PresentationBackground: UIViewRepresentable {
    public func makeUIView(context: Context) -> some UIView {
        let view = PresentationBackgroundView()

        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        }

        return view
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

class PresentationBackgroundView: UIView {
    open override func layoutSubviews() {
        guard let parentView = superview?.superview else { return }
        
        parentView.backgroundColor = .clear
    }
}
