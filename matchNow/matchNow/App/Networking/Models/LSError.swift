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
    
    // 🆕 토큰 관련 에러 추가
    case unauthorized                    // 토큰 없음
    case tokenExpired                   // 토큰 만료
    case invalidToken                   // 잘못된 토큰
    case accountDisabled               // 계정 비활성화
    case refreshTokenExpired           // 리프레시 토큰 만료
    
    public var errorDescription: String {
        switch self {
        case .sessionDeinitialized:
            return "세션 종료 되었습니다.\n다시 로그인 해주세요."
        case .invalidURL:
            return "잘못된 URL 입니다."
        case .sessionTaskFailed:
            return "인터넷 연결이 오프라인 상태입니다."
        case .customError(_, let message):
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
        // 🆕 토큰 관련 에러 메시지 - 서버 응답에 맞게 업데이트
        case .unauthorized:
            return "로그인이 필요합니다."
        case .tokenExpired:
            return "Access Token이 만료되었습니다.\n자동으로 갱신을 시도합니다."
        case .invalidToken:
            return "유효하지 않은 Access Token입니다.\n다시 로그인해 주세요."
        case .accountDisabled:
            return "계정이 비활성화되었습니다.\n고객센터에 문의해 주세요."
        case .refreshTokenExpired:
            return "Refresh Token이 만료되었습니다.\n다시 로그인해 주세요."
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
        // 🆕 토큰 관련 에러 코드
        case .unauthorized:
            return "401"
        case .tokenExpired:
            return "401"
        case .invalidToken:
            return "401"
        case .accountDisabled:
            return "401"
        case .refreshTokenExpired:
            return "401"
        default:
            return "500"
        }
    }
    
    // 🆕 토큰 관련 에러인지 확인하는 편의 프로퍼티
    public var isTokenRelated: Bool {
        switch self {
        case .unauthorized, .tokenExpired, .invalidToken, .accountDisabled, .refreshTokenExpired:
            return true
        default:
            return false
        }
    }
    
    // 🆕 리프레시 토큰으로 복구 가능한 에러인지 확인
    public var isRecoverableWithRefresh: Bool {
        switch self {
        case .tokenExpired:
            return true
        default:
            return false
        }
    }
}
