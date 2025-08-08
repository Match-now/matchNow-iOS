//
//  UIApplication+Extension.swift
//  matchNow
//
//  Created by kimhongpil on 8/2/25.
//

import Foundation
import SwiftUI

extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
    
    /**
     * Keyboard ViewTapDismiss 구현
     * [Ref] https://velog.io/@yangpa043/SwiftUI-KeyboardViewTapDismiss
     */
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private static var toastVc: UIHostingController<LSToastUIView>?
    var window: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return nil }
        return window
    }
    
    func showToast(_ toast: ToastItem) {
        guard let window = window else { return }
        
        removeToastIfNeeded()
        let vc = UIHostingController(rootView: LSToastUIView(item: toast))
        vc.view.backgroundColor = .clear
        Self.toastVc = vc
        
        window.addSubview(vc.view)
        vc.view.frame  = CGRectMake(0, 0, window.bounds.width, window.bounds.height)
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.removeToastIfNeeded()
        }
    }
    
    private func removeToastIfNeeded() {
        guard let vc = Self.toastVc else { return }
        
        // 뷰 제거
        vc.view.removeFromSuperview()
        // 뷰 컨트롤러 cleanup
        vc.removeFromParent()
        // 참조 제거
        Self.toastVc = nil
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
