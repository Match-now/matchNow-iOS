//
//  CommonResponse.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import Foundation

enum CommonResCodingKeys: String, CodingKey {
    case header = "Header"
    case data = "Data"
    case games
    case monthly_gamedate
}

public struct Header: Codable {
    public let resultCode: String
    public let resultDes: String

    enum CodingKeys: String, CodingKey {
        case resultCode = "ResultCode"
        case resultDes = "ResultDes"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CommonResCodingKeys.self)
        let header = try container.nestedContainer(keyedBy: Self.CodingKeys.self, forKey: .header)
        let resultCode = try header.decode(String.self, forKey: .resultCode)
        let resultDes = try header.decode(String.self, forKey: .resultDes)
        if resultCode == "0004" {
            throw LSError.systemMaintenance(code: resultCode, message: resultDes)
        }
        else if resultCode != "0000" {
            throw LSError.customError(code: resultCode, message: resultDes)
        }
        self.resultCode = resultCode
        self.resultDes = try header.decode(String.self, forKey: .resultDes)
    }
}

public struct CommonDataResponse: Codable, Equatable {
    public var result: String
    public var msg: String
    public var interest_cnt: String = ""
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case msg = "msg"
        case interest_cnt
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CommonResCodingKeys.self)
        let data = try container.nestedContainer(keyedBy: Self.CodingKeys.self, forKey: .data)
        self.result = try data.decode(String.self, forKey: .result)
        self.msg = try data.decode(String.self, forKey: .msg)
        self.interest_cnt = try data.decodeIfPresent(String.self, forKey: .interest_cnt) ?? ""
    }
    
    public init(result: String, msg: String) {
        self.result = result
        self.msg = msg
    }
}


extension KeyedDecodingContainer {
    func decodeArray<T: Decodable>(of type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> [T] {
        var nested = try nestedUnkeyedContainer(forKey: key)

        var decoded = [T]()

        while !nested.isAtEnd {
            do {
                if let another = try nested.decodeIfPresent(T.self) {
                    decoded.append(another)
                }
            } catch DecodingError.valueNotFound {
                continue
            } catch {
                throw error
            }
        }

        return decoded
    }
}

