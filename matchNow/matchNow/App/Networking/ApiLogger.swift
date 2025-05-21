//
//  ApiLogger.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import SwiftUI
import Alamofire

final class ApiLogger: EventMonitor {
    let queue = DispatchQueue(label: "LiveScore_NetworkLogger")
    
    func requestDidFinish(_ request: Request) {
        print("-----------------  🛰 NETWORK Reqeust LOG -----------------")
        var url = request.request?.url?.absoluteString ?? ""
        if let httpBodyData = request.request?.httpBody,  let bodyString = String(data: httpBodyData, encoding: .utf8) {
            let queryParams = bodyString.split(separator: "&").map { $0.split(separator: "=") }
            for pair in queryParams {
                if let key = String(pair[0]).removingPercentEncoding {
                    var value = ""
                    if pair.count > 1 {
                        let val = String(pair[1])
                        value = val.removingPercentEncoding ?? ""
                    }
                    url.append("&\(key)=\(value)")
                } else {
                    continue
                }
            }
            url.append("&test=1")
            
        }
        print("[URL] : \(url)")
//        print("[Method] : " + (request.request?.httpMethod ?? ""))
        //print("Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])")
        print("[StatusCode]: \(request.response?.statusCode ?? -99999)")
        
    }
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        switch response.result {
        case .success(let data):
            guard let data = data as? Data else { return }
            
//            guard let dataStr = String(data: data, encoding: .utf8) else { return }
//            print("Response: \(dataStr)")
            
        case .failure(let error):
            print("Response: \(error)")
        }
    }
    
    func request(_ request: Request, didFailTask task: URLSessionTask, earlyWithError error: AFError) {
        print("URLSessionTask가 Fail 했습니다.")
    }
    
    func request(_ request: Request, didFailToCreateURLRequestWithError error: AFError) {
        print("URLRequest를 만들지 못했습니다.")
    }
    
    func requestDidCancel(_ request: Request) {
        print("request가 cancel 되었습니다")
    }
}
extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .withoutEscapingSlashes]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}
