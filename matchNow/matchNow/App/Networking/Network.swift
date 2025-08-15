//
//  Network.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import SwiftUI
import Foundation
import Alamofire

extension AFError {
    var convertLSError: LSError {
        switch self {
            case .sessionDeinitialized, .sessionInvalidated:
                return .sessionDeinitialized
            case .invalidURL:
                return .invalidURL
            case .sessionTaskFailed:
                return .sessionTaskFailed
            case .parameterEncodingFailed:
                return .parameterEncodingFailed
            default:
                return .unknown
            }
    }
}

protocol Networkable {
    func request<T: Decodable>(_ router: APIConvertible, decoder: T.Type) async throws -> T
}

final class Network {
    static let shared = Network()
    private var session: Session
    private let jsonDecoder: JSONDecoder

    init() {
        #if DEBUG
        let apiLogger = ApiLogger()
        self.session = Session(eventMonitors: [apiLogger])
        #else
        self.session = Session()
        #endif
        self.session.sessionConfiguration.timeoutIntervalForRequest = 120
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
    }
    
    func request<T: Decodable>(_ router: APIConvertible, decoder: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            session
                .request(router, interceptor: nil)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        guard let httpResponse = response.response else {
                            continuation.resume(throwing: LSError.unknown)
                            return
                        }
                        
                        // 🔧 수정: HTTP 상태 코드별 에러 처리
                        if httpResponse.statusCode == 401 {
                            // 401 에러일 때 응답 본문을 파싱하여 구체적인 에러 확인
                            if let errorResponse = try? self.parseErrorResponse(data) {
                                print("🔍 [Network] 401 에러 상세 정보:")
                                print("    - error: \(errorResponse.error ?? "nil")")
                                print("    - code: \(errorResponse.code ?? "nil")")
                                print("    - message: \(errorResponse.message)")
                                print("    - nextAction: \(errorResponse.nextAction ?? "nil")")
                                
                                let lsError = self.convertToLSError(errorResponse, statusCode: httpResponse.statusCode)
                                print("    - 변환된 LSError: \(lsError)")
                                continuation.resume(throwing: lsError)
                            } else {
                                print("❌ [Network] 401 에러 응답 파싱 실패")
                                continuation.resume(throwing: LSError.unauthorized)
                            }
                            return
                        }
                        
                        guard 200..<300 ~= httpResponse.statusCode else {
                            // 다른 HTTP 에러 코드 처리
                            if let errorResponse = try? self.parseErrorResponse(data) {
                                let lsError = self.convertToLSError(errorResponse, statusCode: httpResponse.statusCode)
                                continuation.resume(throwing: lsError)
                            } else {
                                continuation.resume(throwing: LSError.unknown)
                            }
                            return
                        }
                        
                        do {
                            let res = try self.jsonDecoder.decode(T.self, from: data)
                            continuation.resume(returning: res)
                        } catch let error as DecodingError {
                            continuation.resume(throwing: LSError.dataParsingFailed(error))
                        } catch let error as LSError {
                            continuation.resume(throwing: error)
                        } catch let error {
                            continuation.resume(throwing: LSError.originError(error))
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error.convertLSError)
                    }
                }
        }
    }
    
    // 🆕 에러 응답 파싱
    private func parseErrorResponse(_ data: Data) throws -> ErrorResponse {
        return try jsonDecoder.decode(ErrorResponse.self, from: data)
    }
    
    // 🆕 에러 응답을 LSError로 변환 - 새로운 서버 응답 구조 반영
    private func convertToLSError(_ errorResponse: ErrorResponse, statusCode: Int) -> LSError {
        let message = errorResponse.message
        let error = errorResponse.error ?? ""
        let code = errorResponse.code ?? ""
        
        // 401 에러의 경우 구체적인 에러 타입 확인
        if statusCode == 401 {
            // 🔧 수정: 새로운 error 및 code 필드 우선 확인
            switch error.uppercased() {
            case "ACCESS_TOKEN_EXPIRED":
                return .tokenExpired
            case "UNAUTHORIZED":
                return .unauthorized
            case "INVALID_TOKEN":
                return .invalidToken
            case "ACCOUNT_DISABLED":
                return .accountDisabled
            default:
                // code 필드도 확인
                switch code.uppercased() {
                case "ACCESS_TOKEN_EXPIRED":
                    return .tokenExpired
                case "REFRESH_TOKEN_EXPIRED":
                    return .refreshTokenExpired
                case "INVALID_TOKEN":
                    return .invalidToken
                case "ACCOUNT_DISABLED":
                    return .accountDisabled
                default:
                    // 메시지 내용으로 판단 (기존 로직)
                    if message.contains("만료") || message.contains("expired") {
                        return .tokenExpired
                    } else if message.contains("Invalid token") || message.contains("유효하지 않은 토큰") {
                        return .invalidToken
                    } else if message.contains("비활성화") || message.contains("disabled") {
                        return .accountDisabled
                    } else {
                        return .unauthorized
                    }
                }
            }
        }
        
        // 기타 에러는 customError로 처리
        return .customError(code: String(statusCode), message: message)
    }
    
    func requestForm<T: Decodable>(_ router: APIConvertible, decoder: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            session
                .upload(multipartFormData: router.multipartFormData!, with: router)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        guard let httpResponse = response.response else {
                            continuation.resume(throwing: LSError.unknown)
                            return
                        }
                        guard 200..<300 ~= httpResponse.statusCode else {
                            continuation.resume(throwing: LSError.unknown)
                            return
                        }
                        do {
                            //헤더 공통으로 파싱 "0000" 아닐경우 에러로 빠짐
                            // Decode header first
                            let _ = try self.jsonDecoder.decode(Header.self, from: data)
                            let res = try self.jsonDecoder.decode(T.self, from: data)
                            continuation.resume(returning: res)
                            
                        } catch let error as DecodingError {
                            continuation.resume(throwing: LSError.dataParsingFailed(error))
                        } catch let error as LSError {
                            continuation.resume(throwing: error)
                        } catch let error {
                            continuation.resume(throwing: LSError.originError(error))
                        }
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error.convertLSError)
                        break
                    }
                }
        }
    }
    
    func request(_ router: APIConvertible) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            session
                .request(router)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        guard let httpResponse = response.response else {
                            continuation.resume(throwing: LSError.unknown)
                            return
                        }
                        guard 200..<300 ~= httpResponse.statusCode else {
                            continuation.resume(throwing: LSError.unknown)
                            return
                        }
                        continuation.resume(returning: data)
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error.convertLSError)
                        break
                    }
                }
        }
    }
}

// 🆕 에러 응답 모델 - 새로운 서버 응답 구조에 맞게 업데이트
struct ErrorResponse: Codable {
    let success: Bool
    let statusCode: Int
    let timestamp: String?
    let path: String?
    let method: String?
    let message: String
    let error: String?
    
    // 🆕 새로 추가된 필드들
    let code: String?
    let suggestion: String?
    let expiredAt: String?
    let refreshEndpoint: String?
    let nextAction: String?
}
