//
//  CommunityPageResponse.swift
//  matchNow
//
//  Created by kimhongpil on 5/22/25.
//

import Foundation

public struct CommunityPageResponse: Codable, Equatable {
    public var code: Int
    public var data: [String]
    public var message: String
    
    enum CodingKeys: String, CodingKey {
        case code, data, message
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decodeIfPresent(Int.self, forKey: .code) ?? 200
        data = try container.decodeIfPresent([String].self, forKey: .data) ?? []
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
    }
}
