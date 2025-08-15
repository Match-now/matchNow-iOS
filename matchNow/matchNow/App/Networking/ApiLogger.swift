//
//  ApiLogger.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import SwiftUI
import Alamofire

final class ApiLogger: EventMonitor {
    let queue = DispatchQueue(label: "MatchNow_NetworkLogger")
    
    // 🆕 요청 시작될 때 로그
    func requestDidResume(_ request: Request) {
        print("\n" + "="*60)
        print("🚀 NETWORK REQUEST START")
        print("="*60)
        
        guard let urlRequest = request.request else {
            print("❌ URLRequest가 없습니다")
            return
        }
        
        // URL 정보
        print("📍 [URL]: \(urlRequest.url?.absoluteString ?? "Unknown URL")")
        print("🔧 [Method]: \(urlRequest.httpMethod ?? "Unknown Method")")
        
        // 헤더 정보 출력
        print("📋 [Headers]:")
        if let headers = urlRequest.allHTTPHeaderFields, !headers.isEmpty {
            for (key, value) in headers.sorted(by: { $0.key < $1.key }) {
                // Authorization 토큰은 보안상 마스킹 처리
                if key.lowercased() == "authorization" {
                    let maskedValue = maskSensitiveValue(value)
                    print("    \(key): \(maskedValue)")
                } else {
                    print("    \(key): \(value)")
                }
            }
        } else {
            print("    (헤더 없음)")
        }
        
        // Body 정보 출력
        print("📦 [Request Body]:")
        if let httpBody = urlRequest.httpBody {
            if let jsonString = httpBody.toPrettyPrintedString {
                print(jsonString)
            } else if let bodyString = String(data: httpBody, encoding: .utf8) {
                // URL-encoded 형태의 데이터 처리
                let formattedBody = formatUrlEncodedBody(bodyString)
                print(formattedBody)
            } else {
                print("    (바이너리 데이터, \(httpBody.count) bytes)")
            }
        } else {
            print("    (Body 없음)")
        }
        
        print("-" * 60)
    }
    
    // 🆕 응답 완료될 때 로그
    func requestDidFinish(_ request: Request) {
        print("\n" + "🏁 NETWORK REQUEST FINISHED")
        print("-" * 60)
        
        // 상태 코드 및 기본 정보
        let statusCode = request.response?.statusCode ?? -1
        let method = request.request?.httpMethod ?? "Unknown"
        let url = request.request?.url?.absoluteString ?? "Unknown URL"
        
        print("📍 [URL]: \(url)")
        print("🔧 [Method]: \(method)")
        
        // 상태 코드에 따른 이모지 표시
        let statusEmoji = getStatusEmoji(statusCode)
        print("\(statusEmoji) [Status Code]: \(statusCode)")
        
        // 응답 시간
        if let startTime = request.task?.earliestBeginDate,
           let endTime = request.task?.response?.url != nil ? Date() : nil {
            let duration = endTime.timeIntervalSince(startTime)
            print("⏱️ [Duration]: \(String(format: "%.3f", duration))s")
        }
        
        // 응답 헤더
        if let response = request.response {
            print("📋 [Response Headers]:")
            for (key, value) in response.allHeaderFields.sorted(by: { "\($0.key)" < "\($1.key)" }) {
                print("    \(key): \(value)")
            }
        }
        
        print("=" * 60 + "\n")
    }
    
    // 🆕 응답 데이터 파싱 완료 시 로그
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("📨 NETWORK RESPONSE DATA")
        print("-" * 60)
        
        switch response.result {
        case .success(let data):
            if let data = data as? Data {
                print("✅ [Success Response]:")
                if let jsonString = data.toPrettyPrintedString {
                    // JSON 응답을 예쁘게 출력
                    print(jsonString)
                } else if let dataString = String(data: data, encoding: .utf8) {
                    print(dataString)
                } else {
                    print("    (바이너리 데이터, \(data.count) bytes)")
                }
            } else {
                print("✅ [Success]: \(data)")
            }
            
        case .failure(let error):
            print("❌ [Error Response]: \(error.localizedDescription)")
            
            // 에러 응답 데이터가 있다면 출력
            if let data = response.data,
               let errorString = String(data: data, encoding: .utf8) {
                print("📄 [Error Response Body]:")
                if let jsonString = data.toPrettyPrintedString {
                    print(jsonString)
                } else {
                    print(errorString)
                }
            }
        }
        
        print("=" * 60 + "\n")
    }
    
    // 🆕 에러 상황별 로그
    func request(_ request: Request, didFailTask task: URLSessionTask, earlyWithError error: AFError) {
        print("❌ NETWORK TASK FAILED")
        print("-" * 60)
        print("Error: \(error.localizedDescription)")
        print("URL: \(request.request?.url?.absoluteString ?? "Unknown")")
        print("=" * 60 + "\n")
    }
    
    func request(_ request: Request, didFailToCreateURLRequestWithError error: AFError) {
        print("❌ FAILED TO CREATE URL REQUEST")
        print("-" * 60)
        print("Error: \(error.localizedDescription)")
        print("=" * 60 + "\n")
    }
    
    func requestDidCancel(_ request: Request) {
        print("⚠️ REQUEST CANCELLED")
        print("-" * 60)
        print("URL: \(request.request?.url?.absoluteString ?? "Unknown")")
        print("=" * 60 + "\n")
    }
    
    // MARK: - Helper Methods
    
    /// 민감한 값 마스킹 (토큰 등)
    private func maskSensitiveValue(_ value: String) -> String {
        if value.lowercased().hasPrefix("bearer ") {
            let token = String(value.dropFirst(7)) // "Bearer " 제거
            if token.count > 10 {
                let start = String(token.prefix(6))
                let end = String(token.suffix(4))
                return "Bearer \(start)***..***\(end)"
            }
        }
        
        if value.count > 10 {
            let start = String(value.prefix(4))
            let end = String(value.suffix(4))
            return "\(start)***..***\(end)"
        }
        
        return "***"
    }
    
    /// URL-encoded body 포맷팅
    private func formatUrlEncodedBody(_ bodyString: String) -> String {
        let pairs = bodyString.components(separatedBy: "&")
        let formattedPairs = pairs.map { pair in
            let components = pair.components(separatedBy: "=")
            if components.count == 2 {
                let key = components[0].removingPercentEncoding ?? components[0]
                let value = components[1].removingPercentEncoding ?? components[1]
                
                // 민감한 정보 마스킹
                if key.lowercased().contains("password") ||
                   key.lowercased().contains("token") ||
                   key.lowercased().contains("secret") {
                    return "    \(key): ***"
                } else {
                    return "    \(key): \(value)"
                }
            } else {
                return "    \(pair)"
            }
        }
        
        return formattedPairs.joined(separator: "\n")
    }
    
    /// 상태 코드에 따른 이모지 반환
    private func getStatusEmoji(_ statusCode: Int) -> String {
        switch statusCode {
        case 200..<300:
            return "✅"
        case 300..<400:
            return "🔄"
        case 400..<500:
            return "⚠️"
        case 500..<600:
            return "❌"
        default:
            return "❓"
        }
    }
}

// MARK: - Extensions

extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .withoutEscapingSlashes]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
            return nil
        }
        return prettyPrintedString as String
    }
}

// MARK: - String Extensions for pretty printing

extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}
