//
//  NewsRouter.swift
//  matchNow
//
//  Created by kimhongpil on 5/24/25.
//

import Foundation
import Alamofire

enum NewsRouter {
    case psynetBanner([String:Any])
    case ticerNoticeDetail([String: Any])
}

extension NewsRouter: APIConvertible {
    var baseURL: URL {
        return URL(string: "\(Constants.Server.Environment.backEndURL)")!
    }
    
    var path: String {
        switch self {
        case .psynetBanner:
            return "/api/petti/sample_data"
        case .ticerNoticeDetail:
            return "/api/petti/sample_data"
        }
    }
    
    var header: HTTPHeaders? {
        let headers = HTTPHeaders()
        
        switch self {
        default:
            break
        }
        
        return headers
    }
    var method: HTTPMethod {
        return .post
    }
    
    var parameters: Parameters? {
        switch self {
        case .psynetBanner(let model):
            return model
        case .ticerNoticeDetail(let model):
            return model
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
        
        var request = URLRequest(url: self.baseURL)
        request.method = method
        
        if let headers = header {
            request.headers = headers
        }
        
        var param = ApiDataRequest.default.defaultParam()
        if let parameters = parameters {
            print("[Params] :\(parameters)")
            param = param.merge(to: parameters)
        }
        
        request = try URLEncoding.default.encode(request, with: param)
        
        return request
    }
}
