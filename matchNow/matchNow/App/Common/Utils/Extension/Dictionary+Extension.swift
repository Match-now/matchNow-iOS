//
//  Dictionary+Extension.swift
//  matchNow
//
//  Created by kimhongpil on 5/21/25.
//

import SwiftUI

extension Dictionary  {
    func merge(to dict2: [String:Any]) -> [String : Any] {
        let dict1 = (self as? [String:Any])!
        let mergeDict = dict1.merging(dict2) { (current, new) in new }
        return mergeDict
    }
    
    func merge(from dic2: [String: Any]) -> [String : Any] {
        let dict1 = (self as? [String:Any])!
        let mergeDict = dict1.merging(dic2) { current, new in return current }
        return mergeDict
    }
    
    func toString() -> String? {
        do{
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        }catch{
            //_log.e(error.localizedDescription)
            return nil
        }
    }
}
