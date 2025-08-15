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
        }
    }
    
    var header: HTTPHeaders? {
        var headers = HTTPHeaders()
        
        switch self {
        case .socialLogin, .refreshToken:
            headers["Content-Type"] = "application/json"
        default:
            break
        }
        
        return headers
    }
    
    var method: HTTPMethod {
        switch self {
        case .socialLogin, .refreshToken:
            return .post
        default:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .socialLogin(let request):
            return request.toDictionary()
        case .refreshToken(let request):
            return request.toDictionary()
        default:
            return nil
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
        
        if let headers = header {
            request.headers = headers
        }
        
        switch self {
        case .socialLogin, .refreshToken:
            // JSON 인코딩 사용
            if let parameters = parameters {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            }
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
