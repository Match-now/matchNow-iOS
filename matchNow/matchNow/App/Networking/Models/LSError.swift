//
//  LSError.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import SwiftUI

public enum LSError: Error, Identifiable, Equatable {
    public var id: UUID { UUID() }

    public static func == (lhs: LSError, rhs: LSError) -> Bool {
        return lhs.id == rhs.id
    }
    
    case sessionDeinitialized
    case invalidURL
    case sessionTaskFailed
    case parameterEncodingFailed
    case dataParsingFailed(DecodingError)
    case responseEncodingFailed
    case unknown
    case customError(code: String, message: String)
    case originError(Error)
    case systemMaintenance(code: String, message: String)
    
    public var errorDescription: String {
        switch self {
        case .sessionDeinitialized:
            return "세션 종료 되었습니다.\n다시 로그인 해주세요."
        case .invalidURL:
            return "잘못된 URL 입니다."
        case .sessionTaskFailed:
            return "인터넷 연결이 오프라인 상태입니다."
        case .customError(_ , let message):
            return message
        case .parameterEncodingFailed:
            return "요청 파라메터 인코딩에 실패했습니다."
        case .responseEncodingFailed:
            return "응답 데이터 UTF8 인코딩에 실패했습니다."
        case .dataParsingFailed(let decodingError):
            switch decodingError {
            case .dataCorrupted(let context):
                return "Data corrupted: \(context.debugDescription)"
            case .keyNotFound(let key, let context):
                return "Key '\(key.stringValue)' not found: \(context.debugDescription),\nPath: \(context.codingPath.map { $0.stringValue }.joined(separator: ", "))"
            case .typeMismatch(let type, let context):
                return "Type '\(type)' mismatch: \(context.debugDescription),\nPath: \(context.codingPath.map { $0.stringValue }.joined(separator: ", "))"
            case .valueNotFound(let type, let context):
                return "Value of type '\(type)' not found: \(context.debugDescription),\nPath: \(context.codingPath.map { $0.stringValue }.joined(separator: ", "))"
            @unknown default:
                return "Unknown decoding error"
            }
        case .systemMaintenance(code: _, message: let message):
            return message
        case .originError(let error):
            return error.localizedDescription
        default:
            return "시스템 장애가 발생했습니다."
        }
    }

    public var localizedDescription: String {
        return self.errorDescription
    }
    
    public var toString: String {
        return self.errorDescription
    }
    
    public var code: String {
        switch self {
        case .sessionDeinitialized:
            return "401"
        case .invalidURL:
            return "404"
        case .sessionTaskFailed:
            return "-1001"
        case .customError(let code, _):
            return code
        case .parameterEncodingFailed:
            return "-998"
        case .dataParsingFailed:
            return "-999"
        case .originError:
            return "500"
        case .systemMaintenance(code: let code, message: _):
            return code
        default:
            return "500"
        }
    }
}
