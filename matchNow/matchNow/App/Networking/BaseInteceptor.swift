//
//  BaseInteceptor.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import SwiftUI
import Alamofire

final class BaseInteceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        do {
            var request = urlRequest
            if let body = request.httpBody,  let bodyString = String(data: body, encoding: .utf8) {
                let queryItems = bodyString.split(separator: "&")
                var param = [String: String]()
                for item in queryItems {
                    let keyValue = item.split(separator: "=")
                    if keyValue.count == 2 {
                        let key = String(keyValue[0])
                        let value = String(keyValue[1]).removingPercentEncoding ?? ""
                        param[key] = value
                    }
                }
                
                print("baseInteceptor param: \(param)")
                
                let newParamString = param.map { key, value -> String in
                    let encodeValue = value.urlEncodedString()
                    return "\(key)=\(encodeValue)"
                }.joined(separator: "&")
                
                request.httpBody = newParamString.data(using: .utf8)
                
                let headers = request.headers
                request.headers = headers
            }
            completion(.success(request))
        } catch {
            // Handle errors that might occur during JSON deserialization
            print("error: base inteceptor query param \(error)")
            completion(.failure(error))
        }
        
    }
    
    
}
