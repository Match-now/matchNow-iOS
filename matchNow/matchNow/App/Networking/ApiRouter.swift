//
//  ApiRouter.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import SwiftUI
import Foundation
import Alamofire

protocol ApiRoutable {
    associatedtype Router: APIConvertible
}

public protocol APIConvertible: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var header: HTTPHeaders? { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var multipartFormData: MultipartFormData? { get }
}

enum ApiRouter {
    case user(UserRouter)
    case home(HomeRouter)
    case match(MatchRouter)
    case mypage(MyPageRouter)
}
extension ApiRouter: APIConvertible {
    var baseURL: URL {
        switch self {
        case .user(let router):
            return router.baseURL
        case .home(let router):
            return router.baseURL
        case .match(let router):
            return router.baseURL
        case .mypage(let router):
            return router.baseURL
        }
    }
    var path: String {
        switch self {
        case .user(let router):
            return router.path
        case .home(let router):
            return router.path
        case .match(let router):
            return router.path
        case .mypage(let router):
            return router.path
        }
    }
    var method: HTTPMethod {
        switch self {
        case .user(let router):
            return router.method
        case .home(let router):
            return router.method
        case .match(let router):
            return router.method
        case .mypage(let router):
            return router.method
        }
    }
    var parameters: Parameters? {
        switch self {
        case .user(let router):
            return router.parameters
        case .home(let router):
            return router.parameters
        case .match(let router):
            return router.parameters
        case .mypage(let router):
            return router.parameters
        }
    }
    var header: HTTPHeaders? {
        switch self {
        case .user(let router):
            return router.header
        case .home(let router):
            return router.header
        case .match(let router):
            return router.header
        case .mypage(let router):
            return router.header
        }
    }

    var multipartFormData: MultipartFormData? {
        switch self {
        case .user(let router):
            return router.multipartFormData
        case .home(let router):
            return router.multipartFormData
        case .match(let router):
            return router.multipartFormData
        case .mypage(let router):
            return router.multipartFormData
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        switch self {
        case .user(let router):
            return try router.asURLRequest()
        case .home(let router):
            return try router.asURLRequest()
        case .match(let router):
            return try router.asURLRequest()
        case .mypage(let router):
            return try router.asURLRequest()
        }
    }
}
