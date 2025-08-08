//
//  GlobalVariable.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import Foundation
import SwiftUI

enum FocusField {
    enum Member: CaseIterable {
        case email, phone, pw1, pw2, nickname
    }
    enum Cartoon: CaseIterable {
        case jumpingBookNo
    }
}

extension Transaction {
    static let noAnimationTransaction: Transaction = {
        var transaction = Transaction(animation: .none)
        transaction.disablesAnimations = true
        return transaction
    }()
}
