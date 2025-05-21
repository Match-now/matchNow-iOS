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
                        guard 200..<300 ~= httpResponse.statusCode else {
                            continuation.resume(throwing: LSError.unknown)
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
    
//    func downloadImage(with urlString: String) async throws -> (UIImage, String) {
//        return try await withCheckedThrowingContinuation { continuse in
//            guard let url = URL(string: urlString) else {
//                print("Invalid URL")
//                return continuse.resume(throwing: LSError.invalidURL)
//            }
//
//            KingfisherManager.shared.retrieveImage(with: url) { result in
//                switch result {
//                case .success(let imageResult):
//                    return continuse.resume(returning: (imageResult.image, urlString))
//                case .failure(let error):
//                    print("Error downloading image: \(error)")
//                    return continuse.resume(throwing: LSError.originError(error))
//                }
//            }
//        }
//    }
}
