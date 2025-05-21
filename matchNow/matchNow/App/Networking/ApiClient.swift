//
//  ApiClient.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import SwiftUI
import ComposableArchitecture
import Alamofire

@DependencyClient
struct ApiClient {
    
    public var apiRequest: @Sendable(ApiRouter) async throws -> Result<Data, LSError>
    
    public func apiRequest<T: Decodable>(_ router: ApiRouter, as: T.Type) async throws -> Result<T, LSError> {
        do {
            let data = try await Network.shared.request(router, decoder: T.self)
            return .success(data)
        } catch {
            guard let error = error as? LSError else {
                return .failure(.unknown)
            }
            return .failure(error)
        }
    }
    
    public func apiRequestForm<T: Decodable>(_ router: ApiRouter, as: T.Type) async throws -> Result<T, LSError> {
        do {
            let data = try await Network.shared.requestForm(router, decoder: T.self)
            return .success(data)
        } catch {
            guard let error = error as? LSError else {
                return .failure(.unknown)
            }
            return .failure(error)

        }
    }
    private func apiRequest(_ router: ApiRouter) async throws -> Result<Data, LSError> {
        do {
            let data = try await Network.shared.request(router)
            return .success(data)
        } catch {
            guard let error = error as? LSError else {
                return .failure(.unknown)
            }
            return .failure(error)

        }
    }
}

extension DependencyValues {
    var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
}

extension ApiClient: DependencyKey {
    public static let liveValue: Self = Self.live()
    
    public static func live() -> Self {
        actor SessionClient {
            func apiRequest(_ router: ApiRouter) async throws -> Result<Data, LSError> {
                do {
                    let data = try await Network.shared.request(router)
                    return .success(data)
                } catch {
                    guard let error = error as? LSError else {
                        return .failure(.unknown)
                    }
                    return .failure(error)
                }
            }
        }
        let sessionClient = SessionClient()
        return Self(
            apiRequest: { try await sessionClient.apiRequest($0) }
        )
    }
}
