//
//  UserRouter.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import Foundation
import Alamofire

enum UserRouter {
    case socialLogin(SocialLoginRequest)
    case refreshToken(RefreshTokenRequest)
    case profile // 프로필 조회 API 추가
}

extension UserRouter: APIConvertible {
    var baseURL: URL {
        return URL(string: "\(Constants.Server.Environment.backEndURL)")!
    }
    
    var path: String {
        switch self {
        case .socialLogin:
            return "/api/v1/app/auth/social-login"
        case .refreshToken:
            return "/api/v1/app/auth/refresh"
        case .profile:
            return "/api/v1/app/auth/profile"
        }
    }
    
    var header: HTTPHeaders? {
        var headers = HTTPHeaders()
        
        switch self {
        case .socialLogin:
            headers["Content-Type"] = "application/json"
        case .refreshToken:
            headers["Content-Type"] = "application/json"
            // refresh 토큰 요청 시에는 Authorization 헤더 불필요
        case .profile:
            headers["Content-Type"] = "application/json"
            // 🔧 수정: 토큰 가져오기 로직 개선 및 디버깅 추가
            if let accessToken = TokenManager.shared.getAccessToken() {
                headers["Authorization"] = "Bearer \(accessToken)"
                print("🔑 [DEBUG] Authorization 헤더 추가됨: Bearer \(accessToken.prefix(20))...")
            } else {
                print("❌ [DEBUG] Access Token이 없습니다!")
            }
        }
        
        // 🆕 최종 헤더 확인용 디버그 로그
        print("📋 [DEBUG] 최종 헤더: \(headers)")
        
        return headers
    }
    
    var method: HTTPMethod {
        switch self {
        case .socialLogin, .refreshToken:
            return .post
        case .profile:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .socialLogin(let request):
            return request.toDictionary()
        case .refreshToken(let request):
            return request.toDictionary()
        case .profile:
            return nil // GET 요청이므로 파라미터 없음
        }
    }
    
    var multipartFormData: MultipartFormData? {
        switch self {
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.method = method
        
        // 🔧 수정: 헤더 설정 로직 개선
        if let headers = header {
            request.headers = headers
            print("🔧 [DEBUG] URLRequest에 헤더 설정 완료: \(request.headers)")
        } else {
            print("❌ [DEBUG] 헤더가 nil입니다!")
        }
        
        switch self {
        case .socialLogin, .refreshToken:
            // JSON 인코딩 사용
            if let parameters = parameters {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            }
        case .profile:
            // GET 요청이므로 body 없음
            print("📍 [DEBUG] Profile API 요청 - GET 메서드, body 없음")
            break
        default:
            // 기존 URLEncoding 사용
            var param = ApiDataRequest.default.defaultParam()
            if let parameters = parameters {
                print("[Params] :\(parameters)")
                param = param.merge(to: parameters)
            }
            request = try URLEncoding.default.encode(request, with: param)
        }
        
        return request
    }
}
