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
    case live(LiveRouter)
    case community(CommunityRouter)
    case news(NewsRouter)
    case interestGame(InterestGameRouter)
    case moreMenu(MoreMenuRouter)
}
extension ApiRouter: APIConvertible {
    var baseURL: URL {
        switch self {
        case .user(let router):
            return router.baseURL
        case .live(let router):
            return router.baseURL
        case .community(let router):
            return router.baseURL
        case .news(let router):
            return router.baseURL
        case .interestGame(let router):
            return router.baseURL
        case .moreMenu(let router):
            return router.baseURL
        }
    }
    var path: String {
        switch self {
        case .user(let router):
            return router.path
        case .live(let router):
            return router.path
        case .community(let router):
            return router.path
        case .news(let router):
            return router.path
        case .interestGame(let router):
            return router.path
        case .moreMenu(let router):
            return router.path
        }
    }
    var method: HTTPMethod {
        switch self {
        case .user(let router):
            return router.method
        case .live(let router):
            return router.method
        case .community(let router):
            return router.method
        case .news(let router):
            return router.method
        case .interestGame(let router):
            return router.method
        case .moreMenu(let router):
            return router.method
        }
    }
    var parameters: Parameters? {
        switch self {
        case .user(let router):
            return router.parameters
        case .live(let router):
            return router.parameters
        case .community(let router):
            return router.parameters
        case .news(let router):
            return router.parameters
        case .interestGame(let router):
            return router.parameters
        case .moreMenu(let router):
            return router.parameters
        }
    }
    var header: HTTPHeaders? {
        switch self {
        case .user(let router):
            return router.header
        case .live(let router):
            return router.header
        case .community(let router):
            return router.header
        case .news(let router):
            return router.header
        case .interestGame(let router):
            return router.header
        case .moreMenu(let router):
            return router.header
        }
    }

    var multipartFormData: MultipartFormData? {
        switch self {
        case .user(let router):
            return router.multipartFormData
        case .live(let router):
            return router.multipartFormData
        case .community(let router):
            return router.multipartFormData
        case .news(let router):
            return router.multipartFormData
        case .interestGame(let router):
            return router.multipartFormData
        case .moreMenu(let router):
            return router.multipartFormData
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        switch self {
        case .user(let router):
            return try router.asURLRequest()
        case .live(let router):
            return try router.asURLRequest()
        case .community(let router):
            return try router.asURLRequest()
        case .news(let router):
            return try router.asURLRequest()
        case .interestGame(let router):
            return try router.asURLRequest()
        case .moreMenu(let router):
            return try router.asURLRequest()
        }
    }
}
