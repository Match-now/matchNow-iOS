//
//  Constants.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import Foundation
typealias SysInfo = Constants.SysInfo

/// 공통
struct Constants {
    // MARK: - 서버 설정
    enum Server{}
    
    // MARK: - 암호화 설정
    enum Security {}
    
    // MARK: - Cache Instance
    enum Cache {}
    
    // MARK: - 경기 관련 정의
    enum Game {}

    enum URLs {}

    enum SysInfo {} //시스템 정보
    
    enum ImageInfo {
        func orgSize(size: CGSize) -> CGSize {
            return .init(width: 1024, height: size.height * 1024 / size.width)
        }

        func thumbSize(size: CGSize) -> CGSize {
            return .init(width: 80, height: size.height * 80 / size.width)
        }
    }
}
