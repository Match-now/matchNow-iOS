//
//  String+Extension.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import Foundation
import SwiftUI

extension String {
    func urlEncodedString() -> String {
        let allowedCharacterSet = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? ""
    }
    var isSuccess: Bool { return self == "0000" }
    var isEncriptOpcode: Bool {
        return ApiDataRequest.default.encryptOpcodes.contains(self)
    }
    
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    func removeChar() -> String {
        return self.removeCharacters(from: CharacterSet.decimalDigits.inverted)
    }
    
    func addComma(_ placeHolder: String = "", digit: Int = 2) -> String {
        if self.isEmpty { return placeHolder }
        //let result = self.removeChar()
        let fm = NumberFormatter()
        fm.maximumFractionDigits = digit
        fm.minimumFractionDigits = 0
        fm.numberStyle = .decimal
        guard let num = fm.number(from: self) else { return placeHolder }
        guard let value = fm.string(from: num) else {
            return placeHolder
        }
        return value
    }
    
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    static func cutStringToBytes(_ input: String, maxBytes: Int) -> String {
        if input.isEmpty {
            return ""
        }
        // UTF-8 인코딩된 바이트 배열로 변환
        let utf8Data = input.data(using: .utf8)!
        
        // 바이트 배열에서 원하는 길이만큼 잘라냄
        let subData = utf8Data.prefix(maxBytes)
        
        // 잘린 데이터를 다시 문자열로 변환
        let resultString = String(data: subData, encoding: .utf8)
        
        // 결과 문자열이 nil인 경우 잘린 데이터가 유효하지 않은 UTF-8 시퀀스를 포함함
        if resultString == nil {
            // 마지막 바이트를 제거하고 다시 시도
            return cutStringToBytes(String(input.dropLast()), maxBytes: maxBytes)
        }
        
        return resultString ?? ""
    }
    func cutStringToLength(_ lenth: Int) ->String {
        if self.isEmpty { return "" }
        var result = self
        if self.count > 6 {
            result = String(prefix(4))+".."
        }
        return result
    }
    
    func toThumbnail() -> String {
        guard let url = URL(string: self) else { return "" }
        let ext = url.pathExtension
        var urlWithoutExtension = url.deletingPathExtension()
        let lastPath = "\(urlWithoutExtension.lastPathComponent)_TH"
        urlWithoutExtension.deleteLastPathComponent()
        let newURL = urlWithoutExtension.appendingPathComponent(lastPath).appendingPathExtension(ext)
        return newURL.absoluteString
    }
    
    var toCGFloat: CGFloat? {
        if let doubleValue = Double(self) {
            return CGFloat(doubleValue)
        }
        return nil
    }
    func maskPhoneNumber() -> String {
        if self.isEmpty { return "" }
        let arrStr = Array(self)
        var result = ""
        for i in 0..<arrStr.count {
            let ch = arrStr[i]
            if i == 0 || i == 1 || i == 2 || i == 6 || i == 10 {
                result += String(ch)
            }
            else if i == 3 || i == 7 {
                result += "-"+String(ch)
            }
            else {
                result += "*"
            }
        }
        return result
    }
    
    func makeHtmlStirng() -> String {
        var result = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n "
        result += "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">\n"
        result += "<head>\n"
        result += "<title></title>\n"
        result += "</head>\n"
        result += "<style>\n"
        result += "a:link{color:#0000ff}\n"
        result += "</style>\n"
        result += "<body align=left bgcolor=#ffffff style='margin-left:11px; margin-right:11px; margin-top:0px'>"
        result += "<font color=#19485b style='font-size:14px;'>"
        result += self
        result += "</font></body></html>"
        return result
    }

    
}
