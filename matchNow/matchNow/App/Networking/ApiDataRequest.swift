//
//  ApiDataRequest.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import Foundation
import CoreTelephony
import Alamofire
import UIKit
import ComposableArchitecture


final class ApiDataRequest {
    static let `default` = ApiDataRequest()
    // 키값 정의
    let appVerKey = "app_ver"
    let nationalKey = "national_code"
    let languageKey = "language_code"
    let modelKey = "mo"
    let ntKey = "nt"
    let dtKey = "dt"
    let gmtKey = "h_gmt"
    let vhKey = "vh"
    
    let pkKey = "pk"
    let opKey = "opcode"
    let osKey = "os"
    let reComKey = "re_com"
    
    let encryptOpcodes = [
        "00000001", // 회원가입
        "00000019", // 라스계정 복원
        "00000022", // 라스계정 정보
        "00000023", // 라스계정 정보 생성 및 수정
        "00000025", // 회원 탈퇴
        "00010013", // 전문가 분석 구매 (스포츠구루 연동)
        "00010018", // 라이브스코어 전문가 분석 픽 구매
        "00010031", // 조합픽 분석 구매(전문가 분석)
        "00040006", // 포인트 구입 영수증 검토 (인앱 구매)
        "00040011", // 영수증 검증 (프리미엄 구독)
        "00120002"  // 이모티콘 구매
    ]
}

extension ApiDataRequest {
    func defaultParam() -> [String:Any] {
        var param = [String: Any]()
        param[appVerKey] = Constants.SysInfo.appVersion.urlEncodedString()
        param[nationalKey] = AppState.shared.countryCode.uppercased()
        param[languageKey] = AppState.shared.languageCode.lowercased()
        param[modelKey] = Constants.SysInfo.modelName
        param[ntKey] = Constants.SysInfo.carrierName
        param["ph"] = ""
        param[gmtKey] = Utils.shared.getGmtTime(Date())
        
        return param
    }
    
    func getDefaultPath(_ path: String) -> String {
        let backUrl = Constants.Server.Environment.backEndURL
        return "\(backUrl)\(path)"
    }
}
