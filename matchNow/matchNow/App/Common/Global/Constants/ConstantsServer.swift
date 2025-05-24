//
//  ConstantsServer.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import Foundation

/// 서버환경
extension Constants.Server {
    static let baseUrl = "http://matchnow.pil.co.kr/matchnow"
    
    enum Environment {}
}

extension Constants.Server.Environment {
    
    /// 운영
    enum Product {
        static let host = "http://matchnow.pil.co.kr"
        static let backEndURL = "http://matchnow.pil.co.kr"
        static let name = "Product"
    }

    /// 개발
    enum Develop {
        static let host = "http://matchnow.pil.co.kr:9002"
        static let backEndURL = "\(host)/MatchNowController.jsp"
        static let name = "Develop"
        
    }
    
    
}

extension Constants.Server.Environment {
    static var backEndURL: String {
        // TODO: 개발 / 운영 나누는 방법으로 차후 수정 예정. 현재는 디버그 빌드시 무조건 개발서버 접속 됨
#if DEBUG
//        return Constants.Server.Environment.Develop.backEndURL
        return Constants.Server.Environment.Product.backEndURL
#else
        return Constants.Server.Environment.Product.backEndURL
#endif
    }
    
    static var host: String {
        return Constants.Server.Environment.Product.host
    }
}
